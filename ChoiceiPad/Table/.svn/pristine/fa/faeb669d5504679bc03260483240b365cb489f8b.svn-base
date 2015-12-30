//
//  BSTableViewController.h
//  BookSystem
//
//  Created by Dream on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTableButton.h"
#import "BSCheckTableView.h"
#import "BSOpenTableView.h"
#import "BSSwitchTableView.h"
#import "BSCancelTableView.h"
#import "BSSearchViewController.h"
#import "BSResvSearchViewController.h"

#define kOpenTag    700
#define kCancelTag  701


@interface BSTableViewController : UIViewController<BSSearchDelegate,CheckTableViewDelegate,OpenTableViewDelegate,SwitchTableViewDelegate,CancelTableViewDelegate,BSTableButtonDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UISearchBarDelegate> {
    UIButton *btnBack,*btnSwitch,*btnCheck;
    UIScrollView *scvTables;
    BSCheckTableView *vCheck;
    BSOpenTableView *vOpen;
    BSSwitchTableView *vSwitch;
    BSCancelTableView *vCancel;
    UILabel *lblTitle;
    UIPopoverController *popSearch,*popTemp;
    UISearchBar *barSearch;
    
    NSArray *aryTables,*aryResvResult;
    
    int dSelectedIndex;
    
    NSDictionary *dicListTable;
    
    NSDictionary *checkTableInfo;
}
@property (nonatomic,retain) NSArray *aryTables,*aryResvResult;
@property (nonatomic,retain) NSDictionary *dicListTable;
@property (nonatomic, retain) NSDictionary *checkTableInfo;

- (void)showTables:(NSArray *)ary;
- (void)dismissViews;
@end
