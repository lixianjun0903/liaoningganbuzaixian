//
//  ChildrenViewController.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-4.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "ChildrenViewController.h"
#import "ChildrenTableViewCell.h"
#import "LisenViewController.h"
#import "ClassFirstTableViewCell.h"

#import "JSON.h"
#import "ImageDownManager.h"
#import "MBProgressHUD.h"
#define WIDETH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
@interface ChildrenViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,MJRefreshBaseViewDelegate>
{
    
    MBProgressHUD * mLoadView;
    UIView   * navBgview;
    UIImageView * imageViews;
    UITableView * _tableView;
   float cellHeight;
    
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    int mpage;
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation ChildrenViewController
@synthesize mLoadMsg;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray= [NSMutableArray arrayWithCapacity:0];

    mpage =0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNav];
    [self createTableView];
    [self loadData];
    [self makeUI];
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
    NSString * urlstr =[NSString stringWithFormat:
                         @"%@/video/getVideoListByCategoryIdAndroid.json?categoryId=%@&pageNumber=%d&studentId=%@",BASEURL,self.categoryId,mpage,strID];

   
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
        
//        if (mpage == 0) {
//        [self.dataArray removeAllObjects];
//            
//        }
        
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

//        for (NSDictionary *dic in array) {
//            
//            
//            [self.dataArray addObject:dic];
//            
//        }
//        
//        
//        [_tableView reloadData];
        
//    }
}

#pragma mark 开始下载
-(void)StartLoading
{
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self CancelFail];
}
-(void)CancelFail
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


-(void)createNav
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDETH, 20)];
//    view.backgroundColor = [UIColor blackColor];
//    UIApplication * app = [UIApplication sharedApplication];
//    AppDelegate * delegate = (AppDelegate*)app.delegate;
//    [delegate.window addSubview:view];


navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDETH, 44)];
navBgview.backgroundColor = NAVBRG;
[self.view addSubview:navBgview];
UILabel  * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, WIDETH - 80, 44)];
    titleLable.text = self.categoryName;
titleLable.font = [UIFont systemFontOfSize:17];
titleLable.textAlignment   = NSTextAlignmentCenter;
titleLable.textColor =[UIColor whiteColor];
[navBgview addSubview:titleLable];



//左侧首页按钮

UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
//    [leftButton setImage:[UIImage imageNamed:@"jiantou_03.png"] forState:UIControlStateNormal ];
[leftButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
[navBgview addSubview:leftButton];

UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 9, 14, 22)];
leftImageView.image = [UIImage imageNamed:@"jiantou_03.png"];
[leftButton addSubview:leftImageView];


}
-(void)backButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDETH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassFirstTableViewCell" owner:self options:nil] firstObject];
    }
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"videoImg"]] placeholderImage:[UIImage imageNamed:@"图标logo.png"]];
    cell.headLable.text = self.dataArray[indexPath.row][@"name"];
    cell.numLalbe.text = [NSString stringWithFormat:@"点播次数:%@",self.dataArray[indexPath.row][@"playnum"]];
    
    int num =[self.dataArray[indexPath.row][@"seconds"]intValue];
    cell.classTimeLalbe.text = [NSString stringWithFormat:@"课时:%d分钟",num/60];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LisenViewController * lisen = [[LisenViewController alloc] init];
//    lisen.videoId  = self.dataArray[indexPath.row][@"videoId"];
//    lisen.intro = self.dataArray[indexPath.row][@"intro"];
//    lisen.videoPath = self.dataArray[indexPath.row][@"videoPath"];
//    lisen.name = self.dataArray[indexPath.row][@"name"];
//    lisen.videoImg = self.dataArray[indexPath.row][@"videoImg"];
//    lisen.videoBgImg = self.dataArray[indexPath.row][@"videoBgImg"];
    lisen.lisenDic =self.dataArray[indexPath.row];
    [self presentViewController:lisen animated:YES completion:nil];
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
