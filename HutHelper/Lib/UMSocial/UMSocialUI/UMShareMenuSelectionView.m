//
//  UMShareMenuSelectionView.m
//  SocialSDK
//
//  Created by umeng on 16/4/24.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import "UMShareMenuSelectionView.h"
#import "UMShareMenuItem.h"


static NSString *kUMSplatformType = @"kUMSplatformType";
static NSString *kUMSSharePlatformType = @"kUMSSharePlatformType";
static NSString *kUMSSharePlatformIconName = @"kUMSSharePlatformIconName";
static NSString *kUMSSharePlatformItemView = @"UMSSharePlatformItemView";


#define UMSocial_Max_Row_Count 3 //最大行数（计算高度时会用到）
#define UMSocial_Item_Count_PerRow 4 //列数 （计算高度时会用到）
#define UMSocial_Line_Space 10 //行间距（计算高度时会用到）

#define UMSocial_Left_Space 10 //透明边的宽度
#define UMSocial_Page_Space 5//页面间距
#define UMSocial_Menu_Bottom_Space 10 //取消按钮距底部的距离

#define UMSocial_Menu_CornerRadius 10
#define UMSocial_MenuAndCancel_Space 0
#define UMSocial_BgGray_View_Alpha 0.3



@interface UMShareMenuSelectionView ()

@property (nonatomic, assign, readwrite) UMSocialPlatformType selectionPlatform;

@property (nonatomic, strong) UIButton *cancelButton;//取消按钮
@property (nonatomic, strong) UIView *shareSuperView;//半透明背景

@property (nonatomic, assign) NSInteger lineCount;//行数
@property (nonatomic, assign) NSInteger columnCount;//列数
@property (nonatomic, assign) CGFloat lineSpace;//实际行间距
@property (nonatomic, assign) CGFloat expectLineSpace;//预期行间距 用于自动计算实际行间距
@property (nonatomic, assign) CGFloat columnSpace;//列间距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;//缩进
@property (nonatomic, assign) CGSize itemSize;//按钮大小

@property (nonatomic, assign) NSInteger pageCount;//页数
@property (nonatomic, strong) NSArray *pageViews;//分页子View

@property (nonatomic, strong) NSMutableArray *platformArrArrays;//分页平台

@end


@implementation UMShareMenuSelectionView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.platformArrArrays = [NSMutableArray array];
        self.shareSuperView = [UIApplication sharedApplication].keyWindow;
        
        self.lineSpace = UMSocial_Line_Space;
        self.columnSpace = 8;
        self.lineSpace = 10;
        self.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
        self.lineCount = UMSocial_Max_Row_Count;
        self.columnCount = UMSocial_Item_Count_PerRow;
        CGFloat UMSocial_Item_Width = 70;
        if ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) {
            UMSocial_Item_Width = [UIScreen mainScreen].bounds.size.height/375 * 70;
        }else{
            UMSocial_Item_Width = [UIScreen mainScreen].bounds.size.width/375 * 70;
        }
        self.itemSize = CGSizeMake(UMSocial_Item_Width, UMSocial_Item_Width);
        self.expectLineSpace = 8;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self creatBackgroundGrayView];
        [self creatCancelButton];
        
        //监听横竖屏切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doRotateAction:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];

        
        //获取可分享平台
        NSMutableArray *platformArray = [[NSMutableArray alloc] init];
        for (NSNumber *platformType in [UMSocialManager defaultManager].platformTypeArray) {
            NSMutableDictionary *dict = [self dictWithPlatformName:platformType];
            [dict setObject:platformType forKey:kUMSSharePlatformType];
            if (dict) {
                [platformArray addObject:dict];
            }
        }
        if (platformArray.count == 0) {//如果没有有效的分享平台，则不创建分享菜单
            UMSocialLogDebug(@"There is no any valid platform");
            return nil;
        }
        
        [platformArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([[obj1 valueForKey:kUMSSharePlatformType] integerValue] > [[obj2 valueForKey:kUMSSharePlatformType] integerValue]) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
        self.sharePlatformInfoArray = platformArray;
        
        
        //创建分页视图,限定三张，用作循环滚动
        NSMutableArray *pageViews = [NSMutableArray array];
        for (int  i = 0; i < 3; i ++) {
            UIView *pageView = [[UIView alloc] init];
            pageView.layer.cornerRadius = UMSocial_Menu_CornerRadius;
            pageView.backgroundColor = [UIColor whiteColor];
            [pageViews addObject:pageView];
        }
        self.pageViews = [NSArray arrayWithArray:pageViews];
        
        //页面切换block
        __weak typeof(self) weakSelf = self;
        self.contentViewWithIndex = ^(UMSocialShareScrollView *scrollView, NSInteger index, DJXScrollSubViewLocation location){
            UIView *pageView = nil;
            if (location == DJX_leftView) {
                pageView = weakSelf.pageViews[0];
            }else if (location == DJX_curView){
                pageView = weakSelf.pageViews[1];
            }else if (location == DJX_rightView){
                pageView = weakSelf.pageViews[2];
            }
            CGSize pageSize = weakSelf.frame.size;
            pageSize.width = pageSize.width - UMSocial_Page_Space*2;//设置页之间的间隔
            if (index < self.platformArrArrays.count) {
                [weakSelf pageView:pageView items:[weakSelf.platformArrArrays[index] valueForKeyPath:kUMSSharePlatformItemView] size:pageSize];
            }else{
                [weakSelf pageView:pageView items:[weakSelf.platformArrArrays[0] valueForKeyPath:kUMSSharePlatformItemView] size:pageSize];
            }
            return pageView;
        };
    }
    return self;
}


