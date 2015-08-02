

//
//  ClassNumViewController.m
//  干部在线
//
//  Created by lixianjun on 15-3-30.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import "ClassNumViewController.h"
#import "LisenViewController.h"
#import "RecentPalyViewController.h"
#import "AboutViewController.h"
#import "ClassNumCollectionViewCell.h"
#import "LZCustomCollectionReusableView.h"
#import "ImageDownManager.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "UIImageView+WebCache.h"
#define WIDETH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define ID  @"cell"
#define ID2 @"element"
#define BGColor [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
#define CELLBorderColor [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]
#define ScreenBounsSize [UIScreen mainScreen].bounds.size

@interface ClassNumViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>

{  MBProgressHUD * mLoadView;
    UIView *yearView;
    NSString *year;
    UIView   * navBgview;
    UIImageView * imageViews;
    UICollectionView *collection;
    LZCustomCollectionReusableView *reusableView;

    
}
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)ImageDownManager *mDownManager;


//@property (nonatomic,strong) LZCustomCollectionReusableView *reusableView;
@end

@implementation ClassNumViewController
@synthesize mLoadMsg;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor  =[UIColor whiteColor];
    [self createNav];
    [self initCollectionView];
    [self loadData];
    // Do any additional setup after loading the view.
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
    [self.view addSubview:mLoadView];
    
    NSString * urlstr = [NSString stringWithFormat:@"%@/video/getVideoList.json",BASEURL];
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
        
                 [collection reloadData];
        
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
    [mLoadView hide:YES];
    mLoadView = nil;
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
    
}


-(void)initCollectionView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置行间距
    layout.minimumLineSpacing = 0;
    //这是item(方块)的间距
    layout.minimumInteritemSpacing = 1;
    //设置Item的长和宽
    layout.itemSize = CGSizeMake((ScreenBounsSize.width-18)/2, 120);
    //设置组的边距（上，左，下，右）
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 1, 8);
    //设置（组）头部视图的高度
    layout.headerReferenceSize = CGSizeMake(0, 45);
    
    //初始化uicollectionView
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, ScreenBounsSize.width, ScreenBounsSize.height-64) collectionViewLayout:layout];
    //背景颜色
    collection.backgroundColor = [UIColor whiteColor];
    
    //注册一个item（cell）
    //    [collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:ID];
    [collection registerNib:[UINib nibWithNibName:@"ClassNumCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    //注册一个头部视图（header）
    [collection registerNib:[UINib nibWithNibName:@"LZCustomCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ID2];
    //设置代理和数据源
    collection.dataSource = self;
    collection.delegate = self;
    [self.view addSubview:collection];
    
    
}

#pragma mark - UICollectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
      return self.dataArray.count;
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
       return ((NSArray*)(self.dataArray[section][@"videoData"])).count;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassNumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    //    cell.layer.borderWidth = 0.3;
    //    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.97f alpha:1.00f];
        [cell.ImageVieW sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.section][@"videoData"][indexPath.row][@"videoImg"]] placeholderImage:nil];
    
        cell.detailLable.text = self.dataArray[indexPath.section][@"videoData"][indexPath.row][@"name"];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:ID2 forIndexPath:indexPath];
             reusableView.titleLabel.text = self.dataArray[indexPath.section][@"categoryName"];
    
    
    return reusableView;
}



#pragma mark - UICollectionView delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LisenViewController * lisen = [[LisenViewController alloc] init];
    lisen.intro = self.dataArray[indexPath.section][@"videoData"][indexPath.row][@"intro"];
    lisen.videoId = self.dataArray[indexPath.section][@"videoData"][indexPath.row][@"videoId"];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:lisen];
    [self presentViewController:lisen animated:YES completion:nil];
    NSLog(@"点击了第%ld个Item",(long)indexPath.item);
}

