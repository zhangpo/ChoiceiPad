//
//  AKsNetAccessClass.m
//  BookSystem
//
//  Created by sundaoran on 13-12-4.
//
//

#import "AKsNetAccessClass.h"
#import "XMLReader.h"
#import "PaymentSelect.h"


@implementation AKsNetAccessClass



@synthesize delegate=_delegate;
@synthesize zhangdanId=_zhangdanId,PeopleManNum=_PeopleManNum,PeopleWomanNum=_PeopleWomanNum,yingfuMoney=_yingfuMoney,phoneNum=_phoneNum,VipCardNum=_VipCardNum,ChuZhiKeYongMoney=_ChuZhiKeYongMoney,JiFenKeYongMoney=_JiFenKeYongMoney,TableNum=_TableNum;
@synthesize VipXiaoFeiArray=_VipXiaoFeiArray;
@synthesize firstCheck=_firstCheck;
@synthesize UserId=_UserId,UserPass=_UserPass;
@synthesize zhongduanNum=_zhongduanNum;
@synthesize zhaolingPrice=_zhaolingPrice;
@synthesize baoliuXiaoshu=_baoliuXiaoshu;       //保留小数位数
@synthesize shiyongVipCard=_shiyongVipCard;     //是否使用会员卡消费标志
@synthesize isVipShow=_isVipShow;               //是否展示会员卡信息
@synthesize dataVersion=_dataVersion;           //版本号
@synthesize userPaymentArray=_userPaymentArray; //消费信息
@synthesize shiyongVipJuan=_shiyongVipJuan;     // 是否使用会员卡标记
@synthesize IntegralOverall=_IntegralOverall;   //会员卡积分
@synthesize bukaiFaPiao=_bukaiFapiao;           //是否开发票标记
@synthesize xiaofeiliuShui=_xiaofeiliuShui;     //会员卡消费流水号
@synthesize CardJuanDict=_CardJuanDict;         //会员卡劵信息
@synthesize CardJuanArray=_CardJuanArray;
@synthesize quandanbeizhu=_quandanbeizhu;       //全单备注

@synthesize fapiaoTuan=_fapiaoTuan;             //是否使用团购卷
@synthesize fapiaoMoney=_fapiaoMoney;           //是否使用现金
@synthesize fapiaoBank=_fapiaoBank;             //是否使用银行卡
@synthesize SettlemenVip=_SettlemenVip;         //是否为优惠会员显示
@synthesize showVipMessageDict=_showVipMessageDict;  // 通过查询账单接口获取会员卡信息
@synthesize changeVipCard=_changeVipCard;       //是否改变会员卡
@synthesize ticketArray=_ticketArray;

static AKsNetAccessClass *_netAccess;
+(AKsNetAccessClass *)sharedNetAccess
{
    if(!_netAccess)
    {
        _netAccess=[[AKsNetAccessClass alloc]init];
        
    }
    
    return _netAccess;
    
}

-(void)dealloc
{
    [_userPaymentArray release];
    [_dataVersion release];
    [_VipXiaoFeiArray release];
    [_zhangdanId release];
    [_phoneNum release];
    [_PeopleManNum release];
    [_PeopleWomanNum release];
    [_yingfuMoney release];
    [_VipXiaoFeiArray release];
    [_VipCardNum release];
    [_ChuZhiKeYongMoney release];
    [_JiFenKeYongMoney release];
    [_zhangdanId release];
    [_netAccess release];
    [super dealloc];
}
-(void)getRequestFromWebService:(NSString *)urlStr andPost:(NSDictionary *)dict andTag:(NSInteger)requestTag
{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.tag=requestTag;
    [request setDelegate:self];
    NSArray *keyArray = [NSArray arrayWithArray:[dict allKeys]];
    NSLog(@"%@",dict);
    for (int i=0; i<[keyArray count]; i++)
    {
        NSString *keyStr = [NSString stringWithFormat:@"%@",[keyArray objectAtIndex:i]];
        NSString *valueStr = [NSString stringWithFormat:@"%@",[dict objectForKey:keyStr]];
        [request setPostValue:valueStr forKey:keyStr];
    }
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",request.responseString);
    if(request.tag==userPayment)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTuserPaymentSuccessFormWebService:dict];
    }
    else if(request.tag==queryProduct)
    {
        
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTqueryProductSuccessFormWebService:dict];
    }
    else if(request.tag==userCounp)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        NSLog(@"%@",dict);
        [_delegate HHTuserCounpSuccessFormWebService:dict];
        
    }
    else if(request.tag==cancleUserPayment)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcancleUserPaymentSuccessFormWebService:dict];
    }
    else if(request.tag==getOrdersBytabNum)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTgetOrdersBytabNumPayMoneySuccessFormWebService:dict];
    }
    else if(request.tag==login)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTloginSuccessFormWebService:dict];
    }
    else if(request.tag==cancleUserCounp)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcancleUserCounpForWebService:dict];
    }
    else if(request.tag==card_GetTrack2)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcard_GetTrack2ForWebService:dict];
    }
    else if(request.tag==card_Logout)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcard_LogoutForWebService:dict];
    }
    else if(request.tag==card_QueryBalance)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcard_QueryBalanceForWebService:dict];
    }
    else if(request.tag==card_Sale)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcard_SaleForWebService:dict];
    }
    else if(request.tag==card_TopUp)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcard_TopUpForWebService:dict];
    }
    else if(request.tag==card_Undo)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcard_UndoForWebService:dict];
    }
    else if(request.tag==invoiceFace)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTinvoiceFaceSuccessFormWebService:dict];
    }
    else if(request.tag==priPrintOrder)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTpriPrintOrderSuccessFormWebService:dict];
    }
    else if(request.tag==reserveTableNum)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTreserveTableNumSuccessFormWebService:dict];
    }
    else if(request.tag==queryReserveTableNum)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTqueryReserveTableNumSuccessFormWebService:dict];
    }
    else if(request.tag==changeTableNum)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTchangeTableNumSuccessFormWebService:dict];
    }
    else if(request.tag==cancelReserveTableNum)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcancelReserveTableNumSuccessFormWebService:dict];
    }
    else if(request.tag==queryWholeProducts)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTqueryWholeProductsFormWebService:dict];
    }
    else if(request.tag==checkAuth)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTcheckAuthSuccessFormWebService:dict];
    }
    else if(request.tag==updateDataVersion)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTupdateDataVersionSuccessFormWebService:dict];
    }
    else if(request.tag==startc)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTstartcSuccessFormWebService:dict];
    }
    else if(request.tag==IsHHTUpgradeWebService)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTIsHHTUpgradeWebServiceSuccessFormWebService:dict];
        
    }
    else if(request.tag==HHTUpgradeVersion)
    {
        NSDictionary *dict=[XMLReader dictionaryForXMLData:request.responseData error:nil];
        [_delegate HHTUpgradeVersionSuccessFormWebService:dict];
    }
    else
    {
        NSLog(@"无此接口");
    }
    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"下载失败");
    if(request.tag==getOrdersBytabNum)
    {
        [_delegate HHTgetOrdersBytabNumfailedFromWebServie];
    }
    else
    {
        [_delegate failedFromWebServie];
    }
}
@end
