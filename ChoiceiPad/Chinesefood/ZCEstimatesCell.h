//
//  ZCEstimatesCell.h
//  ChoiceiPad
//
//  Created by chensen on 15/8/14.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCEstimatesCellDelegate <NSObject>

-(void)ZCEstimatesCellClick:(NSDictionary *)info;

@end


@interface ZCEstimatesCell : UITableViewCell

@property(nonatomic,strong)NSDictionary *estimatesDic;
@property(nonatomic,weak)__weak id<ZCEstimatesCellDelegate>delegate;

@end
