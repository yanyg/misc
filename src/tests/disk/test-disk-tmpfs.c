#include <wis/disk.h>

int main()
{
	char buf[1024];

	printf("start test...\n");

	// 创建目录结构
	printf("create disk root..\n");
	if (disk_tmpfs_init()<0)
	{
		printf("fail!\n");
		return -1;
	}
	printf("OK!\n");

	// 添加磁盘
	printf("add a disk ...\n");
	if (disk_tmpfs_add("sda", "0:1")<0)
	{
		printf("fail!\n");
		return -1;
	}
	printf("OK!\n");

	// 添加磁盘属性
	printf("add attr 'name' to sda ...\n");
	if (disk_tmpfs_write_value("0:1", "name", "sda")<0)
	{
		printf("fail!\n");
		return -1;
	}
	printf("OK!\n");

	// 读取属性
	printf("get attr 'name' from sda ...\n");
	if (disk_tmpfs_read_value("0:1", "name", buf)<0)
	{
		printf("fail!\n");
		return -1;
	}
	printf(" name = %s\n", buf);

	return 0;
}
