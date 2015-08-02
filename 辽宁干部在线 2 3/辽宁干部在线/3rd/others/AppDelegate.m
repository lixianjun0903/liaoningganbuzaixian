//
//  AppDelegate.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-4.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "AppDelegate.h"
#import "liginViewController.h"
#import "ASIHTTPRequest.h"

#define DOWNLOADHISTORY @"downloadHistory"
#define DOWNLOADHISTORYINFO @"downloadHistoryInfo"
#define DOWNLOADFINISH @"downloadFinish"

@interface AppDelegate ()<ASIHTTPRequestDelegate, ASIProgressDelegate>

@end

@implementation AppDelegate
{
    NSInteger _appFlag;
}
@synthesize downVC;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    liginViewController * login = [[liginViewController alloc] init];
    self.window.rootViewController = login;
    [self.window makeKeyAndVisible];
    sleep(1);
    
    downVC = [[DownloadViewController alloc]init];
    //启用网络指示器
    
    [self httpRequest];
    
   UIApplication* app = [ UIApplication  sharedApplication ];
    app.networkActivityIndicatorVisible = YES;
    // Override point for customization after application launch.
    return YES;
}

-(void)httpRequest
{
    _asiDic = [[NSMutableDictionary alloc]init];
    _downDic = [[NSMutableDictionary alloc]init];
    
    _queue = [[ASINetworkQueue alloc]init];
    _queue.showAccurateProgress = YES;
    _queue.shouldCancelAllRequestsOnFailure = NO;
    _queue.delegate = self;
    _queue.maxConcurrentOperationCount = 5;
    [_queue go];
}
-(void)addRequest:(NSString *)url withInfo:(NSDictionary *)info
{
    if (![[_asiDic allValues] containsObject:url]) {
        ASIHTTPRequest *asi = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:url]];
        asi.delegate = self;
        asi.downloadProgressDelegate = self;
        asi.allowResumeForFileDownloads = YES;
        asi.tag = 100 +_appFlag++;
        [_asiDic setObject:url forKey:[NSString stringWithFormat:@"%d",(int)asi.tag]];
        [_downDic setObject:info forKey:[NSString stringWithFormat:@"%d",(int)asi.tag]];
        NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:[[url componentsSeparatedByString:@"/"]lastObject]];
        NSString *temp = [NSHomeDirectory()stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",[[url componentsSeparatedByString:@"/"]lastObject]]];
        NSLog(@"%@",temp);
        //    打印路径
        //        NSLog(@"%@",temp);
        [asi setDownloadDestinationPath:path];
        [asi setTemporaryFileDownloadPath:temp];
        [_queue addOperation:asi];
    }
//    NSLog(@"%d",[[_asiDic allKeys] count]);
//    NSLog(@"%d",_queue.operationCount);
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"123" object:responseHeaders];
}

-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
//    NSLog(@"%lld",bytes);
}


//，下载完毕以后，将userdefault修改，然后将字典移除成功的请求，将dealloc之前的progress保存下来

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [_asiDic removeObjectForKey:[NSString stringWithFormat:@"%d",(int)request.tag]];
    
    NSLog(@"%@",request.error);
    NSLog(@"requestFailed:%d",(int)[[_asiDic allKeys] count]);
    NSLog(@"requestFailed:%d",(int)_queue.operationCount);
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[user objectForKey:DOWNLOADHISTORY]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[user objectForKey:DOWNLOADHISTORYINFO]];
    NSMutableArray *dicDown = [[NSMutableArray alloc]initWithArray:[user objectForKey:DOWNLOADFINISH]];
    [arr removeObject:[_asiDic objectForKey:[NSString stringWithFormat:@"%d",(int)request.tag]]];
    [dic removeObjectForKey:[_asiDic objectForKey:[NSString stringWithFormat:@"%d",(int)request.tag]]];
    [dicDown addObject:[_downDic objectForKey:[NSString stringWithFormat:@"%d",(int)request.tag]]];
    [_downDic removeObjectForKey:[NSString stringWithFormat:@"%d",(int)request.tag]];
    [_asiDic removeObjectForKey:[NSString stringWithFormat:@"%d",(int)request.tag]];
    [user setObject:arr forKey:DOWNLOADHISTORY];
    [user setObject:dic forKey:DOWNLOADHISTORYINFO];
    [user setObject:dicDown forKey:DOWNLOADFINISH];
    [user synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"finish" object:nil];
    NSLog(@"%@",request.error);
    NSLog(@"requestFailed:%d",(int)[[_asiDic allKeys] count]);
    NSLog(@"requestFailed:%d",(int)_queue.operationCount);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
