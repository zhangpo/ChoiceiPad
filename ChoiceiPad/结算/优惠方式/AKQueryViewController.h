//
//  AKQueryViewController.h
//  BookSystem
//
//  Created by sundaoran on 13-11-23.
//
//

#import <UIKit/UIKit.h>
#import "AKMySegmentAndView.h"
#import "AKQueryAllOrders.h"
#import "AKuserPayment.h"
#import "AKCouponView.h"
#import "AKsMoneyVIew.h"
#import "AKAlipayView.h"
#import "BSPrintQueryView.h"
#import "AKPaySelectView.h"

@interface AKQueryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, AKMySegmentAndViewDelegate,UIAlertViewDelegate,AKCouponViewDelegate,UIActionSheetDelegate,AKuserPaymentDelegate,AKsMoneyVIewDelegate,AKAlipayViewDelegate,PrintQueryViewDelegate,AKPaySelectViewDelegate>
{
    
    UITableView *tvOrder;
    
}
@end

