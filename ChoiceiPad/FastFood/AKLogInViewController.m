//
//  AKLogInViewController.m
//  BookSystem
//
//  Created by chensen on 13-11-6.
//
//

#import "AKLogInViewController.h"
#import "AKDeskMainViewController.h"
#import "AKSettingUpViewController.h"
#import "BSDataProvider.h"
#import "Singleton.h"
//#import "WebOrderRepastViewController.h"
#import "BSSettingViewController.h"
//#import "AKsCanDanListClass.h"
//#import "PaymentSelect.h"
#import "SVProgressHUD.h"
//#import "UIKitUtil.h"
#import "CVLocalizationSetting.h"
#import "ZCDeskMainViewController.h"
#import "WebDeskMainViewController.h"

@interface AKLogInViewController ()
{
    UILabel *lb;
    UIButton *btn1;
    UIButton *btn2;
    UITextField *_textField1;
    UITextField *_textField2;
}
@end

@implementation AKLogInViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    if ([[Singleton sharedSingleton].userInfo objectForKey:@"user"]==nil) {
        lb.text=@"";
        
        btn1.frame=CGRectMake(337, 500, 60, 30);
        btn2.frame=CGRectMake(444, 500, 0, 0);
    }
    else
    {
        lb.text=[NSString stringWithFormat:@"用户名:%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
        btn1.frame=CGRectMake(337, 500, 60,30);
        btn2.frame=CGRectMake(444, 500, 60, 30);
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textField2.secureTextEntry = YES;
    UIImageView *BG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [BG setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"logo.png"]];
    [self.view addSubview:BG];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(135, 247, 490, 550)];
    [image setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"KeyboardBackground.png"]];
    [BG addSubview:image];
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    NSArray *array=[[NSArray alloc]initWithObjects:[langSetting localizedString:@"User:"],[langSetting localizedString:@"Password:"],nil];
    for (int i=0; i<2; i++) {
        UILabel *lblUser=[[UILabel alloc] initWithFrame:CGRectMake(192, 258+65*i, 119, 52)];
        lblUser.text=[array objectAtIndex:i];
        lblUser.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [BG addSubview:lblUser];
    }
    _textField1=[[UITextField alloc] initWithFrame:CGRectMake(300, 270, 250, 40)];
    _textField1.borderStyle=UITextBorderStyleRoundedRect;
    _textField1.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:_textField1];
    _textField2=[[UITextField alloc] initWithFrame:CGRectMake(300, 325, 250, 40)];
    _textField2.borderStyle=UITextBorderStyleRoundedRect;
    _textField2.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    _textField2.secureTextEntry = YES;
    [self.view addSubview:_textField2];
    lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 700, 30)];
    lb.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:lb];
    lb.backgroundColor=[UIColor clearColor];
    
    _keyboardView = [[ZenKeyboardView alloc] initWithFrame:CGRectMake(135, 1024-650, 490, 400)];
    _keyboardView.delegate = self;
    _textField1.delegate=self;
    _textField2.delegate=self;
    [_textField1 becomeFirstResponder];
    [self.view addSubview:_keyboardView];
//    if ([[[BSDataProvider alloc] init] activated]) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"setting.png"] forState:UIControlStateNormal];
        btn.frame=CGRectMake(708,944, 50, 50);
        [btn addTarget:self action:@selector(settingUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
//    }
    UILabel *lbl =[[UILabel alloc] initWithFrame:CGRectMake(0, 1004-20, 768, 20)];
    lbl.font=[UIFont systemFontOfSize:14];
    lbl.textColor=[UIColor whiteColor];
    lbl.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl];
    lbl.text = [[BSDataProvider sharedInstance] UUIDString];
}
#pragma mark - 键盘代理事件
- (void)didNumericKeyPressed:(UIButton *)button
{
    CVLocalizationSetting *cvlocal=[CVLocalizationSetting sharedInstance];
    if([button.titleLabel.text isEqualToString:[cvlocal localizedString:@"Finish"]])
    {
        if ([self.textField1 isFirstResponder])
        {
            [self.textField2 becomeFirstResponder];
        }
        else
        {
            [self.textField1 becomeFirstResponder];
        }
    }
    else if ([button.titleLabel.text isEqualToString:[cvlocal localizedString:@"Delect"]])
    {
        [self didBackspaceKeyPressed];
    }
    else
    {
        if ([self.textField1 isFirstResponder])
        {
            self.textField1.text = [NSString stringWithFormat:@"%@%@", self.textField1.text, button.titleLabel.text];
        }else
        {
            self.textField2.text = [NSString stringWithFormat:@"%@%@", self.textField2.text, button.titleLabel.text];
        }
    }
    
}

