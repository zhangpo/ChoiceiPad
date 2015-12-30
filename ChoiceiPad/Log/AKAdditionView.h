//
//  AKAdditionView.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-8-29.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKPrivateAdditionCell.h"
@protocol AKAdditionViewDelegate

- (void)additionSelected:(NSArray *)ary;

@end

@interface AKAdditionView : UIView<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,AKPrivateAdditionCellDelegate,UITextFieldDelegate>
{
    __weak id<AKAdditionViewDelegate>_delegate;
}
@property(nonatomic,weak)__weak id<AKAdditionViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withSelectAddtions:(NSArray *)array;
@end
