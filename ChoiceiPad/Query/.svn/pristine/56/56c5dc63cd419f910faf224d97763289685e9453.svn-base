//
//  BSGogoView.h
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol  GogoViewDelegate

- (void)gogoOrderWithOptions:(NSDictionary *)info;

@end

@interface BSGogoView : BSRotateView {
    UIButton *btnSendNow,*btnSendWait,*btnCancel;
    
    UILabel *lblAcct,*lblPwd,*lblPeople;
    
    UITextField *tfAcct,*tfPwd,*tfPeople;
    
    id<GogoViewDelegate> delegate;
}

@property (nonatomic,assign) id<GogoViewDelegate> delegate;


@end
