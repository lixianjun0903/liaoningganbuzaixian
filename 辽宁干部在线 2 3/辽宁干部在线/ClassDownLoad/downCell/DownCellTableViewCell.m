//
//  DownCellTableViewCell.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-20.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "DownCellTableViewCell.h"

@implementation DownCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)config:(NSDictionary *)dic
{
    self.downLadLable.text = dic[@"name"];
    [self.downLoadImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"videoImg"]] placeholderImage:[UIImage imageNamed:@"图标logo.png"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
