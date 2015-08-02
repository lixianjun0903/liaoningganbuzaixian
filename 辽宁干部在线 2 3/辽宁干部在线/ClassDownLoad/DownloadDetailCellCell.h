//
//  DownloadDetailCellCell.h
//  duandian1
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadDetailCellCell : UITableViewCell

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *state;
@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *progressLabel;

@end
