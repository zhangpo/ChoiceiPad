//
//  AKPaySelectView.h
//  ChoiceiPad
//
//  Created by chensen on 15/8/20.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "BSRotateView.h"

@protocol AKPaySelectViewDelegate <NSObject>

-(void)AKPaySelectViewClick:(NSDictionary *)info;

@end

@interface AKPaySelectView : BSRotateView
@property(nonatomic,weak)__weak id<AKPaySelectViewDelegate>delegate;
-(id)initWithFrame:(CGRect)frame withInfoDic:(NSDictionary *)info;

@end
