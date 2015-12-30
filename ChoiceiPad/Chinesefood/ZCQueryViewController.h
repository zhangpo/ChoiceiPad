//
//  ZCQueryViewController.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-7-15.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataProvider.h"
#import "ZCChuckView.h"
#import "BSQueryCell.h"
#import "ZCPrintQueryView.h"
#import "AKMySegmentAndView.h"

@interface ZCQueryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ChuckViewDelegate,UISearchBarDelegate,BSQueryCellDelegate,UITextFieldDelegate,AKMySegmentAndViewDelegate,PrintQueryViewDelegate,PrintQueryViewDelegate,UIAlertViewDelegate>{
    UIButton *btnQuery,*btnGogo,*btnPrint,*btnChuck,*btnBack;
    
    UITableView *tvOrder;
    
    UILabel *lblTitle;
    
//    NSDictionary *dicOrder,*dictQuery;
//    
//    UIView *vHeader;
//    
//    int dGogoCount,dChuckCount;
    ZCPrintQueryView  *vPrint;
    ZCChuckView *vChuck;
//
//    NSString *strTable;
//    
//    NSString *strUser,*strPwd;
//    
//    int dTable;
//    NSMutableArray *arySelectedFood;
    
}
//@property (nonatomic,copy) NSString *strTable;
//@property (nonatomic,copy) NSString *strUser,*strPwd;
//
//- (void)dismissViews;
//- (void)printQuery;
//@property (nonatomic,retain) NSDictionary *dicOrder,*dicQuery;;
//@property (nonatomic,retain) NSMutableArray *arySelectedFood;
@end
