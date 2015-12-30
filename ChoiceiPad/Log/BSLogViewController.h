//
//  BSLogViewController.h
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataProvider.h"
#import "BSCommonView.h"
#import "AKMySegmentAndView.h"
//#import "AKsAuthorizationView.h"
#import "BSAddtionView.h"
#import "AKLogTableViewCell.h"


@interface BSLogViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CommonViewDelegate,UISearchBarDelegate,UIActionSheetDelegate,AKMySegmentAndViewDelegate,AKLogTableViewCellDelegate>{
    UITableView *tvOrder;
    UILabel *lblTitle;
    BSCommonView *vCommon;
    UILabel *lblCommon;
}
- (void)dismissViews;
@end
