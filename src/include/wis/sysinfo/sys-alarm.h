/*
 * sys-alarm.h - 系统告警相关功能
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

#ifndef __WIS_SYSINFO_ALARM_H
#define __WIS_SYSINFO_ALARM_H

/*
 * @brief 事件类型
 */
enum event_type {
	EVENT_INFO = 0,
	EVENT_WARNING,
	EVENT_ERROR
};

/*
 * @brief 电子邮件加密类型
 */
enum secure_type {
	NO_SECURE = 0,
	SECURE_TLS
};

/*
 * @brief 电子邮件配置
 */
#define MAX_EMAIL_ADDR_LEN	64
#define MAX_SMTP_SERVER_LEN	64
#define MAX_EMAIL_USER_LEN	64
#define MAX_EMAIL_PASSWD_LEN	64
struct email_conf {
	int status;
	char sender[MAX_EMAIL_ADDR_LEN];
	char receiver[MAX_EMAIL_ADDR_LEN];
	enum event_type event;
	bool smtp_relay;
	struct {
		char server[MAX_SMTP_SERVER_LEN];
		uint16_t port;
		enum secure_type secure;
		char user[MAX_EMAIL_USER_LEN];
		char passwd[MAX_EMAIL_PASSWD_LEN];
	} smtp;
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
size_t wis_sys_alarm_set_email(struct email_conf *email);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
struct email_conf *wis_sys_alarm_get_email(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
size_t wis_sys_alarm_email_test(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
void wis_sys_buzzer_switch_set(bool bon);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
bool wis_sys_buzzer_switch_get(void);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
void wis_sys_buzzer_set(bool bon);


/*
 * @brief
 * @details
 * @param
 * @retval
 * @return
 * @note
 * @see
 */
bool wis_sys_buzzer_ison(void);

#endif/*__WIS_SYSINFO_ALARM_H*/
