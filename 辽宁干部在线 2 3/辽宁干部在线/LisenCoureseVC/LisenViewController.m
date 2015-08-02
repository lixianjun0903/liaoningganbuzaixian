//
//  LisenViewController.m
//  干部在线
//
//  Created by lixianjun on 15-3-30.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import "LisenViewController.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "JSON.h"
#import "ImageDownManager.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "HoriViewController.h"
#import "relatedVideoView.h"
#import "Reachability.h"
#import "AppDelegate.h"

#define DOWNLOADHISTORY @"downloadHistory"
#define DOWNLOADHISTORYINFO @"downloadHistoryInfo"

@interface LisenViewController ()<UIScrollViewDelegate,MBProgressHUDDelegate>

{//实例化播放器
    MPMoviePlayerViewController*vc;
    UIButton * selectButton;
    UIView * selectView;
    UIButton * rightButton ;
    CGFloat height;
    UIScrollView * _Sc;
    UIScrollView * mainSc;
    relatedVideoView * rightView;
    UIView * leftView;
    MBProgressHUD * mLoadView;
    UIScrollView * rightSc;
    HoriViewController * horiPlay;
    float bgImageViewHeight;
    float manScX;
    float selectHeightX;
    UIImageView * bgIMageView;
    UILabel * classTitleLable;
    NSString * videoPath;
    NSString * videoBgImg1;
    UILabel * firstLable;
    NSString * detailString;
    UIView * bgView;
    AppDelegate *_app;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end
@implementation LisenViewController
@synthesize mLoadMsg;

- (void)viewDidLoad {
    [super viewDidLoad];
    videoPath = self.lisenDic[@"videoPath"];
    videoBgImg1 = self.lisenDic[@"videoBgImg"];
    detailString = self.lisenDic[@"intro"];
    
    _app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self makeUI];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNav];
    [self createPlay];
    
    [self createTableView];
    
    [self createMain];
    [self createRightView];
    [self createLeftView];
    
}
-(void)makeUI
{
    
    //宽320
#define is3_5Inch  ([UIScreen mainScreen].bounds.size.height == 480.0)
    /**是否4寸屏*/
#define is4Inch  ([UIScreen mainScreen].bounds.size.height == 568.0)
    /**是否是4.7寸屏*/
    //宽375
#define is4_7Inch ([UIScreen mainScreen].bounds.size.height == 667.0)
    /**是否是5.5寸屏幕*/
    //宽414
#define is5_5Inch ([UIScreen mainScreen].bounds.size.height == 736.0)
    if (is3_5Inch||is4Inch)
    {
        bgImageViewHeight =130;
        //        selectHeightX = 140+64;
        //        manScX = 140+64;
        
        
    }else if(is4_7Inch)
    {
        bgImageViewHeight =150;
        //        manScX = 160+64;
    }else if (is5_5Inch)
    {
        bgImageViewHeight =170;
        //        manScX = 180+64;
    }
    
}

-(void)createPlay
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDETH, bgImageViewHeight)];
    bgView.backgroundColor = [UIColor colorWithRed:0.13f green:0.07f blue:0.01f alpha:1.00f];
    [self.view addSubview:bgView];
    bgIMageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, WIDETH, bgImageViewHeight)];
    [bgIMageView sd_setImageWithURL:[NSURL URLWithString:videoBgImg1]];
    
    [bgView addSubview:bgIMageView];
    
    UIButton * playButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDETH /2 - 75,(bgImageViewHeight-50)/2, 150, 50)];
    
    playButton.backgroundColor =[UIColor colorWithRed:226/255.0 green:30/255.0 blue:26/255.0 alpha:0.800f];
    [playButton addTarget:self action:@selector(playButton) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:playButton];
    UIImageView * playView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 50,50)];
    playView.image = [UIImage imageNamed:@"play.png"];
    [playButton addSubview:playView];
    UILabel * playLable = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 95, 50)];
    playLable.text = @"点击播放";
    playLable.textColor = [UIColor whiteColor];
    playLable.font = [UIFont systemFontOfSize:20];
    playLable.textAlignment = NSTextAlignmentCenter;
    [playButton addSubview:playLable];
    
}
-(void)playButton
{
   
    horiPlay=[[HoriViewController alloc]initWithContentURL:[NSURL URLWithString:videoPath]];
    //缓存播放
    [horiPlay.moviePlayer prepareToPlay];
    // 立即播放
    [horiPlay.moviePlayer play];
    //播放
    [self presentViewController:horiPlay animated:YES completion:nil];
    
}

