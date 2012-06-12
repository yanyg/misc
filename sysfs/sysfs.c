/*
 * sysfs.c
 *
 * Copyright(C) 2012-2013 WISDATA Ltd.
 * 
 * Author       yanyonggang <yanyonggang@wisdata.com.cn>
 * Date         Tue Jun 12, 2012
 *
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kobject.h>
#include <linux/sysfs.h>

#include "sysfs.h"

static struct kobject *kobj_wisapp;

static struct kobj_attribute attrs_wisapp[];

ssize_t store_attrs(struct kobject *kobj, struct kobj_attribute *attr,
		    const char *v, size_t n)
{
	int r = -ENOENT;

	switch(attr - attrs_wisapp) {
	case 1:
		r = wis_create(v, n);
		break;
	case 2:
		r = wis_remove(v, n);
		break;
	case 3:
		r = wis_link(v, n);
		break;
	case 4:
		r = wis_unlink(v, n);
		break;
	}

	return r;
}

static struct kobj_attribute attrs_wisapp[] = {
	__ATTR(create,	S_IWUSR, NULL, store_attrs),
	__ATTR(remove,	S_IWUSR, NULL, store_attrs),
	__ATTR(link,	S_IWUSR, NULL, store_attrs),
	__ATTR(unlink,	S_IWUSR, NULL, store_attrs),
};

static struct attribute *pattrs_wisapp[] = {
	&attrs_wisapp[0].attr,
	&attrs_wisapp[1].attr,
	&attrs_wisapp[2].attr,
	&attrs_wisapp[3].attr,
	NULL,
};

static const struct attribute_group attr_group = {
	.attrs = pattrs_wisapp,
};

static int __init wisapp_init(void)
{
	int r = -ENOMEM;

	kobj_wisapp = kobject_create_and_add(NAME_SYSFS_ROOT, NULL);
	if (!kobj_wisapp) {
		printk(KERN_ERR "kobject_create_and_add %s failed\n",
		       NAME_SYSFS_ROOT);
		goto err_kobject_create_and_add;
	}

	r = sysfs_create_group(kobj_wisapp, &attr_group);

	printk(KERN_INFO "wisapp init\n");

	return 0;

err_kobject_create_and_add:
	return r;
}

static void __exit wisapp_exit(void)
{
	sysfs_remove_group(kobj_wisapp, &attr_group);
	kobject_put(kobj_wisapp);
	printk(KERN_INFO "wisapp exit.\n");
}

module_init(wisapp_init);
module_exit(wisapp_exit);

MODULE_LICENSE("GPL v2");
MODULE_DESCRIPTION("wisapp sysfs");
MODULE_AUTHOR("yanyg <yanyonggang@wisdata.com.cn>");
