package main

import (
	"fmt"

	yknet "github.com/cn0512/goKit/yknet"
	//"github.com/cn0512/goLuaGame/src/Yklua"
	//"github.com/yuin/gopher-lua"
)

func main() {
	fmt.Println("start tcp...")
	//开启端口
	yknet.Create_server("127.0.0.1:7056")

}
