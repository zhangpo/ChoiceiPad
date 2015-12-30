//
//  BSPrintQueryView.h
//  BookSystem
//
//  Created by Dream on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol  PrintQueryViewDelegate

- (void)printQueryWithOptions:(NSDictionary *)info;

@end

@interface BSPrintQueryView : BSRotateView {
    UILabel *lblType;
    UISegmentedControl *segType;
}

@property (nonatomic,weak)__weak id<PrintQueryViewDelegate> delegate;


@end