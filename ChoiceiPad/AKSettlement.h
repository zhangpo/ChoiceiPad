//
//  AKSettlement.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-9-16.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKSettlementDelegate <NSObject>

-(void)AKSettlementButtonClick:(NSDictionary *)info;

@end

@interface AKSettlement : UIView
@property(nonatomic,weak)__weak id<AKSettlementDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)AryInfo;

@end
