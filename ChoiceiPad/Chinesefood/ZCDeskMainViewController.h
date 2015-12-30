//
//  ZCDeskMainViewController.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-5-22.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSOpenTableView.h"
#import "AKSwitchTableView.h"
#import "BSSwitchTableView.h"
#import "AKTableCell.h"
#import "ZCResvView.h"
#define kOpenTag    700
#define kCancelTag  701
#define kFoodTag    702
@interface ZCDeskMainViewController : UIViewController<OpenTableViewDelegate,AKSwitchTableViewDelegate,UISearchBarDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AKTableCellDelegate,ZCResvViewDelegate,SwitchTableViewDelegate,UIActionSheetDelegate>

@end
