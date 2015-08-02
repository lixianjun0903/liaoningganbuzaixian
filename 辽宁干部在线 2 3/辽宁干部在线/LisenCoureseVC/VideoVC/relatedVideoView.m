//
//  relatedVideoView.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-6.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "relatedVideoView.h"
@interface relatedVideoView()
{
 MBProgressHUD * mLoadView;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation relatedVideoView
@synthesize mLoadMsg;
-(id)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        //        self.backgroundColor = [UIColor yellowColor];
        [self makeHeight];
        [self createUI];
    }
    return self;
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
    
    [self StartLoading];
    mLoadView = [[MBProgressHUD alloc] initWithView:self];
    mLoadView.delegate = self;
    mLoadView.labelText = @"正在加载中...";
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
    }
    mLoadView.dimBackground = YES;
    [mLoadView show:YES];
    [self addSubview:mLoadView];
       NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *strID = [user objectForKey:@"sutdentId"];
    NSString *urlstr = [NSString stringWithFormat:@"%@/operateVideo/playVideo.json?videoId=%@&studentId=%@",BASEURL,self.videoId,strID];
    
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [dic setObject: @""forKey:@"studentId"];
    //    [dic setObject:@"" forKey:@"courseId"];
    //    [_mDownManager PostHttpRequest:urlstr :dic];
    
}
- (void)OnLoadFinish:(ImageDownManager *)sender
{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    
    [self Cancel];
    NSDictionary *d = dict[@"data"];
    NSArray *array = d[@"relatedVideo"];
    if (array&&[array isKindOfClass:[NSArray class]] &&array.count>0) {
        [self.dataArray addObjectsFromArray:array];
        [_tableView reloadData];
            }
}
#pragma mark 开始下载
-(void)StartLoading
{
    
}
- (void)OnLoadFail:(ImageDownManager *)sender
{
    [self Cancel];
}
- (void)Cancel {
    //[self StopLoading];
    [mLoadView hide:YES];
    mLoadView = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
    
}

-(void)makeHeight
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


-(void)createUI
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator= NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor =  [UIColor whiteColor];
    [self addSubview:_tableView];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell =[[[NSBundle mainBundle] loadNibNamed:@"ClassFirstTableViewCell" owner:self options:nil] firstObject];
    }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.myBlock(self.dataArray[indexPath.row]);
    self.videoId = self.dataArray[indexPath.row][@"videoId"];
    [self loadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
