//
//  AKWaitSeatTakeNOView.h
//  ChoiceiPad
//
//  Created by chensen on 15/6/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKWaitSeatTakeNOViewDelegate <NSObject>

-(void)AKWaitSeatTakeNOViewClick:(NSDictionary *)info;

@end

@interface AKWaitSeatTakeNOView : UIView<UITextFieldDelegate>
@property(nonatomic,weak)__weak id<AKWaitSeatTakeNOViewDelegate>delegate;

@end
