//
//  AppDelegate.h
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-4.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadViewController.h"
#import "ASINetworkQueue.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ASINetworkQueue *queue;

@property (nonatomic, retain) NSMutableDictionary *asiDic;

@property (nonatomic, retain) NSMutableDictionary *downDic;

@property(strong,nonatomic)DownloadViewController * downVC;

-(void)addRequest:(NSString *)url withInfo:(NSDictionary *)info;

@end