-(void)createRightView
{
    rightView = [[relatedVideoView alloc] initWithFrame:CGRectMake(WIDETH, 0, WIDETH, mainSc.frame.size.height)];
    //    __weak typeof(self) weakSelf = self;
    
    rightView.myBlock = ^(NSDictionary *dic)
    {
        
        videoPath = dic[@"videoPath"];
        classTitleLable.text = dic[@"name"];
        self.lisenDic = dic;
        [bgIMageView sd_setImageWithURL:[NSURL URLWithString:dic[@"videoBgImg"]]];
        height=[detailString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 1000)].height;
        firstLable.text = dic[@"intro"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:firstLable.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        
        [paragraphStyle setLineSpacing:12];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [firstLable.text length])];
        firstLable.attributedText = attributedString;
        [_Sc addSubview:firstLable];
        _Sc.contentSize = CGSizeMake(WIDETH, height);

    };
    
    rightView.videoId = self.lisenDic[@"videoId"];
    rightView.lisen = self;
    [rightView loadData];
    [mainSc addSubview:rightView];
    mainSc.contentSize = CGSizeMake(WIDETH*2, HEIGHT - 70-40-bgImageViewHeight);
    
}
-(void)createTableView
{
    //bgview
    selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 70+bgImageViewHeight, WIDETH, 40)];
    selectView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:selectView];
    //
    NSArray * array = @[@"课程简介",@"相关课程"];
    for (int i = 0 ; i < 2; i++) {
        UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(30+i*((WIDETH - 60) /2 - 20)+i*40, 0, (WIDETH - 60) /2 - 20, 34)];
        titleLable.text = array[i];
        titleLable.font = [UIFont systemFontOfSize:14];
        titleLable.textAlignment  = NSTextAlignmentCenter;
        titleLable.textColor = [UIColor blackColor];
        titleLable.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.93f alpha:1.00f];
        [selectView addSubview:titleLable];
    }
    
    
    //添加按钮
    selectButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, (WIDETH - 60) /2 - 20, 40)];
    
    [selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.tag = 10;
    
    [selectButton setImage:[UIImage imageNamed:@"2_03.png"] forState:UIControlStateSelected];
    
    selectButton.selected = YES;
    [selectView addSubview:selectButton];
    
    //添加按钮
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDETH - 60) /2 +30 +20, 0, (WIDETH - 60) /2 - 20, 40)];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.tag = 11;
    [rightButton setImage:[UIImage imageNamed:@"1_03.png"] forState:UIControlStateSelected];
    rightButton.selected = NO;
    [selectView addSubview:rightButton];
}
-(void)buttonClick:(UIButton *)sender
{    NSLog(@"");
    CGFloat  index = sender.tag - 10;
    
    NSLog(@"%f",index);
    UIButton * btn0 = (UIButton *)[selectView viewWithTag:10];
    UIButton * btn1 = (UIButton*)[selectView viewWithTag:11];
    NSArray * tempArray = @[btn0,btn1];
    
    for (UIButton * btn in tempArray) {
        if (btn.tag - 10 == index) {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        mainSc.contentOffset =CGPointMake(index*WIDETH, 0);
    }];
}
-(void)createMain
{
    mainSc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70+40+bgImageViewHeight, WIDETH, HEIGHT - 70-40-bgImageViewHeight)];
    mainSc.delegate  =self;
    //       mainSc.backgroundColor = [UIColor greenColor];
    mainSc.showsHorizontalScrollIndicator = NO;
    
    mainSc.pagingEnabled = YES;
    [self.view addSubview:mainSc];
    mainSc.contentSize = CGSizeMake(WIDETH * 2, HEIGHT - 70-40-bgImageViewHeight);
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    //    bottomLineView.frame = CGRectMake((WIDETH /2- 100)/2+point.x/2, 47, 120, 3);
    
    int index = (int)point.x/(WIDETH/2);
    UIButton * btn0 = (UIButton *)[selectView viewWithTag:10];
    UIButton * btn1 = (UIButton*)[selectView viewWithTag:11];
    if (index == 0) {
        btn0.selected = YES;
        btn1.selected = NO;
    }
    else if(index==2||index == 1)
    {
        btn0.selected = NO;
        btn1.selected = YES;
    }
    
    NSLog(@"%f~~~~%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}
-(void)createLeftView
{
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDETH,  HEIGHT - 70-40-bgImageViewHeight)];
    //   leftView.backgroundColor = [UIColor redColor];
    [mainSc addSubview:leftView];
    _Sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDETH, leftView.frame.size.height)];
    //_Sc.backgroundColor = [UIColor redColor];
    _Sc.backgroundColor=[UIColor colorWithRed:249.0/255 green:249.0/255 blue:247.0/255 alpha:1.00f];
    _Sc.contentSize = CGSizeMake(WIDETH*2, height-70-40-bgImageViewHeight);
    [leftView addSubview:_Sc];
    height=[detailString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, 1000)].height;
    
    firstLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 11, WIDETH - 40, height)];
    
    firstLable.text = detailString;
    firstLable.numberOfLines = 0 ;
    firstLable.font = [UIFont systemFontOfSize:15];
    firstLable.textColor = [UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:firstLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    [paragraphStyle setLineSpacing:12];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [firstLable.text length])];
    firstLable.attributedText = attributedString;
    [_Sc addSubview:firstLable];
    _Sc.contentSize = CGSizeMake(WIDETH, height);
    
}

