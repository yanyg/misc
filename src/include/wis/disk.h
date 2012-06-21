
#include "../include/config-os.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <errno.h>
#include <dirent.h>
#include <string.h>

#ifndef DISK_INFO_H__
#define DISK_INFO_H__


/* ------------------------------------------------------------------*/
/*                               宏定义                              */
/* ------------------------------------------------------------------*/

/* 磁盘类型定义 */
enum {
	DISK_STAT_FREE = 0,	// 空闲磁盘
	DISK_STAT_SPEC_SPARE,	// 专用热备盘
	DISK_STAT_GLB_SPARE,	// 全局热备盘
	DISK_STAT_RAID,		// RAID数据盘
	DISK_STAT_UNBND,	// 未绑定RAID盘
	DISK_STAT_INVALID,	// 无效RAID盘
	DISK_STAT_ERR_RAID	// 错误RAID盘
};

/* 磁盘LED2灯状态 */
typedef enum {
	DISK_LED2_FREE = 0,	// 磁盘不存在，关闭磁盘
	DISK_LED2_DATA,		// 数据状态，蓝灯长亮
	DISK_LED2_BLINK,	// 定位状态，闪烁
	DISK_LED2_ERROR		// 出错告警，红灯长亮
} led_t;

/* 约束常量 */
#define DISK_ID_MAX 112		// 最大磁盘个数
#define DISK_FW_MAX 64		// 固件版本长度

/* --------------------------------------------------------------*/
/*                      数据结构定义                             */
/* --------------------------------------------------------------*/

/* 磁盘SMART信息 */
struct smart_info {
	int health;                   // 健康状态
	int read_err;                 // 读取错误率
	int spin_up_time;             // 起旋时间
	int realct_sect_cnt;          // 重新分配扇区计数
	int seek_err;                 // 寻道错误率
	int spin_retry_cnt;           // 起旋重试计数
	int power_on_hours;           // 累积通电时间
	int degrees_celsius;          // 温度（摄氏度）
	int curr_pending_sect;        // 不稳定扇区数
	int offline_uncorrect;        // 无法修正的错误计数
};

/* 物理磁盘信息 */
struct disk_info {
	char id[DISK_ID_MAX];	// 磁盘ID，格式："0:1"
	char dev[PATH_MAX];	// 磁盘设备名称，格式/dev/sd[x]
	int state;		// 磁盘管理状态
	char model[128];	// 型号
	char serial[128];	// 序列号
	loff_t capacity;	// 容量,字节表示 <sys/types.h>
	char firmware[DISK_FW_MAX];	// 固件版本
	bool cache_switch;	// 写缓存
	int standby;		// 待机模式
	bool ahead_switch;	// 预读模式
	bool queue_switch;	// 命令队列
	int led;	// 磁盘LED灯状态，初始化为DISK_LED2_FREE
	struct smart_info smart;	// 磁盘SMART信息
};

/* 介质巡检 */
struct mpatrol {
	int method;		// 介质巡检方法
	int type;		// 发生巡检的方式
	struct tm datetime;	// 发生巡检的具体时间
	int threshold;		// 阈值
};

/* --------------------------------------------------------*/
/*                     API接口函数声明                     */
/* --------------------------------------------------------*/

ssize_t wis_disk_info(struct disk_info *info, size_t n);

ssize_t wis_disk_led (const char *buf, led_t type);

const char *wis_disk_led_blink(void);

size_t wis_disk_mpatrol(int action, struct mpatrol *mpinfo);


/* --------------------------------------------------------*/
/*                     开机模块函数声明                    */
/* --------------------------------------------------------*/

void disk_init(void);


/* --------------------------------------------------------*/
/*                     监控函数声明                        */
/* --------------------------------------------------------*/

void disk_connect(const char *id);

void disk_disconnect(const char *id);


/* --------------------------------------------------------*/
/*                    内部函数声明                         */
/* --------------------------------------------------------*/

void disk_update_info(const char *id);

void disk_update_smartinfo(const char *id);

void disk_mpatrol_event(const char *id);

int disk_tmpfs_init();

int disk_tmpfs_add(const char *dev, const char *id);

int disk_tmpfs_delete(const char *dev);

int disk_tmpfs_read_value(const char *id, const char *key, char *value);

int disk_tmpfs_write_value(const char *id, const char *key, const char *value);

#endif/*DISK_INFO_H__*/
