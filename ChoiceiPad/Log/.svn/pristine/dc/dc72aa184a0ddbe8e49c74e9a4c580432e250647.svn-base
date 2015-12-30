//
//  BSTempFoodView.h
//  BookSystem
//
//  Created by Dream on 11-7-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TempFoodDelegate

- (void)addTempFood:(NSDictionary *)info;

@end


@interface BSTempFoodViewController : UIViewController {
    IBOutlet UILabel *lblName,*lblPrice,*lblUnit,*lblCount;
    IBOutlet UITextField *tfName,*tfPrice,*tfUnit,*tfCount;
    
    IBOutlet UIButton *btnAdd,*btnCancel;
}

- (IBAction)addPressed:(UIButton *)btn;
- (IBAction)cancelPressed:(UIButton *)btn;

@end
