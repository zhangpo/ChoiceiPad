//
//  AKWaitSeatTypView.h
//  ChoiceiPad
//
//  Created by chensen on 15/6/25.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKWaitSeatTypViewDelegate <NSObject>

-(void)AKWaitSeatTypViewClick:(NSDictionary *)info;

@end

@interface AKWaitSeatTypView : UIView

@property(nonatomic,weak)__weak id<AKWaitSeatTypViewDelegate>delegate;
@end
