/*
 * sys-priority.c - 设置RAID,PDM优先级
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

#include <config-os.h>

#include <wis/sysinfo/sys-priority.h>
#include <wis/global-conf.h>

size_t wis_sys_set_resync_prio(enum priority prio)
{
        return -1;
}

enum priority wis_sys_get_resync_prio(void)
{
        return PRIO_NOSET;
}

size_t wis_sys_set_reshap_prio(enum priority prio)
{
        return -1;
}

enum priority wis_sys_get_reshap_prio(void)
{
        return PRIO_NOSET;
}

size_t wis_sys_set_recovery_prio(enum priority prio)
{
        return -1;
}

enum priority wis_sys_get_recovery_prio(void)
{
        return PRIO_NOSET;
}
