//
//  BSDataProvider.h
//  BookSystem
//
//  Created by Dream on 11-3-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>
//#import "AKsNetAccessClass.h"
#import "BSWebServiceAgent.h"
#define kPlistPath      @"ftp://shipader:shipader123@61.174.28.122/BookSystem/BookSystem.sqlite"
#define kPathHeader      @"ftp://ipad:ipad@10.211.55.4/"
#define kSocketServer   @"192.168.1.115:8080"
#define kPDAID          @"8"
#define kDianPuId       @"600000"


@interface BSDataProvider : NSObject<NSStreamDelegate>
#pragma mark - 快餐
-(NSMutableArray *)allCombo;                                                    //查询所有的套餐明细
-(NSString *)scratch:(NSDictionary *)info andtag:(int)tag;                      //手势划菜反划菜
-(NSDictionary *)queryCompletely;                                               //全单
-(NSArray *)specialremark;                                                      //全单附加项
-(NSArray *)presentreason;                                                      //赠送
-(NSArray *)soldOut;                                                            //估清
-(void)updatecombineTable:(NSDictionary *)dict :(NSString *)cheak;              //并台更改数据库
-(void)delectcombo:(NSString *)tpcode andNUM:(NSString *)num;                   //删除缓存里的套餐
-(void)delectdish:(NSString *)code;                                             //单独删除
-(NSString *)UUIDString;                                                        //物理编号
-(NSArray *)chkCodesql;                                                         //查询退菜原因
-(void)delectCache;                                                             //清除缓存
-(void)reserveCache:(NSArray *)ary;                                             //预定台位存入
-(NSMutableArray *)selectCache;                                                 //查询缓存
-(NSArray *)logout;                                                             //登出
-(NSString *)registerDeviceId:(NSString *)str;                                  //注册
-(void)cache:(NSArray *)ary;                                                    //缓存
-(NSMutableArray *)queryProduct:(NSDictionary *)seat;                           //根据台位查账单
-(NSDictionary *)specialRemark:(NSArray *)ary;                                  //全单附加项
-(void)updateChangTable:(NSDictionary *)info :(NSString *)cheak;                //换台更改数据库
- (NSDictionary *)pListTable:(NSDictionary *)info;                              //查询台位
-(void)suppProductsFinish;                                                      //菜齐
-(NSDictionary *)priPrintOrder:(NSDictionary *)info;                            //预打印
-(NSDictionary *)combineTable:(NSDictionary *)info;                             //并台
-(void)gogoOrderUpData:(NSDictionary *)info;                                    //催菜成功修改数据库
-(NSDictionary *)changTableState:(NSDictionary *)info;                          //改变台位状态
-(NSDictionary *)chkCode:(NSArray *)array info:(NSDictionary *)info;            //退菜
-(NSDictionary *)checkAuth:(NSDictionary *)info;                                //授权
-(NSString *)scratch:(NSArray *)dish;                                           //划菜
-(int)updata:(NSDictionary *)dict withNum:(NSString *)num withOver:(NSString *)over;
+(int)updata:(NSString *)table orderID:(NSString *)order pkid:(NSString *)pkid code:(NSString *)code Over:(NSString *)over;                                                           //数据库划菜
+(NSArray *)tableNum:(NSString *)table orderID:(NSString *)order;//查找本地的发送的菜
-(NSArray *)AllCheak;
-(NSArray *)cancleUserPayment;                                      //取消支付
-(NSDictionary *)getOrdersBytabNum1:(NSString *)str;                //根据台位号查账单
+ (void)loadConfig;                                                 //加载配置
+ (void)reloadConfig;                                               //重新配置
+ (void)reloadCurrentPageConfig;                                    //最近的配置
-(NSMutableArray *)combo:(NSDictionary *)tag;                       //查套餐明细
+ (NSString *)sqlitePath;                                           //数据库的地址
- (NSDictionary *)pStart:(NSDictionary *)info;                      //开台
- (NSDictionary *)pChangeTable:(NSDictionary *)info;                //换台
- (NSDictionary *)pGogo:(NSArray *)array;                           //催菜
- (NSArray *)getArea;                                               //根据区域分
- (NSArray *)getFloor;                                              //根据楼层分
- (NSArray *)getStatus;                                             //根据状态分
- (NSDictionary *)checkFoodAvailable:(NSArray *)ary info:(NSDictionary *)info tag:(int)tag;//发送菜
- (NSDictionary *)bsService:(NSString *)api arg:(NSString *)arg;    //网络请求
- (NSDictionary *)pLoginUser:(NSDictionary *)info;                  //登陆
-(NSArray *)getClassById;                                           //查询菜品分类
- (NSArray *)getAdditions:(NSString *)pcode;                        //查数据库里的附加项
- (NSDictionary *)dictFromSQL;                                      //根据FTP下载文件名的数据库
+ (NSMutableArray *)getFoodList:(NSString *)cmd;                    //获得全部的菜品
-(NSString *)consumerCouponCode:(NSDictionary *)info;               //团购验证
//-(NSArray *)cancleUserCounp;                                        //取消优惠
-(NSArray *)userCounp:(NSDictionary *)info;                         //优惠使用
//-(NSArray *)userPayment:(NSDictionary *)info;                       //消费
-(NSDictionary *)selectRolemodule:(NSString *)moduleCode;           //权限
-(NSArray *)queryTyp;                                               //查询等位类型
-(NSDictionary *)takeNO:(NSDictionary *)info;                       //取号
-(NSArray *)queryNO:(NSDictionary *)info;                           //获取取号信息
-(NSDictionary *)cancelSeat:(NSDictionary *)info;                   //过号
-(NSDictionary *)queryReserveTableNum;                              //查询预订
-(NSDictionary *)reserveTableNum:(NSDictionary *)info;              //预定开台
-(NSDictionary *)changeTableNum:(NSDictionary *)info;               //转正式台
-(NSDictionary *)cancelReserveTableNum:(NSDictionary *)info;        //取消预定
-(NSMutableArray *)getAllFoodList:(NSArray *)classAry;              //查询所有的菜品
-(NSArray *)measdocArray;                                           //查询菜品单位
-(NSDictionary *)getStatusColor;                                    //获取台位状态颜色

