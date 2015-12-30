//
//  BSSettingViewController.h
//  BookSystem
//
//  Created by Dream on 11-4-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKsNetAccessClass.h"

typedef enum{
    BSSettingTypeFtp,
    BSSettingTypeUpdate,
    BSSettingTypeSocket,
    BSSettingTypePDAID,
    BSSettingTypeLogin,
    BSSettingTypeDianPuId,
    BSSettingTypeZeng
}BSSettingType;

@interface BSSettingViewController : UIViewController <UIAlertViewDelegate,AKsNetAccessClassDelegate>
{
    UITextField *tfSetting,*tfUser,*tfPass;
    UILabel *lblUser,*lblPass,*lblSetting;
    
    UIButton *btnConfirm,*btnCancel;
    
    UILabel *lblTips,*lblPath,*lblChecking,*lblDownloading;
    
    UIActivityIndicatorView *indicator;
    
    BSSettingType settingType;
    
    
}

- (id)initWithType:(BSSettingType)type;

@end
