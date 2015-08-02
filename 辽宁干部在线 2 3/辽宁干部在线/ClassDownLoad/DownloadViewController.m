//
//  DownloadViewController.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-20.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "DownloadViewController.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "MyMD5.h"
#import "NSFileManager+Mothod.h"
#import "DowanLoadTableViewCell.h"
#import "DownPlayViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "DownloadDetailCellCell.h"
#import "UIImageView+WebCache.h"

#define CELL_BUTTON_TAG 800
#define DOWNLOADHISTORY @"downloadHistory"
#define DOWNLOADHISTORYINFO @"downloadHistoryInfo"

NSString * const RightBtn_EDITOR = @"编辑";
NSString * const RightBtn_CANCEL = @"取消";
@interface DownloadViewController ()<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>

{   UIView * navBgview;
    NSMutableArray *_dataArr;
    AppDelegate *_app;
    NSInteger _finishedTag;
    NSInteger _failedTag;
      NSUserDefaults *_user;
    NSMutableDictionary *_dataDic;
}
@property (nonatomic,strong)UITableView *customTableView;
@property(nonatomic,strong)UIButton * ediBtn;
@property (nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIButton * deleteBtn;
@property(nonatomic,strong)UIButton * selectAllBtn;
@property(nonatomic,strong)NSMutableDictionary * deleteDic;
@property (nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation DownloadViewController
-(void)viewWillAppear:(BOOL)animated
{
    _user =[NSUserDefaults standardUserDefaults];
    _dataArr = [[NSMutableArray alloc]initWithArray:[_user objectForKey:DOWNLOADHISTORY]];
    _dataDic = [[NSMutableDictionary alloc]initWithDictionary:[_user objectForKey:DOWNLOADHISTORYINFO]];
    
   [self.customTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
      [self customUI];
       [self createNav];
    

      // Do any additional setup after loading the view.
    _app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"%@",[_app.asiDic allValues]);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData:) name:@"123" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiRequestFinish:) name:@"122" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiRequestFailed:) name:@"121" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(httpRequestFinsh) name:@"finish" object:nil];
    
}

-(void)httpRequestFinsh
{
    NSLog(@"httpRequestFinsh");
    _dataArr = nil;
    _dataDic = nil;
//    [_dataArr removeAllObjects];
//    [_dataDic removeAllObjects];
    _dataArr = [[NSMutableArray alloc]initWithArray:[_user objectForKey:DOWNLOADHISTORY]];
    _dataDic = [[NSMutableDictionary alloc]initWithDictionary:[_user objectForKey:DOWNLOADHISTORYINFO]];
      [self.customTableView reloadData];

}
-(void)customUI
{
    UITableView *customTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDETH, HEIGHT - 64)];
    customTableView.dataSource = self;
    customTableView.delegate = self;
    self.customTableView = customTableView;
    [self.view addSubview:customTableView];

}
-(void)getData:(NSNotification *)sender
{
    NSLog(@"NSNotificationCenter %@",sender);
}
-(void)notiRequestFinish:(NSNotification *)sender
{
    _finishedTag = [sender.object intValue];
    NSLog(@"%@",sender.object);
     [self.customTableView reloadData];
}
-(void)notiRequestFailed:(NSNotification *)sender
{
    _failedTag = [sender.object intValue];
    NSLog(@"%@",sender.object);
   
  [self.customTableView reloadData];
}
-(void)onButtonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"ing"]) {
        [_app addRequest:_dataArr[sender.tag -CELL_BUTTON_TAG] withInfo:_dataDic[_dataArr[sender.tag -CELL_BUTTON_TAG]]];
        [sender setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        [sender setTitle:@"下载中" forState:UIControlStateNormal];

       [self.customTableView reloadData];
    } else if ([sender.titleLabel.text isEqualToString:@"下载中"]) {
        NSInteger flag = [[_app.asiDic allValues] indexOfObject:_dataArr[sender.tag -CELL_BUTTON_TAG]];
        for (ASIHTTPRequest *asi in _app.queue.operations) {
            if (asi.tag == [[_app.asiDic allKeys][flag] intValue]) {
                [asi clearDelegatesAndCancel];
                [_app.asiDic removeObjectForKey:[NSString stringWithFormat:@"%d",asi.tag]];
            }
        }
        NSLog(@"%@",[_app.asiDic allKeys]);
        [sender setTitle:@"ing" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%d",_dataArr.count);
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadDetailCellCell *cell = [tableView dequeueReusableCellWithIdentifier:@"2333"];
    if (!cell) {
        cell = [[DownloadDetailCellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"2333"];
        cell.selectionStyle = NO;
    }
    [cell.iconImage setImageWithURL:[NSURL URLWithString:_dataDic[_dataArr[indexPath.row]][@"videoBgImg"]] placeholderImage:nil];
    cell.name.text = _dataDic[_dataArr[indexPath.row]][@"name"];
    [cell.state addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.state.tag = indexPath.row +CELL_BUTTON_TAG;
    for (NSString *url in [_app.asiDic allValues]) {
        NSInteger flag = [[_app.asiDic allValues] indexOfObject:url];
        if ([(NSString *)_dataArr[indexPath.row] isEqualToString:url]) {
            for (ASIHTTPRequest *asi in _app.queue.operations) {
                if (asi.tag == [[_app.asiDic allKeys][flag] intValue]) {
                    if (asi.tag ==_failedTag) {
                        NSLog(@"_failedTag");
                    } else if (asi.tag ==_finishedTag) {
                        NSLog(@"_finishedTag");
                    }
                    [cell.state setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
                    [asi setDownloadProgressDelegate:cell.progress];
                }
            }
        }
    }
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
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
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
    if ([self.ediBtn.titleLabel.text isEqualToString:@"取消"])
    {
        [self.deleteDic setObject:indexPath forKey:[_dataArr objectAtIndex:indexPath.row]];
    }
    [self setDeleteBtnStatus];
}

-(void)dealloc
{
    NSLog(@"dealloc");
    //    for (UIProgressView *progress in _progressesArr) {
    //        [progress removeObserver:self forKeyPath:@"progress"];
    //    }
    for (ASIHTTPRequest *asi in _app.queue.operations) {
        asi.downloadProgressDelegate = nil;
    }
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


///*
// #pragma mark - Navigation
//
// // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }
// */
//
@end