+ (BSDataProvider *)sharedInstance;
//
#pragma mark - 中餐
- (NSDictionary *)ZCpListTable:(NSDictionary *)info;                //查询台位
- (NSDictionary *)ZCStart:(NSDictionary *)info;                     //中餐开台
-(NSArray *)ZCPrivateAddition:(NSArray *)array;                     //固定附加
- (NSDictionary *)ZCLoginUser:(NSDictionary *)info;                 //中餐登录
- (NSDictionary *)ZCChangeTable:(NSDictionary *)info;               //中餐换台
+ (NSMutableArray *)ZCgetFoodList:(NSString *)cmd;                  //刷新菜品列表
+(NSMutableArray *)ZCgetAllFoodList:(NSArray *)classAry;            //中餐查询全部的菜品
- (NSArray *)getShiftFoodPackage:(NSString *)packageid;             //中餐，根据套餐编码查询明细
- (NSArray *)ZCgetAdditions;                                        //中餐查询附加项
- (NSDictionary *)ZCpQuery;                                         //中餐查询账单
-(NSMutableArray *)ZCallCombo;                                      //查询所有的套餐里的菜品
- (NSDictionary *)checkFoodAvailable:(NSArray *)ary;                //中餐估清
- (NSDictionary *)pSendTab:(NSArray *)ary options:(NSDictionary *)info;//拼接发送的文件
- (NSDictionary *)ZCpGogo:(NSArray *)info;                          //中餐催菜
- (NSDictionary *)ZCpPrintQuery:(NSDictionary *)info;               //中餐打印
- (NSMutableArray *)getCodeDesc;                                    //中餐退菜原因
- (NSDictionary *)pChuck:(NSDictionary *)info;                      //中餐退菜
- (NSDictionary *)ZCpOver:(NSDictionary *)info;                     //中餐清台
-(NSDictionary *)ZCscratch:(NSArray *)dish;                         //中餐划菜
-(NSDictionary *)getFolioNo:(NSString *)table;                      //中餐查询账单号
-(NSDictionary *)modifyPax:(NSString *)order;                       //中餐修改人数
-(NSDictionary *)ZCuserPayment:(NSDictionary *)info;                //中餐支付
-(NSDictionary *)ZCqueryPayments;                                   //中餐查询支付记录
-(NSDictionary *)ZCcancelPayment:(NSString *)password;              //中餐取消支付
-(NSDictionary *)ZCqueryTables:(NSDictionary *)info;                //中餐台位检索
-(NSArray *)selecePayment;                                          //中餐查询支付列表
-(NSArray *)ZCselectCoupon;                                         //中餐活动查询
-(NSArray *)ZCquickFood;                                            //中餐查询急推菜
- (NSArray *)ZCgetArea;                                             //查询所有的区域
- (NSDictionary *)ZCpClearTable:(NSDictionary *)info;               //清理脏台
-(NSDictionary*)ZCpListResv;                                    //中餐获取预定信息
-(NSDictionary *)ZCpChangeResv;                                     //预定开台
+ (NSMutableArray *)ZCgetFoodList:(NSString *)cmd;                  //查询菜品
-(NSDictionary *)ZCuserActm:(NSDictionary *)info;                   //使用优惠
-(NSDictionary *)ZCcancelActm:(NSString *)password;                 //取消支付
-(NSDictionary *)ZCpaymentFinish;                                   //支付完成
-(NSDictionary *)ZCqueryCardByCardNo:(NSString *)cardNum;           //会员信息查询
-(NSDictionary *)ZCqueryCardByMobTel:(NSString *)mobtel;            //手机号查卡
-(NSDictionary *)ZCcardPayment:(NSDictionary *)info;                //中餐储值支付
-(NSDictionary *)ZCgetTableColor;
-(NSArray *)ZCEstimatesFoodList;                                    //中餐估清列表
-(NSDictionary *)ZCSetEstimatesFoodList:(NSDictionary *)info;       //中餐估清设置
-(UIColor *)getColorFromString:(NSString *)colorString;             //十进制转颜色
-(NSDictionary *)ZCpriPrintOrder:(NSString *)typ;                   //中餐打印
-(NSDictionary *)ZCpModiOrdrCnt:(NSDictionary *)info;               //修改数量
-(NSArray *)ZCTmpacct;                                              //中餐查询挂账用户
-(NSDictionary *)ZCTmpacctPost:(NSDictionary *)info;                //中餐执行挂账
-(NSDictionary *)ZCequipmentCoding:(NSString *)padid;               //中餐设置设备编码
-(NSDictionary *)deliveryAddress:(NSString *)address;               //中餐外送地址
#pragma mark - webPos
-(NSString *)ZCscratch:(NSDictionary *)info andtag:(int)tag;        //中餐手势划菜
-(BOOL)downloadData;                                                //webpos同步数据
- (NSArray *)WebgetArea;                                            //webpos获取区域
- (NSArray *)WebgetState;                                           //webpos获取状态
- (NSDictionary *)WebpListTable;                                    //webpos查询台位
-(NSArray *)WebgetClassById;                                        //webpos查询菜谱类别
-(NSMutableArray *)Webcombo:(NSString *)tag;                        //webpos查询套餐明细
-(NSArray *)WebSelectAddition;                    //webPos查询附加项
-(NSArray *)webSelectPrivateAddition:(NSString *)pcode;             //webPos查询固定附加项
- (NSDictionary *)WebStart:(NSDictionary *)info;                    //webPos开台
-(NSDictionary *)WebLogin:(NSDictionary *)info;                     //webPos登录
-(NSDictionary *)WebOpenTable:(NSDictionary *)info;                 //webPos开台
-(NSDictionary *)WebgetFolioNo:(NSDictionary *)tableInfo;           //webPos根据台位查询账单号
- (NSDictionary *)WebChangeTable:(NSDictionary *)info;              //webPos换台
-(NSDictionary *)WebSendFood:(NSArray *)food withTag:(NSString *)tag withComment:(NSArray *)comment;                                             //Webpos菜品发送
-(NSMutableArray *)WebgetOrderList;                                 //webPos查询菜品
-(NSDictionary *)WebcommitUrgeOrdrhand:(NSArray *)order;            //WebPos催菜
-(NSDictionary *)WebjoinOpenSitedefinehand:(NSDictionary *)info;    //web连台
-(NSDictionary *)WebprintFirstBillFolio;                            //web打印查询单
-(NSDictionary *)WebclearSitedefine:(NSDictionary *)info;           //web清台
-(NSDictionary *)WebcancelDelFolioFromVbcode;                       //取消账单
-(NSArray *)SelectCoupon_kind;                                      //web查询优惠类别
-(NSArray *)SelectSettlement:(NSString *)cmd;                       //web查下支付类型
-(NSArray *)SelectCoupon_main:(NSString *)cmd;                      //web查询优惠
-(NSMutableArray *)WebgetFolioPaymentList;                          //web查询支付方式
-(NSDictionary *)WebexecuteMarketing:(NSDictionary *)info;          //web活动使用
-(NSDictionary *)WebcommitFolioPayment:(NSDictionary *)info;        //web现金银行卡使用
-(NSDictionary *)WebcancelMarketing_Cut;                            //web取消优惠
-(NSDictionary *)WebcancelFolioPayment;                             //web取消支付
-(NSDictionary *)WebAddHand;                                        //web设备注册
-(NSDictionary *)WebreadCardByPhoneNo:(NSDictionary *)info;         //web根据手机号查询会员卡
-(NSDictionary *)WebreadCardByCardNo_pad:(NSDictionary *)info;      //web根据卡号查卡信息
-(NSString *)Webscratch:(NSDictionary *)info andtag:(int)tag;       //web手势划菜
-(NSDictionary *)Webscratch:(NSArray *)dish;                            //web多选划菜
-(NSMutableArray *)WeballCombo;                                     //web查询全部套餐
#pragma mark 计算服务费
-(NSDictionary *)ComputingServicefee:(NSString *)type;
#pragma mark -销售预估
-(NSDictionary *)productEstimate:(NSString *)classid;
#pragma mark - 查询全部账单
-(NSDictionary *)queryAllOrders;
#pragma mark - 激活
- (BOOL)activated;


