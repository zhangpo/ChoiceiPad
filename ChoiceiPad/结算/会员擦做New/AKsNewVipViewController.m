//
//  AKsNewVipViewController.m
//  BookSystem
//
//  Created by sundaoran on 14-3-5.
//
//

#import "AKsNewVipViewController.h"
#import "AKsNewVipPayViewController.h"
#import "AKDataQueryClass.h"
#import "AKsNewVipMessageShowCell.h"
#import "AKsIsVipShowView.h"
#import "SVProgressHUD.h"
#import "AKURLString.h"
#import "CVLocalizationSetting.h"

@interface AKsNewVipViewController ()

@end

@implementation AKsNewVipViewController
{
    AKMySegmentAndView      *akv;
    AKsNewVipMessageShowView *_showMessage;
    NSArray                   *cardArray;
    NSMutableDictionary       *cardInfo;
    NSString                  *cardNum;
//    AKsIsVipShowView        *showVip;
//    UILabel                 *_phoneNum;
//    UILabel                 *_userName;
//    UILabel                 *_userSex;
//    UILabel                 *_userAge;
//    UILabel                 *_useridentifiy;
//    UILabel                 *_userEmail;
    UITextField             *_userNameShow;
//    
    UITextField             *_phoneNumShow;
//
//    UIButton                *buttonCancle;
//    UIButton                *buttonSure;
//    
//    NSMutableArray          *_orderArray;
//    NSMutableArray          *_dataJuanArray;
    UITableView             *_tableView;
//    UITableView             *_tableViewCard;
//    NSMutableDictionary     *_vipDict;
//    NSString                *isChaxun;
//    BOOL                    queryCard;
//    BOOL                    queryCardSuccess;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view becomeFirstResponder];

    akv=[AKMySegmentAndView shared];
    akv.delegate=self;
    [akv segmentShow:NO];
    [akv shoildCheckShow:NO];
    [self.view addSubview:akv];
    if ([Singleton sharedSingleton].SELEVIP) {
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(450, 0, 250,44)];
        lb.text=[NSString stringWithFormat:@"%@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self.view addSubview:lb];
    }
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1];
    
    [self greatView];
    

}

