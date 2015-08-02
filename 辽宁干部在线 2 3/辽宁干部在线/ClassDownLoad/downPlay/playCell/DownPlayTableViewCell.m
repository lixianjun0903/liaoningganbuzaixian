//
//  DownPlayTableViewCell.m
//  辽宁干部在线
//
//  Created by myMac on 15-5-2.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "DownPlayTableViewCell.h"

@implementation DownPlayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 125, 68)];
        _iconImage.backgroundColor = [UIColor cyanColor];
        _iconImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_iconImage];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(50, 20, 25, 30);
        //       _button.center = _iconImage.center;
        [_button setImage:[UIImage imageNamed:@"播放按钮_03"] forState:UIControlStateNormal];
        _button.userInteractionEnabled = NO;
        _button.enabled = NO;
        [_iconImage addSubview:_button];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(159, 29, 189, 27)];
        _name.font = [UIFont systemFontOfSize:14];
        _name.numberOfLines = 0;
        [self.contentView addSubview:_name];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
