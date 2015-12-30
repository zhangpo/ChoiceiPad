//
//  AKTableCell.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/7/13.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKTableCellDelegate <NSObject>

-(void)AKTableCellClick:(NSDictionary *)dataInfo;
-(void)AKTableCellLongClick:(NSDictionary *)dataInfo;

@end


@interface AKTableCell : UICollectionViewCell


@property(nonatomic,strong)NSDictionary *dataInfo;
@property(nonatomic,weak)__weak id<AKTableCellDelegate>delegate;
@end
