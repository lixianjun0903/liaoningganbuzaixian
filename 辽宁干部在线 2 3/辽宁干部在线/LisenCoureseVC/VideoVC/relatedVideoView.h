//
//  relatedVideoView.h
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-6.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassFirstTableViewCell.h"
#import "LisenViewController.h"
#import "HoriViewController.h"
@interface relatedVideoView : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{

    UITableView * _tableView;
    float cellHeight;
}
@property(nonatomic,strong)NSString * mLoadMsg;
@property(nonatomic,copy)NSString *  videoId;
@property(nonatomic,strong)LisenViewController * lisen;
@property(nonatomic,copy)void(^myBlock)(NSDictionary *dic);
@property(nonatomic,copy)void(^myNameBlock)(NSString * name);
@property(nonatomic,copy)void(^myGgBlock)(NSString* videoBgImg);
-(void)loadData;
@end
