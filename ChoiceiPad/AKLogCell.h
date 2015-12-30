//
//  BSLogCell.h
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKAdditionView.h"


@class AKLogCell;

@protocol  AKLogCellDelegate
-(void)cell:(AKLogCell *)cell present:(BOOL)ZS;
- (void)cell:(AKLogCell *)cell countChanged:(float)count;
-(void)cell:(AKLogCell *)cell count:(int)count;
-(void)unitOfCellChanged:(AKLogCell *)cell;
- (void)cell:(AKLogCell *)cell additionChanged:(NSMutableArray *)additons;
@end

@interface AKLogCell : UITableViewCell <UIAlertViewDelegate,AKAdditionViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
@property (nonatomic,weak)__weak id<AKLogCellDelegate> delegate;//代理
@property (nonatomic,strong) NSDictionary *dicInfo;//信息
@property(nonatomic,strong)UIButton *btnAdd,*btnReduce,*jia,*jian,*btnEdit;
@property (nonatomic,strong) UILabel *lblName,*lblTotalPrice,*lblAddition,*lblAdditionPrice,*lblUnit,*lb;
@property (nonatomic,strong) UILabel *tfPrice,*tfCount,*lblLine;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong)UITableView *supTableView;
- (void)setAddition;
@end
