//
//  AKsWaitSeatOpenTable.m
//  BookSystem
//
//  Created by sundaoran on 13-12-26.
//
//

#import "AKsWaitSeatOpenTable.h"
#import "Singleton.h"
#import "CVLocalizationSetting.h"

@implementation AKsWaitSeatOpenTable
@synthesize delegate=_delegate,btn=_btn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"]) {//判断设置里的版本
            [self viewLoad1];
        }else{
            [self viewLoad2];
        }
    }
    return self;
}

-(void)viewLoad1
{
    self.transform = CGAffineTransformIdentity;
    [self setTitle:@"开台"];
    
    UILabel *lblPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 90, 30)];
    lblPhoneNum.textAlignment = NSTextAlignmentRight;
    lblPhoneNum.backgroundColor = [UIColor clearColor];
    lblPhoneNum.text = [[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"];
    lblPhoneNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self addSubview:lblPhoneNum];
    tfPhoenNum= [[UITextField alloc] initWithFrame:CGRectMake(110, 75, 350, 40)];
    tfPhoenNum.clearButtonMode=UITextFieldViewModeAlways;
    tfPhoenNum.borderStyle = UITextBorderStyleRoundedRect;
    tfPhoenNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self addSubview:tfPhoenNum];
    tfPhoenNum.delegate=self;
    
    lblPeople = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 80, 30)];
    lblPeople.textAlignment = UITextAlignmentRight;
    lblPeople.backgroundColor = [UIColor clearColor];
    lblPeople.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    lblPeople.text = [[CVLocalizationSetting sharedInstance] localizedString:@"People:"];
    [self addSubview:lblPeople];

    tfPeople = [[UITextField alloc] initWithFrame:CGRectMake(110, 130, 350, 40)];
    tfPeople.borderStyle = UITextBorderStyleRoundedRect;
    tfPeople.clearButtonMode=UITextFieldViewModeAlways;
    tfPeople.delegate=self;
    [self addSubview:tfPeople];
    btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnConfirm.frame =CGRectMake(240, 265, 90, 40);
    [btnConfirm setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [self addSubview:btnConfirm];
    btnConfirm.tag = 700;
    [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(345, 265, 90, 40);
    [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [self addSubview:btnCancel];
    btnCancel.tag = 701;
    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewLoad2
{
    self.transform = CGAffineTransformIdentity;
    [self setTitle:@"预点台位"];
    
    
    UILabel *lblPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 90, 30)];
    lblPhoneNum.textAlignment = NSTextAlignmentRight;
    lblPhoneNum.backgroundColor = [UIColor clearColor];
    lblPhoneNum.text = [[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"];
    lblPhoneNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self addSubview:lblPhoneNum];
    
    lblUser = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 90, 30)];
    lblUser.textAlignment = NSTextAlignmentRight;
    lblUser.backgroundColor = [UIColor clearColor];
    lblUser.text = [[CVLocalizationSetting sharedInstance] localizedString:@"Mister"];
    lblUser.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self addSubview:lblUser];

    
    lblPeople = [[UILabel alloc] initWithFrame:CGRectMake(15, 180, 90, 30)];
    lblPeople.textAlignment = NSTextAlignmentRight;
    lblPeople.backgroundColor = [UIColor clearColor];
    lblPeople.text = [[CVLocalizationSetting sharedInstance] localizedString:@"Mistress"];;
    lblPeople.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self addSubview:lblPeople];
    
    
    tfPhoenNum= [[UITextField alloc] initWithFrame:CGRectMake(110, 75, 350, 40)];
    tfPhoenNum.clearButtonMode=UITextFieldViewModeAlways;
    tfPhoenNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    tfUser = [[UITextField alloc] initWithFrame:CGRectMake(110, 125, 350, 40)];
    tfUser.clearButtonMode=UITextFieldViewModeAlways;
    tfUser.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    tfPeople = [[UITextField alloc] initWithFrame:CGRectMake(110, 175, 350, 40)];
    tfPeople.clearButtonMode=UITextFieldViewModeAlways;
    tfPeople.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    
    tfPhoenNum.keyboardType=UIKeyboardTypeNumberPad;
    tfPhoenNum.borderStyle = UITextBorderStyleRoundedRect;
    tfUser.keyboardType=UIKeyboardTypeNumberPad;
    tfUser.borderStyle = UITextBorderStyleRoundedRect;
    tfPeople.borderStyle = UITextBorderStyleRoundedRect;
    tfPeople.keyboardType=UIKeyboardTypeNumberPad;
    
    tfPeople.clearButtonMode=UITextFieldViewModeAlways;
    tfUser.clearButtonMode=UITextFieldViewModeAlways;
    tfPhoenNum.clearButtonMode=UITextFieldViewModeAlways;
    tfWaiter.clearButtonMode=UITextFieldViewModeAlways;
    
    [self addSubview:tfPhoenNum];
    [self addSubview:tfUser];
    [self addSubview:tfPeople];
    
    tfPeople.delegate=self;
    tfPhoenNum.delegate=self;
    tfUser.delegate=self;
    tfWaiter.delegate=self;

    
