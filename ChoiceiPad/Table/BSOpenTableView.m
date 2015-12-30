//
//  BSOpenTableView.m
//  BookSystem
//
//  Created by Dream on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSOpenTableView.h"
#import "CVLocalizationSetting.h"
#import "Singleton.h"
#import "AKsNetAccessClass.h"

@implementation BSOpenTableView
{
    NSString *openTag;
    UITextField *_tableTextField;// 台位号
    UITextField *_manTextField;  //男人数
    UITextField *_womanTextField;//女人数
    NSString    *_scanText;
}
@synthesize delegate=_delegate,tableDic=_tableDic;
-(id)initWithFrame:(CGRect)frame withtag:(NSString *)tag
{
    self=[self initWithFrame:frame withtag:tag withTableShow:NO];
    return self;
}

- (id)initWithFrame:(CGRect)frame withtag:(NSString *)tag withTableShow:(BOOL)tableTag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if ([Mode isEqualToString:@"zc"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowButton_image"];
        }
        CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
        if ([tag intValue]==1) {
            [self setTitle:[localization localizedString:@"Open Table"]];
        }else
        {
            [self setTitle:@"搭台"];
        }
        openTag=tag;
        if (tableTag) {
            UILabel *tableLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 90, 40)];
            
            tableLable.textAlignment = NSTextAlignmentRight;
            tableLable.backgroundColor = [UIColor clearColor];
            tableLable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            tableLable.text = [localization localizedString:@"Table:"];
            [self addSubview:tableLable];
            
            
            _tableTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 80, 320, 40)];
            [_tableTextField becomeFirstResponder];
            _tableTextField.borderStyle=UITextBorderStyleRoundedRect;
            _tableTextField.clearButtonMode=UITextFieldViewModeAlways;
//            _tableTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
            _tableTextField.keyboardAppearance=UIKeyboardTypeNumberPad;
            _tableTextField.delegate=self;
            [self addSubview:_tableTextField];
        }
        
        UILabel *manLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 90, 40)];
        
        manLable.textAlignment = NSTextAlignmentRight;
        manLable.backgroundColor = [UIColor clearColor];
        manLable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        manLable.text=[localization localizedString:@"People:"];
        [self addSubview:manLable];
        
        
        _manTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 130, 320, 40)];
        [_manTextField becomeFirstResponder];
        _manTextField.clearButtonMode=UITextFieldViewModeAlways;
        _manTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
        _manTextField.borderStyle=UITextBorderStyleRoundedRect;
        _manTextField.delegate=self;
        [self addSubview:_manTextField];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"ShowButton_image"] boolValue]) {
            manLable.text = [localization localizedString:@"Mister"];
            UILabel *womanLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 180, 90, 40)];
            womanLabel.textAlignment = NSTextAlignmentRight;
            womanLabel.backgroundColor = [UIColor clearColor];
            womanLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            womanLabel.text = [localization localizedString:@"Mistress"];
            [self addSubview:womanLabel];
            _womanTextField= [[UITextField alloc] initWithFrame:CGRectMake(110, 180, 320, 40)];
            _womanTextField.borderStyle=UITextBorderStyleRoundedRect;
            _womanTextField.clearButtonMode=UITextFieldViewModeAlways;
            _womanTextField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
            _womanTextField.delegate=self;
            [self addSubview:_womanTextField];
        }
