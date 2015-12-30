//
//  AKPrivateAdditionView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-8-29.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPrivateAdditionCell.h"

@protocol AKPrivateAdditionDelegate <NSObject>

- (void)privateAdditionSelected:(NSArray *)ary;

@end

@interface AKPrivateAdditionView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AKPrivateAdditionCellDelegate,UIAlertViewDelegate>
{
    __weak id<AKPrivateAdditionDelegate>_delegate;
}
- (id)initWithFrame:(CGRect)frame withFoodDict:(NSDictionary *)food;
@property(nonatomic,weak)__weak id<AKPrivateAdditionDelegate>delegate;
@end
