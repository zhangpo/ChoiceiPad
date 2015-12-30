//
//  AKLocalWaitSeat.h
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/7/13.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKWaitSeatTakeNOView.h"
#import "AKWaitSeatTableViewCell.h"
#import "AKsOpenSucceed.h"
#import "AKSwitchTableView.h"

@interface AKLocalWaitSeat : UIViewController<AKWaitSeatTakeNOViewDelegate,UITableViewDataSource,UITableViewDelegate,AKWaitSeatTableViewCellDelegate,AKsOpenSucceedDelegate,AKSwitchTableViewDelegate>

@end
