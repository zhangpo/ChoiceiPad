//
//  ZCPrivateAdditionView.h
//  BookSystem-iPhone
//
//  Created by chensen on 15/3/30.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

#define kPadding 10

@protocol ZCPrivateAdditionViewDelegate

- (void)additionsSelected:(NSArray *)additions;

@end


@interface ZCPrivateAdditionView : BSRotateView<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>
@property(nonatomic,assign)id<ZCPrivateAdditionViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withFcodeArray:(NSArray *)array;

@end
