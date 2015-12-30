//
//  BSQueryView.h
//  BookSystem
//
//  Created by Dream on 11-5-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"
#import "BSDataProvider.h"
@protocol  QueryViewDelegate

- (void)queryOrderWithOptions:(NSDictionary *)info;

@end

@interface BSQueryView :  BSRotateView{
    UIButton *btnSendNow,*btnSendWait,*btnCancel;
    
    UILabel *lblAcct,*lblPwd,*lblPeople;
    
    UITextField *tfAcct,*tfPwd,*tfPeople;
    
    id<QueryViewDelegate> delegate;
}

@property (nonatomic,assign) id<QueryViewDelegate> delegate;


@end