#pragma mark - rotation notification

- (void)doRotateAction:(NSNotification *)notification {
    //重新布局
    [self resetSubviews];
    [self reloadData];
}


- (void)reloadData
{
    self.currentPageIndex = 0;
    [self configContentView];
}


#pragma mark - creat subviews
//创建取消按钮
- (void)creatCancelButton
{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    [cancelButton addTarget:self action:@selector(hiddenShareMenuView) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.cornerRadius = UMSocial_Menu_CornerRadius;
    self.cancelButton = cancelButton;
}

//创建半透明背景视图
- (void)creatBackgroundGrayView
{
    self.backgroundGrayView = [[UIView alloc] init];
    self.backgroundGrayView.backgroundColor = [UIColor blackColor];
    self.backgroundGrayView.alpha = UMSocial_BgGray_View_Alpha;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareMenuView)];
    [self.backgroundGrayView addGestureRecognizer:tap];
}




#pragma mark -  reset View frame

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    //在菜单视图（self）添加到父视图之前先add半透明的背景视图和取消按钮
    if (self.backgroundGrayView.superview != newSuperview) {
        [self.backgroundGrayView removeFromSuperview];
        [newSuperview addSubview:self.backgroundGrayView];
    }
    
    if (self.cancelButton.superview != newSuperview) {
        [self.cancelButton removeFromSuperview];
        [newSuperview addSubview:self.cancelButton];
    }
    [self resetSubviews];
}


