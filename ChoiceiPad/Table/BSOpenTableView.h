//
//  BSOpenTableView.h
//  BookSystem
//
//  Created by Dream on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"
#import "QRCodeReaderViewController.h"

typedef void (^WVJBResponseCallback)(id responseData);
typedef void (^BSOPENHandler)(NSString *string);

@protocol OpenTableViewDelegate

- (void)openTableWithOptions:(NSDictionary *)info;
- (void)scanClick:(BSOPENHandler)open;
-(void)VipClick;
@end


@interface BSOpenTableView : BSRotateView <UITextFieldDelegate>
{
    __weak id<OpenTableViewDelegate>_delegate;
}
@property(nonatomic,strong)NSMutableDictionary *tableDic;
@property (nonatomic,weak)__weak id<OpenTableViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withtag:(NSString *)tag;
- (id)initWithFrame:(CGRect)frame withtag:(NSString *)tag withTableShow:(BOOL)tableTag;
@end
