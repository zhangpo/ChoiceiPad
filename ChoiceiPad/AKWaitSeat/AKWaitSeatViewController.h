//
//  AKWaitSeatViewController.h
//  ChoiceiPad
//
//  Created by chensen on 15/6/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKWaitSeatTakeNOView.h"
#import "AKWaitSeatTypView.h"
#import "AKWaitSeatTableViewCell.h"

@interface AKWaitSeatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AKWaitSeatTakeNOViewDelegate,AKWaitSeatTypViewDelegate,AKWaitSeatTableViewCellDelegate>

@end
