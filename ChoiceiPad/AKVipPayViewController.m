//
//  AKsVipPayViewController.m
//  BookSystem
//
//  Created by sundaoran on 13-12-5.
//
//

#import "AKVipPayViewController.h"
#import "CardJuanClass.h"
#import "AKDataQueryClass.h"
#import "AKsKvoPrice.h"
#import "AKMySegmentAndView.h"
#import "AKURLString.h"
#import "AKDataQueryClass.h"
#import "AKsUserPaymentClass.h"
#import "AKsIsVipShowView.h"
#import "AKsNetAccessClass.h"
#import "SVProgressHUD.h"
#import "CVLocalizationSetting.h"



@interface AKVipPayViewController ()

@end

@implementation AKVipPayViewController
{
    UILabel             *lblmoney;
    UITextField         *_tfYuXiao;
    UITextField         *_tfJiXiao;
    UILabel             *_tfYuKe;
    UILabel             *_tfJiKe;
    UIButton            *buttonBack;
    UIButton            *buttonSure;
    UIView              *_showCardView;
    NSMutableArray      *_dataButtonArray;
    NSArray             *_JuanMessageArray;
    float               _yingfuPrice;
    UIScrollView        *scroll;
    AKsKvoPrice         *_kvoPrice;
    AKsPassWordView     *_passWordView;
    AKsIsVipShowView    *showVip;
    NSMutableArray      *_useTicketArray;
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}



-(void)viewDidUnload
{
    [super viewDidUnload];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardFenPay object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardJuanPay object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardPayCancle object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardXianJinPay object:nil];
}

static int count;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AKMySegmentAndView *akv=[[AKMySegmentAndView alloc]init];
    akv.frame=CGRectMake(0, 0, 768, 44);
    [[akv.subviews objectAtIndex:1]removeFromSuperview];
    akv.frame=CGRectMake(0, 0, 768, 114-60);
    [self.view addSubview:akv];
    
    count=1;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1];

    AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
    _useTicketArray=[[NSMutableArray alloc] init];
    
    _yingfuPrice=[netAccess.yingfuMoney floatValue];
    lblmoney=[[UILabel alloc]initWithFrame:CGRectMake(17,174-60-30, 250, 50)];
    lblmoney.textAlignment=NSTextAlignmentCenter;
    lblmoney.text=[NSString stringWithFormat:@"应付金额：%@元",netAccess.yingfuMoney];
    lblmoney.backgroundColor=[UIColor clearColor];
    lblmoney.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:lblmoney];
    NSArray *array=[[NSArray alloc] initWithObjects:@"储值余额:",@"余额消费:",@"积分余额:",@"积分消费:", nil];
    for (int i=0; i<4; i++) {
        UILabel *lb=[[UILabel alloc] init];;
        lb.frame=CGRectMake(20+i%2*380, 154+i/2*70, 110, 50);
        lb.textAlignment=NSTextAlignmentRight;
        lb.text=[array objectAtIndex:i];
        
        lb.layer.cornerRadius=5;
        lb.backgroundColor=[UIColor clearColor];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self.view addSubview:lb];
    }
    _tfYuKe=[[UILabel alloc]init];
    _tfJiKe=[[UILabel alloc]init];
    _tfYuXiao=[[UITextField alloc]init];
    _tfJiXiao=[[UITextField alloc]init];
    NSArray *arrayView=[[NSArray alloc] initWithObjects:_tfYuKe,_tfYuXiao,_tfJiKe,_tfJiXiao, nil];
    for (int i=0; i<4; i++) {
        if (i%2==0) {
            UILabel *label=[arrayView objectAtIndex:i];
            label.textAlignment=NSTextAlignmentRight;
            label.frame=CGRectMake(130+i%2*380, 154+i/2*70, 240, 50);
            if (i==0) {
                label.text=[NSString stringWithFormat:@"%@",netAccess.ChuZhiKeYongMoney];
            }else if (i==2)
            {
                label.text=[NSString stringWithFormat:@"%@",netAccess.JiFenKeYongMoney];
            }
            label.layer.cornerRadius=5;
            label.backgroundColor=[UIColor whiteColor];
            label.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [self.view addSubview:label];
        }else
        {
            UITextField *field=[arrayView objectAtIndex:i];
            field.frame=CGRectMake(130+i%2*380, 154+i/2*70, 240, 50);
            field.borderStyle=UITextBorderStyleRoundedRect;
            field.backgroundColor=[UIColor whiteColor];
            field.clearButtonMode=UITextFieldViewModeAlways;
            field.text=[NSString stringWithFormat:@"%.2f",0.00];
            field.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            field.delegate=self;
            field.clearsOnBeginEditing=YES;
            field.keyboardType=UIKeyboardTypeNumberPad;
            [self.view addSubview:field];
        }
        
    }
    _JuanMessageArray=netAccess.ticketArray;
