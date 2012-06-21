/*
 * sys-basic.c - 系统基本信息
 *
 * Copyright(C) 2012-2013 WisDATA Ltd.
 *
 * Author: GongLei (gonglei@wisdata.com.cn)
 * Date:   Wed Jun 20 22:06:23 CST 2012
 * Desc:
 *
 * Modify:
 *
 */

#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>
#include <linux/reboot.h>
#include <sys/reboot.h>

#include <config-os.h>

#include <wis/sysinfo/sys-basic.h>
#include <wis/global-conf.h>

#define LINUX_HOSTNAME_FILE "/etc/hostname"

// 定义全局配置文件的key
#define GC_HOSTNAME_KEY "sys.hosname"
#define GC_PCIE_KEY     "sys.pcie"

size_t rewrite_file(const char *file, const char *content)
{
        size_t ret;
        int fd = open(file, O_CREAT|O_TRUNC|O_RDWR,
                        S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);

        if (fd < 0)
                return -1;
        ret = write(fd, content, strlen(content));
        close(fd);

        return ret;
}

const char *wis_sys_get_serialno(void)
{
        return NULL;
}

size_t wis_sys_get_basic_info(struct system_info *info)
{
        return -1;
}

const char *wis_sys_version(void)
{
        return NULL;
}

/*
 * @brief 获取Linux主机名称
 */
const char *wis_sys_get_hostname(void)
{
        char _tmp_name[128];
        const char *p = _tmp_name;

        if (!gethostname(_tmp_name, sizeof(_tmp_name)-1))
                return p;
        return NULL;
}

/*
 * @brief 设置Linux主机名称
 */
size_t wis_sys_set_hostname(const char *hostname)
{
        // 更新机器名称
        if (0 != sethostname(hostname, strlen(hostname)))
                return -1;

        // 更新全局配置文件
        wis_write_conf(GC_HOSTNAME_KEY, hostname);

        // 更新Linux配置文件
        return rewrite_file(LINUX_HOSTNAME_FILE, hostname);
}

/*
 * @brief 设置系统时间
 */
size_t wis_sys_set_datetime(const struct tm *dt)
{
        struct timeval tmval;

        tmval.tv_sec = mktime((struct tm*)dt);
        tmval.tv_usec = 0;
        return settimeofday(&tmval, NULL);
}

/*
 * @brief 获取系统时间
 */
struct tm *wis_sys_get_datetime(void)
{
        time_t cur_time;

        cur_time = time(NULL);
        return localtime(&cur_time);
}

/*
 * @brief 关闭系统
 */
void wis_sys_shutdown(void)
{
        sync();
        reboot(LINUX_REBOOT_CMD_POWER_OFF);
        return;
}

/*
 * @brief 重启系统
 */
void wis_sys_reboot(void)
{
        sync();
        reboot(LINUX_REBOOT_CMD_RESTART);
        return;
}

size_t wis_sys_restore_default(void)
{
        return -1;
}

size_t wis_sys_import_conf(const char *filename)
{
        return -1;
}

const char *wis_sys_export_conf(void)
{
        return NULL;
}

size_t wis_sys_pcie_enable(void)
{
        // TODO: 设置PCIE

        return wis_write_conf(GC_PCIE_KEY, "enable");
}

size_t wis_sys_pcie_disable(void)
{
        // TODO: 设置PCIE

        return wis_write_conf(GC_PCIE_KEY, "disable");
}
