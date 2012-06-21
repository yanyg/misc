/*
 * global-conf.h - 定义全局配置文件
 *
 * Copyright(C) 2012-2013 WisDATA Ltd.
 *
 * Author: GongLei (gonglei@wisdata.com.cn)
 * Date:   Wed Jun 20 21:37:16 CST 2012
 * Desc:
 *
 * Modify:
 *
 */

#include <config-os.h>

#ifndef __GLOBAL_CONF_H
#define __GLOBAL_CONF_H

// 系统配置文件名称
#define GLOBAL_CONF_FILE "/etc/macrostor/global.conf"

/*
 * @brief 写配置到全局配置文件
 */
size_t wis_write_conf(const char *key, const char *value);

/*
 * @brief 从全局配置文件读取指定配置
 */
size_t wis_read_conf(const char *key, char *value);

#endif/*__GLOBAL_CONF_H*/
