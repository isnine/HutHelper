//
//  GWPCourseListView.m
//  CourseList
//
//  Created by GanWenPeng on 15/12/3.
//  Copyright © 2015年 GanWenPeng. All rights reserved.
//

#import "GWPCourseListView.h"
#import "Math.h"
#define MaxDay 7
/** 通过三色值获取到颜色 */
#define RGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@protocol CourseSort <Course>
@property (nonatomic, assign) NSUInteger sortIndex;
@end

@interface CourseCell : UITableViewCell
@property (nonatomic, strong) id<Course> course;
/** 分割线 */
@property (nonatomic, weak)   UIView *sepLine;
@end

@implementation CourseCell
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    UIView *sep = [[UIView alloc] init];
   // [self addSubview:sep];
    sep.backgroundColor = RGB(0, 0, 0, 0.07);
    self.sepLine = sep;
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = [UIFont systemFontOfSize:SYReal(12)];
    self.textLabel.numberOfLines = 0;
}

- (void)setCourse:(id<Course>)course{
    _course = course;
    if ([course nameAttribute] && [course courseName].length) {
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[course courseName] attributes:[course nameAttribute]];
    } else {
        self.textLabel.text = course.courseName;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.sepLine.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
}
@end



@interface GWPCourseListView ()<UITableViewDataSource, UITableViewDelegate>
/** 顶部选项卡 */
@property (nonatomic, weak)   UIView *topBar;
/** 顶部选项卡的ContentView */
@property (nonatomic, weak)   UIView *topBarContentView;
/** 顶部选项卡中的按钮 */
@property (nonatomic, strong) NSArray *topBarBtnArr;
/** 顶部选项卡中的日期 */
@property (nonatomic, strong) UILabel *dayBarLabel;
/** 顶部选项卡中的周次 */
@property (nonatomic, strong) UILabel *weekBarLabel;
/** 时间TableView */
@property (nonatomic, weak)   UITableView *timeTableView;

/** 上下滚动的ScrollView */
@property (nonatomic, weak)   UIScrollView *upDownScrollView;

/** 左右滚动的ScrollView */
@property (nonatomic, weak)   UIScrollView *leftRightScrollView;

/** 课程Table列表 */
@property (nonatomic, strong) NSArray *courseTableArr;

/** 亮色集合 */
@property (nonatomic, strong) NSArray *lightColorArr;

/** 课程数据 */
@property (nonatomic, strong) NSArray<id<Course>> *courseDataArr;
@end

@implementation GWPCourseListView
#pragma mark - lazy
- (NSArray *)lightColorArr{
    if (!_lightColorArr) {
        _lightColorArr = @[
                           RGB(39, 201, 155, 1),
                           RGB(146, 196, 40, 1),
                           RGB(253, 185, 46, 1),
                           RGB(112, 161, 246, 1),
                           RGB(246, 126, 140, 1),
                           RGB(185, 140, 221, 1),
                           RGB(30, 180, 235, 1),
                           RGB(226, 112, 194, 1),
                           ];
    }
    return _lightColorArr;
}

