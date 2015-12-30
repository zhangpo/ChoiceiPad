//
//  AKsNetAccessClass.h
//  BookSystem
//
//  Created by sundaoran on 13-12-4.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol AKsNetAccessClassDelegate <NSObject>

@optional

-(void)failedFromWebServie;
-(void)HHTgetOrdersBytabNumfailedFromWebServie;

-(void)HHTuserPaymentSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTqueryProductSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTuserCounpSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTcancleUserPaymentSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTgetOrdersBytabNumPayMoneySuccessFormWebService:(NSDictionary *)dict;
-(void)HHTloginSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTcancleUserCounpForWebService:(NSDictionary *)dict;

//会员卡操作
-(void)HHTcard_GetTrack2ForWebService:(NSDictionary *)dict;
-(void)HHTcard_QueryBalanceForWebService:(NSDictionary *)dict;
-(void)HHTcard_LogoutForWebService:(NSDictionary *)dict;
-(void)HHTcard_SaleForWebService:(NSDictionary *)dict;
-(void)HHTcard_TopUpForWebService:(NSDictionary *)dict;
-(void)HHTcard_UndoForWebService:(NSDictionary *)dict;

//发票
-(void)HHTinvoiceFaceSuccessFormWebService:(NSDictionary *)dict;

//预打印
-(void)HHTpriPrintOrderSuccessFormWebService:(NSDictionary *)dict;

//预定台位
-(void)HHTreserveTableNumSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTqueryReserveTableNumSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTchangeTableNumSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTcancelReserveTableNumSuccessFormWebService:(NSDictionary *)dict;
-(void)HHTqueryWholeProductsFormWebService:(NSDictionary *)dict;

//验证权限
-(void)HHTcheckAuthSuccessFormWebService:(NSDictionary *)dict;


//更改HHT版本号
-(void)HHTupdateDataVersionSuccessFormWebService:(NSDictionary *)dict;

//开台
-(void)HHTstartcSuccessFormWebService:(NSDictionary *)dict;

//ipad版本自动升级
-(void)HHTIsHHTUpgradeWebServiceSuccessFormWebService:(NSDictionary *)dict;

-(void)HHTUpgradeVersionSuccessFormWebService:(NSDictionary *)dict;

@end

@interface AKsNetAccessClass : NSObject<ASIHTTPRequestDelegate>
{
    id<AKsNetAccessClassDelegate> _delegate;
    NSString *_zhangdanId;
    NSString *_TableNum;
    NSString *_PeopleManNum;
    NSString *_PeopleWomanNum;
    NSString *_yingfuMoney;
    NSString *_phoneNum;
    NSString *_VipCardNum;
    NSString *_ChuZhiKeYongMoney;
    NSString *_JiFenKeYongMoney;
    NSString *_UserId;
    NSString *_UserPass;
    NSString *_zhongduanNum;
    NSString *_zhaolingPrice;
    NSString *_fapiaoPrice;
    NSString *_baoliuXiaoshu;
    NSString *_molingPrice;
    NSString *_dataVersion;
    NSString *_IntegralOverall;
    NSString *_xiaofeiliuShui;
    NSString *_quandanbeizhu;
    NSMutableDictionary  *_CardJuanDict;
    NSMutableDictionary  *_showVipMessageDict;
    
    
    BOOL      _firstCheck;
    BOOL      _shiyongVipCard;
    BOOL      _isVipShow;
    BOOL      _shiyongVipJuan;
    BOOL      _bukaiFapiao;
    BOOL      _fapiaoMoney;
    BOOL      _fapiaoBank;
    BOOL      _fapiaoTuan;
    BOOL      _SettlemenVip;
    BOOL      _changeVipCard;  
    
    NSMutableArray *_VipXiaoFeiArray;
    NSMutableArray *_userPaymentArray;
    
}

@property(nonatomic ,strong)    NSString *zhangdanId;
@property(nonatomic ,strong)    NSString *TableNum;
@property(nonatomic ,strong)    NSString *PeopleManNum;
@property(nonatomic ,strong)    NSString *PeopleWomanNum;
@property(nonatomic ,strong)    NSString *yingfuMoney;
@property(nonatomic ,strong)    NSString *phoneNum;
@property(nonatomic ,strong)    NSString *VipCardNum;
@property(nonatomic ,strong)    NSString *ChuZhiKeYongMoney;
@property(nonatomic ,strong)    NSString *JiFenKeYongMoney;
@property(nonatomic ,strong)    NSMutableArray *VipXiaoFeiArray;
@property(nonatomic ,assign) id<AKsNetAccessClassDelegate>delegate;
@property(nonatomic)BOOL firstCheck;
@property(nonatomic ,strong)    NSString *UserId;
@property(nonatomic ,strong)    NSString *UserPass;
@property(nonatomic ,strong)    NSString *zhongduanNum;
@property(nonatomic ,strong)    NSString *zhaolingPrice;
@property(nonatomic ,strong)    NSString *fapiaoPrice;
@property(nonatomic ,strong)    NSString *baoliuXiaoshu;
@property(nonatomic ,strong)    NSString *molingPrice;
@property(nonatomic ,strong)    NSString *dataVersion;
@property(nonatomic ,strong)    NSString *xiaofeiliuShui;
@property(nonatomic ,strong)    NSString *quandanbeizhu;
@property(nonatomic ,strong)    NSMutableArray *CardJuanArray;
@property(nonatomic)    BOOL    shiyongVipCard;
@property(nonatomic)    BOOL    isVipShow;
@property(nonatomic)    BOOL    shiyongVipJuan;
@property(nonatomic)    BOOL    bukaiFaPiao;
@property(nonatomic)    BOOL    fapiaoMoney;
@property(nonatomic)    BOOL    fapiaoBank;
@property(nonatomic)    BOOL    fapiaoTuan;
@property(nonatomic)    BOOL    SettlemenVip;
@property(nonatomic)    BOOL    changeVipCard;

@property(nonatomic ,strong)    NSMutableArray *userPaymentArray,*ticketArray;
@property(nonatomic ,strong)    NSString *IntegralOverall;

@property(nonatomic ,strong)    NSMutableDictionary  *CardJuanDict;
@property(nonatomic ,strong)    NSMutableDictionary  *showVipMessageDict;


-(void)getRequestFromWebService:(NSString *)url andPost:(NSDictionary *)dict andTag:(NSInteger)requestTag;

+(AKsNetAccessClass *)sharedNetAccess;
@end