- (void)didBackspaceKeyPressed {
    if ([self.textField1 isFirstResponder]) {
        NSInteger length = self.textField1.text.length;
        if (length == 0) {
            self.textField1.text = @"";
            return;
        }
        NSString *substring = [self.textField1.text substringWithRange:NSMakeRange(0, length - 1)];
        self.textField1.text = substring;
    }else
    {
        NSInteger length = self.textField2.text.length;
        if (length == 0) {
            self.textField2.text = @"";
            return;
        }
        NSString *substring = [self.textField2.text substringWithRange:NSMakeRange(0, length - 1)];
        self.textField2.text = substring;
    }
    
}
-(void)zenKeychongzhiDelegate
{
    self.textField1.text=@"";
    self.textField2.text=@"";
    [self.textField1 becomeFirstResponder];
}
-(void)zenKeydengluDelegate
{
    [self logIn:nil];
}

////md5加密
//- (NSString *)md5HexDigest:(NSString*)password
//{
//    const char *original_str = [password UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(original_str, strlen(original_str), result);
//    NSMutableString *hash = [NSMutableString string];
//    for (int i = 0; i < 16; i++)
//    {
//        [hash appendFormat:@"%02X", result[i]];
//    }
//    NSString *mdfiveString = [hash lowercaseString];
//    NSLog(@"Encryption Result = %@",mdfiveString);
//    return mdfiveString;
//}


//程序升级
//-(void)isupdata
//{
//    NSString *dianPuNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
//    //    NSString *banbenNum=[[NSUserDefaults standardUserDefaults]objectForKey:@"versionNum"];
//    //    if(!banbenNum)
//    //    {
//    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
//    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
//    [[NSUserDefaults standardUserDefaults]setObject:versionNum forKey:@"versionNum"];
//    //    }
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *yy = [dateFormatter stringFromDate:[NSDate date]];
//    [dateFormatter setDateFormat:@"MM"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *MM = [dateFormatter stringFromDate:[NSDate date]];
//    
//    NSString *xmlstr=[NSString stringWithFormat:@"choicesoft%@%@",yy,MM];
//    NSString *md5XmlStr=[self md5HexDigest:xmlstr];
//    
//    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
//    netAccess.delegate=self;
//    
//    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:md5XmlStr,@"xmlStr",dianPuNum,@"scode",versionNum,@"version", nil];
//    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"IsHHTUpgradeWebService"]] andPost:dict andTag:IsHHTUpgradeWebService];
//    
//}

////升级成功反馈信息
//-(void)isupdataFanKui
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *yy = [dateFormatter stringFromDate:[NSDate date]];
//    [dateFormatter setDateFormat:@"MM"];
//    //用[NSDate date]可以获取系统当前时间
//    NSString *MM = [dateFormatter stringFromDate:[NSDate date]];
//    
//    NSString *xmlstr=[NSString stringWithFormat:@"choicesoft%@%@",yy,MM];
//    NSString *md5XmlStr=[self md5HexDigest:xmlstr];
//    
//    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
//    netAccess.delegate=self;
//    
//    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:md5XmlStr,@"xmlStr",@"",@"version",@"",@"ip",@"",@"oldVersion", nil];
//    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"HHTUpgradeVersion"]] andPost:dict andTag:HHTUpgradeVersion];
//}

