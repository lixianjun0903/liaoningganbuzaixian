//
//  DownCellTableViewCell.h
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-20.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *downLoadImageView;

@property (weak, nonatomic) IBOutlet UILabel *downLadLable;
@property (weak, nonatomic) IBOutlet UIView *downPr0gress;

-(void)config:(NSDictionary *)dic;
@end
