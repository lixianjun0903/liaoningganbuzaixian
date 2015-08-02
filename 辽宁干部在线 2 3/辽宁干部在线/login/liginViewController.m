
//
//  liginViewController.m
//  辽宁政务
//
//  Created by lixianjun on 15-3-31.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import "liginViewController.h"
#import "JSON.h"
#import "ImageDownManager.h"
#import "MBProgressHUD.h"

#import "ClassFistPageViewController.h"
#import "MVYSideMenuController.h"
#import "MVYMenuViewController.h"
#import "IQKeyboardManager.h"

#define WIDETH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
@interface liginViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD * mLoadView;
    MBProgressHUD *hud;
    UITextField * accountTextField;
    UITextField * secretTextField;
    
}

@property(nonatomic,strong)ImageDownManager *mDownManager;

@end

@implementation liginViewController

@synthesize mLoadMsg;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgImageView.image = [UIImage imageNamed:@"login.png"];
    [self.view addSubview:bgImageView];
    
    [self makeUI];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isRemove) name:@"isRemove" object:nil];
   
   
    // Do any additional setup after loading the view.
}
-(void)isRemove
{
//    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
//       secretTextField.text = [user objectForKey:@"userPassword"];
//      accountTextField.text = [user objectForKey:@"username"];
    
    MBProgressHUD* mLoadView1 = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:mLoadView1];
    
    mLoadView1.mode = MBProgressHUDModeCustomView;
    mLoadView1.labelText = @"退出成功";
    [mLoadView1 show:YES];
    [mLoadView1 hide:YES afterDelay:2];
    mLoadView1 = nil;
}
-(void)makeUI
{//标题
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDETH - 172)/2, 80, 172, 33)];
    imageView.image = [UIImage imageNamed:@"777_03.png"];
    [self.view addSubview:imageView];
    //账号
    UIView * accountView = [[UIView alloc] initWithFrame:CGRectMake(30, 130, WIDETH- 60, 44)];
    accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountView];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * userName = [user objectForKey:@"username"];
    NSString * userPassword = [user objectForKey:@"userPassword"];
    //    NSString * sutdentId = [user objectForKey:@"sutdentId"];
    
    //请输入用户名
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, WIDETH -48, 44)];
    accountTextField.delegate = self;
    accountTextField.returnKeyType = UIReturnKeyNext;
    [accountView addSubview:accountTextField];
    // 头像
    UIImageView * headImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(8, (accountView.frame.size.height  - 17)/ 2, 17,17)];
    headImageView.image =[UIImage imageNamed:@"辽宁政务-登录_03.png"];
    [accountView addSubview:headImageView];
    
    //暗条
    UIImageView * accountBgImageView =[[UIImageView alloc] initWithFrame:CGRectMake(40, (accountView.frame.size.height  - 20)/ 2, 1, 20)];
    accountBgImageView.image = [UIImage imageNamed:@"辽宁政务-线_03.png"];
    [accountView addSubview:accountBgImageView];
    
    //密码
    UIView * secretView = [[UIView alloc] initWithFrame:CGRectMake(30, 188, WIDETH - 60,44)];
    [self.view addSubview:secretView];
    secretTextField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, WIDETH - 48, 44)];
    
    secretTextField.returnKeyType = UIReturnKeyGo;
    secretTextField.delegate = self;
    secretTextField.secureTextEntry = YES;
    [secretView addSubview:secretTextField];
    //        if (manager.isFirstLogin!=nil) {
    //             accountTextField.text = userName;
    //            secretTextField.text = userPassword;
    //            [self login];
    //        }
    //        else
    //        {
    if (userName == nil) {
        accountTextField.placeholder = @"请输入账号";
    }
    else
    {
        accountTextField.text = userName;
        
    }
    if (userPassword == nil) {
        secretTextField.placeholder = @"请输入密码";
    }
    else
    {
        
        secretTextField.text = userPassword;
    }
    //        }
    //logo
    UIImageView * secretImageView =[[UIImageView alloc] initWithFrame:CGRectMake(8, (secretView.frame.size.height - 17)/2, 17, 17)];
    secretView.backgroundColor =[UIColor whiteColor];
    secretImageView.image =[UIImage imageNamed:@"辽宁政务-登录_06.png"];
    [secretView addSubview:secretImageView];
    //暗条
    UIImageView * secretBImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (secretView.frame.size.height - 20)/2, 1, 20)];
    secretBImageView.image =[UIImage imageNamed:@"辽宁政务-线_03.png"];
    [secretView addSubview:secretBImageView];
    //登陆
    
    UIButton * loginButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 272, WIDETH - 60, 44)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.textAlignment  =NSTextAlignmentCenter;
    loginButton.backgroundColor = [UIColor colorWithRed:0.81f green:0.03f blue:0.14f alpha:1.00f];
    loginButton.titleLabel.textColor =[UIColor whiteColor];
    [loginButton addTarget:self action:@selector(lognButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == secretTextField) {
        [self lognButton];
    }
    else if (textField == accountTextField)
    {
        [secretTextField becomeFirstResponder];
    }
    return YES;
}
-(void)lognButton
{
    
    //    ClassNumViewController * num = [[ClassNumViewController alloc] init];
    //    //    ClassCollectionViewController * Class  = [[ClassCollectionViewController alloc] init];
    //    [self presentViewController:num animated:YES completion:nil];
    if (!hud) {
        hud= [[MBProgressHUD alloc]initWithView:self.view];
        hud.mode = MBProgressHUDModeCustomView;
        hud.dimBackground = YES;
        [self.view addSubview:hud];
    }
    if ([accountTextField.text length]==0) {
        [hud show:YES];
        hud.labelText = @"用户名格式不正确";
        [hud hide:YES afterDelay:1];
        return;
    }
    else if ([secretTextField.text length]== 0)
    {
        [hud show:YES];
        hud.labelText =@"密码不能为空";
        [hud hide:YES afterDelay:1];
        return;
    }
    [self login];
    NSLog(@"登陆");
}
-(void)login
{
    if (_mDownManager) {
        return;
    }
    mLoadView = [[MBProgressHUD alloc] initWithView:self.view];
    mLoadView.delegate = self;
    mLoadView.labelText = @"正在登录";
    if (mLoadMsg) {
        mLoadView.mode = MBProgressHUDModeCustomView;
    }
    mLoadView.dimBackground = YES;
    [mLoadView show:YES];
    [self.view addSubview:mLoadView];    NSString * urlstr = [NSString stringWithFormat:@"%@/j_spring_security_check",BASEURL];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:accountTextField.text forKey:@"j_username"];
    [dic setObject:secretTextField.text forKey:@"j_password"];
    NSUserDefaults *  user = [NSUserDefaults standardUserDefaults];
    [user setObject:secretTextField.text forKey:@"j_password"];
    [user synchronize];
    [_mDownManager PostHttpRequest:urlstr :dic];
    
    
}
- (void)OnLoadFinish:(ImageDownManager *)sender
{
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        NSString *str = dict[@"error_code"];
        NSString * stre = [NSString stringWithFormat:@"%d",1];
        //str&&![str isEqualToString:@"0"]
        if (str&&![str isEqualToString:stre]) {
            //            [hud show:YES];
            //            hud.labelText = dict[@"msg"];
            //            [hud hide:YES afterDelay:1];
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
            return;
        }
        else
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:[NSString stringWithFormat:@"%@",dict[@"data"][@"sutdentId"]] forKey:@"sutdentId"];
            [user setObject:dict[@"data"][@"username"] forKey:@"username"];
            [user setObject:secretTextField.text forKey:@"userPassword"];
            [user synchronize];
            
            [hud show:YES];
            hud.labelText = dict[@"msg"];
            [hud hide:YES afterDelay:1];
           
            
            //            ClassCategoryViewController * mainVC = [[ClassCategoryViewController alloc] init];
            MVYMenuViewController *mainVC = [[MVYMenuViewController alloc] init];
            ClassFistPageViewController * contentVC = [[ClassFistPageViewController alloc] init];
            UINavigationController *mianNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
            
            MVYSideMenuOptions * options = [[MVYSideMenuOptions alloc] init];
            MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:mianNavigationController
                                                                                            contentViewController:contentVC
                                                                                                          options:options];
            //            NSUserDefaults * userName = [NSUserDefaults standardUserDefaults];
            //            NSString * strName = [userName objectForKey:@"username"];
            //            accountTextField.text = strName;
            
            [self presentViewController:sideMenuController animated:YES completion:nil];
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络问题" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [av show];
}
- (void)Cancel {
    
    [mLoadView hide:YES];
    mLoadView = nil;
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:NO];
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
