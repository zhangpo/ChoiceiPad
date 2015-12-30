//
//  WebSettlementViewController.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-9-16.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKMySegmentAndView.h"
#import "AKQueryAllOrders.h"
#import "AKShowPrivilegeView.h"
#import "AKuserPaymentView.h"
#import "AKSettlement.h"
#import "AKsNetAccessClass.h"
#import "AKsCanDanListClass.h"
#import "AKsCheckAouthView.h"

@interface WebSettlementViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, AKMySegmentAndViewDelegate,UIAlertViewDelegate,AKQueryAllOrdersDelegate,AKShowPrivilegeViewDelegate,AKsNetAccessClassDelegate,AKsCheckAouthViewDelegate,AKuserPaymentViewDelegate,AKSettlementDelegate>
{
    
    UITableView *tvOrder;
    
}
@end
