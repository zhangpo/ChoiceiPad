//
//  AKuserPayment.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/15.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKuserPaymentDelegate <NSObject>

-(void)userPaymentClick:(NSDictionary *)userPaymentDic;

@end

@interface AKuserPayment : UIView
@property(nonatomic,weak)__weak id<AKuserPaymentDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withPaymentArray:(NSArray *)paymentArray;
@end
