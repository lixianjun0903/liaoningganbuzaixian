//
//  RencentsTableViewCell.m
//  辽宁政务
//
//  Created by lixianjun on 15-3-31.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import "RencentsTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation RencentsTableViewCell
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
////        [self makeUI];
//    }
//    return self;
//}
//-(void)makeUI
//{
//    //    numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 100+11, 8, 16)];
//    //
//    //    [self.contentView addSubview:numImageView];
//    numLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 50+11-8, 10, 20)];
//    numLable.font = [UIFont systemFontOfSize:20];
//    //    numLable.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:numLable];
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 175, 100)];
//    imageView.image =[UIImage imageNamed:@"app辽宁政务-首页_10.png"];
//    [self.contentView addSubview:imageView];
//    detailLable = [[UILabel alloc] initWithFrame:CGRectMake(210, 31, [UIScreen mainScreen].bounds.size.width - 210 - 8, 60)];
//    detailLable.text = @"花瓣是杭州纬聚网络有限公司旗下网站任何关于花瓣的意见与建议，以及相关合作事宜";
//    detailLable.numberOfLines = 0;
//    detailLable.font = [UIFont systemFontOfSize:12];
//    [self.contentView addSubview:detailLable];
//    
//}
//-(void) config:(NSDictionary*)dic :(int)row
//{
//    
////    numLable.text =[NSString stringWithFormat:@"%d", row+1];
//    [imageView sd_setImageWithURL:dic[@"videoImg"] placeholderImage:[UIImage imageNamed:@"app辽宁政务-首页_10.png"]];
//    detailLable.text = dic[@"intro"];
//
//}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
