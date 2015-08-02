//
//  DownPlayViewController.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-23.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "DownPlayViewController.h"
#import "DownPlayTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DownloadViewController.h"
#import "HoriViewController.h"
#define DOWNLOADFINISH @"downloadFinish"
#define DOWNLOADHISTORY @"downloadHistory"
@interface DownPlayViewController ()<UITableViewDataSource, UITableViewDelegate>

{
    NSUserDefaults *user;
    UIView * navBgview;
    NSMutableArray *_dataArr;
    NSMutableArray * _dataArrCount;
    UIImageView * bgImageView;
    UILabel * lable;
}
@property (nonatomic,strong)UITableView *customTableView;
@property(nonatomic,strong)UIButton * ediBtn;
@property (nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton * deleteBtn;
@property(nonatomic,strong)UIButton * selectAllBtn;
@property(nonatomic,strong)NSMutableDictionary * deleteDic;
@property (nonatomic,strong)NSMutableArray *imageArray;

@end
@implementation DownPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self createTableView];
    [self createNav];
    [self createView];
user = [NSUserDefaults standardUserDefaults];
    _dataArr = [[NSMutableArray alloc]initWithArray:[user objectForKey:DOWNLOADFINISH]];
    _dataArrCount = [[NSMutableArray alloc]initWithArray:[user objectForKey:DOWNLOADHISTORY]];
    [self loadData];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(httpRequestFinsh) name:@"finish" object:nil];
    // Do any additional setup after loading the view.
}
-(void)createTableView
{
    UITableView *customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+100, WIDETH, HEIGHT - 64-100)];
    customTableView.dataSource = self;
    customTableView.delegate = self;
    self.customTableView = customTableView;
    [self.view addSubview:customTableView];

}
-(void)createView
{
    
    UIView * contenView =[[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDETH, 100)];
    [self.view addSubview:contenView];
    bgImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 70)];
    
    [contenView addSubview:bgImageView];
    lable = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, 200, 20)];
    
    lable.textColor =[UIColor grayColor];
    [contenView addSubview:lable];
    [contenView endEditing:NO];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestur)];
    [contenView addGestureRecognizer:gesture];
    
}
-(void)tapGestur
{
        UIApplication * app = [UIApplication sharedApplication];
        AppDelegate * delegate = (AppDelegate *)app.delegate;
        DownloadViewController * down =  delegate.downVC;
    [self presentViewController:down animated:YES completion:nil];
    
}
-(void)httpRequestFinsh
{
    NSLog(@"httpRequestFinsh");
    _dataArrCount = nil;
    _dataArrCount = [[NSMutableArray alloc]initWithArray:[user objectForKey:DOWNLOADHISTORY]];
    
    [self loadData];
   }

-(void)loadData
{
    
    if ( _dataArrCount.count==0) {
        bgImageView.image =[UIImage imageNamed:@"iconfont-xiazai 拷贝.png"];
        lable.text = @"占无下载任务";
    }
    else
    {
        
        bgImageView.image = [UIImage imageNamed:@"iconfont-xiazai 拷贝 2.png"];
        
        lable.text = [NSString stringWithFormat:@"正在有%d个视频在下载",(int)_dataArrCount.count];
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId =@"cellId";
    DownPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DownPlayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell.iconImage setImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row][@"videoBgImg"]] placeholderImage:[UIImage imageNamed:@"播放按钮_03"]];
    cell.name.text = _dataArr[indexPath.row][@"name"];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
