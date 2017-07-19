obj-m += hello.o
KDIR = /usr/src/linux-headers-4.4.0-81-generic
all:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

clean:
	rm -rf *.o *.ko *.mod.* *.symvers *.order
