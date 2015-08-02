//
//  LisenViewController.h
//  干部在线
//
//  Created by lixianjun on 15-3-30.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LisenViewController : UIViewController
@property(nonatomic,copy)NSString * intro;
@property(nonatomic,copy)NSString * videoId;
@property(nonatomic,strong)NSString * mLoadMsg;
@property(nonatomic,strong)NSString * videoPath;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,copy)NSString * videoImg;
@property(nonatomic,copy)NSString * videoBgImg;
@property(nonatomic,copy)NSDictionary * lisenDic;
@end
