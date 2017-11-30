//
//  MTAHybrid.h
//  MTAHybrid
//
//  Created by tyzual on 19/09/2017.
//  Copyright © 2017 tyzual. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface MTAHybrid : NSObject

#pragma mark - UIWebView相关方法

/**
 此方法应该在UIWebView的Delegate中调用。
 若此方法返回YES，则表示处理的request为MTA混合统计的请求
 具体使用方法请查看Demo注释

 @param request 回调中的request参数
 @param webView 回调中的webView参数
 @return request是否为MTA混合统计请求
 */
+ (BOOL)handleRequest:(NSURLRequest *)request fromWebView:(UIWebView *)webView;

/**
 停止对UIWebView页面的统计
 当webView被隐藏，被销毁，或者从父view上移除时
 需要调用这个方法来停止对该webView的统计

 @param webView 需要停止统计的webView
 */
+ (void)stopWebView:(UIWebView *)webView;


/**
 重新开始对UIWebView的页面统计
 如果之前调用过stopWebView暂停对webView的统计
 调用这个方法可以重新开始对这个webView的统计

 @param webView 需要重新开始统计的webView
 */
+ (void)restartWebView:(UIWebView *)webView;

#pragma mark - WKWebView相关方法

/**
 此方法应该在WKWebView的Delegate中调用。
 若此方法返回YES，则表示处理的request为MTA混合统计的请求
 具体使用方法请查看Demo注释

 @param action 回调中的navigationAction参数
 @param wkWebView 回调中的wkWebView参数
 @return action是否为MTA混合统计请求
 */
+ (BOOL)handleAction:(WKNavigationAction *)action fromWKWebView:(WKWebView *)wkWebView;

/**
 停止对WKWebView页面的统计
 当webView被隐藏，被销毁，或者从父view上移除时
 需要调用这个方法来停止对该webView的统计

 @param wkWebView 需要停止统计的wkWebView
 */
+ (void)stopWKWebView:(WKWebView *)wkWebView;

/**
 重新开始对WKWebView的页面统计
 如果之前调用过stopWebView暂停对wkWebView的统计
 调用这个方法可以重新开始对这个wkWebView的统计

 @param wkWebView 需要重新开始统计的wkWebView
 */
+ (void)restartWKWebView:(WKWebView *)wkWebView;

@end
