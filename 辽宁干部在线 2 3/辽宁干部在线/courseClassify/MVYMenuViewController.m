//
//  MVYMenuViewController.m
//  MVYSideMenuExample
//
//  Created by Álvaro Murillo del Puerto on 10/07/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import "MVYMenuViewController.h"
#import "MVYSideMenuController.h"
#import "ClassFistPageViewController.h"
#import "ClassNumViewController.h"
#import "ChildrenViewController.h"



#import "JSON.h"
#import "ImageDownManager.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#define WIDETH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
@interface MVYMenuViewController ()<MBProgressHUDDelegate>
{
MBProgressHUD * mLoadView;
    UIView * navBgview;
    float navWideth;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;
@end

@implementation MVYMenuViewController
@synthesize mLoadMsg;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeUI];
    [self createNav];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
	
	//[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
//	self.menuItems = @[@"Menu Item 1", @"Menu Item 2", @"Menu Item 3", @"Menu Item 4", @"Menu Item 5"];
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
        navWideth = 320;
        
    }else if (is4Inch)
    {
        navWideth = 320;
    }else if(is4_7Inch)
    {
        navWideth = 375;
    }else if (is5_5Inch)
    {
        navWideth = 414;
        
    }
}

-(void)createNav
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
//    self.navigationController.navigationBar.tintColor =NAVBRG;
    navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, navWideth-120, 44)];
    navBgview.backgroundColor = NAVBRG;
    [self.navigationController.view addSubview:navBgview];
    UILabel  * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, navWideth-120, 44)];
    titleLable.text = @"全部课程";
       titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.textAlignment   = NSTextAlignmentCenter;
    titleLable.textColor =[UIColor whiteColor];
    [navBgview addSubview:titleLable];
    
//    self.title = @"全部课程";
//    if (iOS7) {
//        [self.navigationController.navigationBar
//         
//         setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
//    }else{
//        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor],UITextAttributeFont : [UIFont boldSystemFontOfSize:17]}];
//    }
//
    
//    [navBgview addSubview:titleLable];
//    [self.navigationController.view addSubview:titleLable];
    


}
-(void)dealloc
{
    _mDownManager.delegate = nil;
}

-(void)loadData
{
    if (_mDownManager) {
        return;
    }

    
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    mLoadView.delegate = self;
    mLoadView.labelText = @"正在加载中...";
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
    }
    mLoadView.dimBackground = YES;
    [mLoadView show:YES];
    [self.view addSubview:mLoadView];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString *strID = [user objectForKey:@"sutdentId"];
    NSString * urlstr = [NSString stringWithFormat:@"%@/video/getCategoryList.json?studentId=%@",BASEURL,strID];

   
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    
}
- (void)OnLoadFinish:(ImageDownManager *)sender
{
    self.dataArray= [NSMutableArray arrayWithCapacity:0];
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    NSArray *array = dict[@"data"];
    
    if (array&&[array isKindOfClass:[NSArray class]] &&array.count>0)
    {
        
        [self.dataArray addObjectsFromArray:array];
        
        [self.tableView reloadData];
    }
}
#pragma mark 开始下载
-(void)StartLoading
{
    
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self CancelFial];
}
-(void)CancelFial
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
    
    [mLoadView hide:YES];
    mLoadView = nil;
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark – UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//static NSString *cellIdentifier = @"MenuCell";
	
	//UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UITableViewCell *cell = nil;
    static NSString *objectCell_ID = @"MenuCell";
    cell = [tableView dequeueReusableCellWithIdentifier:objectCell_ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:objectCell_ID];
    }
	
//	NSString *item = [self.menuItems objectAtIndex:indexPath.row];
//	[cell.textLabel setText:item];
//NSString * item = [[self.dataArray[@"categoryName"] objectAtIndex:indexPath.row]];
//    [cell.textLabel setText:item];
    cell.textLabel.text = [NSString stringWithFormat:@"%@( %@门 )",self.dataArray[indexPath.row][@"categoryName"],self.dataArray[indexPath.row][@"courseNum"]];
//    self.dataArray[indexPath.row][@"categoryName"];
	
	return cell;
}

#pragma mark – UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	ClassFistPageViewController *contentVC = [[ClassFistPageViewController alloc] init];
//	[[self sideMenuController] changeContentViewController:contentVC closeMenu:YES];
    
//    ClassNumViewController * classNumVC = [[ClassNumViewController alloc] init];
    ChildrenViewController * children = [[ChildrenViewController alloc] init];
    children.categoryId = self.dataArray[indexPath.row][@"categoryId"];
    children.categoryName = self.dataArray[indexPath.row][@"categoryName"];
    [self presentViewController:children animated:YES completion:nil];
}



@end
