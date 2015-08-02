

//
//  AboutViewController.m
//  辽宁政务
//
//  Created by lixianjun on 15-3-31.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import "AboutViewController.h"
#define iOS7  [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0
#define WIDETH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNav];
    [self createView];
    // Do any additional setup after loading the view.
}
-(void)createView
{
    
    UIImageView * bgImageView  = [[UIImageView alloc] initWithFrame:CGRectMake((WIDETH-375)/2, 64, 375, 412)];
    bgImageView.image = [UIImage imageNamed:@"关于.png"];
    [self.view addSubview:bgImageView];
    
    //    UILabel * lable =[[UILabel alloc] initWithFrame:CGRectMake(50, 130, WIDETH -100, 20)];
    //    lable.text = @"主办单位：";
    //    lable.numberOfLines = 0;
    //    lable.textAlignment = NSTextAlignmentCenter;
    //    lable.font = [UIFont systemFontOfSize:18];
    //    lable.textColor =[UIColor blackColor];
    //    [self.view addSubview:lable];
    //    UILabel * lable1 =[[UILabel alloc] initWithFrame:CGRectMake(50, 160, WIDETH -100, 20)];
    //    lable1.text = @"中共辽宁省委组织部";
    //    lable1.numberOfLines = 0;
    //    lable1.textAlignment = NSTextAlignmentCenter;
    //    lable1.font = [UIFont systemFontOfSize:14];
    //    lable1.textColor =[UIColor grayColor];
    //    [self.view addSubview:lable1];
    //    UILabel * lable2 =[[UILabel alloc] initWithFrame:CGRectMake(50, 190, WIDETH -100, 20)];
    //    lable2.text = @"宁省人力资源和社会保障厅";
    //    lable2.numberOfLines = 0;
    //    lable2.textAlignment = NSTextAlignmentCenter;
    //    lable2.font = [UIFont systemFontOfSize:14];
    //    lable2.textColor =[UIColor grayColor];
    //    [self.view addSubview:lable2];
    //    UILabel * lable3 =[[UILabel alloc] initWithFrame:CGRectMake(50, 220, WIDETH -100, 20)];
    //    lable3.text = @"辽宁省公务员局";
    //    lable3.numberOfLines = 0;
    //    lable3.textAlignment = NSTextAlignmentCenter;
    //    lable3.font = [UIFont systemFontOfSize:14];
    //    lable3.textColor =[UIColor grayColor];
    //    [self.view addSubview:lable3];
    //    UILabel * lable4 =[[UILabel alloc] initWithFrame:CGRectMake(50, 280, WIDETH -100, 20)];
    //    lable4.text = @"联系电话：";
    //    lable4.numberOfLines = 0;
    //    lable4.textAlignment = NSTextAlignmentCenter;
    //    lable4.font = [UIFont systemFontOfSize:18];
    //    lable4.textColor =[UIColor blackColor];
    //    [self.view addSubview:lable4];
    //    UILabel * lable5 =[[UILabel alloc] initWithFrame:CGRectMake(50, 310, WIDETH -100, 20)];
    //    lable5.text = @"024-62656881";
    //    lable5.numberOfLines = 0;
    //    lable5.textColor = [UIColor colorWithRed:0.81f green:0.03f blue:0.14f alpha:1.00f];
    //    lable5.textAlignment = NSTextAlignmentCenter;
    //    lable5.font = [UIFont systemFontOfSize:14];
    //    [self.view addSubview:lable5];
    //    UILabel * lable6 =[[UILabel alloc] initWithFrame:CGRectMake(50, 340, WIDETH -100, 20)];
    //    lable6.text = @"024-62656883";
    //    lable6.numberOfLines = 0;
    //    lable6.textColor= [UIColor colorWithRed:0.81f green:0.03f blue:0.14f alpha:1.00f];
    //    lable6.textAlignment = NSTextAlignmentCenter;
    //    lable6.font = [UIFont systemFontOfSize:14];
    //    [self.view addSubview:lable6];
    //    UILabel * lable7 =[[UILabel alloc] initWithFrame:CGRectMake(50, 390, WIDETH -100, 20)];
    //    lable7.text = @"电子邮箱：";
    //    lable7.numberOfLines = 0;
    //    lable7.textAlignment = NSTextAlignmentCenter;
    //    lable7.font = [UIFont systemFontOfSize:18];
    //    lable7.textColor =[UIColor blackColor];
    //    [self.view addSubview:lable7];
    //    UILabel * lable8 =[[UILabel alloc] initWithFrame:CGRectMake(50, 420, WIDETH -100, 20)];
    //    lable8.text = @"lngbzx@126.com";
    //    lable8.numberOfLines = 0;
    //    lable8.textAlignment = NSTextAlignmentCenter;
    //    lable8.font = [UIFont systemFontOfSize:14];
    //    lable8.textColor =[UIColor colorWithRed:0.81f green:0.03f blue:0.14f alpha:1.00f];
    //    [self.view addSubview:lable8];
    ////    UILabel * lable9 =[[UILabel alloc] initWithFrame:CGRectMake(50, 450, WIDETH -100, 12)];
    ////    lable9.text = @"lngbzx@126.com";
    ////    lable9.textColor = [UIColor colorWithRed:0.81f green:0.03f blue:0.14f alpha:1.00f];
    ////    lable9.numberOfLines = 0;
    ////    lable9.textAlignment = NSTextAlignmentCenter;
    ////    lable9.font = [UIFont systemFontOfSize:12];
    ////    lable9.textColor =[UIColor grayColor];
    ////    [self.view addSubview:lable9];
    ////
    //
    
    
}
-(void)createNav
{self.title = @"关于";
    if (iOS7) {
        [self.navigationController.navigationBar
         
         setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    }else{
        [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor],UITextAttributeFont : [UIFont systemFontOfSize:17]}];
    }
    
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.view addSubview:view];
    
    self.navigationController.navigationBar.barTintColor = NAVBRG;
    //左侧首页按钮
    
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 14, 22)];
    [leftButton setImage:[UIImage imageNamed:@"jiantou_03.png"] forState:UIControlStateNormal ];
    [leftButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
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