//重新布局菜单栏
- (void)resetSelfFrame
{
    //    由 self.frame.size.width = self.columnSpace * (self.columnCount - 1) + self.itemSize.width * self.columnCount + self.edgeInsets.left + self.edgeInsets.right; 可以计算出每行的个数
    
    UIView *superView = self.shareSuperView;
    CGRect selfFrame = superView.frame;
    selfFrame.origin.x = UMSocial_Left_Space;
    selfFrame.size.width = superView.frame.size.width - selfFrame.origin.x*2;

     //根据预期行间距self.expectLineSpace计算出列数
    self.columnCount = (selfFrame.size.width - UMSocial_Page_Space*2 - self.edgeInsets.left - self.edgeInsets.right + self.expectLineSpace) / (self.expectLineSpace + self.itemSize.width);
    if (self.columnCount >= self.sharePlatformInfoArray.count) {
        self.columnCount = self.sharePlatformInfoArray.count;
    }
    
    //重新计算间距
    if (self.columnCount > 2) {
        self.columnSpace = (selfFrame.size.width - UMSocial_Page_Space*2 - self.edgeInsets.left - self.edgeInsets.right - self.columnCount*self.itemSize.width)/(self.columnCount - 1);
    }else{
        //如果列数少于3个 则重新布局
        self.columnSpace = (selfFrame.size.width - UMSocial_Page_Space*2 - self.columnCount*self.itemSize.width)/(self.columnCount + 1);
        //修改偏移量
        self.edgeInsets = UIEdgeInsetsMake(self.edgeInsets.top, self.columnSpace, self.edgeInsets.bottom, self.edgeInsets.right);
    }
    //清除数据
    [self.platformArrArrays removeAllObjects];
    
    //每页显示的按钮个数
    NSInteger itemCountPerPage = self.columnCount * UMSocial_Max_Row_Count;
    if (itemCountPerPage > self.sharePlatformInfoArray.count) {
        //如果平台数小于预期每页显示的个数，则取实际平台数
        [self.platformArrArrays addObject:self.sharePlatformInfoArray];
        self.pageCount = 1;
        itemCountPerPage = self.sharePlatformInfoArray.count;
    }else{
        //如果平台数大于预期每页显示的个数，则分页显示
        CGFloat count = itemCountPerPage;//强制转化成float类型才使得函数ceil有效
        self.pageCount = ceilf(self.sharePlatformInfoArray.count/count);//如果有商，余数进一
        for (int i = 0; i < self.pageCount; i++) {
            NSArray *array = nil;
            if (i == self.pageCount - 1) {
               array = [self.sharePlatformInfoArray subarrayWithRange:NSMakeRange(i*itemCountPerPage, self.sharePlatformInfoArray.count - i*itemCountPerPage)];
            }else{
                array = [self.sharePlatformInfoArray subarrayWithRange:NSMakeRange(i*itemCountPerPage, itemCountPerPage)];
            }
            if (array) {
                [self.platformArrArrays addObject:array];
            }
        }
    }

    //计算行数
    CGFloat columnCount = self.columnCount;//强制转化成float类型才使得函数ceil有效
    NSInteger line = ceilf(itemCountPerPage / columnCount);//如果有商，余数进一，作为行
    selfFrame.size.height = line * self.itemSize.height + self.lineSpace *(line - 1) + self.edgeInsets.top + self.edgeInsets.bottom;
    
    //设置偏移
    selfFrame.origin.y = superView.frame.size.height - selfFrame.size.height - self.cancelButton.frame.size.height - UMSocial_MenuAndCancel_Space - UMSocial_Menu_Bottom_Space - self.pageControl.frame.size.height;
    self.frame = selfFrame;
    
    CGRect pageControllFrame = self.pageControl.frame;
    pageControllFrame.origin.y = self.frame.origin.y + self.frame.size.height;
    pageControllFrame.origin.x = self.frame.origin.x;
    self.pageControl.frame = pageControllFrame;
    
    self.totalCount = self.platformArrArrays.count;
}


- (void)pageView:(UIView *)pageView items:(NSArray *)items size:(CGSize)size
{
    [self reloadPageView:pageView items:items];
    CGRect pageViewFrame = pageView.frame;
    pageViewFrame.size = size;
    pageViewFrame.origin.x = UMSocial_Page_Space/2;
    pageView.frame = pageViewFrame;

}

- (void)reloadPageView:(UIView *)pageView items:(NSArray *)items
{
    if (items.count == 0) {
        return;
    }
    for (UIView *subView in pageView.subviews) {
        [subView removeFromSuperview];
    }
    for (NSInteger index = 0; index < items.count; index ++) {
        UIView *itemView = items[index];
        itemView.frame = [self itemFrameWithIndex:index];
        [pageView addSubview:itemView];
    }
}


- (CGRect)itemFrameWithIndex:(NSInteger)index
{
    CGRect rect;
    NSInteger column = index % self.columnCount;//取余数作为列
    NSInteger line = index / self.columnCount;//取商为行
    
    rect.origin.x =  column * (self.columnSpace + self.itemSize.width) + self.edgeInsets.left;
    rect.origin.y = line * (self.lineSpace + self.itemSize.height);
    
    rect.size = self.itemSize;
    return rect;
}

- (NSInteger)rowCountWithPlatformArray:(NSArray *)paltformArr
{
    NSInteger rowCount = ceilf(paltformArr.count/UMSocial_Item_Count_PerRow);
    if (rowCount > UMSocial_Max_Row_Count) {
        rowCount = UMSocial_Max_Row_Count;
    }
    return rowCount;
}

- (void)resetSubviews
{
    [self resetSelfFrame];
    
    //设置取消按钮的的大小和位置
    UIView *superView = self.shareSuperView;
    self.backgroundGrayView.frame = superView.bounds;
    CGRect cancelButtonFrame = self.cancelButton.frame;
    cancelButtonFrame.size.width = self.frame.size.width;
    cancelButtonFrame.origin.y = superView.frame.size.height - cancelButtonFrame.size.height - UMSocial_Menu_Bottom_Space;
    cancelButtonFrame.origin.x = self.frame.origin.x;
    self.cancelButton.frame = cancelButtonFrame;
}

