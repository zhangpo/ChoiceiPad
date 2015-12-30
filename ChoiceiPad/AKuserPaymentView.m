//
//  AKuserPaymentView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-9-16.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "AKuserPaymentView.h"
#import "AKsNetAccessClass.h"

@implementation AKuserPaymentView
{
    UITextField *_moneyField;
    NSMutableDictionary *_dataInfo;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withInfo:(NSDictionary *)info
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        /**
         *  名称
         */
        [self setTitle:[info objectForKey:@"OPERATENAME"]];
        _dataInfo=[NSMutableDictionary dictionaryWithDictionary:info];
        for (int i=0; i<2; i++) {
            UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonSure.frame=CGRectMake(240+105*i, 265, 90, 40);
            buttonSure.titleLabel.textColor=[UIColor whiteColor];
            buttonSure.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            buttonSure.tag=i;
            [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
            if (i==0)
                [buttonSure setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
            else
                [buttonSure setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
            [buttonSure addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:buttonSure];
        }
        
        _moneyField=[[UITextField alloc]init];
        _moneyField.frame=CGRectMake(100, 90, 300, 40);
        _moneyField.borderStyle=UITextBorderStyleRoundedRect;
        _moneyField.text=[AKsNetAccessClass sharedNetAccess].yingfuMoney;
        _moneyField.delegate=self;
        [_moneyField becomeFirstResponder];
        _moneyField.clearButtonMode=UITextFieldViewModeAlways;
        _moneyField.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:_moneyField];
    }
    return self;
}
/**
 *  按钮事件
 *
 *  @param btn
 */
-(void)ButtonClick:(UIButton *)btn
{
    if (btn.tag==0) {
        if([_moneyField.text length]<=0)
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入钱数不可为空,确定重新输入"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                      otherButtonTitles:nil];
                [alert show];
                
            });
        }
        else
        {
            [_dataInfo setObject:_moneyField.text forKey:@"voperate"];
            [_delegate AKuserPaymentViewButtonClick:_dataInfo];
        }
    }else
    {
        [_delegate AKuserPaymentViewButtonClick:nil];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
