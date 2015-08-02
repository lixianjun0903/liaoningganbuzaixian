//
//  ClassFistPageViewController.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-4.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "ClassFistPageViewController.h"
#import "RecentPalyViewController.h"
#import "AboutViewController.h"
#import "SDCycleScrollView.h"
#import "ClassFirstTableViewCell.h"
#import "MVYMenuViewController.h"
#import "KxMenu.h"
#import "MVYSideMenuController.h"
#import "ChildrenViewController.h"
#import "LisenViewController.h"
#import "MJRefresh.h"
#import "DataCachTool.h"
#import "DownloadViewController.h"
#import "AppDelegate.h"
#import "DownPlayViewController.h"
@interface ClassFistPageViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate>
{
    MBProgressHUD * mLoadView;
    UIView *yearView;
    NSString *year;
    UIView   * navBgview;
    UIImageView * imageViews;
    UICollectionView *collection;
    UITableView * _tableView;
    UIButton * _btn3;
    float cellHeight;
    float focusHeight;
    
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    int mpage;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation ClassFistPageViewController
@synthesize mLoadMsg;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    self.dataArray= [NSMutableArray arrayWithCapacity:0];
    mpage =0;
    self.view.backgroundColor =[UIColor whiteColor];
    [self createNav];
    [self createTableView];
    [self createSc];
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
        focusHeight = 150;
        
    }else if (is4Inch)
    {
        cellHeight = 95;
        focusHeight = 150;
    }else if(is4_7Inch)
    {
        cellHeight = 95;
        focusHeight = 160;
    }else if (is5_5Inch)
    {
        cellHeight = 95;
        focusHeight = 170;
        
    }
}
-(void)dealloc
{
    _mDownManager.delegate = nil;
    [header free];
    [footer free];
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    //透明显示层
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    mLoadView.delegate = self;
    mLoadView.labelText = @"正在加载...";
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
    }
    mLoadView.dimBackground = YES;
    [mLoadView show:YES];
    [self.view addSubview:mLoadView];
    //
    NSString *urlstr = [NSString stringWithFormat:@"%@/video/getHomePageVideoList.json?pageNumber=%d",BASEURL,mpage];
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
    NSArray *array = dict[@"videoData"];
    
    if (array&&[array isKindOfClass:[NSArray class]] &&array.count>0) {
        if (mpage==0) {
          [self.dataArray removeAllObjects];
           

        }
        [self.dataArray addObjectsFromArray:array];
        
     [DataCachTool arryWriteToFile:@"dataHome" baseBody:self.dataArray];
        
        mpage ++;
        [_tableView reloadData];
        
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"已加载完全部数据";
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
    
    if (![DataCachTool hasFile:@"dataHome"]) {
        NSLog(@"文件不存在");
        
    }
    else
    {
        //加载数据
        NSArray * array = [DataCachTool arryReadFromFile:@"dataHome"];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:array];
        [_tableView reloadData];
    
    }
    [self CancelFaile];
}
-(void)CancelFaile
{
    MBProgressHUD* mLoadView1 = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mLoadView1];
    
    mLoadView1.mode = MBProgressHUDModeCustomView;
    mLoadView1.labelText = @"网络有问题";
    [mLoadView1 show:YES];
    [mLoadView1 hide:YES afterDelay:3];
    mLoadView1 = nil;


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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDETH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    _tableView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataArray.count;
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"ClassFirstTableViewCell" owner:self options:nil] firstObject];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"videoImg"]] placeholderImage:[UIImage imageNamed:@"图标logo.png"]];
    cell.headLable.text = self.dataArray[indexPath.row][@"name"];
    cell.numLalbe.text = [NSString stringWithFormat:@"点播次数:%@",self.dataArray[indexPath.row][@"playnum"]];
    
    int num =[self.dataArray[indexPath.row][@"seconds"]intValue];
    cell.classTimeLalbe.text = [NSString stringWithFormat:@"课时:%d分钟",num/60];
    
    
//    NSDictionary * dic = @{@"videoImg":self.dataArray[indexPath.row][@"videoImg"],
//                           @"name":self.dataArray[indexPath.row][@"name"],
//                           
//                           @"playnum":self.dataArray[indexPath.row][@"playnum"],
//                           @"seconds":[self.dataArray[indexPath.row][@"seconds"]stringValue],
//                           
//                           };
//    [DataCachTool arryWriteToFile:@"dataHome" baseBody:dic];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSLog(@"选择了哪门课程");
    LisenViewController * lisen = [[LisenViewController alloc] init];
