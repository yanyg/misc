#include <syslog.h>

int main()
{
	openlog("yyg-test", LOG_CONS|LOG_NDELAY|LOG_PID, 0);
	syslog(LOG_EMERG, "%s", "test LOG_EMERG");
	syslog(LOG_ALERT, "%s", "test LOG_ALERT");
	syslog(LOG_CRIT, "%s", "test LOG_CRIT");
	syslog(LOG_ERR, "%s", "test LOG_ERR");
	syslog(LOG_WARNING, "%s", "test LOG_WARNING");
	syslog(LOG_NOTICE, "%s", "test LOG_NOTICE");
	syslog(LOG_INFO, "%s", "test LOG_INFO");
	syslog(LOG_DEBUG, "%s", "test LOG_DEBUG");
	return 0;
}
