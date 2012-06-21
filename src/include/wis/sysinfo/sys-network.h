/*
 * network.h - 网络配置
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

#include <net/if.h>
#include <config-os.h>

#ifndef __WIS_SYSINFO_NETWORK_H
#define __WIS_SYSINFO_NETWORK_H

/*----------------------
 * 结构定义
 *----------------------*/

/*
 * @brief IP地址信息
 */
struct nic_ipconf{
        uint32_t ipaddr;
        uint32_t mask;
        uint32_t gateway;
};

/*
 * @brief 汇聚类型
 */
enum trunk_type {
        TRUNKING = 0,
        LACP,
        MULTI_HOMED
};

/*
 * @brief 网卡参数
 */
struct nic_info {
        char name[IFNAMSIZ];
        int status;
        struct nic_ipconf active;
        struct nic_ipconf conf;
        uint8_t mac_addr[6];
        int bootp;
        int jumbo;
        int traffic;            // 接口流量，单位kbps
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
size_t wis_sys_nic_get(struct nic_info *info, size_t n);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_nic_set_jumbo(const char *name, bool jumbo);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_nic_set_trunking(enum trunk_type type,
                struct nic_ipconf *ipconf);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_dns_add(const char *dns);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_dns_remove(const char *dns);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_dns_get(char *dns_list[], size_t n);



/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_set_ntp(const char *server);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
const char *wis_sys_get_ntp(void);

#endif/*__WIS_SYSINFO_NETWORK_H*/
