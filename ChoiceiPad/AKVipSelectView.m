//会员卡查询
//  AKsVipCardQueryView.m
//  BookSystem
//
//  Created by sundaoran on 13-12-4.
//
//

#import "AKVipSelectView.h"
#import "CardJuanClass.h"
#import "PaymentSelect.h"
#import "AKDataQueryClass.h"
#import "Singleton.h"
#import "SVProgressHUD.h"
#import "AKURLString.h"
#import "CVLocalizationSetting.h"
#import "AKsNetAccessClass.h"

@implementation AKVipSelectView
{
    UITextField                     *_phoneNum;  //手机号输入框
    UITextField                     *_cardNum;   //会员卡号
    UILabel                         *lblCardYuShow;
    UILabel                         *lblCardJiShow;
    UILabel                         *lblCardJuanShow;
    UILabel                         *lblMessage;
    UIButton                        *_orderButton;
    UITableView                     *_tableView;
    BOOL                            ischange;
    NSMutableArray                  *_orderArray;
    NSMutableArray                  *_dataJuanArray;
    UIScrollView                    *_scroll;
    UIButton                        *buttonCancle;
    UIButton                        *buttonSure;

}
@synthesize delegate=_delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatView];
    }
    return self;
}

-(void)creatView
{
    AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
    UILabel *lblmoney=[[UILabel alloc]initWithFrame:CGRectMake(17,104-30, 250, 50)];
    lblmoney.textAlignment=NSTextAlignmentCenter;
    lblmoney.text=[NSString stringWithFormat:@"应付金额：%@元",netAccess.yingfuMoney];
    lblmoney.backgroundColor=[UIColor clearColor];
    lblmoney.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    if(!(netAccess.yingfuMoney==NULL))
    {
        [self addSubview:lblmoney];
    }
    NSArray *array=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"],@"会员卡号:",@"储值卡余额:",@"积分余额:", nil];
    for (int i=0;i<4;i++) {
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(20+i%2*380, 154+i/2*70, 110, 50)];
        lable.textAlignment=NSTextAlignmentLeft;
        lable.text=[array objectAtIndex:i];
        lable.backgroundColor=[UIColor clearColor];
        lable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self addSubview:lable];
    }
//    234+150
    
    _phoneNum=[[UITextField alloc] init];
    _cardNum=[[UITextField alloc] init];
