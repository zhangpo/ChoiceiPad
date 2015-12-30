//
//  WebChildrenTable.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-8-27.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol WebChildrenTableDelegate <NSObject>

-(void)ChiledrenTableButton:(NSDictionary *)info;

@end

@interface WebChildrenTable : BSRotateView

@property(nonatomic,weak)__weak id<WebChildrenTableDelegate>delegete;
-(id)initWithFrame:(CGRect)frame withArray:(NSArray *)aryInfo;
@end
