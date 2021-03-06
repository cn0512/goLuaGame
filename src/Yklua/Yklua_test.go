package Yklua

import (
	"fmt"
	"testing"

	"github.com/yuin/gopher-lua"
)

const (
	ddz_script_cmd    = "../../bin/scripts/game_ddz/CMD_Game.lua"
	ddz_script_define = "../../bin/scripts/game_ddz/Define.lua"
	ddz_script_logic  = "../../bin/scripts/game_ddz/GameLogic.lua"
)

var (
	cmd    *lua.LState
	define *lua.LState
	logic  *lua.LState
)

func init() {
	cmd = nil
	define = nil
	logic = nil
}

func TestLoad(t *testing.T) {

	//[1]
	cmd = Load(ddz_script_cmd)
	//define = Yklua.Load(ddz_script_define)
	logic = Load(ddz_script_logic)
	fmt.Println(cmd, ",", define, ",", logic)

	//[1]
	c1 := cmd.GetGlobal("cmd")
	c2 := cmd.Get(1)
	c3 := cmd.GetField(c2, "CMD_C_Login")
	fmt.Println(c1, c2, c3)
	fmt.Println(c3.String(), c3.Type())

	//[2]
	g1 := logic.GetGlobal("GameLogic")
	g2 := logic.Get(1)
	g3 := logic.GetField(g2, "mod")
	g4 := logic.GetField(g2, "GAME_PLAYER") //3
	fmt.Println(g1, g2, g3, g4)

	//[3]
	/*err := logic.CallByParam(lua.P{
		Fn:      logic.GetGlobal("testmod"),
		NRet:    1,
		Protect: true,
	}, lua.LNumber(77), lua.LNumber(22))
	*/
	err := logic.CallByParam(lua.P{
		Fn:      logic.GetField(g2, "mod"),
		NRet:    1,
		Protect: true,
	}, g2, lua.LNumber(77), lua.LNumber(22))

	if err != nil {
		panic(err)
	}
	ret := logic.Get(-1)
	logic.Pop(-1)
	res, ok := ret.(lua.LNumber)
	if ok {
		fmt.Println("lua result:", int(res))
	}
}