#pragma mark -
#pragma mark Tableview delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.ediBtn.titleLabel.text isEqualToString:@"取消"])
    {
        [self.deleteDic removeObjectForKey:[_dataArr objectAtIndex:indexPath.row]];
    }
    [self setDeleteBtnStatus];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleDefault;
    if (tableView.editing) {
        if ([self.ediBtn.titleLabel.text isEqualToString:@"取消"])
        {
            [self.deleteDic setObject:indexPath forKey:[_dataArr objectAtIndex:indexPath.row]];
        }
    }else{
    
    NSString *path = [NSHomeDirectory()stringByAppendingPathComponent:[[_dataArr[indexPath.row][@"videoPath"] componentsSeparatedByString:@"/"]lastObject]];
    HoriViewController *player = [[HoriViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    [self presentViewController:player animated:YES completion:nil];
    }
    [self setDeleteBtnStatus];
}

-(void)createNav
{
    navBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDETH, 44)];
    navBgview.backgroundColor = NAVBRG;
    [self.view addSubview:navBgview];
    //左侧首页按钮
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    [leftButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [navBgview addSubview:leftButton];
    
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 9, 14, 22)];
    leftImageView.image = [UIImage imageNamed:@"jiantou_03.png"];
    [leftButton addSubview:leftImageView];
    
    
    self.deleteDic =[[NSMutableDictionary alloc]init];
    UIButton *ediBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDETH-44, 5, 44, 40)];
    [ediBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [ediBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [ediBtn setTitle:@"取消" forState:UIControlStateSelected];
    self.ediBtn = ediBtn;
    [navBgview addSubview:ediBtn];
    
    CGFloat width = (WIDETH - 40) / 2;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-50, WIDETH, 50)];
    bgView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
   self.bgView = bgView;
    bgView.alpha = 0.0;
    [self.view addSubview:bgView];
    
    UIButton *selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,5,width,40)];
    [selectAllBtn addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setTitle:@"取消全选" forState:UIControlStateSelected];
    [selectAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
    selectAllBtn.layer.masksToBounds = YES;
    selectAllBtn.layer.cornerRadius = 5;
    selectAllBtn.backgroundColor =[UIColor blueColor];
    self.selectAllBtn = selectAllBtn;
    [bgView addSubview:selectAllBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(width +20,5,width,40)];
    [deleteBtn addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.backgroundColor =[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    deleteBtn.layer.cornerRadius = 5;
    self.deleteBtn = deleteBtn;
    [bgView addSubview:deleteBtn];
}
-(void)backButton
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)editButtonClick:(UIButton*)btn
{
    btn.selected = !btn.selected;
    [UIView animateWithDuration:0.6 animations:^{
        self.bgView.alpha = btn.selected ? 1.0:0.0;
    }];
    [self.customTableView setEditing:!self.customTableView.editing animated:true];
    if (btn.selected == NO)
    {
        for (NSIndexPath *cellIndex in [self.customTableView indexPathsForVisibleRows])
        {
            [self.customTableView cellForRowAtIndexPath:cellIndex].selected = NO;
        }
        [self.deleteDic removeAllObjects];
    }
    [self setDeleteBtnStatus];
}

- (void)selectAllButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self setDeleteBtnStatus];
    if (btn.selected)
    {
        for (int i = 0; i < _dataArr.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:self.customTableView didSelectRowAtIndexPath:indexPath];
        }
    }else
    {
        for (int i = 0; i < _dataArr.count; i++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self tableView:self.customTableView didDeselectRowAtIndexPath:indexPath];
        }
    }
    for (NSIndexPath *cellIndex in [self.customTableView indexPathsForVisibleRows])
    {
        [self.customTableView cellForRowAtIndexPath:cellIndex].selected = btn.selected;
    }
}
- (void)setEditButtonStatus
{
    if (_dataArr.count != 0)
    {
        [self.ediBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ediBtn.enabled = YES;
    }else
    {
        self.ediBtn.enabled = NO;
        self.ediBtn.backgroundColor =[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1];
        [self.ediBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.6 animations:^{
            self.bgView.alpha = 0.0;
        }];
    }
}
- (void)deleteButtonClick
{
    [self.customTableView beginUpdates];
    [_dataArr removeObjectsInArray:[self.deleteDic allKeys]];
    [self.customTableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.deleteDic allValues]] withRowAnimation:UITableViewRowAnimationFade];
    [self.deleteDic removeAllObjects];
    [self.customTableView endUpdates];
    [self setDeleteBtnStatus];
    [self setEditButtonStatus];
}
- (void)setDeleteBtnStatus
{
    self.deleteDic.count == 0 ? (self.deleteBtn.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]) : (self.deleteBtn.backgroundColor = [UIColor colorWithRed:230/255.0 green:67/255.0 blue:67/255.0 alpha:1]);
    if (self.deleteDic.count != 0)
    {
        [self.deleteBtn setTitle:[NSString stringWithFormat:@"删除 (%ld)",self.deleteDic.count] forState:UIControlStateNormal];
        return;
    }
    [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
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
