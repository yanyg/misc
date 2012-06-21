#include <stdio.h>

#include <config-os.h>

#include <wis/common/conf.h>
#include <wis/global-conf.h>

#define TEST_KEY "sys.ntp.server"

/*
 * 测试全局配置文件读写接口
 */
int main()
{
        char server[128];

        wis_write_conf(TEST_KEY, "ntp.pool.org");
        if (1==wis_read_conf(TEST_KEY, server))
                printf("got sysctl.ntp.server = %s\n", server);
        else
                printf("nothing found!\n");

        return 0;
}