//    lblCardJuanShow=[[UILabel alloc] init];
    lblCardYuShow=[[UILabel alloc] init];
    lblCardJiShow=[[UILabel alloc] init];
    NSArray *arrayShow=[[NSArray alloc] initWithObjects:_phoneNum,_cardNum,lblCardYuShow,lblCardJiShow, nil];
    //手机号输入框
    for (int i=0; i<4; i++) {
        if (i<2) {
            UITextField *textField=[arrayShow objectAtIndex:i];
            textField.frame=CGRectMake(130+i%2*380, 154+i/2*70, 240, 50);
            textField.borderStyle=UITextBorderStyleRoundedRect;
            textField.backgroundColor=[UIColor whiteColor];
            textField.clearButtonMode=UITextFieldViewModeAlways;
            if (i==0) {
                textField.placeholder=@"请输入手机号";
            }else
            {
                textField.placeholder=@"请输入会员卡号";
            }
            
            textField.delegate=self;
            textField.keyboardType=UIKeyboardTypeNumberPad;
            textField.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [self addSubview:textField];
        }else
        {
            UILabel *lb=[arrayShow objectAtIndex:i];
            lb.frame=CGRectMake(130+i%2*380, 154+i/2*70, 240, 50);
            lb.textAlignment=NSTextAlignmentRight;
            lb.text=@"";
            lb.layer.cornerRadius=5;
            lb.backgroundColor=[UIColor whiteColor];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [self addSubview:lb];
        }
    }
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0,260+100, 768,40)];
    title.textAlignment=NSTextAlignmentCenter;
    title.text=@"劵信息列表";
    title.layer.cornerRadius=5;
    title.backgroundColor=[UIColor clearColor];
    title.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self addSubview:title];
    
    lblMessage=[[UILabel alloc]initWithFrame:CGRectMake(20,310+100,728, 300)];
    lblMessage.textAlignment=NSTextAlignmentCenter;
    lblMessage.text=@"请输入正确的手机号码后点击确定按钮并等待通讯结束......";
    lblMessage.lineBreakMode=NSLineBreakByCharWrapping;
    lblMessage.numberOfLines=3;
    lblMessage.backgroundColor=[UIColor whiteColor];
    lblMessage.textColor=[UIColor greenColor];
    lblMessage.font=[UIFont systemFontOfSize:40];
    [self addSubview:lblMessage];
    
    _scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(20,410, 728, 240)];
    _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_orderButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    [_orderButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cardNumDown.png"] forState:UIControlStateNormal];
    _orderButton.frame=CGRectMake(20, 710-60, 728, 60);
    _orderButton.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:40];
    _orderButton.tintColor=[UIColor blackColor];
    _orderButton.titleLabel.textAlignment=UITextAlignmentLeft;
    [_orderButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(20,610+100, 728, 180) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    ischange=YES;
    NSArray *arry=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"],[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"], nil];
    buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    NSArray *arryButton=[[NSArray alloc] initWithObjects:buttonSure,buttonCancle, nil];
    for (int i=0; i<2; i++) {
        UIButton *btn=[arryButton objectAtIndex:i];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
        [btn setTitle:[arry objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        if (i==0) {
            btn.tag=2000;
        }else
        {
            btn.tag=1000;
        }
        [btn addTarget:self action:@selector(ButtonQuery:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(550+100*i, 740,80,40);
        [self addSubview:btn];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    NSArray *numValues;
        if(netAccess.showVipMessageDict)
        {
            numValues =[[NSArray alloc]initWithObjects:netAccess.showVipMessageDict, nil];
        }
    if([numValues count]==1)
    {
        NSDictionary *dict=[numValues objectAtIndex:0];
        
        _phoneNum.text=[dict objectForKey:@"phoneNum"];
        //        _cardNum.text=[dict objectForKey:@"cardNum"];
    }
    else
    {
        _phoneNum.text=netAccess.phoneNum;
    }
}



//键盘显示
-(void)keyboardWillShow
{
    [UIView animateWithDuration:0.18 animations:^{
        lblMessage.frame=CGRectMake(20,310+100, 728, 300-80);
        _orderButton.frame=CGRectMake(20, 710-60-80, 728, 60);
        buttonSure.frame=CGRectMake(550, 740-80,80,40);
        buttonCancle.frame=CGRectMake(650, 740-80, 80,40);
        _tableView.frame=CGRectMake(20,610+100-80, 728, 180);
    } completion:^(BOOL finished) {
        
    }];
}

//键盘隐藏
-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.18 animations:^{
        lblMessage.frame=CGRectMake(20,310+100,728, 300);
        _orderButton.frame=CGRectMake(20, 710-60, 728, 60);
        buttonSure.frame=CGRectMake(550, 740, 80,40);
        buttonCancle.frame=CGRectMake(650, 740,80,40);
        _tableView.frame=CGRectMake(20,610+100, 728, 180);
    } completion:^(BOOL finished) {
        
    }];
    
}

//-(void)ControlClick
//{
//  [_phoneNum resignFirstResponder];
//}

-(void)ButtonQuery:(UIButton *)btn
{
    if (1000==btn.tag) {
        [_delegate AKVipSelectViewButtonClick:btn.tag];
    }else if (1001==btn.tag){
        for (UIView *view in [_scroll subviews]) {
            [view removeFromSuperview];
        }
        [_scroll removeFromSuperview];
        [_orderButton removeFromSuperview];
        [_tableView removeFromSuperview];
        lblMessage.text=@"请输入正确的手机号码后点击确定按钮并等待通讯结束......";
        lblCardJiShow.text=@"";
        lblCardJuanShow.text=@"";
        lblCardYuShow.text=@"";
        _cardNum.text=@"";
        _phoneNum.text=@"";
        _dataJuanArray=nil;
        [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
        buttonSure.tag=2000;
        
    }
    else if (2000==btn.tag){
        if ([_phoneNum.text length]>0) {
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [self WebreadCardByPhoneNo];
        }
    }else if (2001==btn.tag){
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [self WebreadCardByCardNo_pad];
    }else if(2002==btn.tag){
        [_delegate AKVipSelectViewButtonClick:btn.tag];
    }
}
/**
 *  根据手机号查询卡号
 */
-(void)WebreadCardByPhoneNo
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:_phoneNum.text,@"phoneNum", nil];
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebreadCardByPhoneNo:dic];
    [SVProgressHUD dismiss];
    if (dict) {
        NSArray *values=[[[[dict objectForKey:@"root"] lastObject] objectForKey:@"value"] componentsSeparatedByString:@"@"];
        if ([[[values lastObject] componentsSeparatedByString:@"-"] count]==2) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"查询失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        _orderArray=[NSMutableArray arrayWithArray:values];
        [_orderButton setTitle:[NSString stringWithFormat:@"%@",[_orderArray objectAtIndex:0]] forState:UIControlStateNormal];
        _cardNum.text=[NSString stringWithFormat:@"%@",[_orderArray objectAtIndex:0]];
        AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
        netAccess.VipCardNum= _cardNum.text;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refushVipMessage" object:nil];
        [self addSubview:_orderButton];
        [_cardNum resignFirstResponder];
        [buttonSure setTitle:@"查询" forState:UIControlStateNormal];
        buttonSure.tag=2001;
        buttonCancle.tag=1001;
        [self addSubview:buttonSure];
        lblMessage.text=@"输入手机卡号会有多张会员卡，请选择使用卡号，输入密码，并点击查询继续↓......↓";
        [_tableView reloadData];
        
    }
}
/**
 *  根据卡号查询卡信息
 */