#pragma mark - init system
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup{
    /*=============================== 初始化变量 ==============================*/
    _itemHeight = SYReal(60);
    _timeTableWidth = 50;
    _courseListWidth = 0;
    _maxCourseCount = 10;
    _selectedIndex = [Math getWeekDay];
    _weekIndex = 1;
    _topBarBgColor = [UIColor whiteColor];
    self.backgroundColor = RGB(237, 241, 241, 1);
    
    /*=============================== 添加控件 ==============================*/
    NSMutableArray *temp;
    
    /** topBar */
    UIView *topBar = [[UIView alloc] init];
    topBar.backgroundColor = _topBarBgColor;
    [self addSubview:topBar];
    self.topBar = topBar;
    
    /** topBarContentView */
    UIView *topBarContentView = [[UIView alloc] init];
    topBarContentView.backgroundColor = [UIColor clearColor];
    topBarContentView.clipsToBounds = YES;
    [topBar addSubview:topBarContentView];
    self.topBarContentView = topBarContentView;
    
    /** tabBarBtnArr */
    temp = [NSMutableArray array];
    for (int i=0; i<MaxDay; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i+1;
        [topBarContentView addSubview:btn];
        [temp addObject:btn];
    }
    _topBarBtnArr = temp;
    
    /** upDownScrollView */
    UIScrollView *upDownScrollView = [[UIScrollView alloc] init];
    upDownScrollView.showsVerticalScrollIndicator = NO;
    upDownScrollView.bounces = NO;
    [self addSubview:upDownScrollView];
    self.upDownScrollView = upDownScrollView;
    
    /** timeTableView */
    UITableView *timeTableView = [[UITableView alloc] init];
    timeTableView.backgroundColor = [UIColor clearColor];
    [timeTableView registerClass:[CourseCell class] forCellReuseIdentifier:NSStringFromClass([CourseCell class])];
    timeTableView.scrollEnabled = NO;
    timeTableView.delegate = self;
    timeTableView.dataSource = self;
    [upDownScrollView addSubview:timeTableView];
    self.timeTableView = timeTableView;
    
    /** leftRightScrollView */
    UIScrollView *leftRightScrollView = [[UIScrollView alloc] init];
    leftRightScrollView.bounces = NO;
    leftRightScrollView.showsHorizontalScrollIndicator = NO;
    leftRightScrollView.delegate = self;
    [upDownScrollView addSubview:leftRightScrollView];
    self.leftRightScrollView = leftRightScrollView;
    
    /** courseTableArr */
    temp = [NSMutableArray array];
    for (int i=0; i<MaxDay; i++) {
        UITableView *table = [[UITableView alloc] init];
        table.backgroundColor = [UIColor clearColor];
        [table registerClass:[CourseCell class] forCellReuseIdentifier:NSStringFromClass([CourseCell class])];
        table.delegate = self;
        table.dataSource = self;
        table.scrollEnabled = NO;
        table.tag = i+1;
        [leftRightScrollView addSubview:table];
        [temp addObject:table];
    }
    _courseTableArr = [NSArray arrayWithArray:temp];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat courseW = _courseListWidth ? _courseListWidth : (width-_timeTableWidth)/(MaxDay+0.5-2);
    CGFloat x,y,w,h;
    
    _topBar.frame = CGRectMake(0, 0, courseW*(MaxDay+0.5)+_timeTableWidth, 30);
    _topBarContentView.frame = CGRectMake(_timeTableWidth, 0, courseW*(MaxDay+0.5), 30);
    
    for (int i=0; i<self.topBarBtnArr.count; i++) {
        UIButton *btn = self.topBarBtnArr[i];
        if (i>0) {
            UIButton *preBtn = self.topBarBtnArr[i-1];
            x = CGRectGetMaxX(preBtn.frame);
        } else {
            x = -_leftRightScrollView.contentOffset.x;
        }
        y=0;
        if (btn.tag==_selectedIndex) {
            w = 1.5*courseW;
        } else {
            w = courseW;
        }
        h = _topBarContentView.frame.size.height;
        btn.frame = CGRectMake(x, y, w, h);
    }
    
    _upDownScrollView.frame = CGRectMake(0, CGRectGetMaxY(_topBar.frame), width, height-_topBar.frame.size.height);
    _upDownScrollView.contentSize = CGSizeMake(0, _maxCourseCount*_itemHeight);
    
    _timeTableView.frame = CGRectMake(0, 0, _timeTableWidth, _itemHeight*_maxCourseCount);
    
    _leftRightScrollView.frame = CGRectMake(_timeTableWidth, 0, width-_timeTableWidth, _timeTableView.frame.size.height);
    _leftRightScrollView.contentSize = CGSizeMake(courseW*(MaxDay+0.5), 0);
    
    for (int i=0; i<self.courseTableArr.count; i++) {
        UITableView *table = self.courseTableArr[i];
        if (i>0) {
            UITableView *preTable = self.courseTableArr[i-1];
            x = CGRectGetMaxX(preTable.frame);
        } else {
            x = 0;
        }
        y=0;
        if (table.tag==_selectedIndex) {
            w = 1.5*courseW;
        } else {
            w = courseW;
        }
        h = _timeTableWidth*_itemHeight;
        table.frame = CGRectMake(x, y, w, h);
        
    }
    
}

