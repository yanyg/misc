#include <wis/disk.h>

#define DIR_ACCESS_MODE (R_OK | W_OK | X_OK)  // 目录访问权限

// 存储磁盘信息tmpfs根路径，不包括'/'
const char DISK_TMPFS_ROOT[] = "/tmp/disk";
// 存储磁盘信息tmpfs目录权限
//（超级用户可读写执行，其他用户只读）
const mode_t DISK_ROOT_MODE = 0744;


/**
 * 描述：初始化存储磁盘节点的tmpfs目录结构
 * 返回值：0   - 成功
 *         -1  - 目录不存在
 *         -2  - 无法创建目录
 */
int disk_tmpfs_init()
{
	char tmp_by_dev[PATH_MAX], tmp_by_slot[PATH_MAX];

	// 检查目录是否存在，否则创建
	if (access(DISK_TMPFS_ROOT, DIR_ACCESS_MODE) && (ENOENT==errno))
	{
		if (mkdir(DISK_TMPFS_ROOT, DISK_ROOT_MODE))
			return -2;  // 创建目录失败
	}
	else
	{
		return -1;
	}

	sprintf(tmp_by_slot, "%s/by-slot", DISK_TMPFS_ROOT);
	sprintf(tmp_by_dev, "%s/by-dev", DISK_TMPFS_ROOT);

	// 检查by-dev,by-slot目录是否存在，否则创建
	if (access(tmp_by_slot, DIR_ACCESS_MODE) && (ENOENT==errno))
	{
		if (mkdir(tmp_by_slot, DISK_ROOT_MODE))
			return -2;  // 创建目录失败
	}
	else
	{
		return -1;
	}

	if (access(tmp_by_dev, DIR_ACCESS_MODE) && (ENOENT==errno))
	{
		if (mkdir(tmp_by_dev, DISK_ROOT_MODE))
			return -2;  // 创建目录失败
	}
	else
	{
		return -1;
	}

	return 0;
}

int recursive_remove_dir(const char *path)
{
	DIR *dir;
	struct dirent *read_dir;
	struct stat st;
	char tmp_name[PATH_MAX];

	// 获取目录信息
	if (lstat(path, &st) < 0)
	{
		return -1;
	}


	// 判断是否为目录
	if (S_ISDIR(st.st_mode))
	{
		if ((dir = opendir(path)) == NULL)
			return -1;

		// 获取目录项
		while((read_dir = readdir(dir)) != NULL)
		{
			// 忽略 '.' '..'
			if ( !strcmp(read_dir->d_name, ".") ||
					 !strcmp(read_dir->d_name, "..") )
				continue;

			// 删除文件或者目录
			sprintf(tmp_name, "%s/%s", path, read_dir->d_name);
			recursive_remove_dir(tmp_name);
		}
	}

	// 删除文件或者空目录
	if (remove(path) < 0)
		return -1;

	return 0;
}


/**
 * 描述：添加磁盘节点到文件目录
 * 输入参数：
 *     dev  - 设备节点名称，格式：sd[x]
 *     id   - 设备槽位号，格式：[x:y]
 * 返回值：
 *     0    - 成功
 *     <0   - 失败
 */
int disk_tmpfs_add(const char *dev, const char *id)
{
	char disk_dev_path[PATH_MAX], disk_id_path[PATH_MAX];

	// 检查槽位号格式
	// 检查设备名称格式

	sprintf(disk_dev_path, "%s/by-dev/%s", DISK_TMPFS_ROOT, dev);
	sprintf(disk_id_path, "%s/by-slot/%s", DISK_TMPFS_ROOT, id);

	// 设备节点连接存在，则删除
	if (!access(disk_dev_path, DIR_ACCESS_MODE))
	{
		if (remove(disk_dev_path) < 0)
			return -1;
	}

	// 槽位号目录存在，则删除
	if (!access(disk_id_path, DIR_ACCESS_MODE))
	{
		if (recursive_remove_dir(disk_id_path) < 0)
			return -1;
	}

	// 创建槽位号目录
	if (mkdir(disk_id_path, DISK_ROOT_MODE))
		return -1;   // 创建设备槽位号目录失败

	// 创建设备节点连接
	if (symlink(disk_id_path, disk_dev_path)<0)
		return -1;

	return 0;
}


/**
 * 描述：从tmpfs存储磁盘的目录结构中删除指定磁盘目录
 * 输入参数：
 *     dev  - 设备名称，格式：sd[x]
 * 返回值：
 *     0    - 成功
 *     <0   - 失败
 */
int disk_tmpfs_delete(const char *dev)
{
	bool need_to_delete = true;
	char disk_id_path[PATH_MAX];

	// 检查设备节点格式是否正确

	if (readlink(dev, disk_id_path, PATH_MAX-1) < 0)
		need_to_delete = false;

	// 删除设备节点软连接
	remove(dev);

	// 删除设备槽位号目录
	if (need_to_delete)
		return recursive_remove_dir(disk_id_path);

	return 0;
}


/**
 * 描述：从指定磁盘读取指定属性的值
 * 输入参数：
 *     id  - 磁盘槽位号
 *     key - 属性名称
 *     value - [o]取值
 * 返回值：
 *     >0  - 取值结果字符串的字节数
 *     <0  - 失败
 */
int disk_tmpfs_read_value(const char *id, const char *key, char *value)
{
	int fd, retcode = 0;
	ssize_t rd_bytes;
	char disk_attr_path[PATH_MAX];

	// 检查槽位号格式

	// 获取属性
	sprintf(disk_attr_path, "%s/by-slot/%s/%s", DISK_TMPFS_ROOT, id, key);
	if ( (fd=open(disk_attr_path, O_RDONLY)) < 0 )
			return -1;
	if ( (rd_bytes=read(fd, value, 1024)) < 0 )
		retcode = -1;

	close(fd);

	return retcode;
}


/**
 * 描述：设置指定磁盘指定属性的值
 * 输入参数：
 *     id  - 磁盘槽位号
 *     key - 属性名称
 *     value - 取值
 * 返回值：
 *     0  - 成功
 *     <0 - 失败
 */
int disk_tmpfs_write_value(const char *id, const char *key, const char *value)
{
	int fd, retcode = 0;
	ssize_t wr_bytes;
	char disk_attr_path[PATH_MAX];

	// 检查槽位号格式

	// 写入属性
	sprintf(disk_attr_path, "%s/by-slot/%s/%s", DISK_TMPFS_ROOT, id, key);
	if ( (fd=open(disk_attr_path, O_RDWR)) < 0 )
		return -1;
	if ( (wr_bytes=write(fd, value, strlen(value)+1)) < 0)
		retcode = -1;
	close(fd);

	return retcode;
}