#pragma mark - 在线会员
-(NSDictionary *)onelineQueryCardByMobTel:(NSString *)telNum;
-(NSDictionary *)onelineQueryCardByCardNo:(NSString *)cardNum;


-(NSDictionary *)activityUserCounp:(NSDictionary *)info;            //活动使用
-(NSDictionary *)paymentViewQueryProduct;                           //查询账单
-(NSDictionary *)couponForTicket:(NSDictionary *)ticket;            //根据券编码查询活动
-(NSDictionary *)onelineCardOutAmt:(NSDictionary *)info;            //会员消费
-(NSDictionary *)userPayment:(NSDictionary *)info;                  //现金银行卡支付
-(NSArray *)selectCoupon;                                           //查询全部的活动
-(NSDictionary *)cancleUserPayment:(NSString *)passWord;            //取消支付
-(NSDictionary *)cancleUserCounp;                                   //取消优惠
-(NSArray *)selectBankArray;                                        //查询银行卡
-(NSArray *)selectCashArray;                                        //查询现金
-(NSArray *)selectOnlinePaymentArray;                               //查询网络支付
//-(NSDictionary *)querySqlInterface:(NSString *)sql;                 //通用查询 sql 语句接口
-(NSDictionary *)memberConsumptionRecord;                           //查询是否存在会员消费
-(NSDictionary *)scanCode:(NSDictionary *)alipayDic;                //支付失败
-(double)ClearZeroFunclearMoneyYN:(int) clearMoneyYN withSumYmoney:(double)sumYmoney withClearZeroMoney:(double) ClearZeroMoney withClearBit:(double) dClearBit;        //抹零计算
-(NSDictionary *)shouldCheckData;                                   //查询需要支付接口
-(NSDictionary *)updateTableStata;                                  //改变台位占用状态
-(NSDictionary *)pushWeChatCheckOut:(NSDictionary *)info;           //微信上传
-(NSDictionary *)updateDataVersion:(NSString *)dataVersion;         //更新版本号
-(NSDictionary *)cancleProducts:(NSDictionary *)info;               //退菜
-(NSArray *)getAdditionsAndClass;
-(NSArray *)SelectPrivateAddition:(NSString *)pcode;
@end