-(void)greatView
{
    
//    queryCardSuccess=NO;
//    queryCard=NO;
    AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
    netAccess.VipCardNum=@"";
    UILabel *lblmoney=[[UILabel alloc]initWithFrame:CGRectMake(17,104-50, 250, 50)];
    lblmoney.textAlignment=NSTextAlignmentCenter;
    lblmoney.text=[NSString stringWithFormat:@"应付金额：%@元",netAccess.yingfuMoney];
    lblmoney.backgroundColor=[UIColor clearColor];
    lblmoney.font=[UIFont systemFontOfSize:20];
    if(!(netAccess.yingfuMoney==NULL))
    {
        [self.view addSubview:lblmoney];
    }

    UILabel *_phoneNum=[[UILabel alloc]initWithFrame:CGRectMake(20,54+50, 130, 50)];
    _phoneNum.textAlignment=NSTextAlignmentLeft;
    _phoneNum.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"];
    _phoneNum.backgroundColor=[UIColor clearColor];
    _phoneNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:_phoneNum];
    _phoneNumShow=[[UITextField alloc]initWithFrame:CGRectMake(120, 54+50, 260, 50)];
    _phoneNumShow.borderStyle=UITextBorderStyleRoundedRect;
    _phoneNumShow.backgroundColor=[UIColor whiteColor];
    _phoneNumShow.clearButtonMode=UITextFieldViewModeAlways;
    _phoneNumShow.placeholder=@"请输入手机号";
    _phoneNumShow.delegate=self;
    _phoneNumShow.keyboardType=UIKeyboardTypeNumberPad;
    _phoneNumShow.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [_phoneNumShow becomeFirstResponder];
    [self.view addSubview:_phoneNumShow];
    UILabel * _userName=[[UILabel alloc]initWithFrame:CGRectMake(400,54+50, 130, 50)];
    _userName.textAlignment=NSTextAlignmentLeft;
    _userName.text=@"会员卡号";
    _userName.backgroundColor=[UIColor clearColor];
    _userName.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:_userName];
    _userNameShow=[[UITextField alloc]initWithFrame:CGRectMake(520,54+50, 230, 50)];
    _userNameShow.textAlignment=NSTextAlignmentLeft;
    _userNameShow.text=@"";
    _userNameShow.layer.cornerRadius=5;
    _userNameShow.backgroundColor=[UIColor whiteColor];
    _userNameShow.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    _userNameShow.clearButtonMode=UITextFieldViewModeAlways;
    _userNameShow.placeholder=@"请输入卡号";
    [self.view addSubview:_userNameShow];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(16, 196, 736, 460)];
    view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view];
    UILabel * _lblMessage=[[UILabel alloc]initWithFrame:CGRectMake(20,200,728, 450)];
    _lblMessage.textAlignment=NSTextAlignmentCenter;
    _lblMessage.text=@"请输入正确的手机号码或会员卡号后点击确定按钮并等待通讯结束......";
    _lblMessage.lineBreakMode=NSLineBreakByCharWrapping;
    _lblMessage.numberOfLines=3;
    _lblMessage.backgroundColor=[UIColor whiteColor];
    _lblMessage.textColor=[UIColor greenColor];
    _lblMessage.font=[UIFont systemFontOfSize:40];
    [self.view addSubview:_lblMessage];
    
    
    UIButton *buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancle setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [buttonCancle setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
    [buttonCancle setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Back"] forState:UIControlStateNormal];
    buttonCancle.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    buttonCancle.tag=2001;
    [buttonCancle addTarget:self action:@selector(ButtonQuery:) forControlEvents:UIControlEventTouchUpInside];
    buttonCancle.frame=CGRectMake(650, 740-50,80,40);
    [self.view addSubview:buttonCancle];
    
    UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonYellow.png"] forState:UIControlStateHighlighted];
    [buttonSure setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
    buttonSure.tag=2002;
    buttonSure.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [buttonSure addTarget:self action:@selector(ButtonQuery:) forControlEvents:UIControlEventTouchUpInside];
    buttonSure.frame=CGRectMake(550, 740-50,80,40);
    [self.view addSubview:buttonSure];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(10,50,728-20, 450-60) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
//    _vipDict=[[NSMutableDictionary alloc]init];
    _showMessage=[[AKsNewVipMessageShowView alloc]initWithFrame:CGRectMake(20,200,728, 450)];
    _showMessage.delegate=self;
    [self.view addSubview:_showMessage];
    [_showMessage addSubview:_tableView];
}

-(void)segmentButtonClick:(int)buttonTag
{
    if (buttonTag==1000) {
        _tableView.tag=900;
        [_tableView reloadData];
        if ([cardArray count]>0) {
            NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
            [_tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionTop];
            cardNum=[[cardArray objectAtIndex:0] objectForKey:@"cardNo"];
            _userNameShow.text=cardNum;
        }
        [self changeTableViewHeader:900];
        if ([self.view viewWithTag:2003]) {
            UIButton *button=(UIButton *)[self.view viewWithTag:2003];
            if ([cardArray count]>0) {
                button.tag=2004;
                [button setTitle:@"重置" forState:UIControlStateNormal];
            }else
            {
                button.tag=2002;
                [button setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
            }
        }
    }else if (buttonTag==1001||buttonTag==1002){
        if (cardNum) {
            _userNameShow.text=cardNum;
            BSDataProvider *dp=[BSDataProvider sharedInstance];
            if([Mode isEqualToString:@"zc"]){
                cardInfo=[dp ZCqueryCardByCardNo:cardNum];
            }else if ([Mode isEqualToString:@"kc"])
            {
            cardInfo=[dp onelineQueryCardByCardNo:cardNum];
            }else
            {
                
            }
            [cardInfo setObject:cardNum forKey:@"cardNum"];
//            [AKsNetAccessClass sharedNetAccess].showVipMessageDict=cardInfo;
            [Singleton sharedSingleton].cardMessage=[NSDictionary dictionaryWithObjectsAndKeys:cardNum,@"cardNum",_phoneNumShow.text,@"phoneNum", nil];
            [Singleton sharedSingleton].VIPCardInfo=cardInfo;
            if (buttonTag==1001) {
                _tableView.tag=901;
                [_tableView reloadData];
                [self changeTableViewHeader:901];
            }else
            {
                _tableView.tag=902;
                [_tableView reloadData];
                [self changeTableViewHeader:902];
            }
            UIButton *button=(UIButton *)[self.view viewWithTag:2004];
            button.hidden=NO;
            [button setTitle:@"支付" forState:UIControlStateNormal];
            button.tag=2003;
        }
    }
}



-(void)ButtonQuery:(UIButton *)btn
{
    if(2001==btn.tag)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(2002==btn.tag)
    {
        if([_phoneNumShow.text length]>0)
        {
            NSDictionary *dict;
            BSDataProvider *dp=[BSDataProvider sharedInstance];
            if ([Mode isEqualToString:@"zc"]) {
                dict=[dp ZCqueryCardByMobTel:_phoneNumShow.text];
            }else if([Mode isEqualToString:@"kc"]){
                dict=[dp onelineQueryCardByMobTel:_phoneNumShow.text];
            }
            if ([[dict objectForKey:@"return"] intValue]==0) {
                cardArray=[dict objectForKey:@"cardData"];
                _tableView.tag=900;
                [_tableView reloadData];
                [self changeTableViewHeader:900];
                if ([cardArray count]>0) {
                    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
                    [_tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionTop];
                    cardNum=[[cardArray objectAtIndex:0] objectForKey:@"cardNo"];
                    UIButton *button=(UIButton *)[self.view viewWithTag:2002];
                    [button setTitle:@"重置" forState:UIControlStateNormal];
                    button.tag=2004;
                }
            }else
            {
                [self showAlter:[dict objectForKey:@"error"]];
            }
            
        }else
        {
            [self showAlter:@"请输入正确的手机号码或者会员卡号"];
        }
    }
    else if(2003==btn.tag)
    {
//        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:_userNameShow.text,@"cardNum",_phoneNumShow.text,@"phoneNum", nil];
//        [Singleton sharedSingleton].VIPCardInfo=dict;
        AKsNewVipPayViewController *payview=[[AKsNewVipPayViewController alloc] init];
        [self.navigationController pushViewController:payview animated:YES];
    }else if(2004==btn.tag)
    {
        _phoneNumShow.text=@"";
        _userNameShow.text=@"";
        cardArray=nil;
        _tableView.tag=900;
        UIButton *button=(UIButton *)[self.view viewWithTag:2004];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.tag=2002;
        [_tableView reloadData];
    }
}

-(void)showAlter:(NSString *)string
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                              otherButtonTitles:nil];
        [alert show];
        
    });
    
}
#pragma mark - TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==900) {
        cardNum=[[cardArray objectAtIndex:indexPath.row] objectForKey:@"cardNo"];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==900) {
        return [cardArray count];
    }else if (tableView.tag==901)
    {
        return 1;
    }else if(tableView.tag==902)
    {
        return [[cardInfo objectForKey:@"ticketInfoList"] count];
    }else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==900) {
        static NSString * cellName=@"cellName";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        cell.textLabel.text=[[cardArray objectAtIndex:indexPath.row] objectForKey:@"cardNo"];
        return cell;
    }else if (tableView.tag==901) {
        static NSString * cellName=@"cellName1";
        AKsNewVipMessageShowCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[AKsNewVipMessageShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        cell.VipNum.text=cardNum;
        cell.jihuoTime.text=[cardInfo objectForKey:@"pszName"];
        cell.youxiaoTime.text=[cardInfo objectForKey:@"cardType"];
        cell.chuZhiMoney.text=[cardInfo objectForKey:@"storedCardsBalance"];
        cell.jifenMoney.text=[cardInfo objectForKey:@"integralOverall"];
        return cell;
    }else if (tableView.tag==902){
        static NSString * cellName=@"cellName2";
        AKsNewVipMessageShowCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[AKsNewVipMessageShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        NSArray *array=[cardInfo objectForKey:@"ticketInfoList"];
        cell.VipNum.text=cardNum;
        cell.jihuoTime.text=[[array objectAtIndex:indexPath.row] objectForKey:@"counpId"];
        cell.youxiaoTime.text=[[array objectAtIndex:indexPath.row] objectForKey:@"counpName"];
        cell.jifenMoney.text=[[array objectAtIndex:indexPath.row] objectForKey:@"counpMoney"];
        cell.chuZhiMoney.text=[[array objectAtIndex:indexPath.row] objectForKey:@"counpNum"];
        return cell;

    }
    return nil;
}
-(void)changeTableViewHeader:(int)tag
{
    _tableView.tableHeaderView=nil;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 30)];
    view.backgroundColor=[UIColor lightTextColor];
    if (_tableView.tag==900) {
        UILabel *lb=[[UILabel alloc] initWithFrame:view.frame];
        lb.text=@"    会员卡号";

        lb.textColor=[UIColor blackColor];
        
        [view addSubview:lb];
    }else if (_tableView.tag==901){
        NSArray *array=[[NSArray alloc] initWithObjects:@"会员卡号",@"用户名",@"卡类型",@"储值金额",@"积分金额", nil];
        int i=0;
        for (NSString *str in array) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(_tableView.frame.size.width/[array count]*i, 0, _tableView.frame.size.width/[array count], 30)];
            lb.text=str;
            lb.textAlignment=NSTextAlignmentCenter;
            lb.textColor=[UIColor blackColor];
            
            [view addSubview:lb];
            i++;
        }
    }else if (_tableView.tag==902){
        NSArray *array=[[NSArray alloc] initWithObjects:@"会员卡号",@"券编码",@"券名称",@"券数量",@"券金额", nil];
        int i=0;
        for (NSString *str in array) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(_tableView.frame.size.width/[array count]*i, 0, _tableView.frame.size.width/[array count], 30)];
            lb.text=str;
            lb.textAlignment=NSTextAlignmentCenter;
            lb.textColor=[UIColor blackColor];
            
            [view addSubview:lb];
            i++;
        }
    }
    [_tableView setTableHeaderView:view];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}
