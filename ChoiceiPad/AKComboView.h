//
//  AKComboView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-8-30.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPrivateAdditionView.h"

@protocol AKComboViewDelegate <NSObject>

-(void)AKComboViewClick:(NSMutableDictionary *)comboDic;

@end

@interface AKComboView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,AKPrivateAdditionDelegate>

- (id)initWithFrame:(CGRect)frame withPcode:(NSDictionary *)food;
@property(nonatomic,weak)__weak id<AKComboViewDelegate>delegate;
@end
