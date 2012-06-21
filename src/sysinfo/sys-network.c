#include <wis/sysinfo/sys-network.h>

size_t wis_sys_nic_get(struct nic_info *info, size_t n)
{
        return -1;
}

size_t wis_sys_nic_set_jumbo(const char *name, bool jumbo)
{
        return -1;
}

size_t wis_sys_nic_set_trunking(enum trunk_type type,
                struct nic_ipconf *ipconf)
{
        return -1;
}

size_t wis_sys_dns_add(const char *dns)
{
        return -1;
}

size_t wis_sys_dns_remove(const char *dns)
{
        return -1;
}

size_t wis_sys_dns_get(char *dns_list[], size_t n)
{
        return -1;
}

size_t wis_sys_set_ntp(const char *server)
{
        return -1;
}

const char *wis_sys_get_ntp(void)
{
        return NULL;
}
