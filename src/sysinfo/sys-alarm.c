#include <wis/sysinfo/sys-alarm.h>

size_t wis_sys_alarm_set_email(struct email_conf *email)
{
        return -1;
}

struct email_conf *wis_sys_alarm_get_email(void)
{
        return NULL;
}

size_t wis_sys_alarm_email_test(void)
{
        return -1;
}

void wis_sys_buzzer_switch_set(bool bon)
{
        return;
}

bool wis_sys_buzzer_switch_get(void)
{
        return false;
}

void wis_sys_buzzer_set(bool bon)
{
        return;
}

bool wis_sys_buzzer_ison(void)
{
        return false;
}
