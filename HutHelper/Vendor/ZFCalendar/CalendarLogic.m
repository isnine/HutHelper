//
//  CalendarLogic1.m
//  Calendar
//
//  Created by 张凡 on 14-7-3.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarLogic.h"

@interface CalendarLogic ()
{
    NSDate *today;//今天的日期
    NSDate *before;//之后的日期
    NSDate *select;//选择的日期
    CalendarDayModel *selectcalendarDay;
}

@end


@implementation CalendarLogic





//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)reloadCalendarView:(NSDate *)date  selectDate:(NSDate *)selectdate needDays:(int)days_number
{
    //如果为空就从当天的日期开始
    if(date == nil){
        date = [NSDate date];
    }
    
    //默认选择中的时间
    if (selectdate == nil) {
        selectdate = date;
    }
    
    today = date;//起始日期
    
    before = [date dayInTheFollowingDay:days_number];//计算它days天以后的时间
    
    select = selectdate;//选择的日期
    
    NSDateComponents *todayDC= [today YMDComponents];
    
    NSDateComponents *beforeDC= [before YMDComponents];
    
    NSInteger todayYear = todayDC.year;
    
    NSInteger todayMonth = todayDC.month;
    
    NSInteger beforeYear = beforeDC.year;
    
    NSInteger beforeMonth = beforeDC.month;
    
    NSInteger months = (beforeYear-todayYear) * 12 + (beforeMonth - todayMonth);
    
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    
    for (int i = 0; i <= months; i++) {
        
        NSDate *month = [today dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份的天数
        
        //        [self calculateDaysIsWeekendandArray:calendarDays];
        
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    
    return calendarMonth;
    
}



#pragma mark - 日历上+当前+下月份的天数

//计算上月份的天数

- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    NSUInteger partialDaysCount = weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取年月日对象
    
    for (int i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;//不显示
        [array addObject:calendarDay];
    }
    
    
    return NULL;
}



//计算下月份的天数

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;
        [array addObject:calendarDay];
    }
}


//计算当月的天数

- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        
//        calendarDay.Chinese_calendar = [self LunarForSolarYear:components.year Month:components.month Day:i];
        
        calendarDay.week = [[calendarDay date]getWeekIntValueWithDate];
        [self LunarForSolarYear:calendarDay];
        [self changStyle:calendarDay];
        [array addObject:calendarDay];
    }
}




- (void)changStyle:(CalendarDayModel *)calendarDay
{
    
    NSDateComponents *calendarToDay  = [today YMDComponents];//今天
    NSDateComponents *calendarbefore = [before YMDComponents];//最后一天
    NSDateComponents *calendarSelect = [select YMDComponents];//默认选择的那一天
    
    
    //被点击选中
    if(calendarSelect.year == calendarDay.year &
       calendarSelect.month == calendarDay.month &
       calendarSelect.day == calendarDay.day){
        
        calendarDay.style = CellDayTypeClick;
        selectcalendarDay = calendarDay;
      
    //没被点击选中
    }else{
        
        //昨天乃至过去的时间设置一个灰度
        if (calendarToDay.year >= calendarDay.year &
            calendarToDay.month >= calendarDay.month &
            calendarToDay.day > calendarDay.day) {
            
            calendarDay.style = CellDayTypePast;
          
        //之后的时间时间段
        }else if (calendarbefore.year <= calendarDay.year &
                  calendarbefore.month <= calendarDay.month &
                  calendarbefore.day <= calendarDay.day) {
            
            calendarDay.style = CellDayTypePast;
          
        //需要正常显示的时间段
        }else{
            //周末
            if (calendarDay.week == 1 || calendarDay.week == 7||(calendarDay.month==1&&calendarDay.day>=15)||calendarDay.month==2||(calendarDay.month==3&&calendarDay.day<=2)){
                calendarDay.style = CellDayTypeWeek;
            //工作日
            }else{
                calendarDay.style = CellDayTypeFutur;
            }
        }
    }
    
    
    
    
    //===================================
    //这里来判断节日
        //今天
    if (calendarToDay.year == calendarDay.year &&
        calendarToDay.month == calendarDay.month &&
        calendarToDay.day == calendarDay.day) {
        calendarDay.holiday = @"今天";
        
        //明天
    }else if (calendarDay.month == 1 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"元旦";
     
        //2.14情人节
    }else if (calendarDay.month == 2 &&
             calendarDay.day == 14){
        calendarDay.holiday = @"情人节";
        
        //3.8妇女节
    }else if (calendarDay.month == 3 &&
              calendarDay.day == 8){
        calendarDay.holiday = @"妇女节";
        
        //5.1劳动节
    }else if (calendarDay.month == 5 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"劳动节";
        
        //6.1儿童节
    }else if (calendarDay.month == 6 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"儿童节";
        
        //8.1建军节
    }else if (calendarDay.month == 8 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"建军节";
        
        //9.10教师节
    }else if (calendarDay.month == 9 &&
              calendarDay.day == 10){
        calendarDay.holiday = @"教师节";
        
        //10.1国庆节
    }else if (calendarDay.month == 10 &&
              calendarDay.day == 1){
        calendarDay.holiday = @"国庆节";
        
        
        //11.11光棍节
    }else if (calendarDay.month == 11 &&
              calendarDay.day == 11){
        calendarDay.holiday = @"光棍节";
        
    }else if (calendarDay.month == 9 &&
              (calendarDay.day == 2)){
        calendarDay.holiday = @"老生报告";
    }else if (calendarDay.month == 9 &&
              (calendarDay.day == 9||calendarDay.day == 10)){
        calendarDay.holiday = @"新生报告";
    }else if (calendarDay.month == 9 &&
              calendarDay.day == 4){
        calendarDay.holiday = @"老生上课";
    }else if (calendarDay.month == 9 &&
              calendarDay.day == 13){
        calendarDay.holiday = @"新生军训";
    }else if (calendarDay.year == 2017&&calendarDay.month == 9 &&
              calendarDay.day == 4){
        calendarDay.holiday = @"新生上课";
    }else if (calendarDay.month == 1 &&
              calendarDay.day == 15){
        calendarDay.holiday = @"寒假";
    }
}
#pragma mark - 农历转换函数

