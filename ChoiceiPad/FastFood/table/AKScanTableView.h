//
//  AKScanTableView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/6/9.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@protocol AKScanTableViewDelegate <NSObject>

-(void)AKScanTableViewClick:(NSString *)string;

@end

@interface AKScanTableView : UIView<ZBarReaderViewDelegate>
@property(nonatomic,weak)__weak id<AKScanTableViewDelegate>delegate;

@end