#pragma mark - get platform Info
- (NSMutableDictionary *)dictWithPlatformName:(NSNumber *)platformType
{
    UMSocialPlatformType platformType_int = [platformType integerValue];
    NSString *imageName = nil;
    NSString *platformName = nil;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    switch (platformType_int) {
        case UMSocialPlatformType_Sina:
            imageName = @"UMS_sina_icon";
            platformName = UMLocalizedString(@"sina",@"新浪微博");
            break;
        case UMSocialPlatformType_WechatSession:
            imageName = @"UMS_wechat_session_icon";
            platformName = UMLocalizedString(@"wechat",@"微信");
            break;
        case UMSocialPlatformType_WechatTimeLine:
            imageName = @"UMS_wechat_timeline_icon";
            platformName = UMLocalizedString(@"wechat_timeline",@"微信朋友圈");
            break;
        case UMSocialPlatformType_WechatFavorite:
            imageName = @"UMS_wechat_favorite_icon";
            platformName = UMLocalizedString(@"wechat_favorite",@"微信收藏");
            break;
        case UMSocialPlatformType_QQ:
            imageName = @"UMS_qq_icon";
            platformName = UMLocalizedString(@"qq",@"QQ");
            break;
        case UMSocialPlatformType_Qzone:
            imageName = @"UMS_qzone_icon";
            platformName = UMLocalizedString(@"qzone",@"QQ空间");
            break;
        case UMSocialPlatformType_TencentWb:
            imageName = @"UMS_tencent_icon";
            platformName = UMLocalizedString(@"tencentWB",@"腾讯微博");
            break;
        case UMSocialPlatformType_AlipaySession:
            imageName = @"UMS_alipay_session_icon";
            platformName = UMLocalizedString(@"alipay",@"支付宝");
            break;
        case UMSocialPlatformType_LaiWangSession:
            imageName = @"UMS_laiwang_session";
            platformName = UMLocalizedString(@"lw_session",@"点点虫");
            break;
        case UMSocialPlatformType_LaiWangTimeLine:
            imageName = @"UMS_laiwang_timeline";
            platformName = UMLocalizedString(@"lw_timeline",@"点点虫动态");
            break;
        case UMSocialPlatformType_YixinSession:
            imageName = @"UMS_yixin_session";
            platformName = UMLocalizedString(@"yixin_session",@"易信");
            break;
        case UMSocialPlatformType_YixinTimeLine:
            imageName = @"UMS_yixin_timeline";
            platformName = UMLocalizedString(@"yixin_timeline",@"易信朋友圈");
            break;
        case UMSocialPlatformType_YixinFavorite:
            imageName = @"UMS_yixin_favorite";
            platformName = UMLocalizedString(@"yixin_favorite",@"易信收藏");
            break;
        case UMSocialPlatformType_Douban:
            imageName = @"UMS_douban_icon";
            platformName = UMLocalizedString(@"douban",@"豆瓣");
            break;
        case UMSocialPlatformType_Renren:
            imageName = @"UMS_renren_icon";
            platformName = UMLocalizedString(@"renren",@"人人");
            break;
        case UMSocialPlatformType_Email:
            imageName = @"UMS_email_icon";
            platformName = UMLocalizedString(@"email",@"邮箱");
            break;
        case UMSocialPlatformType_Sms:
            imageName = @"UMS_sms_icon";
            platformName = UMLocalizedString(@"sms",@"短信");
            break;
        case UMSocialPlatformType_Facebook:
            imageName = @"UMS_facebook_icon";
            platformName = UMLocalizedString(@"facebook",@"Facebook");
            break;
        case UMSocialPlatformType_Twitter:
            imageName = @"UMS_twitter_icon";
            platformName = UMLocalizedString(@"twitter",@"Twitter");
            break;
        case UMSocialPlatformType_Instagram:
            imageName = @"UMS_instagram_icon";
            platformName = UMLocalizedString(@"instagram",@"Instagram");
            break;
        case UMSocialPlatformType_Line:
            imageName = @"UMS_line_icon";
            platformName = UMLocalizedString(@"line",@"Line");
            break;
        case UMSocialPlatformType_Flickr:
            imageName = @"UMS_flickr_icon";
            platformName = UMLocalizedString(@"flickr",@"Flickr");
            break;
        case UMSocialPlatformType_KakaoTalk:
            imageName = @"UMS_kakao_icon";
            platformName = UMLocalizedString(@"kakaoTalk",@"KakaoTalk");
            break;
        case UMSocialPlatformType_Pinterest:
            imageName = @"UMS_pinterest_icon";
            platformName = UMLocalizedString(@"pinterest",@"Pinterest");
            break;
        case UMSocialPlatformType_Tumblr:
            imageName = @"UMS_tumblr_icon";
            platformName = UMLocalizedString(@"tumblr",@"Tumblr");
            break;
        case UMSocialPlatformType_Linkedin:
            imageName = @"UMS_linkedin_icon";
            platformName = UMLocalizedString(@"linkedin",@"Linkedin");
            break;
        case UMSocialPlatformType_Whatsapp:
            imageName = @"UMS_whatsapp_icon";
            platformName = UMLocalizedString(@"whatsapp",@"Whatsapp");
            break;
            
        default:
            break;
    }
    
    [dict setObject:UMSocialPlatformIconWithName(imageName) forKey:kUMSSharePlatformIconName];
    [dict setObject:platformName forKey:kUMSplatformType];
    //为各平台创建按钮
    UMShareMenuItem *cell = [[UMShareMenuItem alloc] init];
    [cell reloadDataWithImage:[UIImage imageNamed:UMSocialPlatformIconWithName(imageName)] platformName:platformName];
    cell.index = platformType_int;
    
    __weak typeof(self) weakSelf = self;
    cell.tapActionBlock = ^(NSInteger index){
        __strong typeof(UMShareMenuSelectionView *)strongSelf = weakSelf;
        strongSelf.selectionPlatform = index;
        if (strongSelf.shareSelectionBlock) {
            [strongSelf hiddenShareMenuView];
            strongSelf.shareSelectionBlock(strongSelf, index);
        }
    };
    [dict setObject:cell forKey:kUMSSharePlatformItemView];
    
    return dict;
}