/*
// 查询手机号下所有的会员卡号
-(void)HHTcard_GetTrack2ForWebService:(NSDictionary *)dict
{
    [SVProgressHUD dismiss];
    NSArray *array=[self getArrayWithDict:dict andFunction:card_GetTrack2Name];
    NSLog(@"%@",array);
    if([[array objectAtIndex:0]isEqualToString:@"0"])
    {
        
        NSArray *values=[[array objectAtIndex:2]componentsSeparatedByString:@";"];
        
        if(([values count]==1)&& ([[values objectAtIndex:0]length]!=16))
        {
            [self showAlter:@"该手机号下暂无注册会员卡"];
        }
        else
        {
            BSDataProvider *bsdata=[[BSDataProvider alloc] init];
            NSDictionary *dict=[bsdata onelineQueryCardByMobTel:_phoneNum.text];
            
//
//            int count=0;
//            for (NSDictionary *dict in numValues)
//            {
//                if([[dict objectForKey:@"zhangdanId"]isEqualToString:[AKsNetAccessClass sharedNetAccess].zhangdanId] && (![[dict objectForKey:@"phoneNum"]isEqualToString:_phoneNumShow.text]))
//                {
//                    [data delectPhoneNumWhithZhangdanId:[AKsNetAccessClass sharedNetAccess].zhangdanId];
//                    [data savePhoneNumWhithZhangdanId:_phoneNumShow.text andZhangDanId:[AKsNetAccessClass sharedNetAccess].zhangdanId];
//                    count++;
//                    break;
//                }
//                else
//                {
//                    count++;
//                }
//            }
//            if(count==0)
//            {
//                [data savePhoneNumWhithZhangdanId:_phoneNumShow.text andZhangDanId:[AKsNetAccessClass sharedNetAccess].zhangdanId];
//            }
//            //    刷新会员信息
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"refushVipMessage" object:nil];

            _orderArray=[[NSMutableArray alloc]initWithArray:values];
            
            
//            AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
//            netAccess.VipCardNum= lblCardJuanKeShow.text;
            
//            [_lblMessage removeFromSuperview];
//            _lblMessage=nil;
            
    
            
            
            [buttonSure setTitle:@"重 置" forState:UIControlStateNormal];
            buttonSure.tag=2003;
            
//            if ([isChaxun length]==16)
//            {
//                AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
//                netAccess.delegate=self;
//                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",isChaxun,@"cardNumber",netAccess.zhangdanId,@"orderId", nil];
//                [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"card_QueryBalance"]] andPost:dict andTag:card_QueryBalance];
//                [self.view addSubview:_HUD];
//            }
//            else
//            {
//                if([AKsNetAccessClass sharedNetAccess].isVipShow)
//                {
//                    [buttonSure setTitle:@"点 菜" forState:UIControlStateNormal];
//                    [buttonSure setTitle:@"点 菜" forState:UIControlStateHighlighted];
//                    buttonSure.tag=2005;
//                }
//                else if([Singleton sharedSingleton].isYudian)
//                {
//                    [buttonSure setTitle:@"点 菜" forState:UIControlStateNormal];
//                    [buttonSure setTitle:@"点 菜" forState:UIControlStateHighlighted];
//                    buttonSure.tag=2005;
//                }
//                else
//                {
//                    [buttonSure setTitle:@"支 付" forState:UIControlStateNormal];
//                    [buttonSure setTitle:@"支 付" forState:UIControlStateHighlighted];
//                    buttonSure.tag=2004;
//                }
//
//            }
        }
    }
    else
    {
        [self showAlter:[array lastObject]];
    }
    
}
//。。。。。。。。。。。
//查询会员卡信息
-(void)HHTcard_QueryBalanceForWebService:(NSDictionary *)dict
{
    [SVProgressHUD dismiss];
//    _dataJuanArray=[[NSMutableArray alloc]init];
    NSArray *array=[self getArrayWithDict:dict andFunction:card_QueryBalanceName];
    
    
    if([[array objectAtIndex:0]isEqualToString:@"0"])
    {
        queryCardSuccess=YES;
        
        AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
        
        netAccess.JiFenKeYongMoney=[array objectAtIndex:4];
        netAccess.IntegralOverall=[array objectAtIndex:4];
        netAccess.ChuZhiKeYongMoney=[array objectAtIndex:3];
        netAccess.VipCardNum=[array objectAtIndex:1];
    
        NSArray *VipJuan=[[NSArray alloc]initWithArray:[[array objectAtIndex:7]componentsSeparatedByString:@";"]];
        NSMutableDictionary *cardJuanDict=[[NSMutableDictionary alloc]init];
        for (int i=0; i<[VipJuan count]-1; i++)
        {
            NSArray *values=[[VipJuan objectAtIndex:i] componentsSeparatedByString:@","];
            CardJuanClass *cardJuan=[[CardJuanClass alloc]init];
            cardJuan.JuanId=[values objectAtIndex:0];
            cardJuan.JuanMoney=[NSString stringWithFormat:@"%.2f",[[values objectAtIndex:1]floatValue]/100.0];
            cardJuan.JuanName=[values objectAtIndex:2];
            cardJuan.JuanNum=[values objectAtIndex:3];
            [cardJuanDict setObject:cardJuan.JuanName forKey:cardJuan.JuanId];
            
            [_dataJuanArray addObject:cardJuan];
        }
        
        [AKsNetAccessClass sharedNetAccess].CardJuanDict=cardJuanDict;
        
        
        NSMutableDictionary *vipMessageDict=[[NSMutableDictionary alloc]init];
    
        [vipMessageDict setObject:[array objectAtIndex:1] forKey:@"cardNum"];
        [vipMessageDict setObject:[array objectAtIndex:3] forKey:@"yueMoney"];
        [vipMessageDict setObject:[array objectAtIndex:4] forKey:@"jifenMoney"];
        [vipMessageDict setObject:[array objectAtIndex:6] forKey:@"juanMoney"];
        [vipMessageDict setObject:[array objectAtIndex:8] forKey:@"userName"];
        [vipMessageDict setObject:[array objectAtIndex:9] forKey:@"userSex"];
        [vipMessageDict setObject:[array objectAtIndex:10] forKey:@"userAge"];
        [vipMessageDict setObject:[array objectAtIndex:11] forKey:@"userIndetifiy"];
        [vipMessageDict setObject:[NSString stringWithFormat:@"%@%@",[array objectAtIndex:12],[array objectAtIndex:13]] forKey:@"userEmail"];
        [vipMessageDict setObject:[array objectAtIndex:14] forKey:@"beginTime"];
        [vipMessageDict setObject:_dataJuanArray forKey:@"juanArray"];
        
        _userNameShow.text=[array objectAtIndex:1];
        _userSexShow.text=[array objectAtIndex:9];
        _userAgeShow.text=[array objectAtIndex:10];
        _useridentifiyShow.text=[array objectAtIndex:11];
        _userEmailShow.text=[NSString stringWithFormat:@"%@%@",[array objectAtIndex:12],[array objectAtIndex:13]];
        
        [_vipDict setObject:vipMessageDict forKey:[array objectAtIndex:1]];
        
        if(queryCard && queryCardSuccess)
        {
            _orderArray=[[NSMutableArray alloc]initWithObjects:[array objectAtIndex:1],nil];
            _showMessage=[[AKsNewVipMessageShowView alloc]initWithFrame:CGRectMake(20,200,728, 450)];
            _showMessage.delegate=self;
            [_lblMessage removeFromSuperview];
            _lblMessage=nil;
            
            
            [self.view addSubview:_showMessage];
            [_showMessage addSubview:_tableView];
            
            [buttonSure setTitle:@"重 置" forState:UIControlStateNormal];
            [buttonSure setTitle:@"重 置" forState:UIControlStateHighlighted];
            buttonSure.tag=2003;

        }
    
//        AKDataQueryClass *data=[[AKDataQueryClass alloc]init];
//        
//        [data saveCardNumforVip:netAccess.VipCardNum andPhoneNum:netAccess.phoneNum andzhangdanId:netAccess.zhangdanId andIntegralOverall:netAccess.IntegralOverall];
//
        //    刷新会员信息
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"refushVipMessage" object:nil];
//        
//
//        if([AKsNetAccessClass sharedNetAccess].isVipShow)
//        {
//            [buttonSure setTitle:@"点 菜" forState:UIControlStateNormal];
//            [buttonSure setTitle:@"点 菜" forState:UIControlStateHighlighted];
//            buttonSure.tag=2005;
//        }
//        else if([Singleton sharedSingleton].isYudian)
//        {
//            [buttonSure setTitle:@"点 菜" forState:UIControlStateNormal];
//            [buttonSure setTitle:@"点 菜" forState:UIControlStateHighlighted];
//            buttonSure.tag=2005;
//        }else if ([Singleton sharedSingleton].SELEVIP)
//        {
//            buttonSure.hidden=YES;
//        }
//        else
//        {
//            [buttonSure setTitle:@"支 付" forState:UIControlStateNormal];
//            [buttonSure setTitle:@"支 付" forState:UIControlStateHighlighted];
//            buttonSure.tag=2004;
//        }
//        
    }
    else
    {
        [self showAlter:[array lastObject]];
    }
    
    [_tableView reloadData];
    [_tableViewCard reloadData];
}

-(void)HHTreserveTableNumSuccessFormWebService:(NSDictionary *)dict
{
    NSLog(@"=======%@",dict);
    NSArray *array= [self getArrayWithDict:dict andFunction:reserveTableNumName];
    
    NSLog(@"=======%@",array);
    if([[array objectAtIndex:0]isEqualToString:@"0"])
    {
        
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"预定成功：账单号%@\n 等位序号：%@号\n是否预点餐",[array objectAtIndex:1],[array lastObject]]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NO"]
                                                  otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],nil];
            
            alert.tag=10001;
            [alert show];
            
        });
        [Singleton sharedSingleton].CheckNum=[array objectAtIndex:1];
        [AKsNetAccessClass sharedNetAccess].zhangdanId=[array objectAtIndex:1];
        
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[array lastObject]
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                  otherButtonTitles:nil];
            [alert show];
            
        });
    }
    
}

-(void)HHTstartcSuccessFormWebService:(NSDictionary *)dict
{
    NSArray *array=[self getArrayWithDict:dict andFunction:startcName];
    if([[array objectAtIndex:0]isEqualToString:@"0"])
    {
        AKOrderRepastViewController *akor=[[AKOrderRepastViewController alloc]init];
        [self.navigationController pushViewController:akor animated:YES];
        [AKsNetAccessClass sharedNetAccess].zhangdanId=[array lastObject];
        [Singleton sharedSingleton].CheckNum=[array lastObject];
    }
    else
    {
        [self showAlter:[array lastObject]];
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==10001)
    {
        
        if(buttonIndex==1)
        {
           
            AKOrderRepastViewController *akor=[[AKOrderRepastViewController alloc]init];
            [self.navigationController pushViewController:akor animated:YES];
            [Singleton sharedSingleton].isYudian=YES;
            
        }
    }
}

-(NSArray *)getArrayWithDict:(NSDictionary *)dict andFunction:(NSString *)functionName
{
    NSString *str=[[[dict objectForKey:[NSString stringWithFormat:@"ns:%@Response",functionName]]objectForKey:@"ns:return"]objectForKey:@"text"];
    NSArray *array=[str componentsSeparatedByString:@"@"];
    return array;
}

-(void)failedFromWebServie
{
    [SVProgressHUD dismiss];
    bs_dispatch_sync_on_main_thread(^{
        
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"网络连接失败，请检查网络！"
                                                     delegate:nil
                                            cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                            otherButtonTitles:nil];
        [alert show];
    });
}

#pragma mark UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_tableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_tableView)
    {
        return [_orderArray count];
    }
    else
    {
        return [_dataJuanArray count];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView)
    {
        return 40;
    }
    else
    {
        return 40;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==_tableView)
    {
        return 40;
    }
    else
    {
        return 40;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = nil;
    if(tableView==_tableView)
    {
        view=[[UIView alloc]initWithFrame:CGRectMake(0,0 , 708, 40)];
        view.backgroundColor=[UIColor cyanColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 708, 40)];
        label.text=[NSString stringWithFormat:@"     会员卡号                   激活时间             有效期至           储值余额      积分余额"];
        label.textColor=[UIColor blackColor];
        label.font=[UIFont boldSystemFontOfSize:20];
        label.backgroundColor=[UIColor clearColor];
        [view addSubview:label];
    }
    else
    {
        view=[[UIView alloc]initWithFrame:CGRectMake(0,0 , 708, 40)];
        view.backgroundColor=[UIColor cyanColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 708, 40)];
        label.text=[NSString stringWithFormat:@"          劵编码                      劵金额                       劵名称                      劵数量"];
        label.textColor=[UIColor blackColor];
        label.font=[UIFont boldSystemFontOfSize:20];
        label.backgroundColor=[UIColor clearColor];
        [view addSubview:label];

    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView)
    {
        static NSString *cellName=@"cell";
        AKsNewVipMessageShowCell *cell=[_tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell==nil)
        {
            cell=[[AKsNewVipMessageShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        NSDictionary *dict=[_vipDict objectForKey:[_orderArray objectAtIndex:indexPath.row]];
        cell.VipNum.text=[_orderArray objectAtIndex:indexPath.row];
        cell.jihuoTime.text=[dict objectForKey:@"beginTime"];
        cell.jifenMoney.text=[dict objectForKey:@"jifenMoney"];
        cell.youxiaoTime.text=@"";
        cell.chuZhiMoney.text=[dict objectForKey:@"yueMoney"];
        if([[_orderArray objectAtIndex:indexPath.row]isEqualToString:[AKsNetAccessClass sharedNetAccess].VipCardNum])
        {
            cell.contentView.backgroundColor=[UIColor grayColor];
        }
        else
        {
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }
        return cell;
    }
    else
    {
        static NSString *cellName2=@"cell2";
        UITableViewCell *cell=[_tableViewCard dequeueReusableCellWithIdentifier:cellName2];
        if(cell==nil)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName2];
        }
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        for (int j=0; j<3; j++)
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((j+1)*182,5, 1, 30)];
            label.backgroundColor=[UIColor blackColor];
            label.alpha=0.5;
            [cell.contentView addSubview:label];
        }
        for(int i=0 ;i<4;i++)
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*182,0, 182, 40)];
            label.textAlignment=NSTextAlignmentCenter;
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:20];
            switch (i) {
                case 0:
                    label.text=((CardJuanClass *)[_dataJuanArray objectAtIndex:indexPath.row]).JuanId;
                    break;
                case 1:
                    label.text=[NSString stringWithFormat:@"%@(元)",((CardJuanClass *)[_dataJuanArray objectAtIndex:indexPath.row]).JuanMoney];
                    break;
                case 2:
                    label.text=((CardJuanClass *)[_dataJuanArray objectAtIndex:indexPath.row]).JuanName;
                    break;
                case 3:
                    label.text=[NSString stringWithFormat:@"%@(张)",((CardJuanClass *)[_dataJuanArray objectAtIndex:indexPath.row]).JuanNum];
                    break;
                default:
                    break;
            }
            [cell.contentView addSubview:label];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_tableView)
    {
        AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
        netAccess.delegate=self;
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",[_orderArray objectAtIndex:indexPath.row],@"cardNumber",netAccess.zhangdanId,@"orderId", nil];
        [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"card_QueryBalance"]] andPost:dict andTag:card_QueryBalance];
        [SVProgressHUD showProgress:-1 status:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
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

#pragma mark AKsNewVipMessageShowViewDelegate

-(void)segmentButtonClick:(int)buttonTag
{
    [self dismissView];
    if(1000==buttonTag)
    {
        [_showMessage addSubview:_tableView];
    }
    else
    {
        if([_vipDict objectForKey:[AKsNetAccessClass sharedNetAccess].VipCardNum])
        {
            switch (buttonTag)
            {
                case 1001:
                    if([_dataJuanArray count]==0)
                    {
                        noCardJuan.text=@"该会员卡暂无劵可显示...";
                        [_showMessage addSubview:noCardJuan];
                    }
                    else
                    {
                        [_showMessage addSubview:_tableViewCard];
                    }
                    break;
                case 1002:
                    if([_dataJuanArray count]==0)
                    {
                        noCardJuan.text=@"暂不支持此功能...";
                        [_showMessage addSubview:noCardJuan];
                    }
                    else
                    {
                        
                    }
                    
                    break;
                case 1003:
                    if([_dataJuanArray count]==0)
                    {
                        noCardJuan.text=@"暂不支持此功能...";
                        [_showMessage addSubview:noCardJuan];
                    }
                    else
                    {
                        
                    }
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            bs_dispatch_sync_on_main_thread(^{
                
                
                UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"你还没有选择需要消费的会员卡\n请选择后继续操作"
                                                              message:@""
                                                             delegate:nil
                                                    cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                    otherButtonTitles:nil];
                [alert show];
            });
            
        }
        
    }
}

-(void)dismissView
{
    if(_tableViewCard && _tableViewCard.superview)
    {
        [_tableViewCard removeFromSuperview];
    }
    if(_tableView && _tableView.superview)
    {
        [_tableView removeFromSuperview];
    }
    if(_lblMessage && _lblMessage.superview)
    {
        [_lblMessage removeFromSuperview];
    }
    if(noCardJuan && noCardJuan.superview)
    {
        [noCardJuan removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

@end
