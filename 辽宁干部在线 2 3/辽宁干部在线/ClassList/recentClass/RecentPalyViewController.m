

//
//  RecentPalyViewController.m
//  辽宁政务
//
//  Created by lixianjun on 15-3-31.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import "RecentPalyViewController.h"
#import "RencentsTableViewCell.h"
#import "JSON.h"
#import "ImageDownManager.h"
#import "MBProgressHUD.h"
#import "LisenViewController.h"
#define iOS7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0
#define WIDETH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
@interface RecentPalyViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,MJRefreshBaseViewDelegate>
{
    MBProgressHUD * mLoadView;
    UITableView *_tableView;
    float cellHeight;
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    int mpage;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation RecentPalyViewController
@synthesize mLoadMsg;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray= [NSMutableArray arrayWithCapacity:0];
    mpage = 0;
    [self createNav];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
[self makeUI];
    
        [self loadData];
    // Do any additional setup after loading the view.
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
    if (is3_5Inch)
    {
        cellHeight = 95;
        
    }else if (is4Inch)
    {
        cellHeight = 95;
    }else if(is4_7Inch)
    {
        cellHeight = 95;
    }else if (is5_5Inch)
    {
        cellHeight = 95;
        
    }
    
}

-(void)dealloc
{   [header free];
    [footer free];
    _mDownManager.delegate = nil;
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    mLoadView.delegate = self;
    mLoadView.labelText = @"正在加载...";
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
    }
    mLoadView.dimBackground = YES;
    [mLoadView show:YES];
    [self.view addSubview:mLoadView];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *strID = [user objectForKey:@"sutdentId"];

    NSString * urlstr = [NSString stringWithFormat:@"%@/statistics/getMyPlayHistory.json?studentId=%@&pageNumber=%d",BASEURL, strID,mpage];
        self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    }
- (void)OnLoadFinish:(ImageDownManager *)sender
{
    
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    NSArray *array = dict[@"data"];
    
    if (array&&[array isKindOfClass:[NSArray class]] &&array.count>0) {
        
        if (mpage==0) {
          [self.dataArray removeAllObjects];
        
       
        }
        [self.dataArray addObjectsFromArray:array];
        mpage ++;
        [_tableView reloadData];
        
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载完成";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
    }
}



#pragma mark 开始下载
-(void)StartLoading
{
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [header endRefreshing];
    [footer endRefreshing];
    [mLoadView hide:YES];
    mLoadView = nil;
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
    
}



-(void)createTableView
{
  
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDETH, HEIGHT - 64) style:UITableViewStylePlain];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.delegate = self;
    _tableView.dataSource= self;
    [self.view addSubview:_tableView];
    header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
    
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == header) {
        mpage =0;
        [self loadData];
    }
    else if (refreshView == footer)
    {
        [self loadData];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
//    ((NSArray *)(self.dataArray[0][@"videoData"])).count;
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RencentsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil]firstObject];
       
    }
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"videoImg"]] placeholderImage:[UIImage imageNamed:@"图标logo.png"]];
    cell.headLable.text = self.dataArray[indexPath.row][@"name"];
    NSString * strPath = self.dataArray[indexPath.row][@"lastPlayTime"];
    
    NSString * yearStr = [strPath substringToIndex:4];
    NSString * monthStr = [strPath substringWithRange:NSMakeRange(4,2)];
    NSString * dayStr = [strPath substringWithRange:NSMakeRange(6, 2)];
    int * hour = (int)([[strPath substringWithRange:NSMakeRange(8, 3)] intValue])/60;
    int  * acount = (int)([[strPath substringWithRange:NSMakeRange(11, 3)] intValue])/60;
    cell.palyTimeLable.text =[NSString stringWithFormat:@"上次播放:%@/%@/%@ %d:%d",yearStr,monthStr,dayStr,hour,acount];
//    self.dataArray[indexPath.row][@"lastPlayTime"];
//     [cell config:self.dataArray[0][@"videoData"][indexPath.row] :(int)indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了哪门课程");
    LisenViewController * lisen = [[LisenViewController alloc] init];
    lisen.videoId = self.dataArray[indexPath.row][@"videoId"];
    lisen.videoPath = self.dataArray[indexPath.row][@"videoPath"];
    lisen.intro = self.dataArray[indexPath.row][@"intro"];
    lisen.name  = self.dataArray[indexPath.row][@"name"];
    lisen.videoImg = self.dataArray[indexPath.row][@"videoImg"];
    lisen.videoBgImg = self.dataArray[indexPath.row][@"videoBgImg"];
    [self presentViewController:lisen animated:YES completion:nil];


}
-(void)createNav
{

    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDETH, 20)];
//    view.backgroundColor = [UIColor blackColor];
//    UIApplication * app = [UIApplication sharedApplication];
//    AppDelegate * delegate = (AppDelegate*)app.delegate;
//    [delegate.window addSubview:view];

        //导航背景
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
    UILabel * classTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDETH, 44)];
    classTitleLable.text = @"最近播放";
    classTitleLable.font = [UIFont systemFontOfSize:17];
    classTitleLable.textAlignment = NSTextAlignmentCenter;
    classTitleLable.textColor = [UIColor whiteColor];
    [navBgview addSubview:classTitleLable];
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
