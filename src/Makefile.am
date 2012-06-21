SUBDIRS = common net utils disk raid lvm2 iscsi nas sysinfo wis-common . tests

lib_LTLIBRARIES = libwisapp.la
libwisapp_la_SOURCES =
libwisapp_la_LIBADD = \
	common/libwisapp-common.la \
	disk/libwisapp-disk.la \
	sysinfo/libwisapp-sysinfo.la \
	wis-common/libwisapp-wis-common.la
libwisapp_la_LDFLAGS = -release $(PACKAGE_VERSION) -version-info 1

EXTRA_DIST = $(srcdir)/include