-(void)createNav
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDETH, 44)];
    navBgview.backgroundColor = [UIColor colorWithRed:0.06f green:0.22f blue:0.40f alpha:1.00f];
    [self.view addSubview:navBgview];
    UILabel  * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, WIDETH - 80, 44)];
    titleLable.text = @"辽宁政务学习网";
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.textAlignment   = NSTextAlignmentCenter;
    titleLable.textColor =[UIColor whiteColor];
    [navBgview addSubview:titleLable];
    
    
//    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDETH -44, 0,44, 44)];
    
//    [leftButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
//    [navBgview addSubview:leftButton];
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 13, 20, 20)];
//    imageView.image = [UIImage imageNamed:@"03.png"];
//    [leftButton addSubview:imageView];
    
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


//-(void)backButton
//{
//    NSLog(@"选项设置");
//    NSArray  * yearsArray = @[@"最近播放",@"关于我们",@"退出登陆"];
//    NSArray * iamgeArreay = @[@"app辽宁政务-首页_031.png",@"app辽宁政务-首页_06.png",@"app辽宁政务-首页_09(1).png"];
//    if (yearView == nil) {
//        yearView = [[UIView alloc]initWithFrame:CGRectMake(WIDETH  - 120, 63, 112, 0.1)];
//        [self.view addSubview:yearView];
//        imageViews = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, yearView.frame.size.width, yearView.frame.size.width)];
//        imageViews.image = [UIImage imageNamed:@"02_03.png"];
//        [yearView addSubview:imageViews];
//    }
//    [UIView animateWithDuration:0.1 animations:^{
//        yearView.frame = CGRectMake(WIDETH-120, 72, 112, 155);
//        imageViews.frame = CGRectMake(0, 0, 112, 150);
//        for (int i= 0; i<yearsArray.count; i++) {
//            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4+i * 50, 112, 50)];
//            //            btn.backgroundColor = [UIColor redColor];
//            
//            //            添加图片
//            UIImageView * titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 18, 17, 14)];
//            titleImageView.image = [UIImage imageNamed:iamgeArreay[i]];
//            [btn addSubview:titleImageView];
//            //添加文字
//            UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 55, 50)];
//            titleLable.text = yearsArray[i];
//            titleLable.font = [UIFont boldSystemFontOfSize:15];
//            titleLable.textAlignment = NSTextAlignmentCenter;
//            titleLable.textColor = [UIColor whiteColor];
//            titleLable.adjustsFontSizeToFitWidth = YES;
//            [btn addSubview:titleLable];
//            [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
//            [yearView addSubview:btn];
//            btn.tag = 10 + i;
//            
//            
//        }
//    }];
//    
//}
//
//#pragma mark 我的年份学习记录
//-(void)selectClick:(UIButton*)sender
//{
//    switch (sender.tag) {
//        case 10:
//            
//        {
//            RecentPalyViewController * recent = [[RecentPalyViewController alloc] init];
//            UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:recent];
//            [self presentViewController:nav animated:YES completion:nil];
//        }
//            break;
//        case 11:
//            
//        {
//            AboutViewController * about = [[AboutViewController alloc] init];
//            UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:about];
//            [self presentViewController:nav animated:YES completion:nil];
//        }
//            break;
//        case 12:
//            
//        {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }
//            break;
//            
//            
//        default:
//            break;
//    }
//    
//    
//    float index = sender.tag - 10;
//    NSArray  * yearsArray = @[@"最近播放",@"关于",@"退出"];
//    
//    year = yearsArray[sender.tag-10];
//    NSLog(@"年份%f",index);
//    [UIView animateWithDuration:0.5 animations:^{
//        yearView.frame =CGRectMake(WIDETH-78, 63, 78, 0.1);
//    } completion:^(BOOL finished) {
//        if (finished) {
//            for (UIView *view in yearView.subviews) {
//                [view removeFromSuperview];
//            }
//            [yearView removeFromSuperview];
//            yearView = nil;
//        }
//    }];
//}
//
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