//    lisen.videoId = self.dataArray[indexPath.row][@"videoId"];
//    lisen.videoPath = self.dataArray[indexPath.row][@"videoPath"];
//    lisen.intro = self.dataArray[indexPath.row][@"intro"];
//    lisen.name  = self.dataArray[indexPath.row][@"name"];
//    lisen.videoImg = self.dataArray[indexPath.row][@"videoImg"];
//    lisen.videoBgImg = self.dataArray[indexPath.row][@"videoBgImg"];
    lisen.lisenDic = self.dataArray[indexPath.row];
    [self presentViewController:lisen animated:YES completion:nil];
   
}

-(void)createSc
{
    
    NSArray *images = @[[UIImage imageNamed:@"轮播1.jpg"],
                        [UIImage imageNamed:@"轮播2.jpg"],
                        [UIImage imageNamed:@"轮播3.jpg"]
                        ];
    
    
    NSArray *titles = @[@"辽宁干部在线",
                        @"讲诚信守规矩",
                        @"社会主义核心价值观"
                        ];
    
    
    
    //    // 创建不带标题的图片轮播器
    //    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 60, w, 180) imagesGroup:images];
    //    cycleScrollView.delegate = self;
    //    cycleScrollView.autoScrollTimeInterval = 2.0;
    //    [self.view addSubview:cycleScrollView];
    
    
    // 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, WIDETH, focusHeight) imagesGroup:images];
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.delegate = self;
    cycleScrollView2.titlesGroup = titles;
    _tableView.tableHeaderView = cycleScrollView2;
    //    [_tableView addSubview:cycleScrollView2];
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%d张图片", (int)index);
}
-(void)createNav
{
    
    
    navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDETH, 44)];
    navBgview.backgroundColor = NAVBRG;
    [self.view addSubview:navBgview];
    UILabel  * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, WIDETH - 80, 44)];
    titleLable.text = @"辽宁干部在线";
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.textAlignment   = NSTextAlignmentCenter;
    titleLable.textColor =[UIColor whiteColor];
    [navBgview addSubview:titleLable];
    
    
    //下拉菜单
    _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(WIDETH -50, 20,50, 44)];
    
//    [_btn3 setImage:[UIImage imageNamed:@"03.png"] forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn3];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 8, 28, 28)];
    imageView.image = [UIImage imageNamed:@"03.png"];
    [_btn3 addSubview:imageView];
    
    //左侧按钮课程列表
    UIButton * classButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 60, 44)];
    //    classButton.backgroundColor = [UIColor redColor];
    [classButton addTarget:self action:@selector(classCilck) forControlEvents:UIControlEventTouchUpInside];
    [navBgview addSubview:classButton];
    
    UIImageView * classImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    classImageView.image =[UIImage imageNamed:@"menu_icon (1).png"];
    [classButton addSubview:classImageView];
}
- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"最近播放"
                     image:[UIImage imageNamed:@"app辽宁政务-首页_031.png"]
                    target:self
                    action:@selector(pushMenuItem1)],
      [KxMenuItem menuItem:@"下载管理"
                     image:[UIImage imageNamed:@"app辽宁政务-2_07.png"]
                    target:self
                    action:@selector(pushMenuItem3)],
      
      [KxMenuItem menuItem:@"关于我们"
                     image:[UIImage imageNamed:@"app辽宁政务-首页_06.png"]
                    target:self
                    action:@selector(pushMenuItem2)],
      
      [KxMenuItem menuItem:@"退出登录"
                                                                    image:[UIImage imageNamed:@"app辽宁政务-首页_09(1).png"]
                                                                   target:self
                                                                   action:@selector(pushMenuItem4)]];
    
    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}
-(void)pushMenuItem1{
    
    RecentPalyViewController * recent = [[RecentPalyViewController alloc] init];
    //    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:recent];
    [self presentViewController:recent animated:YES completion:nil];
}
-(void)pushMenuItem2
{
    
    AboutViewController * about = [[AboutViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:about];
    [self presentViewController:nav animated:YES completion:nil];
   
    
}
-(void)pushMenuItem3
{
//    UIApplication * app = [UIApplication sharedApplication];
//    AppDelegate * delegate = (AppDelegate *)app.delegate;
    
//    DownloadViewController * down =  delegate.downVC;
    DownPlayViewController * down =[[DownPlayViewController alloc] init];
    [self presentViewController:down animated:YES completion:nil];
    
    }
-(void)pushMenuItem4
{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else
    {
//        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
////        NSString * userPassword = [user objectForKey:@"userPassword"];
//        [user removeObjectForKey:@"userPassword"];
//        [user synchronize];
//        NSString * str = [[RegisterMananger shareManager] isFirstLogin];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isRemove" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}

-(void)classCilck
{
    
    
    MVYSideMenuController *sideMenuController = [self sideMenuController];
    if (sideMenuController) {
        [sideMenuController openMenu];
    }
    //    NSLog(@"课程列表");
    //    ClassCategoryViewController * class = [[ClassCategoryViewController alloc] init];
    //    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:class];
    //    [self presentViewController:nav animated:YES completion:nil];
    
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
