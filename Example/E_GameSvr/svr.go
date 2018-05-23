package main

import (
	"fmt"

	yknet "github.com/cn0512/goKit/yknet"
	ykframe "github.com/cn0512/goLuaGame/src/Frame"
)

const (
	tcp_address = "127.0.0.1:7056"
)

func main() {
	fmt.Println("start tcp...")

	//初始化游戏框架
	ykframe.InitLobby()
	ykframe.InitTable()
	ykframe.InitLogic()

	//初始化存储
	ykframe.InitStorage()

	//开启端口
	yknet.Create_server(tcp_address)

}
