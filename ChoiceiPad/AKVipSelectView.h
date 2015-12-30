//
//  AKVipSelectView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-9-23.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKVipSelectViewDelegate <NSObject>

-(void)AKVipSelectViewButtonClick:(int)tag;

@end

@interface AKVipSelectView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)__weak id<AKVipSelectViewDelegate>delegate;
@end
