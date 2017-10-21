//
//  HutHelperUITests.m
//  HutHelperUITests
//
//  Created by Nine on 2017/5/15.
//  Copyright © 2017年 nine. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HutHelperUITests : XCTestCase
@property(nonatomic,copy)NSArray *user;
@end
@implementation HutHelperUITests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _user=[[NSArray alloc]init];
    _user=@[
            @{@"userName":@"13407620206",
              @"passWord":@"056621"},
            @{@"userName":@"16495100224",
              @"passWord":@"222816"},
            @{@"userName":@"14409100441",
              @"passWord":@"181072"}
            ];
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
int currentIndex;
-(void)testExample{
    for (int i=0; i<_user.count; i++) {
        currentIndex=i;
        [self testLogin];
        [self testExam];
        [self testExit];
    }
}

- (void)testLogin{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *textField = app.textFields[@"学号"];
    [textField tap];
    [textField typeText:_user[currentIndex][@"userName"]];
    
    XCUIElement *secureTextField = app.secureTextFields[@"密码"];
    [secureTextField tap];
    [secureTextField typeText:_user[currentIndex][@"passWord"]];
    
    [app.staticTexts[@"登录"] tap];
}
//打开考试计划
- (void)testExam {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *kaoshiButton = app.buttons[@"kaoshi"];
    [kaoshiButton tap];
    XCUIElement *button = app.navigationBars[@"考试计划"].buttons[@"返回"];
    [button tap];
    [kaoshiButton tap];
    [button tap];
}
//主界面->切换用户
- (void)testExit {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.navigationBars[@"MainPageView"].buttons[@"menu"] tap];
    [app.tables.staticTexts[@"切换用户"] tap];
    [app.alerts[@"切换用户"].buttons[@"确定"] tap];
}
@end