#pragma mark - show and hidden
- (void)show
{
    if (self.superview != self.shareSuperView) {
        [self removeFromSuperview];
        [self.shareSuperView addSubview:self];
        self.pageControl.alpha = 0;
    }
    
    CGRect frame = self.frame;
    if (frame.origin.y != self.superview.frame.size.height) {
        frame.origin.y = self.superview.frame.size.height;
        self.frame = frame;
    }
    
    CGRect cancelButtonFrame = self.cancelButton.frame;
    if (cancelButtonFrame.origin.y != self.superview.frame.size.height*2-cancelButtonFrame.size.height) {
        cancelButtonFrame.size.width = self.frame.size.width;
        cancelButtonFrame.origin.y = self.superview.frame.size.height*2-cancelButtonFrame.size.height;
        self.cancelButton.frame = cancelButtonFrame;
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = self.superview.frame.size.height - frame.size.height - self.cancelButton.frame.size.height - UMSocial_MenuAndCancel_Space - UMSocial_Menu_Bottom_Space - self.pageControl.frame.size.height;
        self.frame = frame;

        CGRect cancelButtonFrame = self.cancelButton.frame;
        cancelButtonFrame.size.width = self.frame.size.width;
        cancelButtonFrame.origin.y = self.superview.frame.size.height-cancelButtonFrame.size.height - UMSocial_Menu_Bottom_Space;
        self.cancelButton.frame = cancelButtonFrame;
        self.backgroundGrayView.alpha = UMSocial_BgGray_View_Alpha;
        self.pageControl.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

//隐藏视图
- (void)hiddenShareMenuView
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }

    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = self.superview.frame.size.height;
        self.frame = frame;
        
        CGRect  pageControlFrame = self.pageControl.frame;
        pageControlFrame.origin.y = self.frame.origin.y + self.frame.size.height;
        self.pageControl.frame = pageControlFrame;
        
        CGRect cancelFrame = self.cancelButton.frame;
        cancelFrame.origin.y = self.superview.frame.size.height*2-cancelFrame.size.height;
        self.cancelButton.frame = cancelFrame;
        
        self.backgroundGrayView.alpha = 0;

        
    } completion:^(BOOL finished) {
        [self.backgroundGrayView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