//    _btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    _btn.frame=CGRectMake(50, 230, 30, 30);
//    _btn.selected=NO;
//    [_btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"select_no.png"] forState:UIControlStateNormal];
//    [_btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_btn];
//    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(80, 230, 300, 30)];
//    lb.text=@"是否会员?";
//    lb.textAlignment=NSTextAlignmentCenter;
//    lb.backgroundColor=[UIColor clearColor];
//    lb.textColor=[UIColor redColor];
//    lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//    [self addSubview:lb];
    btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnConfirm.frame = CGRectMake(240, 265, 90, 40);
    btnConfirm.titleLabel.textColor=[UIColor whiteColor];
    btnConfirm.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [btnConfirm setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
    [btnConfirm setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];

    btnConfirm.tag = 700;
    [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnConfirm];
    
    
    btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(345, 265, 90, 40);
    btnCancel.titleLabel.textColor=[UIColor whiteColor];
    btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [btnCancel setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
    [btnCancel setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [self addSubview:btnCancel];
    btnCancel.tag = 701;
    [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    //    tfUser.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"username"];
}

-(void)selectBtnClick:(UIButton *)btn
{
    if (btn.selected) {
        //[fmdb executeUpdate:@"updata "]
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"select_no.png"] forState:UIControlStateNormal];
        
        btn.selected=NO;
    }
    else
    {
       
        if([tfPhoenNum.text length]!=11)
        {
           
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号码"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                      otherButtonTitles:nil];
                [alert show];
                
            });
            

        }
        else
        {
            if ([tfPeople.text length]>0||[tfUser.text length]>0)
            {
                [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"select_yes.png"] forState:UIControlStateNormal];
                [AKsNetAccessClass sharedNetAccess].phoneNum=tfPhoenNum.text;
                [AKsNetAccessClass sharedNetAccess].TableNum=tfPhoenNum.text;
                [AKsNetAccessClass sharedNetAccess].isVipShow=YES;
                [AKsNetAccessClass sharedNetAccess].PeopleManNum=tfUser.text;
                [AKsNetAccessClass sharedNetAccess].PeopleWomanNum=tfPeople.text;
                [AKsNetAccessClass sharedNetAccess].VipCardNum=@"";
                
                [Singleton sharedSingleton].Seat=tfPhoenNum.text;
                [Singleton sharedSingleton].man=tfUser.text;
                [Singleton sharedSingleton].woman=tfPeople.text;
//                [_delegate VipClickWait];
                btn.selected=YES;
            }
            else
            {
                UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入人数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [al show];
            }

        }
       
    }
    
}
- (void)confirm{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"]) {//判断设置里的版本
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"name"] forKey:@"user"];
//        [dic setObject:@"0" forKey:@"waiter"];
//        if ([tfPeople.text length]>0)
//            [dic setObject:tfPeople.text forKey:@"people"];
//        [_delegate openWaitTableWithOptions:dic];

       if([tfPhoenNum.text length]==11)
       {
           if ([tfPeople.text length]>0||[tfUser.text length]>0)
           {
               NSMutableDictionary *dict=[NSMutableDictionary dictionary];
               [Singleton sharedSingleton].man=tfPeople.text;
//               [Singleton sharedSingleton].woman=tfPeople.text;
               [Singleton sharedSingleton].Seat=tfPhoenNum.text;
               [AKsNetAccessClass sharedNetAccess].TableNum=tfPhoenNum.text;
               NSLog(@"%@",tfPeople.text);
               NSLog(@"%d",[tfUser.text length]);
               if ([tfUser.text length]==0) {
                   tfUser.text=@"0";
               }
               if ([tfPeople.text length]==0)
               {
                   tfPeople.text=@"0";
               }
               [dict setValue:tfPeople.text forKey:@"man"];
               [_delegate openWaitTableWithOptions:dict];
           }
           else
           {
               UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入人数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
               [al show];
           }

        }
        else
        {
            UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入正确的手机号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [al show];
        }
    }
    else{
        if([tfPhoenNum.text length]==11)
        {
            if ([tfPeople.text length]>0||[tfUser.text length]>0)
            {
                NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                [Singleton sharedSingleton].man=tfUser.text;
                [Singleton sharedSingleton].woman=tfPeople.text;
                [Singleton sharedSingleton].Seat=tfPhoenNum.text;
                [AKsNetAccessClass sharedNetAccess].TableNum=tfPhoenNum.text;
                if ([tfUser.text length]==0) {
                    tfUser.text=@"0";
                }
                if ([tfPeople.text length]==0)
                {
                    tfPeople.text=@"0";
                }
                NSLog(@"%@",tfPeople.text);
                [dict setValue:tfPeople.text forKey:@"woman"];
                [dict setValue:tfUser.text forKey:@"man"];
                [_delegate openWaitTableWithOptions:dict];
            }
            else
            {
                UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入人数" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [al show];
            }
            
        }
        else
        {
            UIAlertView *al=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请录入正确的手机号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [al show];
        }

    }
}

- (void)cancel{
    [_delegate cancleAKsWaitSeat];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else if(([string isEqualToString:@"0"] &&[textField.text length]==0)||((textField!=tfPhoenNum)&&[textField.text length]>1)||((textField==tfPhoenNum)&&[textField.text length]>10))
    {
        return NO;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
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
