//
//  DowanLoadTableViewCell.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-23.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "DowanLoadTableViewCell.h"

@implementation DowanLoadTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 125, 68)];
    logoImageView.image =[UIImage imageNamed:@"图标logo.png"];
    [self.contentView addSubview:logoImageView];
    //    stopOrGoButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 14, 125, 68)];
    
    titleLable =[[UILabel alloc] initWithFrame:CGRectMake(159, 8, 189, 27)];
    titleLable.text = @"课程标题";
    titleLable.font =[UIFont systemFontOfSize:17];
    [self.contentView addSubview:titleLable];
    
    self.contentLable =[[UILabel alloc] initWithFrame:CGRectMake(159, 60, 100, 20)];
    self.contentLable.text = @"11.2MB/50MB";
    self.contentLable.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.contentLable];
    self.progress = [[UIProgressView alloc] initWithFrame:CGRectMake(159, 75, 155, 2)];
    [self.contentView addSubview:self.progress];
    
    self.stopOrGoButton = [[UIButton alloc] initWithFrame:CGRectMake(14, 14, 125, 68)];
    [self.stopOrGoButton setImage:[UIImage imageNamed:@"下载.png"] forState:UIControlStateNormal];
    [self.stopOrGoButton setImage:[UIImage imageNamed:@"暂停.png"] forState:UIControlStateSelected];
    self.stopOrGoButton.selected = NO;
    [self.stopOrGoButton addTarget:self action:@selector(selectCilk:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.stopOrGoButton];
    self.stopOrGoButton.tag =1;
    //百分比
    percentLable  =[[UILabel alloc] initWithFrame:CGRectMake(290, 60, 40, 20)];
    percentLable.text = @"20%";
    percentLable.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:percentLable];
}
-(void)selectCilk:(UIButton*)sender
{
//    sender.tag++;
    
//    NSInteger  startSender = sender.tag %2==0;
    //判断选中的状态
//      DownloadViewController * down = [[DownloadViewController alloc] init];
    if (sender.tag %2==0) {
    
//        for (ASIHTTPRequest *request in [self.queue operations])
//        { //暂停
//            NSInteger bookid = [[request.userInfo objectForKey:@"bookID"] intValue];//查看userinfo信息
//            if ([sender tag] == bookid) {
//                //判断ID是否匹配
//                //暂停匹配对象
//                [request clearDelegatesAndCancel];
//            }
//            
//        }
           NSLog(@"点击暂停");
//        [down stardLoad:startSender];
      self.stopOrGoButton.selected = YES;
        
    }
    else
    {
        //继续
        self.stopOrGoButton.selected = NO;
        NSLog(@"点击开始");

//        [down stardLoad:startSender];
    }
   
}
-(void)config1:(NSString*)str totalText:(NSString*)totalStr
{//显示总的进度
    self.contentLable.text= [NSString stringWithFormat:@"%@M/%@M",str,totalStr];
    //显示百分比
    int num = (int)([str doubleValue]/[totalStr doubleValue]*100);
    percentLable.text = [NSString stringWithFormat:@"%d%c",num,'%'];
}
-(void)config:(NSDictionary *)dict
{
    NSDictionary *dic = dict[@"dicInfo"];
    
    titleLable.text = dic[@"name"];
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"videoImg"]] placeholderImage:[UIImage imageNamed:@"图标logo.png"]];
    
}

- (void)awakeFromNib{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