#pragma mark - setter
- (void)setCourseDataArr:(NSArray<id<Course>> *)courseDataArr{
    __block NSUInteger cha = 0;
    
    for (int i=0; i<=MaxDay; i++) {
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id<Course>  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return evaluatedObject.dayIndex==i;
        }];
        NSArray<id<Course>> *enumCourses = [courseDataArr filteredArrayUsingPredicate:pre];
        [enumCourses enumerateObjectsUsingBlock:^(id<Course>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.sortIndex = obj.startCourseIndex-cha;
            cha = cha + obj.endCourseIndex - obj.startCourseIndex;
        }];
        cha = 0;
    }
    
    _courseDataArr = courseDataArr;
}
- (void)setDataSource:(id<GWPCourseListViewDataSource>)dataSource{
    _dataSource = dataSource;
    
   // [self loadData];
    
    
}

- (void)setTopBarBgColor:(UIColor *)topBarBgColor{
    _topBarBgColor = topBarBgColor;
    
    self.topBar.backgroundColor = topBarBgColor;
    
}

#pragma mark - public
- (void)reloadData{
    [self loadData];
}

#pragma mark - private
- (void)topBarItemClick:(UIButton *)btn{
    _selectedIndex = btn.tag;
    
    [self layoutSubviews];
}

- (void)loadData{
   
    /*=============================== topBar ==============================*/
    NSArray *temp = @[
                      @"周一",
                      @"周二",
                      @"周三",
                      @"周四",
                      @"周五",
                      @"周六",
                      @"周日"
                      ];
    for (int i=0; i<self.topBarBtnArr.count; i++) {
        UIButton *btn = self.topBarBtnArr[i];
        NSString *str = @"";
        if ([_dataSource respondsToSelector:@selector(courseListView:titleInTopbarAtIndex:)]) {
            
            str = [_dataSource courseListView:self titleInTopbarAtIndex:i];
        } else {
            str = temp[i];
        }
        
        NSDictionary *attr;
        if ([_dataSource respondsToSelector:@selector(courseListView:titleAttributesInTopbarAtIndex:)]) {
            attr = [_dataSource courseListView:self titleAttributesInTopbarAtIndex:i];
        }
//        if (attr) {
//            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@" " attributes:attr];
//            [btn setAttributedTitle:attrStr forState:UIControlStateNormal];
//        }
        /** 周次 */
            UILabel *weekBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(10), 0, SYReal(30), SYReal(15))];
        /** 日期 */
            UILabel *dayBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(SYReal(10), SYReal(15), SYReal(30), SYReal(15))];
            //周几
            weekBarLabel.font=[UIFont systemFontOfSize:10];
            weekBarLabel.tag=201+i;
            weekBarLabel.text=temp[i];
            //日期
            dayBarLabel.font=[UIFont systemFontOfSize:10];
            dayBarLabel.tag=101+i;
           dayBarLabel.text=[NSString stringWithFormat:@"%d日",[Math getDayOfWeek:self.weekIndex d:i]];
            [btn addSubview:weekBarLabel];
            [btn addSubview:dayBarLabel];
