//
//  ZCTmpacctView.h
//  ChoiceiPad
//
//  Created by chensen on 15/9/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCTmpacctViewDelegate <NSObject>

-(void)ZCTmpacctClick:(NSDictionary *)tmpacct;

@end

@interface ZCTmpacctView : UIView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)NSArray *tmpacctArray;
@property(nonatomic,weak)__weak id<ZCTmpacctViewDelegate>delegate;

@end
