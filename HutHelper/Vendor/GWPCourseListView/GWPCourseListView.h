//
//  GWPCourseListView.h
//  CourseList
//
//  Created by GanWenPeng on 15/12/3.
//  Copyright © 2015年 GanWenPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWPCourseListView;

@protocol Course <NSObject>
/** 课程名 */
@property (nonatomic, copy)   NSString   *courseName;
/** 课程显示时的文字属性，用来控制颜色、大小等 */
@property (nonatomic, strong) NSDictionary *nameAttribute;
/** 一周中的第几天？即周几 */
@property (nonatomic, assign) NSUInteger dayIndex;
/** 开始时间(第几节开始) */
@property (nonatomic, assign) NSUInteger startCourseIndex;
/** 结束时间(第几节结束) */
@property (nonatomic, assign) NSUInteger endCourseIndex;
/** 位置Index(用于UI布局，若非必要不要修改，GWPCourseListView会自动计算) */
@property (nonatomic, assign) NSUInteger sortIndex;
@end


@protocol GWPCourseListViewDelegate <NSObject>
@optional
- (void)courseListView:(GWPCourseListView*)courseListView didSelectedCourse:(id<Course>)course;
@end

@protocol GWPCourseListViewDataSource <NSObject>
@required
/** 设置课程数据，必须实现 */
- (NSArray<id<Course>> *)courseForCourseListView:(GWPCourseListView *)courseListView;

@optional
#pragma mark 顶部选项卡相关
/** 设置选项卡的title，默认依次为中文：周一、周二、...、周日 */
- (NSString *)courseListView:(GWPCourseListView *)courseListView titleInTopbarAtIndex:(NSInteger)index;
/** 设置选项卡的title的文字属性，如果实现该方法，该方法返回的attribute将会是attributeString的属性 */
- (NSDictionary*)courseListView:(GWPCourseListView *)courseListView titleAttributesInTopbarAtIndex:(NSInteger)index;
/** 设置选项卡的title的背景颜色，默认白色 */
- (UIColor*)courseListView:(GWPCourseListView *)courseListView titleBackgroundColorInTopbarAtIndex:(NSInteger)index;

#pragma mark 课程属性相关
/** 设置每一个课程单元的title的背景颜色，默认白色 */
- (UIColor*)courseListView:(GWPCourseListView *)courseListView courseTitleBackgroundColorForCourse:(id<Course>)course;

@end


@interface GWPCourseListView : UIView
#pragma mark 数据相关
/** 数据源 */
@property (nonatomic, weak) IBOutlet id<GWPCourseListViewDataSource> dataSource;
/** 代理 */
@property (nonatomic, weak) IBOutlet id<GWPCourseListViewDelegate> delegate;
#pragma mark IU相关
/** 第几周 */
@property (nonatomic, assign) NSUInteger weekIndex;
/** 行高，默认50 */
@property (nonatomic, assign) CGFloat itemHeight;
/** 左侧时间tableView的宽度，默认50 */
@property (nonatomic, assign) CGFloat timeTableWidth;
/** 每列课程的宽度，默认50，选中的列为1.5倍 */
@property (nonatomic, assign) CGFloat courseListWidth;
/** 每天最大节数，默认12 */
@property (nonatomic, assign) NSUInteger maxCourseCount;
/** 被选中日期的索引，默认1（1~7，代表一周中 周一~周日） */
@property (nonatomic, assign) NSUInteger selectedIndex;
/** 顶部选项卡背景颜色 默认白色 */
@property (nonatomic, strong) UIColor *topBarBgColor;
/** 刷新 */
- (void)reloadData;
@end