-(void)createNav
{
    
    UIView*  navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDETH, 44)];
    navBgview.backgroundColor = NAVBRG;
    [self.view addSubview:navBgview];
    
    //左侧首页按钮
    
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    //    [leftButton setImage:[UIImage imageNamed:@"jiantou_03.png"] forState:UIControlStateNormal ];
    [leftButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [navBgview addSubview:leftButton];
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 9, 14, 22)];
    leftImageView.image = [UIImage imageNamed:@"jiantou_03.png"];
    [leftButton addSubview:leftImageView];
    //对应课程标题
    classTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDETH, 44)];
    classTitleLable.text = self.lisenDic[@"name"];
    
    classTitleLable.font = [UIFont systemFontOfSize:17];
    classTitleLable.textAlignment = NSTextAlignmentCenter;
    classTitleLable.textColor = [UIColor whiteColor];
    [navBgview addSubview:classTitleLable];
    
    //下载按钮
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(WIDETH - 34, 10, 24, 24)];
    //    [button setTitle:@"下载" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"app辽宁政务-详情-课程简介下载_03.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(downButton) forControlEvents:UIControlEventTouchUpInside];
    [navBgview addSubview:button];
}
-(void)downButton
{
    //实时监测网络的变化
    [self isNewWork];
    
   
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:[user objectForKey:DOWNLOADHISTORY]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:[user objectForKey:DOWNLOADHISTORYINFO]];
    if (![arr containsObject:videoPath]) {
        [arr addObject:videoPath];
        [dic  setObject:_lisenDic forKey:videoPath];
        [user setObject:dic forKey:DOWNLOADHISTORYINFO];
        [user synchronize];
        [user setObject:arr forKey:DOWNLOADHISTORY];
        [user synchronize];
        [_app addRequest:videoPath withInfo:_lisenDic];
    }
   
}
-(void)isNewWork{
    Reachability*net=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([net currentReachabilityStatus]) {
        case ReachableViaWiFi:
        {
            NSLog(@"wifi");
            MBProgressHUD* mLoadView1 = [[MBProgressHUD alloc] initWithView:bgView];
            [bgView addSubview:mLoadView1];
            
            mLoadView1.mode = MBProgressHUDModeCustomView;
            mLoadView1.labelText = @"当前是wifi状态,成功添加到下载管理";
            [mLoadView1 show:YES];
            [mLoadView1 hide:YES afterDelay:2];
            mLoadView1 = nil;
        }
            
            break;
        case ReachableViaWWAN:
        {
            NSLog(@"3G");
            MBProgressHUD* mLoadView1 = [[MBProgressHUD alloc] initWithView:bgView];
            [bgView addSubview:mLoadView1];
            
            mLoadView1.mode = MBProgressHUDModeCustomView;
            mLoadView1.labelText = @"当前是3G状态，成功添加到下载管理";
            [mLoadView1 show:YES];
            [mLoadView1 hide:YES afterDelay:2];
            mLoadView1 = nil;
        }
            break;
            
        case NotReachable:
        {
            NSLog(@"无网络");
            MBProgressHUD* mLoadView1 = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:mLoadView1];
            
            mLoadView1.mode = MBProgressHUDModeCustomView;
            mLoadView1.labelText = @"当前处于网络状态";
            [mLoadView1 show:YES];
            [mLoadView1 hide:YES afterDelay:2];
            mLoadView1 = nil;
        }
            break;
        default:
            break;
    }
    
    
}

-(void)leftButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
-(void)backButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
