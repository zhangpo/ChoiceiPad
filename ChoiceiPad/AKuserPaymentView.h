//
//  AKuserPaymentView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-9-16.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol AKuserPaymentViewDelegate <NSObject>

-(void)AKuserPaymentViewButtonClick:(NSDictionary *)info;

@end


@interface AKuserPaymentView : BSRotateView<UITextFieldDelegate>
@property(nonatomic,weak)__weak id<AKuserPaymentViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)info;

@end
