#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
 .name = KBUILD_MODNAME,
 .init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
 .exit = cleanup_module,
#endif
 .arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x568fba06, "module_layout" },
	{ 0xf9157598, "genl_unregister_ops" },
	{ 0x39b5bc38, "genl_unregister_family" },
	{ 0x37c2a26, "genl_register_ops" },
	{ 0x298f2ac8, "genl_register_family" },
	{ 0xf699bae9, "netlink_unicast" },
	{ 0xed25218d, "nla_put" },
	{ 0xfac00f33, "skb_put" },
	{ 0x9c0f1700, "__alloc_skb" },
	{ 0x27e1a049, "printk" },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";

