//
//  ZCResvView.h
//  ChoiceiPad
//
//  Created by chensen on 15/8/6.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCResvViewDelegate <NSObject>

-(void)ZCResvViewClick:(int)tag;

@end

@interface ZCResvView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSDictionary *resvDic;
@property(nonatomic,weak)__weak id<ZCResvViewDelegate>delegate;
@end
