/*
 * global-conf.c - 全局配置文件读写函数
 *
 * Copyright(C) 2012-2013 WisDATA Ltd.
 *
 * Author: GongLei (gonglei@wisdata.com.cn)
 * Date:   Wed Jun 20 21:36:49 CST 2012
 * Desc:
 *
 * Modify:
 *
 */

#include <limits.h>
#include <string.h>

#include <config-os.h>

#include <wis/common/conf.h>
#include <wis/common/unistd.h>
#include <wis/global-conf.h>

void touch_conf_dir(void)
{
        char conf_dir[PATH_MAX];
        char *p;

        // 创建目录
        strcpy(conf_dir, GLOBAL_CONF_FILE);
        p = strrchr(conf_dir, '/');
        *(p+1) = '\0';
        mkdir_p(conf_dir);
}

/*
 * @brief 写配置到全局配置文件
 */
size_t wis_write_conf(const char *key, const char *value)
{
        // TODO: 代码需要加锁

        touch_conf_dir();
        return conf_write_string(GLOBAL_CONF_FILE, key, value);
}

/*
 * @brief 从全局配置文件读取指定配置
 **/
size_t wis_read_conf(const char *key, char *value)
{
        // TODO: 代码需要加锁

        touch_conf_dir();
        return conf_read_string(GLOBAL_CONF_FILE, key, value);
}
