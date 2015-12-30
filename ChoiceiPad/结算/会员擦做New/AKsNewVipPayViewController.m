//tmp/VMwareDnD/7629813b/BookSystem.sqlite//
//  AKsVipPayViewController.m
//  BookSystem
//
//  Created by sundaoran on 13-12-5.
//
//

#import "AKsNewVipPayViewController.h"
#import "AKsIsVipShowView.h"
#import "SVProgressHUD.h"
#import "CVLocalizationSetting.h"
#import "BSDataProvider.h"



@interface AKsNewVipPayViewController ()

@end

@implementation AKsNewVipPayViewController
{
    UILabel             *lblmoney;      //余额
    UILabel             *_tfYuKe;       //可用余额
    UILabel             *_tfJiKe;       //可用积分
    UITextField         *_tfYuXiao;     //消费余额
    UITextField         *_tfJiXiao;     //消费积分
    UIButton            *buttonBack;
    UIButton            *buttonSure;
    UIView              *_showCardView;
    NSMutableArray      *_ticketArray;
    NSMutableArray      *_userTicketArray;
    AKsPassWordView     *_passWordView;
    float               _yingfuPrice;
    float               _orderYmoney;
    UIScrollView        *scroll;
    AKsIsVipShowView    *showVip;
    NSDictionary        *cardInfo;
}


