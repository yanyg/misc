/*
 * sys-basic.h - 系统基本信息
 *
 * Copyright(C) 2012-2013 WisDATA Ltd.
 *
 * Author: GongLei (gonglei@wisdata.com.cn)
 * Date:   Mon Jun 18 23:04:09 CST 2012
 * Desc:
 *
 * Modify:
 *
 */

#include <config-os.h>

#ifndef __WIS_SYSINFO_BASIC_H
#define __WIS_SYSINFO_BASIC_H

/*
 * @brief 系统基本信息
 */
struct system_info {
	struct tm runtime;		// 运行时间
	uint64_t samp_time;		// 采样时间

	/* CPU信息 */
	struct {
		uint8_t timeperature;	// 温度(摄氏度)
		uint8_t user_rate;	// 用户进程占用率
		uint8_t sys_rate;	// 内核占用率
		uint8_t io_rate;	// I/O占用率
		uint8_t idle_rate;	// 空闲率
	} cpu;

	/* 内存信息 */
	struct {
		uint64_t total;		// 总内存大小(字节)
		uint64_t used;		// 已经使用内存大小(字节)
	} memory;
};


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
const char *wis_sys_get_serialno(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_get_basic_info(struct system_info *info);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
const char *wis_sys_version(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
const char *wis_sys_get_hostname(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_set_hostname(const char *hostname);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_set_datetime(const struct tm *dt);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
struct tm *wis_sys_get_datetime(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
void wis_sys_shutdown(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
void wis_sys_reboot(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_restore_default(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_import_conf(const char *filename);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
const char *wis_sys_export_conf(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_pcie_enable(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_pcie_disable(void);


#endif/*__WIS_SYSINFO_BASIC_H*/