//        } else {
//            //周几
//            UILabel *weekBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 30, 15)];
//            weekBarLabel.font=[UIFont systemFontOfSize:10];
//            weekBarLabel.text=temp[i];
//            //日期
//            UILabel *dayBarLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 30, 15)];
//            dayBarLabel.font=[UIFont systemFontOfSize:10];
//            dayBarLabel.text=[NSString stringWithFormat:@"%d日",[Math getDayOfWeek:7 d:i]];
//            [btn addSubview:weekBarLabel];
//            [btn addSubview:dayBarLabel];
//            //[btn setTitle:str forState:UIControlStateNormal];
//        }
        
        UIColor *bgColor;
        if ([_dataSource respondsToSelector:@selector(courseListView:titleBackgroundColorInTopbarAtIndex:)]) {
            bgColor = [_dataSource courseListView:self titleBackgroundColorInTopbarAtIndex:i];
        }
        if (bgColor) {
            btn.backgroundColor = bgColor;
        } else {
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    
    
    /*=============================== course ==============================*/
    //    for (UITableView *table in self.courseTableArr) {
    //        [table reloadData];
    //    }
    NSString *msg = [NSString stringWithFormat:@"使用 %@ 必须实现“courseForCourseListView:”方法", self.class];
    NSAssert([_dataSource respondsToSelector:@selector(courseForCourseListView:)], msg);
    self.courseDataArr = [_dataSource courseForCourseListView:self];
    [self.courseTableArr makeObjectsPerformSelector:@selector(reloadData)];
}


#pragma mark - UITableViewDataSource、Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    return [tableView isEqual:self.timeTableView] ? _maxCourseCount :20;
}
-(NSString*)transformTime:(NSInteger)row{
    switch (row) {
        case 1:
            return @"8:00";
            break;
        case 2:
            return @"8:55";
            break;
        case 3:
            return @"10:00";
            break;
        case 4:
            return @"10:55";
            break;
        case 5:
            return @"14:00";
            break;
        case 6:
            return @"14:55";
            break;
        case 7:
            return @"16:00";
            break;
        case 8:
            return @"16:55";
            break;
        case 9:
            return @"19:00";
            break;
        case 10:
            return @"19:55";
            break;
        default:
            return @"";
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CourseCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([tableView isEqual:self.timeTableView]) {
        UITableViewCell *cellTime = [tableView cellForRowAtIndexPath:indexPath];
        if (cellTime == nil) {
            cellTime = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle
                                          reuseIdentifier: @"cellTime"];
        }
        cellTime.detailTextLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row+1];
        cellTime.detailTextLabel.textColor = [UIColor blackColor];
        
        cellTime.textLabel.text = [self transformTime:indexPath.row+1];
        cellTime.textLabel.font = [UIFont systemFontOfSize: SYReal(6)];
        cellTime.textLabel.textColor = [UIColor darkGrayColor];
        
        cellTime.backgroundColor = RGB(237, 241, 241, 1.0);
        
//        cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row+1];
//        //cell.textLabel.numberOfLines=2;
//        cell.backgroundColor = RGB(243, 243, 243, 1.0);
//        cell.textLabel.textColor = [UIColor darkGrayColor];
        return cellTime;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id<Course>  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return (tableView.tag==evaluatedObject.dayIndex) && (indexPath.row+1==evaluatedObject.sortIndex);
    }];
    id<Course> course = [[self.courseDataArr filteredArrayUsingPredicate:pre] firstObject];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.course = course;
    UIColor *bgColor = [_dataSource courseListView:self courseTitleBackgroundColorForCourse:course];
    cell.backgroundColor = course ? (bgColor ? bgColor : self.lightColorArr[arc4random_uniform((u_int32_t)self.lightColorArr.count)]) : [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.timeTableView]) return _itemHeight;
    
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id<Course>  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return (tableView.tag==evaluatedObject.dayIndex) && (indexPath.row+1==evaluatedObject.sortIndex);
    }];
    id<Course> course = [[self.courseDataArr filteredArrayUsingPredicate:pre] firstObject];
    
    if (course) {
        return (course.endCourseIndex-course.startCourseIndex+1)*_itemHeight;
    } else {
        return _itemHeight;
    }
    //    return _itemHeight*2;
    //    return course ? (course.endCourseIndex-course.startCourseIndex)*_itemHeight : _itemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.timeTableView]) return;
    _selectedIndex = tableView.tag;
    [self layoutSubviews];
    if ([_delegate respondsToSelector:@selector(courseListView:didSelectedCourse:)]) {
        CourseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [_delegate courseListView:self didSelectedCourse:cell.course];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self layoutSubviews];
}
@end
