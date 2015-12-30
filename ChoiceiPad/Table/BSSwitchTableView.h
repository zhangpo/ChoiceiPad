//
//  BSSwitchTableView.h
//  BookSystem
//
//  Created by Dream on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol SwitchTableViewDelegate

- (void)switchTableWithOptions:(NSDictionary *)info;
-(void)multipleTableWithOptions:(NSDictionary *)info;
@end


@interface BSSwitchTableView : BSRotateView {
    UIButton *btnConfirm,*btnCancel;
    __weak id<SwitchTableViewDelegate>_delegate;
}
@property (nonatomic,weak)__weak id<SwitchTableViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withTag:(int)tag;

@end
