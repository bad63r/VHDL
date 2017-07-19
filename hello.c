#include <linux/init.h>
#include <linux/module.h>
MODULE_LICENSE("Dual BDS/GPL");

static int __init hello_init(void){
	printk("<1> My first driver is working \n");

return 0;
}

static int __exit hello_exit(void){
	printk("<1 >Leaving my first driver\n");
	
return 0;
}

module_init(hello_init);
module_exit(hello_exit);

