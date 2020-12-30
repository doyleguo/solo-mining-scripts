#!/bin/bash

config_help()
{
cat << EOF
Usage:
    help                                  show help information ｜ 帮助信息
    show                                  show configurations ｜ 查看配置信息
    set                                   set configurations ｜ 重新设置
EOF
}

config_show()
{
    cat $basedir/config.json | jq .
}

config_set_all()
{
	local node_name=""
	read -p "Enter phala node name (default:phala-node)输入节点名称（默认：phala-node）: " node_name
	node_name=`echo "$node_name"`
	if [ x"$node_name" == x"" ]; then
		node_name="phala-node"
	fi
	sed -i "2c \\  \"nodename\" : \"$node_name\"," $basedir/config.json &>/dev/null
	log_success "Set phala node name: '$node_name' successfully"
    log_success "设置节点名称为: '$node_name' 成功"
	local ipaddr=""
	read -p "Enter your local IP address 输入你的IP地址: " ipaddr
	ipaddr=`echo "$ipaddr"`
	if [ x"$ipaddr" == x"" ] || [ `echo $ipaddr | awk -F . '{print NF}'` -ne 4 ]; then
		log_err "The IP address cannot be empty or the format is wrong"
		log_err "IP地址格式错误，或者为空"
		exit 1
	fi
	sed -i "3c \\  \"ipaddr\" : \"$ipaddr\"," $basedir/config.json &>/dev/null
	log_success "Set IP address: '$ipaddr' successfully"
	log_success "设置IP地址为: '$ipaddr' 成功"

    local mnemonic=""
	read -p "Enter your controllor mnemonic 输入你的Controllor账号助记词 : " mnemonic
	mnemonic=`echo "$mnemonic"`
	if [ x"$mnemonic" == x"" ]; then
		log_err "Mnemonic cannot be empty"
		log_err "助记词不能为空"
		exit 1
	fi
	sed -i "4c \\  \"mnemonic\" : \"$mnemonic\"" $basedir/config.json &>/dev/null
	log_success "Set your controllor mnemonic: '$mnemonic' successfully"
	log_success "设置助记词为: '$mnemonic' 成功"
}

config()
{
	case "$1" in
		show)
			config_show
			;;
		set)
			config_set_all
			;;
		*)
			config_help
	esac
}