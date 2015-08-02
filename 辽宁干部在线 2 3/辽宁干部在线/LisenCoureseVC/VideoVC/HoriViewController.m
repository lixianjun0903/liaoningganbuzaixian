//
//  HoriViewController.m
//  辽宁干部在线
//
//  Created by lixianjun on 15-4-5.
//  Copyright (c) 2015年 中青致学. All rights reserved.
//

#import "HoriViewController.h"

@interface HoriViewController ()

@end

@implementation HoriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
//    [self createButton];
//     Do any additional setup after loading the view.
}
-(void)createButton
{
//    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    backButton.backgroundColor= [UIColor redColor];
//    [self.view addSubview:backButton];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 50, 45)];
    leftImageView.image = [UIImage imageNamed:@"icon_back_white.png"];
    [self.view addSubview:leftImageView];
}
//横屏播放需要实现2个方式即可
-(BOOL)shouldAutorotate
{
    return YES;
}
//强制横屏
-(NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscape;
    
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
