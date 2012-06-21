/*
 * sys-priority.h - 优先级设置
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


#ifndef __WIS_SYSINFO_PRIORITY_H
#define __WIS_SYSINFO_PRIORITY_H

/*
 * @brief 优先级
 */
enum priority {
	PRIO_HIGH = 0,
	PRIO_MEDIUM,
	PRIO_LOW,
	PRIO_NOSET
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
size_t wis_sys_set_resync_prio(enum priority prio);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
enum priority wis_sys_get_resync_prio(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_set_reshap_prio(enum priority prio);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
enum priority wis_sys_get_reshap_prio(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_set_recovery_prio(enum priority prio);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
enum priority wis_sys_get_recovery_prio(void);

#endif/*__WIS_SYSINFO_PRIORITY_H*/
