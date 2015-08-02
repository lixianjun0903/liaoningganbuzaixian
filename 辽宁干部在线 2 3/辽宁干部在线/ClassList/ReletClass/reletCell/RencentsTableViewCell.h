//
//  RencentsTableViewCell.h
//  辽宁政务
//
//  Created by lixianjun on 15-3-31.
//  Copyright (c) 2015年 lixianjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RencentsTableViewCell : UITableViewCell
//{
//    UILabel * numLable;
//    UIImageView * imageView;
//    UILabel *  detailLable;
//}


//-(void) config:(NSDictionary*)dic :(int)row;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *headLable;
@property (weak, nonatomic) IBOutlet UILabel *palyTimeLable;

@end
