//
//  AKLogInViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-6.
//
//
#import <UIKit/UIKit.h>
//#import "AKsNetAccessClass.h"
#import "ZenKeyboardView.h"
@interface AKLogInViewController : UIViewController<UITextFieldDelegate,ZenKeyboardViewDelegate>

@property (retain, nonatomic) IBOutlet UITextField *textField1;
@property (retain, nonatomic) IBOutlet UITextField *textField2;
@property (retain, nonatomic) IBOutlet UIButton *rememberBut;
@property (nonatomic, strong) ZenKeyboardView *keyboardView;
@end
