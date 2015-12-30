//
//  AKFoodOrderViewController.h
//  ChoiceiPad
//
//  Created by chensen on 15/7/17.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKOrderClassView.h"
#import "AKMySegmentAndView.h"
#import "AKPrivateAdditionView.h"
#import "AKAdditionView.h"
#import "AKComboView.h"

@interface AKFoodOrderViewController : UIViewController<AKOrderClassViewDelegate,AKMySegmentAndViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AKPrivateAdditionDelegate,AKAdditionViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,AKComboViewDelegate,UISearchBarDelegate>

@end
