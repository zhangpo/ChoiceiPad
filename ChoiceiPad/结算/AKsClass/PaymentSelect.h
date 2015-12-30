

//asi请求tag值
#pragma mark WebService方法
#define GetCheckList 10000
#define cancleUserPayment  10001
#define changeTableNum 10002
#define checkAuth 10003
#define getOrdersBytabNum 10004
//#define init 10005
#define invoiceFace 10006
#define login 10007
#define queryProduct 10008
#define sendc 10009
#define startc 10010
#define suppProductsFinish 10011
#define userCounp 10012
#define userPayment 10013
#define cancleUserCounp 10014
#define card_GetTrack2 10015
#define card_QueryBalance 10016
#define card_Logout 10017
#define card_Sale 10018
#define card_TopUp 10019
#define card_Undo 10020
#define priPrintOrder 10021
#define reserveTableNum 10022
#define queryReserveTableNum 10023
#define cancelReserveTableNum 10024
#define updateDataVersion 10025
#define IsHHTUpgradeWebService  10026
#define HHTUpgradeVersion   10027
#define queryWholeProducts  10028



//通过标签解析数据，用于asi下载完成后的数据解析
#define GetCheckListName         @"GetCheckList"
#define cancleUserPaymentName    @"cancleUserPayment"
#define changeTableNumName       @"changeTableNum"
#define checkAuthName            @"checkAuth"
#define getOrdersBytabNumName    @"getOrdersBytabNum"
//#define HHTinitName                 @"HHTinit"
#define invoiceFaceName          @"invoiceFace"
#define loginName                @"login"
#define queryProductName         @"queryProduct"
#define sendcName                @"sendc"
#define startcName               @"startc"
#define suppProductsFinishName   @""
#define userCounpName            @"userCounp"
#define userPaymentName          @"userPayment"
#define cancleUserCounpName      @"cancleUserCounp"
#define card_GetTrack2Name       @"card_GetTrack2"
#define card_QueryBalanceName    @"card_QueryBalance"
#define card_LogoutName          @"card_Logout"
#define card_SaleName            @"card_Sale"
#define card_TopUpName           @"card_TopUp"
#define card_UndoName            @"card_Undo"
#define priPrintOrderName        @"priPrintOrder"
#define reserveTableNumName      @"reserveTableNum"
#define queryReserveTableNumName @"queryReserveTableNum"
#define cancelReserveTableNumName @"cancelReserveTableNum"
#define updateDataVersionName    @"updateDataVersion"
#define IsHHTUpgradeWebServiceName   @"IsHHTUpgradeWebService"
#define HHTUpgradeVersionName     @"HHTUpgradeVersion"
#define queryWholeProductsName    @"queryWholeProducts"


#pragma mark 账单详情
#define Sfujiacode       @"fujiacode"
#define Sfujianame       @"fujianame"
#define Sfujiaprice      @"fujiaprice"
#define Sisok            @"isok"
#define Sistc            @"istc"
#define Sorderid         @"orderid"
#define Spcname          @"pcname"
#define Spcode           @"pcode"
#define Spcount          @"pcount"
#define Spkid            @"pkid"
#define Sprice           @"price"
#define Spromonum        @"promonum"
#define Stpcode          @"tpcode"
#define Stpname          @"tpname"
#define Stpnum           @"tpnum"
#define Sunit            @"unit"
#define Sweight          @"weight"
#define Sweightflag      @"weightflag"
#define SrushCount       @"rushCount"
#define SpullCount       @"pullCount"
#define SrushOrCall      @"rushOrCall"
#define SeachPrice        @"eachPrice"
#define SIsQuit         @"IsQuit"
#define SQuitCause      @"QuitCause"



#define NSNotificationCardJuanPay       @"CardJuanPay"               //会员卡劵消费
#define NSNotificationCardPayCancle     @"CardPayCancle"            //取消会员卡消费
#define NSNotificationCardXianJinPay    @"CardXianJinPay"     //会员卡现金消费
#define NSNotificationCardFenPay        @"CardFenPay"              //会员卡积分消费

#define FTPDownload   1111  //FTP数据同步Alter


//拼接的webService地址
#define WEBSERVICEURL @"http://%@/ChoiceWebService/services/HHTSocket?%@"
