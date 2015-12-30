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
#import "AKLogCell.h"
#import "AKMySegmentAndView.h"
#import "BSChuckView.h"


@interface WebLogViewController:UIViewController <UITableViewDelegate,UITableViewDataSource,AKLogCellDelegate,CommonViewDelegate,UISearchBarDelegate,UIActionSheetDelegate,AKMySegmentAndViewDelegate,ChuckViewDelegate>{
    UIButton *btnTable,*btnSend,*btnCommon,*btnBack,*btnCache;
    UITableView *tvOrder;
    UILabel *lblTitle;
    UIView *vHeader;
    BSCommonView *vCommon;
    NSArray *aryCommon;
    NSMutableArray *arySelectedFood;
    UILabel *lblCommon;
    UIView *footerView;
    UIPopoverController *popSearch,*popTemp;
    UISearchBar *barSearch;
    NSString *strUser;
    NSArray *aryUploading;
    CGFloat fEdittingCellPosition;
}

@end
