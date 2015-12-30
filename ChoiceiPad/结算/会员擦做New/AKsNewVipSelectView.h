//
//  AKsNewVipSelectView.h
//  ChoiceiPad
//
//  Created by chensen on 15/6/15.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "BSRotateView.h"

@protocol AKsNewVipSelectViewDelegate <NSObject>

-(void)AKsNewVipSelectView:(NSDictionary *)info;

@end

@interface AKsNewVipSelectView : BSRotateView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,weak)__weak id<AKsNewVipSelectViewDelegate>delegate;

@end