#pragma mark - 登录按钮事件
- (void)logIn:(UIButton *)sender {
    [SVProgressHUD dismiss];
    if (_textField1.text.length&&_textField2.text.length) {
        NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:self.textField1.text,@"userCode",self.textField2.text,@"usePass", nil];
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        if ([Mode isEqualToString:@"zc"]) {
            [NSThread detachNewThreadSelector:@selector(ZCloginRequest:) toTarget:self withObject:requestDic];
        }else if([Mode isEqualToString:@"kc"]){
            [NSThread detachNewThreadSelector:@selector(loginRequest:) toTarget:self withObject:requestDic];
        }else
        {
            [Singleton sharedSingleton].pk_store=@"c97221b714e14f91b8f4";
            [NSThread detachNewThreadSelector:@selector(WebloginRequest:) toTarget:self withObject:requestDic];
        }
    }else{
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"User and Password could not be empty"]
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                             otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark - webPos
/**
 *  webPos登录请求
 *
 *  @param info
 */
-(void)WebloginRequest:(NSDictionary *)info
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShowButton_image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebLogin:info];
    [SVProgressHUD dismiss];
    if (dict) {
        
        NSArray *array=[dict objectForKey:@"root"];
        if (array==nil) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"网络连接超时"
                                                          message:Nil delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (![(NSString *)array isEqual:@"null"]) {
            NSDictionary *dic=[array lastObject];
            [Singleton sharedSingleton].userName=[dic objectForKey:@"userName"];        //用户名
            [Singleton sharedSingleton].pk_store=[dic objectForKey:@"userPK_Store"];    //店铺编主键
            [Singleton sharedSingleton].pk_inemp=[dic objectForKey:@"userPK_Operator"]; //服务员主键
            [Singleton sharedSingleton].pk_pos=  [dic objectForKey:@"userPK_POS"];      //pos主键
            [[BSDataProvider sharedInstance] downloadData];
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"curDataVersion"] isEqualToString:[dic objectForKey:@"curDataVersion"]]) {
                if ([[BSDataProvider sharedInstance] downloadData]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"curDataVersion"] forKey:@"curDataVersion"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"更新失败，请重新更新数据" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            }
            bs_dispatch_sync_on_main_thread(^{
                WebDeskMainViewController *web=[[WebDeskMainViewController alloc] init];
                
                [self.navigationController pushViewController:web animated:YES];
            });
            
        }else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"用户名密码错误或没有注册" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }else
    {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"网络连接超时" message:Nil delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - 中餐请求
-(void)ZCloginRequest:(NSDictionary *)requestDic
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp ZCLoginUser:requestDic];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowButton_image"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//     @"ShowButton_image"]
    [SVProgressHUD dismiss];
    if (![[dict objectForKey:@"Result"] boolValue]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
    }else {
        NSMutableDictionary *dict1=[[NSMutableDictionary alloc] init];
        [dict1 setObject:self.textField1.text forKey:@"user"];
        [dict1 setObject:self.textField2.text forKey:@"password"];
        [AKsNetAccessClass sharedNetAccess].UserPass=self.textField1.text;
        [Singleton sharedSingleton].userInfo=dict1;
        [Singleton sharedSingleton].userName=[[[dict objectForKey:@"Message"] componentsSeparatedByString:@"^"] objectAtIndex:0];
        if ([[[[dict objectForKey:@"Message"] componentsSeparatedByString:@"^"] objectAtIndex:1] boolValue]) {
            [AKsNetAccessClass sharedNetAccess].molingPrice=[[[dict objectForKey:@"Message"] componentsSeparatedByString:@"^"] objectAtIndex:2];
        }
        bs_dispatch_sync_on_main_thread(^{
            ZCDeskMainViewController *desk=[[ZCDeskMainViewController alloc] init];
            self.textField1.text=@"";
            self.textField2.text=@"";
            [self.navigationController pushViewController:desk animated:YES];
        });
    }

}
#pragma mark - 快餐请求
-(void)loginRequest:(NSDictionary *)requestDic
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp pLoginUser:requestDic];
    if (dict) {
        [SVProgressHUD dismiss];
        NSString *result = [[dict objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if ([ary count]==1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[ary lastObject] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSString *content=[ary objectAtIndex:1];
            NSString *str=[ary objectAtIndex:0];
            if ([str isEqualToString:@"0"]) {
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                [dict setObject:self.textField1.text forKey:@"user"];
                [dict setObject:self.textField2.text forKey:@"password"];
                [Singleton sharedSingleton].userInfo=dict;
                [Singleton sharedSingleton].Time=[ary objectAtIndex:1];
                [Singleton sharedSingleton].userName=[ary objectAtIndex:6];
                [Singleton sharedSingleton].jurisdiction=[ary objectAtIndex:2];
                [Singleton sharedSingleton].dataVersion=[ary objectAtIndex:4];
                if([ary objectAtIndex:4] && [ary objectAtIndex:5])
                {
                    if([[ary objectAtIndex:4]isEqualToString:[ary objectAtIndex:5]])
                    {
                        bs_dispatch_sync_on_main_thread(^{
                            AKDeskMainViewController *deskMainViewController = [[AKDeskMainViewController alloc]initWithNibName:nil bundle:nil];
                            [self.navigationController pushViewController:deskMainViewController animated:YES];
                        });
                    }
                    else
                    {
                        bs_dispatch_sync_on_main_thread(^{
                            
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Version updated FTP synchronize data"]
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NO"]
                                                                 otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],nil];
                            alert.tag=4;
                            [alert show];
                        });
                    }
                }
                
            }
            else
            {
                [SVProgressHUD dismiss];
                if (content==nil) {
                    content=[[CVLocalizationSetting sharedInstance] localizedString:@"network connection timeout"];
                }
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:content
                                                              delegate:nil
                                                     cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                     otherButtonTitles:nil];
                [alert show];
                
                
            }
        }
    }
    else
    {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"network connection timeout"
                                                      delegate:nil
                                             cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                             otherButtonTitles:nil];
        [alert show];
        
    }
}
#pragma mark - 设置按钮事件
- (IBAction)settingUp:(UIButton *)sender//设置
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[CVLocalizationSetting sharedInstance] localizedString:@"Please enter the password"] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"],nil];
        alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
        UITextField *tf=[alertView textFieldAtIndex:0];
        tf.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
        alertView.tag=3;
        [alertView show];
    });
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==4)
    {
        if(buttonIndex==1)
        {
            BSSettingViewController *vcSetting = [[BSSettingViewController alloc] initWithType:BSSettingTypeUpdate];
            [self.navigationController pushViewController:vcSetting animated:YES];
        }
    }
    //    else if (alertView.tag==5)
    //    {
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://115.238.164.148:8070/ChoiceIpad/ChoiceApp.html"]];
    //        exit(0);
    //    }
    else if (alertView.tag==3) {
        if (buttonIndex==1) {
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];               NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*60*24*3;
            NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yy"];
            //用[NSDate date]可以获取系统当前时间
            NSString *yy = [dateFormatter stringFromDate:localeDate];
            [dateFormatter setDateFormat:@"MM"];
            //用[NSDate date]可以获取系统当前时间
            NSString *MM = [dateFormatter stringFromDate:localeDate];
            [dateFormatter setDateFormat:@"dd"];
            //用[NSDate date]可以获取系统当前时间
            NSString *dd = [dateFormatter stringFromDate:localeDate];
            NSString *str=[NSString stringWithFormat:@"%@%@%@",dd,MM,yy];
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            tf1.enabled=YES;
            if ([tf1.text isEqualToString:str]) {
                AKSettingUpViewController *settingUpViewController = [[AKSettingUpViewController alloc]initWithNibName:nil bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:settingUpViewController];
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[[CVLocalizationSetting sharedInstance] localizedString:@"Wrong password, please enter again"] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alert show];
            }
            
        }
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    return YES;
}
/**
 *  键盘通知
 *
 *  @param Notification
 */
- (void)keyboardWillShow:(NSNotification *)Notification{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    [tempWindow setAlpha:0];
}
@end