static int count;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AKMySegmentAndView *akv=[AKMySegmentAndView shared];
    akv.frame=CGRectMake(0, 0, 768, 44);
    akv.delegate=self;
    [akv segmentShow:NO];
    [akv shoildCheckShow:NO];
    [self.view addSubview:akv];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    cardInfo=[Singleton sharedSingleton].VIPCardInfo;
    _ticketArray=[cardInfo objectForKey:@"ticketInfoList"];
    self.view.backgroundColor=[UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1];
    
    //    AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
    //
    //
    //    _yingfuPrice=[netAccess.yingfuMoney floatValue];
    [self paymentViewQueryProduct];
    lblmoney=[[UILabel alloc]initWithFrame:CGRectMake(17,174-60-30, 250, 50)];
    lblmoney.textAlignment=NSTextAlignmentCenter;
    _orderYmoney=_yingfuPrice;
    lblmoney.text=[NSString stringWithFormat:@"应付金额：%.2f元",_yingfuPrice];
    lblmoney.backgroundColor=[UIColor clearColor];
    lblmoney.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:lblmoney];
    NSArray *array=[[NSArray alloc] initWithObjects:@"储值可用余额:",@"余额消费:",@"积分可用余额:",@"积分消费:", nil];
    for (int i=0;i<[array count];i++) {
        UILabel *label=[[UILabel alloc] init];
        label.frame=CGRectMake(20+380*(i%2), 164+(i/2)*60, 130, 50);
        label.text=[array objectAtIndex:i];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentLeft;
        label.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self.view addSubview:label];
        
    }
    
    
    _tfYuKe=[[UILabel alloc]initWithFrame:CGRectMake(150,54+170-60, 210, 50)];
    _tfYuKe.textAlignment=NSTextAlignmentRight;
    
    _tfYuKe.text=[NSString stringWithFormat:@"%@",[cardInfo objectForKey:@"storedCardsBalance"]];
    _tfYuKe.layer.cornerRadius=5;
    _tfYuKe.backgroundColor=[UIColor whiteColor];
    _tfYuKe.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:_tfYuKe];
    
    _tfJiKe=[[UILabel alloc]initWithFrame:CGRectMake(150,124+170-60, 210, 50)];
    _tfJiKe.textAlignment=NSTextAlignmentRight;
    _tfJiKe.text=[NSString stringWithFormat:@"%@",[cardInfo objectForKey:@"integralOverall"]];
    _tfJiKe.layer.cornerRadius=5;
    _tfJiKe.backgroundColor=[UIColor whiteColor];
    _tfJiKe.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:_tfJiKe];
    
    _tfYuXiao=[[UITextField alloc]initWithFrame:CGRectMake(540,54+170-60, 210, 50)];
    _tfYuXiao.borderStyle=UITextBorderStyleRoundedRect;
    _tfYuXiao.backgroundColor=[UIColor whiteColor];
    _tfYuXiao.text=[NSString stringWithFormat:@"%.2f",0.00];
    _tfYuXiao.clearButtonMode=UITextFieldViewModeAlways;
    _tfYuXiao.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    _tfYuXiao.delegate=self;
    _tfYuXiao.clearsOnBeginEditing=YES;
    _tfYuXiao.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:_tfYuXiao];
    
    
    _tfJiXiao=[[UITextField alloc]initWithFrame:CGRectMake(540,124+170-60, 210, 50)];
    _tfJiXiao.borderStyle=UITextBorderStyleRoundedRect;
    _tfJiXiao.backgroundColor=[UIColor whiteColor];
    _tfJiXiao.clearButtonMode=UITextFieldViewModeAlways;
    _tfJiXiao.text=[NSString stringWithFormat:@"%.2f",0.00];
    _tfJiXiao.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    _tfJiXiao.delegate=self;
    _tfJiXiao.clearsOnBeginEditing=YES;
    _tfJiXiao.keyboardType=UIKeyboardTypeNumberPad;
    [self.view addSubview:_tfJiXiao];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,260+170-60, 768,40)];
    title.frame=CGRectMake(0, 300, 768, 40);
    title.textAlignment=NSTextAlignmentCenter;
    title.text=@"优惠劵";
    title.layer.cornerRadius=5;
    title.backgroundColor=[UIColor clearColor];
    title.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:title];
    
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 728, 220)];
    scroll.frame=CGRectMake(0, 0, 728, 290);
    scroll.backgroundColor=[UIColor colorWithRed:254/255.0f green:254/255.0f blue:254/255.0f alpha:1];
    _showCardView=[[UIView alloc]initWithFrame:CGRectMake(20,480-60,728, 370)];
    _showCardView.frame=CGRectMake(20, 350, 728, 440);
    _showCardView.backgroundColor=[UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1];
    
    [self.view addSubview:_showCardView];
    NSArray *array2=[[NSArray alloc]initWithObjects:@"计算余额",@"计算积分", nil];
    for (int i=0; i<[array2 count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonBlue.png"] forState:UIControlStateHighlighted];
        button.titleLabel.font=[UIFont systemFontOfSize:20];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        //        button.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        [button setTitle:[NSString stringWithFormat:@"%@",[array2 objectAtIndex:i]] forState:UIControlStateNormal];
        button.tag=200+i;
        [button addTarget:self action:@selector(ButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(10+i%3*160,i/3*75+300, 140, 65);
//        [_caozuoButtonArray addObject:button];
        [_showCardView addSubview:button];
    }
    [_showCardView addSubview:scroll];
    
//    _dataButtonArray=[[NSMutableArray alloc]init];
//    _caozuoButtonArray=[[NSMutableArray alloc]init];
    
    [self addTicketButton];
    
    buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
    buttonBack.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    buttonBack.titleLabel.textAlignment=NSTextAlignmentCenter;
    buttonBack.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
    [buttonBack setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Back"] forState:UIControlStateNormal];
    buttonBack.tag=203;
    [buttonBack addTarget:self action:@selector(ButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
    buttonBack.frame=CGRectMake(650, 740, 80, 40);
    [self.view addSubview:buttonBack];
    
    buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
    buttonSure.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    buttonBack.titleLabel.textAlignment=NSTextAlignmentCenter;
    buttonBack.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
    [buttonSure setTitle:@"确认支付" forState:UIControlStateNormal];
    buttonSure.tag=204;
    [buttonSure addTarget:self action:@selector(ButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
    buttonSure.frame=CGRectMake(550, 740, 80, 40);
    [self.view addSubview:buttonSure];

    UIControl *control=[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view sendSubviewToBack:control];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)controlClick
{
    [_tfJiXiao resignFirstResponder];
    [_tfYuXiao resignFirstResponder];
}

//键盘显示
-(void)keyboardWillShow
{
    [UIView animateWithDuration:0.18 animations:^{
        scroll.frame=CGRectMake(0, 0, 728, 220-100);
        _showCardView.frame=CGRectMake(20,480-60,728, 370);
        buttonBack.frame=CGRectMake(650, 640, 80, 40);
        buttonSure.frame=CGRectMake(550, 640, 80, 40);
        scroll.frame=CGRectMake(0, 0, 728, 190);
        _showCardView.frame=CGRectMake(20,350,728, 300);
        buttonBack.frame=CGRectMake(650, 640, 80, 40);
        buttonSure.frame=CGRectMake(550, 640, 80, 40);

        
    } completion:^(BOOL finished) {
        
    }];
}
//
////键盘隐藏
-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.18 animations:^{
        
        scroll.frame=CGRectMake(0, 0, 728, 220);
        _showCardView.frame=CGRectMake(20,480-60,728, 470);
        buttonBack.frame=CGRectMake(650, 740, 80, 40);
        buttonSure.frame=CGRectMake(550, 740, 80, 40);
        scroll.frame=CGRectMake(0, 0, 728, 290);
        _showCardView.frame=CGRectMake(20,350,728, 400);
        buttonBack.frame=CGRectMake(650, 740, 80, 40);
        buttonSure.frame=CGRectMake(550, 740, 80, 40);
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - 券按钮生成
-(void)addTicketButton
{
    for (int i=0; i<[_ticketArray count]; i++)
    {
        NSString *str=[NSString stringWithFormat:@"%@|%@|",[[_ticketArray objectAtIndex:i] objectForKey:@"counpName"],[[_ticketArray objectAtIndex:i] objectForKey:@"counpNum"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeView.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeViewSelect.png"] forState:UIControlStateHighlighted];
        button.titleLabel.font=[UIFont systemFontOfSize:20];
        [button setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(10+(i%4)*180,10+(i/4)*100, 170, 90);
        button.tag=i+100;
        [scroll addSubview:button];
    }
    
    int line;
    if([_ticketArray count]%4==0)
    {
        line =[_ticketArray count]/4;
    }
    else
    {
        line=[_ticketArray count]/4+1;
    }
    scroll.contentSize=CGSizeMake(728, line*100);
}
#pragma mark - 券使用
-(void)ButtonClick:(UIButton *)btn
{
    NSDictionary *ticket=[_ticketArray objectAtIndex:btn.tag-100];
    if ([[ticket objectForKey:@"counpNum"] intValue]>0) {
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        NSDictionary *info=[dp couponForTicket:ticket];
        if (!info) {
            [SVProgressHUD showErrorWithStatus:@"活动未定义"];
            return;
            
        }
        NSDictionary *dict=[dp activityUserCounp:info];
        if ([[dict objectForKey:@"Result"] boolValue]==YES) {
            [ticket setValue:[NSString stringWithFormat:@"%d",[[ticket objectForKey:@"counpNum"] intValue]-1] forKey:@"counpNum"];
            NSString *str=[NSString stringWithFormat:@"%@|%@|",[ticket objectForKey:@"counpName"],[ticket objectForKey:@"counpNum"]];
            [_userTicketArray addObject:ticket];
            
            [btn setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
            [self paymentViewQueryProduct];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
}
-(void)paymentViewQueryProduct
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp paymentViewQueryProduct];
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        _yingfuPrice=[[[dict objectForKey:@"Message"] objectForKey:@"paymentPrice"] floatValue];
        lblmoney.text=[NSString stringWithFormat:@"应付金额：%.2f元",_yingfuPrice];
    }
    
}

-(void)ButtonClick2:(UIButton *)btn
{
    //    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    if(201==btn.tag)
    {
        if(!([_tfJiXiao.text floatValue]>_yingfuPrice))
        {
            //        @"计算积分"
            if ([[cardInfo objectForKey:@"integralOverall"] doubleValue]>=_yingfuPrice-[_tfYuXiao.text doubleValue]) {
                _tfJiXiao.text=[NSString stringWithFormat:@"%.2f",_yingfuPrice-[_tfYuXiao.text doubleValue]];
                _tfJiKe.text=[NSString stringWithFormat:@"%.2f",[[cardInfo objectForKey:@"integralOverall"] doubleValue]-[_tfJiXiao.text doubleValue]];
            }
        }
        
    }
    else if(200==btn.tag)
    {
        if(!([_tfYuXiao.text floatValue]>_yingfuPrice))
        {
            if ([[cardInfo objectForKey:@"storedCardsBalance"] doubleValue]>=_yingfuPrice-[_tfYuXiao.text doubleValue]) {
                _tfYuXiao.text=[NSString stringWithFormat:@"%.2f",_yingfuPrice-[_tfJiXiao.text doubleValue]];
                _tfYuKe.text=[NSString stringWithFormat:@"%.2f",[[cardInfo objectForKey:@"storedCardsBalance"] doubleValue]-[_tfYuXiao.text doubleValue]];
            }
        }
        
    }
    else if(203==btn.tag)
    {
//        if(isJuanXiaofei)
//        {
//            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
//        }
//        else
//        {
//    
            NSArray *viewArray=  self.navigationController.viewControllers;
            [self.navigationController popToViewController:[viewArray objectAtIndex:[viewArray count]-3] animated:YES];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }
    else if (204==btn.tag)
    {
        if([_tfJiXiao.text doubleValue] +[_tfYuXiao.text doubleValue]<=_yingfuPrice)
        {
            [_passWordView removeFromSuperview];
            _passWordView =nil;
            _passWordView=[[AKsPassWordView alloc] initWithFrame:CGRectMake(0, 0, 493, 354)];
            _passWordView.delegate=self;
            [self.view addSubview:_passWordView];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"余额消费不足，请重新支付"];
        }
    }
    else
    {
        NSLog(@"%d",btn.tag);
    }
}

#pragma mark --AKsPassWordDelegate
-(void)PassWordCancle
{
    [_passWordView removeFromSuperview];
    _passWordView=nil;
}
#pragma mark - 支付
-(void)PassWordSure:(NSString *)passWord
{
    [_passWordView removeFromSuperview];
    _passWordView=nil;
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSString *str in _userTicketArray) {
        [array addObject:str];
    }
    NSDictionary *info=[[NSDictionary alloc] initWithObjectsAndKeys:[cardInfo objectForKey:@"cardNum"],@"cardNum",[NSString stringWithFormat:@"%.2f",[_tfYuXiao.text doubleValue]],@"cardStoredAmount",[NSString stringWithFormat:@"%.2f",[_tfJiXiao.text doubleValue]],@"cardIntegralAmount",@"0",@"cardCashAmount",passWord,@"cardPassword",[Singleton sharedSingleton].CheckNum,@"orderid",[Singleton sharedSingleton].Seat,@"tableNum",[NSString stringWithFormat:@"%.2f",_orderYmoney],@"orderYmoney",array,@"cardTicketInfoList", nil];
    BSDataProvider *bs=[[BSDataProvider alloc] init];
    NSDictionary *dict=[bs onelineCardOutAmt:info];
    if ([[dict objectForKey:@"return"] intValue]>0) {
        [self paymentViewQueryProduct];
        if (_yingfuPrice>0) {
            [SVProgressHUD showSuccessWithStatus:@"会员支付卡完成"];
            NSArray *viewArray=  self.navigationController.viewControllers;
            [self.navigationController popToViewController:[viewArray objectAtIndex:[viewArray count]-3] animated:YES];
        }else
        {
            NSDictionary *userPaymentInfo=[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"paymentID",@"",@"paymentCnt",@"",@"paymentMoney",@"1",@"payFinish",_tfJiKe.text,@"integralOverall",[cardInfo objectForKey:@"cardNum"],@"cardNumber", nil];
            NSDictionary *userPayment=[bs userPayment:userPaymentInfo];
            if ([[userPayment objectForKey:@"Result"] boolValue]==YES) {
                [SVProgressHUD showSuccessWithStatus:[userPayment objectForKey:@"Message"]];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[userPayment objectForKey:@"Message"]];
            }
            NSArray *viewArray=  self.navigationController.viewControllers;
            [self.navigationController popToViewController:[viewArray objectAtIndex:2] animated:YES];
        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"error"]];
    }
}





-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==1002)
    {
        [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:[self.navigationController.viewControllers count]-4] animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
    }
}


#pragma mark  AKMySegmentAndViewDelegate
-(void)showVipMessageView:(NSArray *)array andisShowVipMessage:(BOOL)isShowVipMessage
{
    if(isShowVipMessage)
    {
        [showVip removeFromSuperview];
        showVip=nil;
    }
    else
    {
        showVip=[[AKsIsVipShowView alloc]initWithArray:array];
        [self.view addSubview:showVip];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *str;
    if (![string isEqualToString:@""]) {
       str=[NSString stringWithFormat:@"%@%@",textField.text,string];
     }else
     {
           str=@"";
       }
    
        NSString *intergral,*stored;
        if (textField==_tfJiXiao) {
            intergral=str;
        }
        if (textField==_tfYuXiao) {
            stored=str;
        }
        if (textField==_tfJiXiao&&[str doubleValue]>[[cardInfo objectForKey:@"integralOverall"] doubleValue]) {
            [SVProgressHUD showErrorWithStatus:@"超过积分余额"];
            return NO;
        }
        if (textField==_tfYuXiao&&[str doubleValue]>[[cardInfo objectForKey:@"storedCardsBalance"] doubleValue]) {
            [SVProgressHUD showErrorWithStatus:@"超过储值余额"];
            return NO;
        }
    //  判断输入的是否为数字小数点和删除键，输入其他字符是不被允许的
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else if([string isEqualToString:@"."])
    {
        return YES;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
        {
            if (textField==_tfJiXiao) {
                _tfJiKe.text=[NSString stringWithFormat:@"%.2f",[[cardInfo objectForKey:@"integralOverall"] doubleValue]-[intergral doubleValue]];
            }
            if (textField==_tfYuXiao) {
                _tfYuKe.text=[NSString stringWithFormat:@"%.2f",[[cardInfo objectForKey:@"storedCardsBalance"] doubleValue]-[stored doubleValue]];
             }
            return YES;
        }
        else
            
            return NO;
    }
    
}

@end
