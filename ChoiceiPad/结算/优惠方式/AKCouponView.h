//
//  AKCouponView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/14.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKShowPrivilegeView.h"

@protocol AKCouponViewDelegate <NSObject>

-(void)couponSelect:(NSDictionary *)coupon;

@end

@interface AKCouponView : UIView<AKShowPrivilegeViewDelegate>
@property(nonatomic,weak)__weak id<AKCouponViewDelegate>delegate;

@end