-(void)LunarForSolarYear:(CalendarDayModel *)calendarDay{
    
    
    NSString *solarYear = [self LunarForSolarYear:calendarDay.year Month:calendarDay.month Day:calendarDay.day];
    
    NSArray *solarYear_arr= [solarYear componentsSeparatedByString:@"-"];
  
    if([solarYear_arr[0]isEqualToString:@"正"] &&
       [solarYear_arr[1]isEqualToString:@"初一"]){
    
    //正月初一：春节
        calendarDay.holiday = @"春节";
    
    }else if([solarYear_arr[0]isEqualToString:@"正"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        
        
    //正月十五：元宵节
        calendarDay.holiday = @"元宵";
        
    }else if([solarYear_arr[0]isEqualToString:@"二"] &&
             [solarYear_arr[1]isEqualToString:@"初二"]){
        
    //二月初二：春龙节(龙抬头)
        calendarDay.holiday = @"龙抬头";
        
    }else if([solarYear_arr[0]isEqualToString:@"五"] &&
             [solarYear_arr[1]isEqualToString:@"初五"]){
        
    //五月初五：端午节
        calendarDay.holiday = @"端午";
        
    }else if([solarYear_arr[0]isEqualToString:@"七"] &&
             [solarYear_arr[1]isEqualToString:@"初七"]){
        
    //七月初七：七夕情人节
        calendarDay.holiday = @"七夕";
        
    }else if([solarYear_arr[0]isEqualToString:@"八"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        
    //八月十五：中秋节
        calendarDay.holiday = @"中秋";
        
    }else if([solarYear_arr[0]isEqualToString:@"九"] &&
             [solarYear_arr[1]isEqualToString:@"初九"]){
        
    //九月初九：重阳节、中国老年节（义务助老活动日）
        calendarDay.holiday = @"重阳";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"初八"]){
        
    //腊月初八：腊八节
        calendarDay.holiday = @"腊八";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"二十四"]){
        
        
    //腊月二十四 小年
        calendarDay.holiday = @"小年";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"三十"]){
        
    //腊月三十（小月二十九）：除夕
        calendarDay.holiday = @"除夕";
        
    }
    
    
    calendarDay.Chinese_calendar = solarYear_arr[1];
    
    
    
}

-(NSString *)LunarForSolarYear:(int)wCurYear Month:(int)wCurMonth Day:(int)wCurDay{
    

    
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                          @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                          @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
                                ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
                                ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
                                ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
                                ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
                                ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
                                ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
                                ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
                                ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
                                ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
  
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    

    //生成农历月
    NSString *szNongliMonth;
    if (wCurMonth < 1){
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    
    //合并
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    
    return lunarDate;
}




- (void)selectLogic:(CalendarDayModel *)day
{
    
    if (day.style == CellDayTypeClick) {
        return;
    }
    
    day.style = CellDayTypeClick;
    //周末
    if (selectcalendarDay.week == 1 || selectcalendarDay.week == 7){
        selectcalendarDay.style = CellDayTypeWeek;
        
    //工作日
    }else{
        selectcalendarDay.style = CellDayTypeFutur;
    }
    selectcalendarDay = day;
}



@end
