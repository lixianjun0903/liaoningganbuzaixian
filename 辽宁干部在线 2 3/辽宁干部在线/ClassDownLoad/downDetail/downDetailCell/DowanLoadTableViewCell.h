//
//  DowanLoadTableViewCell.h
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-23.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "DownloadViewController.h"
@interface DowanLoadTableViewCell : UITableViewCell
{
    UIImageView * logoImageView;
    UILabel * titleLable;
    UILabel * percentLable;
//    ASIHTTPRequest*request;
}
@property(nonatomic,strong)UIProgressView * progress;
@property(nonatomic,strong)UILabel * contentLable;
@property(nonatomic,strong)UIButton * stopOrGoButton;
@property(nonatomic,strong)ASINetworkQueue * queue;
@property(nonatomic,strong)DownloadViewController * dowanLoad;

-(void)config:(NSDictionary *)dic;
-(void)config1:(NSString*)str totalText:(NSString*)totalStr;

@end
