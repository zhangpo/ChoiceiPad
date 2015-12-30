//
//  AKPrivateAdditionCell.h
//  BookSystem-iPhone
//
//  Created by chensen on 15/3/24.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKPrivateAdditionCell;

@protocol AKPrivateAdditionCellDelegate <NSObject>

-(void)AKPrivateAdditionBtnClick:(AKPrivateAdditionCell *)cell;

@end

@interface AKPrivateAdditionCell : UITableViewCell

@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSIndexPath  *indexPath;
@property(nonatomic,weak) __weak id<AKPrivateAdditionCellDelegate>delegate;
@end
