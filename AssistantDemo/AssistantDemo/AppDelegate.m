//
//  AppDelegate.m
//  AssistantDemo
//
//  Created by 杨帆 on 2016/9/20.
//  Copyright © 2016年 杨帆. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NewsViewController *newsVC = [NewsViewController new];
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = newsVC;
    [_window makeKeyAndVisible];
    
    return YES;
}



@end
