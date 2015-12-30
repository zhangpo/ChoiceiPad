//
//  ZCFoodOrderViewController.h
//  ChoiceiPad
//
//  Created by chensen on 15/7/31.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKFoodOrderCell.h"
#import "AKOrderClassView.h"
#import "ZCAdditionalView.h"
#import "AKMySegmentAndView.h"
#import "ZCPrivateAdditionView.h"
#import "ZCPackageView.h"

@interface ZCFoodOrderViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,AKOrderClassViewDelegate,ZCAdditionalViewDelegate,UISearchBarDelegate,AKMySegmentAndViewDelegate,ZCPrivateAdditionViewDelegate,ZCPackageViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@end
