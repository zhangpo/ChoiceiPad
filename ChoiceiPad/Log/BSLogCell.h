//
//  BSLogCell.h
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKAdditionView.h"
#import "BSAddtionView.h"


@class BSLogCell;

@protocol  BSLogCellDelegate
-(void)cell:(BSLogCell *)cell present:(BOOL)ZS;
- (void)cell:(BSLogCell *)cell countChanged:(float)count;
-(void)cell:(BSLogCell *)cell count:(int)count;
- (void)cell:(BSLogCell *)cell additionChanged:(NSMutableArray *)additons;
@end

@interface BSLogCell : UITableViewCell <UIAlertViewDelegate,AKAdditionViewDelegate,AdditionViewDelegate>
@property (nonatomic,weak)__weak id<BSLogCellDelegate> delegate;//代理
@property (nonatomic,strong) NSDictionary *dicInfo;//信息
@property(nonatomic,strong)UIButton *btnAdd,*btnReduce,*jia,*jian,*btnEdit;
@property (nonatomic,strong) UILabel *lblName,*lblTotalPrice,*lblAddition,*lblAdditionPrice,*lblUnit,*lb;
@property (nonatomic,strong) UILabel *tfPrice,*tfCount,*lblLine;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong)UITableView *supTableView;
- (void)setAddition;
@end