/*
 
 char* scCommandWord[22]=
 { 
 {("+login<user:%s;password:%s;>\r\n")}, //0.登陆login
 {("+logout<user:%s;>\r\n")},//1.退出登陆logout
 {("+listtable<user:%s;pdanum:%s;floor:%s;area:%s;status:%s;>\r\n")},// 2.查询桌位list table  
 {("+start<pdaid:%s;user:%s;table:%s;peoplenum:%s;waiter:%s;acct:%s;>\r\n")},//3.开台start
 {("+over<pdaid:%s;user:%s;table:%s;>\r\n")},//4.取消开台
 {("+sendtab<pdaid:%s;user:%s;tabid:%d;acct:%s;tb:%s;usr:%s;pn:%s;foodnum:%d;type:%s;tablist:%s;>\r\n")},//5.发送菜单
 {("+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n")},//6.换台changetable
 {("+signteb<pdaid:%s;user:%s;tabto:%s;intotab:%s;type:%s;>\r\n")},//7.标记并单
 {("+query<pdaid:%s;user:%s;table:%s;>\r\n")},//8.查询
 {("+gogo<pdaid:%s;user:%s;tab:%s;foodnum:%s;>\r\n")},//9.催菜
 {("+rebate<pdaid:%s;user:%s;id:%s;pwd:%s;tab:%s;rebatetype:%s;foodnum:%s;pic:%s;ispic:%d;>\r\n")},//10.打折//fwang modif
 {("+printquery<pdaid:%s;user:%s;tab:%s;type:%s;>\r\n")},//11.打印
 {("+printtab<pdaid:%s;user:%s;tab:%s;>\r\n")},//12.打印
 {("+chuck<pdaid:%s;user:%s;id:%s;pwd:%s;tab:%s;result:%s;foodnum:%s;>\r\n")}, //13.退菜
 {("+listsubscribetab<pdaid:%s;user:%s;table:%s;>\r\n")}, //14.显示预订单
 {("+entersubscribetab<pdaid:%s;user:%s;tab:%s;num:%s;>\r\n")},  //15.预定单转成正式单
 {("+updata<pdaid:%s;user:%s;updatatype:%s;cls:%s;>\r\n") },//16.更新//fwang modif
 {("+modifyfoodnum<pdaid:%s;user:%s;foodid:%s;newnum:%.2f;oldnum:%.2f;>\r\n") },//17.更改数量
 {("+gototab<pdaid:%s;user:%s;tab:%s;foodnum:%s;>\r\n") },//18.转单  
 {("+set_branch<pdaid:%s;branch:%s;>\r\n") },//19.set branch  
 {("+customer<pdaid:%s;user:%s;tab:%s;data:%s;>\r\n") },//20.customer
 {("+card<pdaid:%s;user:%s;id:%s;pwd:%s;tab:%s;do:%s;vip:%s;vpwd:%s;money:%s;type:%s;>\r\n") }//21.card
 };
 
 */