-(void)WebreadCardByCardNo_pad
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:[AKsNetAccessClass sharedNetAccess].VipCardNum,@"cardNum", nil];
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebreadCardByCardNo_pad:dic];
    [SVProgressHUD dismiss];
    if (dict) {
        NSArray *values=[[[[dict objectForKey:@"root"] lastObject] objectForKey:@"value"] componentsSeparatedByString:@"@"];
        if ([[[values lastObject] componentsSeparatedByString:@"-"] count]==2) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"查询失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        /**
         *  积分
         */
        lblCardJiShow.text=[values objectAtIndex:8];
        [AKsNetAccessClass sharedNetAccess].JiFenKeYongMoney=[values objectAtIndex:8];
        /**
         *  卡金额
         */
        lblCardYuShow.text=[values objectAtIndex:7];
        [AKsNetAccessClass sharedNetAccess].ChuZhiKeYongMoney=[values objectAtIndex:7];
        
        NSArray *array=[[values lastObject] componentsSeparatedByString:@"#"];
        /**
         *  券
         */
        if ([array count]>2) {
            _dataJuanArray=[NSMutableArray array];
            [self addSubview:_scroll];
            for (NSString *strMess in array) {
                NSArray *ary=[strMess componentsSeparatedByString:@","];
                NSDictionary *dicMess=[[NSDictionary alloc] initWithObjectsAndKeys:[ary objectAtIndex:0],@"ID",[ary objectAtIndex:2],@"name",[ary objectAtIndex:3],@"price", nil];
                [_dataJuanArray addObject:dicMess];
            }
            [AKsNetAccessClass sharedNetAccess].ticketArray=_dataJuanArray;
            /**
             *  生成券按钮
             */
        
            for (int i=0; i<[_dataJuanArray count]; i++)
            {
                
                NSString *str=[NSString stringWithFormat:@"%@",[[_dataJuanArray objectAtIndex:i] objectForKey:@"name"]];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonSeal.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
                button.titleLabel.font=[UIFont systemFontOfSize:20];
                button.titleLabel.textAlignment=UITextAlignmentCenter;
                button.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
                [button setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
                //            button.tag=[((CardJuanClass *)[_JuanMessageArray objectAtIndex:i]).JuanId intValue];
//                [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.frame=CGRectMake(10+(i%4)*180,10+(i/4)*100, 170, 90);
                [_scroll addSubview:button];
                //            [_dataButtonArray addObject:button];
            }
            
            int line;
            if([_dataJuanArray count]%4==0)
            {
                line =[_dataJuanArray count]/4;
            }
            else
            {
                line=[_dataJuanArray count]/4+1;
            }
            lblMessage.text=@"";
//            _scroll.backgroundColor=[UIColor redColor];
            _scroll.contentSize=CGSizeMake(728, line*100);
        }else
        {
            lblMessage.text=@"该会员卡暂无券可显示";
        }
        [buttonSure setTitle:@"支付" forState:UIControlStateNormal];
        buttonSure.tag=2002;
        buttonCancle.tag=1001;
        [_orderButton removeFromSuperview];
        [_tableView removeFromSuperview];
    }
}

/**
 *  下拉按钮事件
 *
 *  @param btn
 */
-(void)ButtonClick:(UIButton *)btn
{
    if(ischange)
    {
        [_cardNum resignFirstResponder];
        [_phoneNum resignFirstResponder];
        [self addSubview:_tableView];
        [_orderButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cardNumRight.png"] forState:UIControlStateNormal];
        ischange=NO;
        [UIView animateWithDuration:0.13 animations:^{
            buttonSure.frame=CGRectMake(550, 740+180, 80,40);
            buttonCancle.frame=CGRectMake(650, 740+180,80,40);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [_orderButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cardNumDown.png"] forState:UIControlStateNormal];
        [_tableView removeFromSuperview];
        ischange =YES;
        [UIView animateWithDuration:0.13 animations:^{
            buttonSure.frame=CGRectMake(550, 740, 80, 40);
            buttonCancle.frame=CGRectMake(650, 740, 80, 40);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


-(void)showAlter:(NSString *)string
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                        message:@"\n"
                                                       delegate:nil
                                              cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                              otherButtonTitles:nil];
        [alert show];
        
    });
    
}




#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [_orderArray count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellName=@"cell";
        UITableViewCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        cell.textLabel.text=[_orderArray objectAtIndex:indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView)
    {
        [_orderButton setTitle:[NSString stringWithFormat:@"%@",[_orderArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        [_tableView removeFromSuperview];
        ischange=YES;
        _cardNum.text=_orderButton.titleLabel.text;
        AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
        netAccess.VipCardNum=_orderButton.titleLabel.text;
        [_orderButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cardNumDown.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.13 animations:^{
            buttonSure.frame=CGRectMake(550, 740,80, 40);
//            buttonQuery.frame=CGRectMake(550, 740,80, 40);
//            buttonPay.frame=CGRectMake(550, 740, 80, 40);
//            buttonDianCai.frame=CGRectMake(550, 740, 80, 40);
            buttonCancle.frame=CGRectMake(650, 740,80, 40);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    if([string isEqualToString:@""])
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
