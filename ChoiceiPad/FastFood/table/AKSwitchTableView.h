//
//  AKSwitchTableView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/1/19.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "BSRotateView.h"



@protocol AKSwitchTableViewDelegate

- (void)switchTableWithOptions:(NSDictionary *)info;
-(void)multipleTableWithOptions:(NSDictionary *)info;
@end

@interface AKSwitchTableView : UIView<UITableViewDataSource,UITableViewDelegate>
- (id)initWithFrame:(CGRect)frame withTag:(int)tag;
@property(nonatomic,strong)NSArray *currentArray;
@property(nonatomic,strong)NSArray *aimsArray;
@property (nonatomic,weak)__weak id<AKSwitchTableViewDelegate> delegate;
@end
