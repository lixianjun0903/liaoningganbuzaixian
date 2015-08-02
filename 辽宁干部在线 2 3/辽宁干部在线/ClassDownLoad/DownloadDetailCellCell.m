//
//  DownloadDetailCellCell.m
//  duandian1
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 home. All rights reserved.
//

#import "DownloadDetailCellCell.h"

@implementation DownloadDetailCellCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 14, 125, 68)];
        //        _iconImage.backgroundColor = [UIColor cyanColor];
        _iconImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_iconImage];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(159, 8, 189, 27)];
        _name.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_name];
        
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(159, 75, 155, 2)];
        [_progress addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.contentView addSubview:_progress];
        
        _state = [UIButton buttonWithType:UIButtonTypeCustom];
        _state.frame = CGRectMake(0, 0, _iconImage.frame.size.width, _iconImage.frame.size.height);
        [_state setTitle:@"ing" forState:UIControlStateNormal];
        _state.tintColor = [UIColor clearColor];
        [_state setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_iconImage addSubview:_state];
        
        _progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 60, 60, 20)];
        _progressLabel.font = [UIFont systemFontOfSize:12];
        _progressLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_progressLabel];
        
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    NSLog(@"%@",change[@"new"]);
    _progressLabel.text = [NSString stringWithFormat:@"%.2f%%",[change[@"new"] floatValue] *100];
    if ([change[@"new"] floatValue] >=1) {
        
        [_state setTitle:@"下载完成" forState:UIControlStateNormal];
        _state.enabled = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
