//
//  AKShouldCheckView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/21.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKShouldCheckViewDelegate <NSObject>

-(void)shouldCheckViewClick:(NSDictionary *)checkDic;

@end

@interface AKShouldCheckView : UIView<UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSTimer  *timer;
@property(nonatomic,weak)__weak id<AKShouldCheckViewDelegate>delegate;
-(void)startTimer;
-(void)pauseTimer;
+(AKShouldCheckView *)shared;
+(AKShouldCheckView *)sharedDest;
@end
