//
//  AKAlipayView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/16.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"
#import "ZBarSDK.h"

@protocol AKAlipayViewDelegate <NSObject>

-(void)AKAlipayViewButtonClick:(NSDictionary *)alipay;

@end

@interface AKAlipayView : BSRotateView<ZBarReaderViewDelegate>

@property(nonatomic,weak)__weak id<AKAlipayViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withAlipayDict:(NSDictionary *)alipayDict;

@end
