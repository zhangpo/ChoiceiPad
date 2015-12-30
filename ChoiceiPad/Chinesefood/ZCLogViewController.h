//
//  ZCLogViewController.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-5-26.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSLogCell.h"
#import "AKMySegmentAndView.h"
//#import "BSCommonView.h"
#import "ZCAdditionalView.h"
#import "AKLogTableViewCell.h"
//#import "FTPHelper.h"
//#import "WhiteRaccoon.h"


@interface ZCLogViewController : UIViewController<BSLogCellDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AKMySegmentAndViewDelegate,ZCAdditionalViewDelegate,AKLogTableViewCellDelegate>
@property(nonatomic,strong)NSArray *aryCommon;
@end
