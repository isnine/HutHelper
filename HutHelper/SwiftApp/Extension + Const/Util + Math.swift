//
//  Util + Math.swift
//  HutHelperSwift
//
//  Created by 张驰 on 2020/1/13.
//  Copyright © 2020 张驰. All rights reserved.
//

import Foundation

/** 开学 年 月 日*/
let startYear  = 2020
let startMonth = 2
let startDay = 24


/** 今天是第今年第几天 */
func getNumDay(year:Int,mouth:Int,day:Int) -> Int {
    let mouths = [31,0,31,30,31,30,31,31,30,31,30,31];
    var sum = 0
    for i in 0..<mouth-1 {
        sum += mouths[i]
    }
    if mouth > 2 {
        if ( year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
            sum += 29
        }else {
            sum += 28
        }
    }
    return sum + day
}

/** 返回当前是本学期第几周 */
func getNumWeek(nowYear:Int,nowMouth:Int,nowDay:Int) -> Int {
    var ans = 0
    if nowYear != startYear {
        ans = getNumDay(year: nowYear, mouth: nowMouth, day: nowDay) - getNumDay(year: nowYear, mouth: 1, day: 1) + 1
        ans += getNumDay(year: nowYear-1, mouth: 12, day: 31) - getNumDay(year: startYear, mouth: startMonth, day: startDay) + 1
    }else {
        ans = getNumDay(year: nowYear, mouth: nowMouth, day: nowDay) - getNumDay(year: startYear, mouth: startMonth, day: startDay) + 1
    }
    
    if (ans + 6) / 7 <= 0 {
        return 1
    }
    return (ans + 6) / 7
}




//MARK: - 获取日期各种值
extension Date {

    //MARK: 年
    func years() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.year!
    }
    //MARK: 月
    func months() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.month!
        
    }
    //MARK: 日
    func days() ->Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.day!
        
    }
    /** 获取当前星期几 */
    func getWeekDay()->String{
        let interval = Int(self.timeIntervalSince1970)
        let days = Int(interval/86400) // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        let weekDays = ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"]
        return weekDays[weekday]
    }
    //MARK: 当月天数
    func countOfDaysInMonth() ->Int {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self)
        return (range?.length)!
        
    }
    //MARK: 当月第一天是星期几
    func firstWeekDay() ->Int {
        //1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let firstWeekDay = (calendar as NSCalendar?)?.ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: self)
        return firstWeekDay! - 1
        
    }
    //MARK: - 日期的一些比较
    //是否是今天
    func isToday()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month && com.day == comNow.day
    }
    //是否是这个月
    func isThisMonth()->Bool {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        let comNow = calendar.dateComponents([.year,.month,.day], from: Date())
        return com.year == comNow.year && com.month == comNow.month
    }

}
