//
//  ZCSettlementViewController.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-7-15.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKCouponView.h"
#import "AKsMoneyVIew.h"
#import "AKsNewVipSelectView.h"
#import "ZCPrintQueryView.h"
#import "ZCTmpacctView.h"

@interface ZCSettlementViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AKsMoneyVIewDelegate,UIAlertViewDelegate,AKCouponViewDelegate,AKsNewVipSelectViewDelegate,PrintQueryViewDelegate,ZCTmpacctViewDelegate>

@end