//    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,260+170-60, 768,40)];
//    title.frame=CGRectMake(0, 300, 768, 40);
//    title.textAlignment=NSTextAlignmentCenter;
//    title.text=@"优惠劵";
//    title.layer.cornerRadius=5;
//    title.backgroundColor=[UIColor clearColor];
//    title.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
//    [self.view addSubview:title];
    
    scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 728, 220)];
    scroll.frame=CGRectMake(0, 0, 728, 290);
    scroll.backgroundColor=[UIColor colorWithRed:254/255.0f green:254/255.0f blue:254/255.0f alpha:1];
    
    
    _showCardView=[[UIView alloc]initWithFrame:CGRectMake(20,480-60,728, 370)];
    _showCardView.frame=CGRectMake(20, 350, 728, 440);
    _showCardView.backgroundColor=[UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1];
    
    [self.view addSubview:_showCardView];
    
    [_showCardView addSubview:scroll];
    
    _dataButtonArray=[[NSMutableArray alloc]init];
    
    [self addJuanButton];
    
    //    NSArray *array2=[[NSArray alloc]initWithObjects:@"计算余额",@"计算积分",@"计算现金", nil];
    NSArray *array2=[[NSArray alloc]initWithObjects:@"计算余额",@"计算积分", nil];
    for (int i=0; i<[array2 count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonBlue.png"] forState:UIControlStateHighlighted];
        button.titleLabel.font=[UIFont systemFontOfSize:20];
        button.titleLabel.textAlignment=UITextAlignmentCenter;
        button.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        [button setTitle:[NSString stringWithFormat:@"%@",[array2 objectAtIndex:i]] forState:UIControlStateNormal];
        button.tag=200+i;
        [button addTarget:self action:@selector(ButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(10+i%3*160,i/3*75+300, 140, 65);
        [_showCardView addSubview:button];
    }
    
    buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [buttonBack setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
    buttonBack.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    buttonBack.titleLabel.textAlignment=UITextAlignmentCenter;
    buttonBack.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    [buttonBack setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Back"] forState:UIControlStateNormal];
    buttonBack.tag=203;
    [buttonBack addTarget:self action:@selector(ButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
    buttonBack.frame=CGRectMake(650, 740, 80, 40);
    [self.view addSubview:buttonBack];
    
    buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
    buttonSure.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    buttonSure.titleLabel.textAlignment=UITextAlignmentCenter;
    buttonSure.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    [buttonSure setTitle:@"确认支付" forState:UIControlStateNormal];
    buttonSure.tag=204;
    [buttonSure addTarget:self action:@selector(ButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
    buttonSure.frame=CGRectMake(550, 740, 80, 40);
    [self.view addSubview:buttonSure];
//    _xiaofeiArray=[[NSMutableArray alloc]init];
//    _FenXiaoFeiArray=[[NSMutableArray alloc]init];
//    _youhuiHuChiArray=[[NSMutableArray alloc]init];
    
    _kvoPrice=[[AKsKvoPrice alloc]init];
    
    [_kvoPrice setValue:[NSString stringWithFormat:@"%.2f",_yingfuPrice] forKey:@"price"];
    [_kvoPrice addObserver:self forKeyPath:@"price" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    netAccess.xiaofeiliuShui=@"";
//    fapiaoPrice=0;
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
        scroll.frame=CGRectMake(0, 0, 728, 190);
        _showCardView.frame=CGRectMake(20,350,728, 200);
        buttonBack.frame=CGRectMake(650, 640, 80, 40);
        buttonSure.frame=CGRectMake(550, 640, 80, 40);
//        for(UIButton *button in [_showCardView subviews])
//        {
//            button.frame=CGRectMake(button.frame.origin.x, button.frame.origin.y-100, button.frame.size.width, button.frame.size.height);
//        }
        
    } completion:^(BOOL finished) {
        
    }];
}

//键盘隐藏
-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.18 animations:^{
        
        scroll.frame=CGRectMake(0, 0, 728, 290);
        _showCardView.frame=CGRectMake(20,350,728, 300);
        buttonBack.frame=CGRectMake(650, 740, 80, 40);
        buttonSure.frame=CGRectMake(550, 740, 80, 40);
//        for(UIButton *button in [_showCardView subviews])
//        {
//            button.frame=CGRectMake(button.frame.origin.x, button.frame.origin.y+100, button.frame.size.width, button.frame.size.height);
//        }
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(_yingfuPrice<0)
    {
//        [AKsNetAccessClass sharedNetAccess].zhaolingPrice=[NSString stringWithFormat:@"%.2f",0-_yingfuPrice+chuzhixiaofei];
        lblmoney.text=[NSString stringWithFormat:@"应付金额：%.2f元",0.0];
    }
    else
    {
        lblmoney.text=[NSString stringWithFormat:@"应付金额：%.2f元",_yingfuPrice];
    }
    
    if([keyPath isEqualToString:@"price"])
    {
        if([[change valueForKey:@"new"]floatValue]<=0)
        {
        }
    }
}


//支付拼接
-(NSMutableArray *)userPaymenypinjie:(NSMutableArray *)array
{
    NSMutableArray *MuatbleArray;
    if([array count])
    {
        AKsUserPaymentClass *userPay=((AKsUserPaymentClass *)[array objectAtIndex:0]);
        NSString *userCount=userPay.userpaymentCount;
        NSString *userMoney=userPay.userpaymentMoney;
        NSString *userTag=userPay.userpaymentTag;
        NSString *userName=userPay.userpaymentName;
        NSString *payFinish=@"0";
        for(int i=1;i<[array count];i++)
        {
            AKsUserPaymentClass *userPayValues=((AKsUserPaymentClass *)[array objectAtIndex:i]);
            userCount=[userCount stringByAppendingString:[NSString stringWithFormat:@"!%@",userPayValues.userpaymentCount]];
            userMoney=[userMoney stringByAppendingString:[NSString stringWithFormat:@"!%@",userPayValues.userpaymentMoney]];
            userName=[userName stringByAppendingString:[NSString stringWithFormat:@"!%@",userPayValues.userpaymentName]];
            userTag=[userTag stringByAppendingString:[NSString stringWithFormat:@"!%@",userPayValues.userpaymentTag]];
            payFinish=[payFinish stringByAppendingString:@"!0"];
        }
        MuatbleArray=[[NSMutableArray alloc]initWithObjects:userCount,userMoney,userName,userTag,payFinish, nil];
    }
    else
    {
        MuatbleArray=[[NSMutableArray alloc]init];
    }
    
    return MuatbleArray;
}
/**
 *  券
 */
-(void)addJuanButton
{
    
    for (int i=0; i<[_JuanMessageArray count]; i++)
    {
        NSString *str=[NSString stringWithFormat:@"%@",[[_JuanMessageArray objectAtIndex:i] objectForKey:@"name"]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
        button.titleLabel.font=[UIFont systemFontOfSize:20];
        button.titleLabel.textAlignment=UITextAlignmentCenter;
        button.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
        [button setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
//        button.tag=[((CardJuanClass *)[_JuanMessageArray objectAtIndex:i]).JuanId intValue];
        button.tag=i;
        [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(10+(i%4)*180,10+(i/4)*100, 170, 90);
        [scroll addSubview:button];
        [_dataButtonArray addObject:button];
    }
    
    int line;
    if([_JuanMessageArray count]%4==0)
    {
        line =[_JuanMessageArray count]/4;
    }
    else
    {
        line=[_JuanMessageArray count]/4+1;
    }
    scroll.contentSize=CGSizeMake(728, line*100);
}

-(void)ButtonClick:(UIButton *)btn
{
    [_tfJiXiao resignFirstResponder];
    [_tfYuXiao resignFirstResponder];
//    int  index=0;
    for (UIButton *button in _dataButtonArray)
    {
        if (button.tag==btn.tag&&!button.selected) {
            button.selected=YES;
            [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
            [_useTicketArray addObject:[_JuanMessageArray objectAtIndex:btn.tag]];
            break;
        }else if(button.tag==btn.tag&&button.selected)
        {
            button.selected=NO;
            [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
//            [_useTicketArray addObject:[_JuanMessageArray objectAtIndex:btn.tag]];
            [_useTicketArray removeObject:[_JuanMessageArray objectAtIndex:btn.tag]];
            break;
        }
        
    }
}






-(void)ButtonClick2:(UIButton *)btn
{
    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    
    
    if(200==btn.tag)
    {
        if([_tfJiXiao.text floatValue]<=_yingfuPrice)
        {
            //        @"计算余额"
            _tfYuXiao.text=[NSString stringWithFormat:@"%.2f",_yingfuPrice-[_tfJiXiao.text doubleValue]];
            
            _tfYuKe.text=[NSString stringWithFormat:@"%.2f",[netAccess.ChuZhiKeYongMoney doubleValue]-[_tfYuXiao.text doubleValue]];
            _tfJiKe.text=[NSString stringWithFormat:@"%.2f",[netAccess.JiFenKeYongMoney doubleValue]-[_tfJiXiao.text doubleValue]];
        }
    }
    else if(201==btn.tag)
    {
        if([_tfYuXiao.text floatValue]<=_yingfuPrice)
        {
            //        @"计算积分"
            _tfJiXiao.text=[NSString stringWithFormat:@"%.2f",_yingfuPrice-[_tfYuXiao.text doubleValue]];
            _tfYuKe.text=[NSString stringWithFormat:@"%.2f",[netAccess.ChuZhiKeYongMoney doubleValue]-[_tfYuXiao.text doubleValue]];
            _tfJiKe.text=[NSString stringWithFormat:@"%.2f",[netAccess.JiFenKeYongMoney doubleValue]-[_tfJiXiao.text doubleValue]];
        }
        
    }
    else if(203==btn.tag)
    {
            [self.navigationController popViewControllerAnimated:YES];
    }
    else if (204==btn.tag)
    {
        if((([_tfJiXiao.text doubleValue]+[_tfYuXiao.text doubleValue])<=_yingfuPrice) && ([_tfYuXiao.text doubleValue]<=[netAccess.ChuZhiKeYongMoney doubleValue]) && ([_tfJiXiao.text doubleValue]<=[netAccess.JiFenKeYongMoney doubleValue]))
        {
            _passWordView=nil;
            _passWordView=[[AKsPassWordView alloc]initWithFrame:CGRectMake(0, 0, 493, 354)];
            _passWordView.delegate=self;
            [self.view addSubview:_passWordView];
            
        }
        else
        {
            NSString *title;
            if(([_tfJiXiao.text floatValue]+[_tfYuXiao.text floatValue])>_yingfuPrice)
            {
                title=@"支付金额与应付金额不同，请重新支付";
            }
            else if([_tfYuXiao.text floatValue]>[netAccess.ChuZhiKeYongMoney floatValue])
            {
                title=@"余额消费不足，请重新支付";
            }
            else if([_tfJiXiao.text floatValue]>[netAccess.JiFenKeYongMoney floatValue])
            {
                title=@"积分消费不足，请重新支付";
            }
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    else
    {
        NSLog(@"%d",btn.tag);
    if([_tfJiKe.text floatValue]<0.0)
    {
        _tfJiXiao.text=[NSString stringWithFormat:@"%.2f",[_tfJiXiao.text floatValue]+[_tfJiKe.text floatValue]];
        _tfJiKe.text=[NSString stringWithFormat:@"%.2f",0.0];
        
    }
    if([_tfYuKe.text floatValue]<0.0)
    {
        _tfYuXiao.text=[NSString stringWithFormat:@"%.2f",[_tfYuXiao.text floatValue]+[_tfYuKe.text floatValue]];
        _tfYuKe.text=[NSString stringWithFormat:@"%.2f",0.0];
    }
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
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
            
            return YES;
        
        else
            
            return NO;
    }
    
}

@end
