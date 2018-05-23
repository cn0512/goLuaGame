--[[
  calendar printer by apache(hqw) 2010-9-28 at shenzhen tx
  welcome to my baidu space -> www.hi.baidu.com/hqwfreefly
  email -> hqwemail@163.com
  在本程序中你可以学到一下内容：
  1.Lua中面向对象的编程方法
  2.日期相关的库函数
  3.获取指定年月日的星期数
  4.获取指定年月的天数
  5.日历打印格式
  声明：这个小软件是一个自由软件，如果你觉得它有帮助，欢迎你推荐他给更多的初学者。
  希望你也和我一样，热爱自由，热爱开源精神！：）
--]]
Calendar =
{
    curyear  = os.date("*t")["year"],             --当前年份
    curmonth = os.date("*t")["month"],            --当前月份
    curday   = os.date("*t")["day"],              --当前日期
    cruweek  = os.date("*t")["wday"],             --当前星期
    desyear  = curyear,                           --指定打印的年份
    desmonth = curmonth,                          --指定打印的月份
    MAX_YEAR = 10000,                             --最大年份
    MIN_YEAR = 1,                                 --最小年份
    MAX_MONTH = 12,                               --最大月份
    MIN_MONTH = 1,                                --最小月份
 
    new = function(self, obj)                     --创建新对象
        obj = obj or {}
        setmetatable(obj, self)
        self.__index = self
        return obj
    end,
 
    get_des2print_date = function(self)           --获取指定打印的年份和月份
        local argc = table.getn(arg)              --获取命令行参数个数
        if argc < 3 then
            if argc == 2 then
                return tonumber(arg[1]), tonumber(arg[2])
            elseif argc == 1 then
                return tonumber(arg[1]), 1
            else
                return self.curyear, self.curmonth
            end
        else
            return tonumber(arg[1]), tonumber(arg[2])
        end
    end,
 
    check_date = function(self, year, month)      --检查年份和月份是否合法
        local flag = 0
        if year == nil then
            flag = flag + 1
        elseif year <= self.MAX_YEAR and year >= self.MIN_YEAR then
            flag = flag + 2
        else
            flag = flag + 4
        end
        if month == nil then
            flag = flag + 8
        elseif month <= self.MAX_MONTH and month >= self.MIN_MONTH then
            flag = flag + 16
        else
            flag = flag + 32
        end
        return flag
    end,
    get_days = function(self, year, month)        --获取指定年月的天数和第一天的星期
        local bigmonth = "(1)(3)(5)(7)(8)(10)(12)"
        local strmonth = "(" .. month .. ")"
        local week = os.date("*t", os.time{year = year, month = month, day = 1})["wday"]
        if month == 2 then
            if year % 4 == 0 or (year % 400 == 0 and year % 400 ~= 0) then
                return 29, week
            else
                return 28, week
            end
        elseif string.find(bigmonth, strmonth) ~= nil then
            return 31, week
        else
            return 30, week
        end
    end,
    print_calendar = function(self, year, month, days, week)       --打印日历
        print(string.format("      %s  %02s", year, month))
        print("Su Mo Tu We Th Fr Sa")
        local calendar = string.rep("   ", week)
        local cnt = week
        for i = 1, days do
            cnt = cnt + 1
            if cnt % 7 == 0 then
                endl = "\n"
            else
                endl = ""
            end
            if year == self.curyear and month == self.curmonth then
                if i == self.curday then
                    calendar = calendar .. string.format("(%02s)", i) .. endl
                elseif i + 1 == self.curday then
                    calendar = calendar .. string.format("%02s", i) .. endl
                else
                    calendar = calendar .. string.format("%02s ", i) .. endl
                end
            else
                calendar = calendar .. string.format("%02s ", i) .. endl
            end
        end
        print(calendar)
    end,
    error_help = function(self, ret)              --根据错误码打印帮助信息
        local help_msg =
        {
            [9] = "The year and the month should be an enterger!",
            [10] = "The month should be an enterger!",
            [12] = "The year should between [1, 10000], and the month should be an enterger!",
            [17] = "The year should be an enterger!",
            [20] = "The year should between [1, 10000]!",
            [33] = "The year should be an enterger and the month should between [1, 12]!",
            [34] = "The month should between [1, 12]",
            [36] = "The year should between [1, 10000] and the month should between [1, 12]!"
        }
        print(help_msg[ret])
    end
}
 
cal = Calendar:new()
local year, month = cal:get_des2print_date()
local ret = cal:check_date(year, month)
if ret ~= 18 then
    cal:error_help(ret)
    os.exit()
end
local days, week = cal:get_days(year, month)
cal:print_calendar(year, month, days, week - 1)