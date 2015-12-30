//
//  ZCAdditionalView.h
//  ChoiceiPad
//
//  Created by chensen on 15/7/22.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAdditionCell.h"
@protocol ZCAdditionalViewDelegate

- (void)additionSelected:(NSArray *)ary;

@end

@interface ZCAdditionalView : UIView<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    __weak id<ZCAdditionalViewDelegate>_delegate;
}
@property(nonatomic,weak)__weak id<ZCAdditionalViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withSelectAddtions:(NSArray *)array;
@end