//        if ([Mode isEqualToString:@"kc"])
//        {
//            UIButton *btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
//            btnScan.frame = CGRectMake(135, 265, 90, 40);
//            
//            [btnScan setTitle:[localization localizedString:@"OK"] forState:UIControlStateNormal];
//            btnScan.titleLabel.textColor=[UIColor whiteColor];
//            btnScan.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//            btnScan.tag = 700;
//            [btnScan addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
//            [btnScan setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
//            [self addSubview:btnScan];
//        }
        
        
        UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConfirm.frame = CGRectMake(240, 265, 90, 40);
        
        [btnConfirm setTitle:[localization localizedString:@"OK"] forState:UIControlStateNormal];
        btnConfirm.titleLabel.textColor=[UIColor whiteColor];
        btnConfirm.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        btnConfirm.tag = 700;
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        [btnConfirm setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [self addSubview:btnConfirm];
        
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(345, 265, 90, 40);
        btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnCancel setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [btnCancel setTitle:[localization localizedString:@"Cancel"] forState:UIControlStateNormal];
        btnCancel.titleLabel.textColor=[UIColor whiteColor];
        [self addSubview:btnCancel];
        btnCancel.tag = 701;
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"]) {//判断设置里的版本
//            
//            [self viewLoad1];
//        }else{
//            [self viewLoad2];
//        }
        
    }
    return self;
}
//-(void)viewLoad1
//{
//    self.transform = CGAffineTransformIdentity;
//    CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
//    if ([openTag intValue]==1) {
//        [self setTitle:[localization localizedString:@"Open Table"]];
//    }else
//    {
//        [self setTitle:@"搭台"];
//    }
//    
//    lblPeople = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 80, 30)];
//    lblPeople.font=[UIFont italicSystemFontOfSize:20];
//    lblPeople.textAlignment = UITextAlignmentRight;
//    lblPeople.backgroundColor = [UIColor clearColor];
//    lblPeople.text = [localization localizedString:@"People:"];
//    
//    [self addSubview:lblPeople];
//    tfPeople = [[UITextField alloc] initWithFrame:CGRectMake(100, 130, 350, 30)];
//    tfPeople.borderStyle = UITextBorderStyleRoundedRect;
//    tfPeople.clearButtonMode=UITextFieldViewModeAlways;
//    tfPeople.delegate=self;
//    tfPeople.keyboardAppearance=UIKeyboardTypeNumberPad;
//    [tfPeople becomeFirstResponder];
//    tfPeople.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
//    [self addSubview:tfPeople];
//    //    _btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    //    _btn.frame=CGRectMake(50, 180, 30, 30);
//    //    _btn.selected=NO;
//    //    [_btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"select_no.png"] forState:UIControlStateNormal];
//    //    [_btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //    [self addSubview:_btn];
//    //    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(100, 180, 300, 40)];
//    //    lb.text=@"是否会员?";
//    //    lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:25];
//    //    lb.backgroundColor=[UIColor clearColor];
//    //    lb.textColor=[UIColor redColor];
//    //    [self addSubview:lb];
//    btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btnConfirm.frame = CGRectMake(240, 265, 90, 40);
//    [btnConfirm setTitle:[localization localizedString:@"OK"] forState:UIControlStateNormal];
//    btnConfirm.titleLabel.font=[UIFont italicSystemFontOfSize:20];
//    [btnConfirm setTintColor:[UIColor whiteColor]];
//    //    [btnConfirm setImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
//    [self addSubview:btnConfirm];
//    btnConfirm.tag = 700;
//    [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
//    [btnConfirm setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
//    btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btnCancel.frame = CGRectMake(345, 265, 90, 40);
//    btnCancel.titleLabel.font=[UIFont italicSystemFontOfSize:20];
//    [btnConfirm setTintColor:[UIColor whiteColor]];
//    [btnCancel setTitle:[localization localizedString:@"Cancel"] forState:UIControlStateNormal];
//    [btnCancel setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
//    //    [btnCancel setImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
//    [btnCancel setTintColor:[UIColor whiteColor]];
//    [self addSubview:btnCancel];
//    btnCancel.tag = 701;
//    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//}
//-(void)viewLoad2
//{
//    self.transform = CGAffineTransformIdentity;
//    CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
//    if ([openTag intValue]==1) {
//        [self setTitle:[localization localizedString:@"Open Table"]];
//    }else
//    {
//        [self setTitle:@"搭台"];
//    }
//    lblUser = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 90, 40)];
//    lblUser.textAlignment = UITextAlignmentRight;
//    lblUser.backgroundColor = [UIColor clearColor];
//    lblUser.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//    lblUser.text = [localization localizedString:@"Mister"];
//    [self addSubview:lblUser];
//    
//    lblPeople = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 90, 40)];
//    lblPeople.textAlignment = UITextAlignmentRight;
//    lblPeople.backgroundColor = [UIColor clearColor];
//    lblPeople.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//    lblPeople.text = [localization localizedString:@"Mistress"];
//    [self addSubview:lblPeople];
//    tfUser = [[UITextField alloc] initWithFrame:CGRectMake(110, 80, 320, 40)];
//    [tfUser becomeFirstResponder];
//    tfPeople = [[UITextField alloc] initWithFrame:CGRectMake(110, 130, 320, 40)];
//    tfUser.clearButtonMode=UITextFieldViewModeAlways;
//    tfPeople.clearButtonMode=UITextFieldViewModeAlways;
//    tfPeople.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
//    tfUser.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
////    tfUser.keyboardType=UIKeyboardTypeNumberPad;
//    tfUser.borderStyle = UITextBorderStyleRoundedRect;
//    tfPeople.borderStyle = UITextBorderStyleRoundedRect;
//    tfPeople.keyboardType=UIKeyboardTypeNumberPad;
//    tfPeople.delegate=self;
//    tfUser.delegate=self;
//    tfWaiter.delegate=self;
//    
//    [self addSubview:tfUser];
//    [self addSubview:tfPeople];
//    //    _btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    //    _btn.frame=CGRectMake(50, 180, 30, 30);
//    //    _btn.selected=NO;
//    //    [_btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"select_no.png"] forState:UIControlStateNormal];
//    //    [_btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    //    [self addSubview:_btn];
//    //    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(100, 180, 300, 40)];
//    //    lb.text=@"是否会员?";
//    //    lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:25];
//    //    lb.backgroundColor=[UIColor clearColor];
//    //    lb.textColor=[UIColor redColor];
//    //    [self addSubview:lb];
//    btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnConfirm.frame = CGRectMake(240, 265, 90, 40);
//    
//    [btnConfirm setTitle:[localization localizedString:@"OK"] forState:UIControlStateNormal];
//    btnConfirm.titleLabel.textColor=[UIColor whiteColor];
//    btnConfirm.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//    [btnConfirm setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
//    [self addSubview:btnConfirm];
//    btnConfirm.tag = 700;
//    [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
//    
//    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnCancel.frame = CGRectMake(345, 265, 90, 40);
//    btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//    [btnCancel setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
//    [btnCancel setTitle:[localization localizedString:@"Cancel"] forState:UIControlStateNormal];
//    btnCancel.titleLabel.textColor=[UIColor whiteColor];
//    [self addSubview:btnCancel];
//    btnCancel.tag = 701;
//    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    
//    //    tfUser.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"username"];
//}


-(void)selectBtnClick:(UIButton *)btn
{
    if (btn.selected) {
        //[fmdb executeUpdate:@"updata "]
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"select_no.png"] forState:UIControlStateNormal];
        [AKsNetAccessClass sharedNetAccess].isVipShow=NO;
        btn.selected=NO;
    }
    else
    {
        if ([_manTextField.text length]>0||[_womanTextField.text length]>0) {
            [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"select_yes.png"] forState:UIControlStateNormal];
            [AKsNetAccessClass sharedNetAccess].isVipShow=YES;
//            [AKsNetAccessClass sharedNetAccess].PeopleManNum=tfUser.text;
//            [AKsNetAccessClass sharedNetAccess].PeopleWomanNum=tfPeople.text;
            [Singleton sharedSingleton].man=_manTextField.text;
            [Singleton sharedSingleton].woman=_womanTextField.text;
            [Singleton sharedSingleton].Seat=[AKsNetAccessClass sharedNetAccess].TableNum;
            btn.selected=YES;
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入人数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}
-(void)scanClick
{
    [_delegate scanClick:^(NSString *string) {
        _scanText=string;
        
    }];
}
- (void)confirm{
    if (_tableTextField) {
        if ([_tableTextField.text length]==0) {
            UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入台位号" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [al show];
            return;
        }else
        {
            _tableDic =[NSMutableDictionary dictionaryWithObjectsAndKeys:_tableTextField.text,@"name",_tableTextField.text,@"num", nil];
        }
    }
    if (_scanText) {
        [_tableDic setObject:_scanText forKey:@"auth_code"];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"]) {//判断设置里的版本
        [_manTextField endEditing:YES];
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:_tableDic];
        if ([_manTextField.text length]>0)
        {
            [dict setObject:_manTextField.text forKey:@"man"];
            //            [_tableDic setValue:tfPeople.text forKeyPath:@"man"];
            [Singleton sharedSingleton].man=_manTextField.text;
        }
        else
        {
            UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入人数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [al show];
            return;
        }
        [dict setObject:@"0" forKey:@"tag"];
        [dict setObject:openTag forKey:@"openTag"];
        [_delegate openTableWithOptions:dict];
        
    }else{
        [_manTextField endEditing:YES];
        [_womanTextField endEditing:YES];
        if ([_manTextField.text intValue]>0||[_womanTextField.text intValue]>0) {
            NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:_tableDic];
            [Singleton sharedSingleton].man=_manTextField.text;
            [Singleton sharedSingleton].woman=_womanTextField.text;
            if ([_manTextField.text length]==0) {
                _manTextField.text=0;
            }
            if ([_womanTextField.text length]==0)
            {
                _womanTextField.text=0;
            }
            [dict setValue:_womanTextField.text forKey:@"woman"];
            [dict setValue:_manTextField.text forKey:@"man"];
            [dict setValue:@"1" forKey:@"tag"];
            [dict setValue:openTag forKey:@"openTag"];
            [_delegate openTableWithOptions:dict];
        }
        else
        {
            UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入人数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [al show];
        }
        
    }
}

- (void)cancel{
    [_delegate openTableWithOptions:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        
        //        ^\d{m,n}$
        NSString *validRegEx=nil;
        if (_tableTextField) {
            validRegEx =@"^[0-9,-]";
        }else{
            validRegEx =@"^[0-9]";
            if ([textField.text length]>=2) {
                return NO;
            }
        }
        
       
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}

@end
