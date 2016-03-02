
//
//  BSDataProvider.m
//  BookSystem
//
//  Created by Dream on 11-3-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSDataProvider.h"
#import "FMDatabase.h"
#import "Singleton.h"
#import "AKsCanDanListClass.h"
#import "AKsYouHuiListClass.h"
#import "AKsCanDanListClass.h"
#import "AKsNetAccessClass.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#import "UIKitUtil.h"
#import "CardJuanClass.h"
#import "CVLocalizationSetting.h"
#import "SBJSON.h"
#import "NSObject+SBJSON.h"

//#import "PaymentSelect.h"


@implementation BSDataProvider

static int dSendCount = 0;
#pragma mark - 公共方法

static BSDataProvider *_BSDataProvider;
+(BSDataProvider *)sharedInstance
{
    if (!_BSDataProvider) {
        _BSDataProvider=[[BSDataProvider alloc] init];
    }
    return _BSDataProvider;
}
/**
 *  初始化
 *
 *  @return
 */
-(id)init
{
    self = [super init];
    if (self) {
        // Initialization cod
    }
    return self;
}
//PadId
-(NSString *)padID{
    NSString *deviceID=[[NSUserDefaults standardUserDefaults] objectForKey:@"PDAID"];
    AKsNetAccessClass *netaccess=[AKsNetAccessClass sharedNetAccess];
    netaccess.UserId=deviceID;
    return deviceID;
}
/**
 *  获取唯一标示
 *
 *  @return
 */
-(NSString *)UUIDString{
    NSString *uuid = nil;
    uuid =[OpenUDID value];
    return uuid;
}
#pragma mark 查询缓存的菜品
-(NSMutableArray *)selectCache
{
    NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]]];
    NSMutableArray *array=[cacheDict objectForKey:[Singleton sharedSingleton].Seat];
    return array;
}
#pragma mark - 删除保存的套餐数据
-(void)delectcombo:(NSString *)tpcode andNUM:(NSString *)num
{
    NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]]];
    NSMutableArray *array=[cacheDict objectForKey:[Singleton sharedSingleton].Seat];
    if (array) {
    A:
        for (NSDictionary *dict in array) {
            if ([[dict objectForKey:@"ITCODE"] isEqualToString:tpcode]&&[[dict objectForKey:@"TPNUM"]isEqualToString:num]) {
                [array removeObject:dict];
                goto A;
                break;
            }
        }
        [cacheDict setObject:array forKey:[Singleton sharedSingleton].Seat];
        [cacheDict writeToFile:[@"FoodCache.plist" documentPath] atomically:NO];
    }

    
}
#pragma mark - 删除保存的单个菜品
-(void)delectdish:(NSString *)code
{
    NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]]];
    NSMutableArray *array=[cacheDict objectForKey:[Singleton sharedSingleton].Seat];
    if (array) {
    A:
        for (NSDictionary *dict in array) {
            if ([[dict objectForKey:@"ITCODE"] isEqualToString:code]) {
                [array removeObject:dict];
                goto A;
                break;
            }
        }
        [cacheDict setObject:array forKey:[Singleton sharedSingleton].Seat];
        [cacheDict writeToFile:[@"FoodCache.plist" documentPath] atomically:NO];
    }
    
}
#pragma mark - 缓存菜品信息
-(void)cache:(NSArray *)ary
{
    NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]]];
    [cacheDict setObject:ary forKey:[Singleton sharedSingleton].Seat];
    [cacheDict writeToFile:[@"FoodCache.plist" documentPath] atomically:NO];
}
#pragma mark - 删除缓存

-(void)delectCache
{
    NSMutableDictionary *cacheDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[@"FoodCache.plist" documentPath]]];
    if ([cacheDict objectForKey:[Singleton sharedSingleton].Seat]) {
        [cacheDict removeObjectForKey:[Singleton sharedSingleton].Seat];
    }
    
    [cacheDict writeToFile:[@"FoodCache.plist" documentPath] atomically:NO];
}
#pragma mark - 获取数据库路径
+ (NSString *)sqlitePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BookSystem.sqlite"];
    return path;
}
#pragma mark - 数据库查询
+ (id)getDataFromSQLByCommand:(NSString *)cmd{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [self sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd = cmd;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return ary;
}
- (NSArray *)getDataFromSQLByCommandReturnArray:(NSString *)cmd{
    NSMutableArray *ary = [NSMutableArray array];
    
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [docPaths objectAtIndex:0];
    NSString *path = [docPath stringByAppendingPathComponent:@"BookSystem.sqlite"];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd = cmd;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            //            NSLog(@"%@",stat);
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return ary;
}

#pragma mark -  post请求
-(NSDictionary *)postData:(NSString *)info with:(NSString *)api
{
    BSWebServiceAgent *agent = [[BSWebServiceAgent alloc] init];
    NSDictionary *dict =[agent PostData:info arg:api];
    return dict;
}
#pragma mark -  get请求
- (NSDictionary *)bsService:(NSString *)api arg:(NSString *)arg{
    BSWebServiceAgent *agent = [[BSWebServiceAgent alloc] init];
    NSDictionary *dict = [agent GetData:api arg:arg];
    return dict;
}
#pragma mark -  激活
- (BOOL)checkActivated{
    BOOL bActivated = [[NSUserDefaults standardUserDefaults] boolForKey:@"Activated"];
    
    if (bActivated)
        return YES;
    BOOL bSuceed = NO;
    
    NSString *strRegNo = [NSString UUIDString];
    
    NSArray *urls = [NSArray arrayWithObjects:@"61.174.28.122",@"60.12.218.91",nil];
    for (int i=0;i<2;i++){
        NSString *strUrl = [NSString stringWithFormat:@"http://%@:9100/choicereg.asmx/choicereg?uuid=%@",[urls objectAtIndex:i],strRegNo];
        NSURL *url = [NSURL URLWithString:strUrl];
        
        NSMutableURLRequest *request = nil;
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *serviceData = nil;
        
        request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
        [request setHTTPMethod:@"GET"];
        
        serviceData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&error];
        
        
        
        if (!error){
            NSString *str = [[NSString stringWithCString:[serviceData bytes]
                                                encoding:NSUTF8StringEncoding] lowercaseString];
            NSRange range = [str rangeOfString:@"true"];
            if (range.location!=NSNotFound && str){
                bSuceed = YES;
                break;
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setBool:bSuceed forKey:@"Activated"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return bSuceed;
}
- (BOOL)activated{
    return [self checkActivated];
}

#pragma mark - 快餐
#pragma mark 查询菜品类别
-(NSArray *)getClassById
{
    return [BSDataProvider getDataFromSQLByCommand:@"select * from class order by GRP asc"];
}
#pragma mark  查询优惠类别
-(NSArray *)SelectCoupon_kind
{
    NSArray * array=[BSDataProvider getDataFromSQLByCommand:@"SELECT *FROM coupon_kind"];
    return array;
}
#pragma mark  查找优惠方式
-(NSArray *)SelectCoupon_main:(NSString *)cmd
{
    NSArray *array=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT *FROM coupon_main WHERE KINDID='%@' and isshow='Y'",cmd]];
    return array;
}
#pragma mark 查询支付方式
-(NSArray *)SelectSettlement:(NSString *)cmd
{
    NSArray * array=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT *FROM settlementoperate WHERE OPERATEGROUPID='%@'",cmd]];
    return array;
}
#pragma mark  估清接口
-(NSArray *)soldOut
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]]];
    NSDictionary *dict = [self bsService:@"soldOut" arg:strParam];
    NSMutableArray *array=[NSMutableArray array];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:soldOutResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            for (int i=1; i<[ary count]; i++) {
                [array addObject:[ary objectAtIndex:i]];
            }
        }
    }
    return array;
}
#pragma mark  预定台位----可不用
-(void)reserveCache:(NSArray *)ary
{
    for (int i=0; i<ary.count; i++) {
        
        AKsCanDanListClass *caiList=[ary objectAtIndex:i];
        
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            NSLog(@"数据库打开失败");
        }
        else
        {
            NSLog(@"数据库打开成功");
        }
        FMResultSet *rs = [db executeQuery:@"select * from food where itcode=?",caiList.pcode];
        NSString *class;
        while ([rs next]){
            class=[rs stringForColumn:@"class"];
        }
        NSString *qqq;
        if ([caiList.istc intValue]==1) {
            qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,caiList.pkid,caiList.pcode,caiList.pcname,caiList.tpcode,caiList.tpname,caiList.tpnum,@"1",caiList.promonum,caiList.fujiacode,caiList.fujianame,caiList.eachPrice,caiList.fujiaprice,caiList.weight,caiList.weightflag,caiList.unit,caiList.istc,caiList.pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",@"1",caiList.pcount];
        }
        else
        {
            qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,caiList.pkid,caiList.pcode,caiList.pcname,caiList.tpcode,caiList.tpname,caiList.tpnum,caiList.pcount,caiList.promonum,caiList.fujiacode,caiList.fujianame,caiList.eachPrice,caiList.fujiaprice,caiList.weight,caiList.weightflag,caiList.unit,caiList.istc,caiList.pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",@"1",@""];
        }
        [db executeUpdate:qqq];
        [db close];
    }
    
}

#pragma mark 查询附加项
- (NSArray *)getAdditions:(NSString *)pcode{
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from FoodFuJia where pcode=%@",pcode]];
    if ([ary count]==0) {
        ary=[BSDataProvider getDataFromSQLByCommand:@"select * from FoodFuJia where length(PCODE)=0 OR pcode like '%PCODE%'"];
    }
    return [NSArray arrayWithArray:ary];
}
#pragma mark 退菜原因
-(NSArray *)chkCodesql{
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:@"select * from ERRORCUSTOM where STATE=1"];
    return ary;
}
#pragma mark  查询所有区域
- (NSArray *)getArea{//根据区域区分
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:@"select * from storearear_mis"];
    return ary;
}
#pragma mark  查询楼层
- (NSArray *)getFloor{//根据楼层区分
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand: @"select * from codedesc where code = 'LC'"];
    return ary;
}
#pragma mark  查询状态
- (NSArray *)getStatus{//根据状态区分
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    
    NSString *langCode = [langSetting localizedString:@"LangCode"];
    
    if ([langCode isEqualToString:@"en"])
        return [NSArray arrayWithObjects:@"Idle",@"Ordered",@"No order",nil];
    else if ([langCode isEqualToString:@"cn"])
        return [NSArray arrayWithObjects:@"空闲",@"开台未点",@"开台点餐",@"结账",@"已封台",@"换台",@"子台位",@"挂单",@"菜齐",nil];
    else
        return [NSArray arrayWithObjects:@"空閒",@"開台點菜",@"開台未點",nil];
    
}
#pragma mark 查询台位颜色
-(NSDictionary *)getStatusColor
{
    NSArray *array=[BSDataProvider getDataFromSQLByCommand:@"select USESTATE,USECOLOR from STORETABLESUSESTATE_MIS"];
    NSMutableDictionary *returnDic=[[NSMutableDictionary alloc] init];
    for (NSDictionary *dict in array) {
        [returnDic setObject:[dict objectForKey:@"USECOLOR"] forKey:[dict objectForKey:@"USESTATE"]];
    }
    return returnDic;
}

#pragma mark 预打印接口
-(NSDictionary *)priPrintOrder:(NSDictionary *)info
{
    
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@&json=%@",pdanum,user,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info JSONRepresentation]];
    
    NSDictionary *dict = [self bsService:@"PrintOrder" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:priPrintOrderResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[ary objectAtIndex:1],@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[ary objectAtIndex:1],@"Message", nil];
        }
        
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"打印失败",@"Message", nil];
    }
}
#pragma mark  并台修改数据库（已不用）
-(void)updatecombineTable:(NSDictionary *)dict :(NSString *)cheak
{
    NSMutableArray *array=[NSMutableArray array];
    [array addObject:[dict objectForKey:@"newtable"]];
    [array addObject:[dict objectForKey:@"oldtable"]];
    for (int i=0; i<[array count]; i++) {
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            return;
        }
        
        //    NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum='%@' and Time='%@'"
        NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET orderId = '%@' WHERE tableNum = '%@' and Time='%@'",cheak,[array objectAtIndex:i],[Singleton sharedSingleton].Time];
        [db executeUpdate:str];
        [db close];
    }
}
#pragma mark 换台修改数据库（已不用）

-(void)updateChangTable:(NSDictionary *)info :(NSString *)cheak
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET tableNum = '%@' WHERE tableNum = '%@' and orderId='%@'",[info objectForKey:@"newtable"],[info objectForKey:@"oldtable"],cheak];
    [db executeUpdate:str];
    [db close];
}
#pragma mark 手势划菜
-(NSString *)scratch:(NSDictionary *)info andtag:(int)tag
{
    NSMutableString *fanfood=[NSMutableString string];
    if ([info objectForKey:@"fujiacode"]==nil) {
        [info setValue:@"" forKey:@"fujiacode"];
    }
    if ([info objectForKey:@"Weightflg"]==nil) {
        [info setValue:@"" forKey:@"Weightflg"];
    }
    [fanfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[info objectForKey:@"count"],[info objectForKey:@"PKID"],[info objectForKey:@"Sublistid"],[info objectForKey:@"UnitCode"],[info objectForKey:@"istemp"]];
    [fanfood appendString:@";"];
    if (tag==0) {
        //        if ([[info objectForKey:@"Over"] intValue]==[[info objectForKey:@"pcount"] intValue]) {
        //        NSString *str2;
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"reCallElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:reCallElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        return result;
    }else
    {
        //        NSString *str;
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"callElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:callElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        return result;
    }
}
#pragma mark 划菜按钮

-(NSString *)scratch:(NSArray *)dish
{
    //    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    //    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSMutableString *mutfood = [NSMutableString string];
    NSMutableString *fanfood=[NSMutableString string];
    for (NSDictionary *info in dish) {
        if ([[info objectForKey:@"Over"] intValue]==[[info objectForKey:@"pcount"] intValue]) {
            if ([info objectForKey:@"fujiacode"]==nil) {
                [info setValue:@"" forKey:@"fujiacode"];
            }
            if ([info objectForKey:@"Weightflg"]==nil) {
                [info setValue:@"" forKey:@"Weightflg"];
            }
            [fanfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[info objectForKey:@"pcount"],[info objectForKey:@"PKID"],[info objectForKey:@"Sublistid"],[info objectForKey:@"UnitCode"],[info objectForKey:@"istemp"]];
            [fanfood appendString:@";"];
        }
        else
        {
            if ([info objectForKey:@"fujiacode"]==nil) {
                [info setValue:@"" forKey:@"fujiacode"];
            }
            if ([info objectForKey:@"Weightflg"]==nil) {
                [info setValue:@"" forKey:@"Weightflg"];
            }
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[info objectForKey:@"pcount"],[info objectForKey:@"PKID"],[info objectForKey:@"Sublistid"],[info objectForKey:@"UnitCode"],[info objectForKey:@"istemp"]];
            [mutfood appendString:@";"];
        }
    }
    NSString *str1;
    if (![mutfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,mutfood];
        NSDictionary *dict = [self bsService:@"callElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:callElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        str1=result;
    }
    if (![fanfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"reCallElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:reCallElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        //        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if (str1==nil) {
            str1=result;
        }
    }
    return str1;
}
#pragma mark  查询全单附加项
-(NSArray *)specialremark//查询全单附加项
{
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:@"select * from specialremark"];
    return [NSArray arrayWithArray:ary];
}
#pragma mark 查询赠菜原因
-(NSArray *)presentreason
{
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:@"select * from presentreason"];
    return [NSArray arrayWithArray:ary];
}
#pragma mark  数据库划菜（已不用）

+(int)updata:(NSString *)table orderID:(NSString *)order pkid:(NSString *)pkid code:(NSString *)code Over:(NSString *)over;{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    if ([over isEqualToString:@"0"]) {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=?",@"1",table,order,pkid,code];
    }
    else
    {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=?",@"0",table,order,pkid,code];
    }
    FMResultSet *rs=[db executeQuery:@"select * from AllCheck where Over=0 and tableNum = ? and orderId=?",table,order];
    int i=0;
    while ([rs next]) {
        i++;
    }
    [db close];
    return i;
}
#pragma mark  改变台位状态

-(NSDictionary *)changTableState:(NSDictionary *)info
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    //    NSString *tableNum=[info objectForKey:@"tableNum"];
    NSString *currentState=[info objectForKey:@"currentState"];
    NSString *nextState=[info objectForKey:@"nextState"];
    NSString *api=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&currentState=%@&nextState=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,currentState,nextState];
    
    NSDictionary *dict = [self bsService:@"changTableState" arg:api];
    return dict;
}
#pragma mark   换台
- (NSDictionary *)pChangeTable:(NSDictionary *)info{
    NSString *pdaid,*user,*oldtable,*newtable,*pwd;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd = [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    oldtable = [info objectForKey:@"oldtable"];
    newtable = [info objectForKey:@"newtable"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tablenumSource=%@&tablenumDest=%@",pdaid,user,oldtable,newtable];
    NSArray *dic=[[self getOrdersBytabNum1:[info objectForKey:@"oldtable"]] objectForKey:@"message"];
    NSDictionary *dict = [self bsService:@"pSignTeb" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:changeTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            [self updateChangTable:info :[[dic objectAtIndex:0] objectForKey:@"CheckNum"]];
            //            [NSNumber numberWithBool:YES],@"Result",@"成功",@"Message"
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result", [[CVLocalizationSetting sharedInstance] localizedString:@"Change Table Succeed"],@"Message",nil];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result", [[CVLocalizationSetting sharedInstance] localizedString:@"Change Table Failed"],@"Message",nil];
}

#pragma mark  并台
-(NSDictionary *)combineTable:(NSDictionary *)info
{
    NSString *pdaid,*user,*oldtable,*newtable,*pwd;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd = [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    oldtable = [info objectForKey:@"oldtable"];
    newtable = [info objectForKey:@"newtable"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableList=%@@%@",pdaid,user,oldtable,newtable];
    NSDictionary *dict = [self bsService:@"combineTable" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:combineTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[[ary objectAtIndex:0] intValue]==0?YES:NO],@"Result",[ary objectAtIndex:1],@"Message", nil];
        
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
    }
}

#pragma mark 查询台位菜品
-(NSMutableArray *)queryProduct:(NSDictionary *)seat
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *tableNum=@"",*orderId=@"",*comOrDetach=@"0";
    tableNum=[seat objectForKey:@"tableNum"]==nil?[seat objectForKey:@"Tablename"]:[seat objectForKey:@"tableNum"];
    if ([seat objectForKey:@"orderId"]) {
        orderId=[seat objectForKey:@"orderId"];
    }
    if ([seat objectForKey:@"comOrDetach"]) {
        comOrDetach=@"0";
    }
    NSString *api=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&manCounts=&womanCounts=&orderId=%@&chkCode=&comOrDetach=%@",pdanum,user,tableNum,@"",comOrDetach];
    NSDictionary *dict = [self bsService:@"queryProduct" arg:api];
    NSString *result = [[[dict objectForKey:@"ns:queryProductResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    if ([[[result componentsSeparatedByString:@"@"] objectAtIndex:0] intValue]==0) {
        [Singleton sharedSingleton].CheckNum=[[result componentsSeparatedByString:@"@"] objectAtIndex:1];
    }
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    NSArray *ary1 = [result componentsSeparatedByString:@"#"];
    for (int i=0;i<[ary1 count];i++) {
        if (i==0) {
            NSArray *ary2=[[ary1 objectAtIndex:0] componentsSeparatedByString:@";"];
            NSMutableArray *array2=[[NSMutableArray alloc] initWithArray:ary2];
            [array2 removeLastObject];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (NSString *result2 in array2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([[ary3 objectAtIndex:0] intValue]==0) {
                    AKsCanDanListClass *candan=[[AKsCanDanListClass alloc] init];
                    if ([[ary3 objectAtIndex:3] isEqualToString:[ary3 objectAtIndex:5]]||[[ary3 objectAtIndex:5]isEqualToString:@""]) {
                        candan.pcname=[ary3 objectAtIndex:4];
                    }
                    else
                    {
                        candan.pcname=[NSString stringWithFormat:@"--%@",[ary3 objectAtIndex:4]];
                    }
                    [Singleton sharedSingleton].CheckNum=[ary3 objectAtIndex:1];
                    candan.tpname=[ary3 objectAtIndex:6];
                    candan.pcount=[ary3 objectAtIndex:8];
                    candan.fujianame=[ary3 objectAtIndex:7];
                    candan.pcount=[ary3 objectAtIndex:8];
                    candan.promonum=[ary3 objectAtIndex:9];
                    NSArray *ary4=[[ary3 objectAtIndex:11] componentsSeparatedByString:@"!"];
                    NSMutableString *FujiaName =[NSMutableString string];
                    for (NSString *str in ary4) {
                        [FujiaName appendFormat:@"%@ ",str];
                    }
                    
                    float addtition=0.0f;
                    NSArray *ary5=[[ary3 objectAtIndex:13] componentsSeparatedByString:@"!"];
                    for (NSString *str in ary5) {
                        addtition+=[str floatValue];
                    }
                    candan.fujiaprice=[NSString stringWithFormat:@"%.2f",addtition];
                    candan.fujianame=[FujiaName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
                    candan.price=[ary3 objectAtIndex:12];
                    candan.weightflag=[ary3 objectAtIndex:14];
                    candan.weightflag=[ary3 objectAtIndex:15];
                    candan.unit=[ary3 objectAtIndex:16];
                    candan.istc=[ary3 objectAtIndex:17];
                    [array addObject:candan];
                }
                else
                {
                    return nil;
                }
                
            }
            [array1 addObject:array];
        }
        else if(i==1)
        {
            NSArray *ary2=[[ary1 objectAtIndex:1] componentsSeparatedByString:@";"];
            NSMutableArray *array2=[[NSMutableArray alloc] initWithArray:ary2];
            [array2 removeLastObject];
            NSMutableArray *ary=[[NSMutableArray alloc] init];
            for (NSString *result2 in array2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([[ary3 objectAtIndex:0] intValue]==0) {
                    AKsYouHuiListClass *youhui=[[AKsYouHuiListClass alloc] init];
                    youhui.youName=[ary3 objectAtIndex:2];
                    youhui.youMoney=[ary3 objectAtIndex:3];
                    youhui.youCode=[ary3 objectAtIndex:4];
//                    [youhui.youCode ]
                    [ary addObject:youhui];
                }
            }
            [array1 addObject:ary];
        }
        else if(i==2)
        {
            NSArray *ary2=[[ary1 objectAtIndex:2] componentsSeparatedByString:@"@"];
            if ([[ary2 objectAtIndex:0] intValue]==0) {
                [Singleton sharedSingleton].man=[ary2 objectAtIndex:1];
                [Singleton sharedSingleton].woman=[ary2 objectAtIndex:2];
            }
        }
        else{
            NSArray *ary2=[[ary1 objectAtIndex:3] componentsSeparatedByString:@";"];
            NSMutableArray *ary=[[NSMutableArray alloc] init];
            NSMutableString *str=[NSMutableString string];
            for (NSString *result2 in ary2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([ary3 count]==2) {
                    //                    [ary stringByAppendingString:[ary3 objectAtIndex:1]];
                    [str appendFormat:@"%@ ",[ary3 objectAtIndex:1]];
                }
                //                [ary addObject:[ary3 objectAtIndex:1]];
            }
            [ary addObject:str];
            [array1 addObject:ary];
        }
    }
    if ([array1 count]==3) {
        [array1 exchangeObjectAtIndex:1 withObjectAtIndex:2];
    }
    return array1;
}
#pragma mark   根据台位号查询账单
-(NSDictionary *)getOrdersBytabNum1:(NSString *)str{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],str];
    NSDictionary *dict = [self bsService:@"getOrdersBytabNum" arg:strParam];
    NSString *str1=[[[dict objectForKey:@"ns:getOrdersBytabNumResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary = [str1 componentsSeparatedByString:@"@"];
    NSMutableDictionary *dataDic=[NSMutableDictionary dictionary];
    if ([ary count]==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return  nil;
    }
    else
    {
        [dataDic setValue:[ary objectAtIndex:0] forKey:@"Result"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            NSArray *ary2 = [str1 componentsSeparatedByString:@"&"];
            NSMutableArray *returnArray=[[NSMutableArray alloc] init];
            for (NSString *string in ary2) {
                NSArray *valuearray=[string componentsSeparatedByString:@"#"];
                if([[valuearray objectAtIndex:1]isEqualToString:@"1"])
                {
                    AKsNetAccessClass *netAccess =[AKsNetAccessClass sharedNetAccess];
                    NSArray *cardValue=[[valuearray objectAtIndex:2]componentsSeparatedByString:@"@"];
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                    
                    
                    [dict setObject:@"" forKey:@"zhangdanId"];
                    [dict setObject:[cardValue objectAtIndex:0] forKey:@"phoneNum"];
                    [dict setObject:[Singleton sharedSingleton].Time forKey:@"dateTime"];
                    [dict setObject:[cardValue objectAtIndex:1] forKey:@"cardNum"];
                    [dict setObject:[cardValue objectAtIndex:4] forKey:@"IntegralOverall"];
                    netAccess.JiFenKeYongMoney=[cardValue objectAtIndex:4];
                    netAccess.ChuZhiKeYongMoney=[cardValue objectAtIndex:3];
                    netAccess.VipCardNum=[cardValue objectAtIndex:1];
                    
                    NSArray *VipJuan=[[NSArray alloc]initWithArray:[[cardValue objectAtIndex:7]componentsSeparatedByString:@";" ]];
                    NSMutableArray *cardJuanArray=[[NSMutableArray alloc]init];
                    for (int i=0; i<[VipJuan count]-1; i++)
                    {
                        NSArray *values=[[VipJuan objectAtIndex:i] componentsSeparatedByString:@","];
                        CardJuanClass *cardJuan=[[CardJuanClass alloc]init];
                        cardJuan.JuanId=[values objectAtIndex:0];
                        cardJuan.JuanMoney=[NSString stringWithFormat:@"%.2f",[[values objectAtIndex:1]floatValue]/100.0];
                        cardJuan.JuanName=[values objectAtIndex:2];
                        cardJuan.JuanNum=[values objectAtIndex:3];
                        [cardJuanArray addObject:cardJuan];
                        
                    }
                    netAccess.CardJuanArray=cardJuanArray;
                    netAccess.showVipMessageDict=dict;
                }
                NSArray *array=[[valuearray objectAtIndex:0] componentsSeparatedByString:@";"];
                NSMutableDictionary *dictV=[[NSMutableDictionary alloc] init];
                [dictV setObject:[[[array objectAtIndex:0] componentsSeparatedByString:@"@"] lastObject] forKey:@"CheckNum"];
                [dictV setObject:[array objectAtIndex:1] forKey:@"man"];
                [dictV setObject:[array objectAtIndex:2] forKey:@"woman"];
                [dictV setObject:[array objectAtIndex:3] forKey:@"people"];
                [dictV setObject:[array objectAtIndex:4] forKey:@"state"];
                [dictV setObject:[array objectAtIndex:5] forKey:@"tableName"];
                [dictV setObject:[array objectAtIndex:6] forKey:@"ISFENGTAI"];
                [returnArray addObject:dictV];
            }
            [dataDic setValue:returnArray forKey:@"message"];
            return [NSDictionary dictionaryWithDictionary:dataDic];
        }
        else
        {
            [dataDic setValue:[ary objectAtIndex:1] forKey:@"message"];
            return [NSDictionary dictionaryWithDictionary:dataDic];
        }
    }
}
#pragma mark  注销登录
-(NSArray *)logout
{
    NSString *strParam=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *dict=[self bsService:@"logout" arg:strParam];
    NSString *result = [[[dict objectForKey:@"ns:loginOutResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    return ary1;
}
#pragma mark   POS注册
-(NSString *)registerDeviceId:(NSString *)str
{
    NSString *strParam =[NSString stringWithFormat:@"?&handvId=%@",str];
    NSDictionary *dict = [self bsService:@"registerDeviceId" arg:strParam];
    NSString *result = [[[dict objectForKey:@"ns:registerDeviceIdResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    return [ary1 objectAtIndex:1];
}
#pragma mark   授权

-(NSDictionary *)checkAuth:(NSDictionary *)info
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[info objectForKey:@"user"];
    NSString *pass=[info objectForKey:@"pwd"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&userPass=%@",pdanum,user,pass];
    NSDictionary *dict = [self bsService:@"checkAuth" arg:strParam];
    return dict;
    
}
#pragma mark   全单附加项
-(NSDictionary *)specialRemark:(NSArray *)ary
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *userCode=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *orderId=[Singleton sharedSingleton].CheckNum;
    NSMutableString *remarkId=[NSMutableString string];
    NSMutableString *remark=[NSMutableString string];
    for (NSDictionary *dict in ary) {
        [remarkId appendFormat:@"%@",[dict objectForKey:@"Id"]];
        [remarkId appendString:@"!"];
        [remark appendFormat:@"%@",[dict objectForKey:@"DES"]];
        [remark appendString:@"!"];
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&remarkIdList=%@&remarkList=%@&flag=%@",pdanum,userCode,orderId,remarkId,remark,@"1"];
    NSDictionary *dict1 = [self bsService:@"specialRemark" arg:strParam];
    return dict1;
}
#pragma mark 查询全单
- (NSDictionary *)queryCompletely{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"queryWholeProducts" arg:strParam];
    
    if (dict) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        NSString *result = [[[dict objectForKey:@"ns:queryWholeProductsResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        NSMutableArray *aryResult = [NSMutableArray array];
        if ([[ary objectAtIndex:0] isEqualToString:@"0"]) {
            //获取男人数、女人数、账单号、台位等基本信息
            NSArray *aryInfo = [result componentsSeparatedByString:@"#"];
            NSArray *aryInfoRes =[[aryInfo objectAtIndex:[aryInfo count]-2] componentsSeparatedByString:@"@"];
            [Singleton sharedSingleton].man=[aryInfoRes objectAtIndex:1];
            [Singleton sharedSingleton].woman=[aryInfoRes objectAtIndex:2];
            NSArray *ary = [[aryInfo objectAtIndex:0] componentsSeparatedByString:@";"];
            NSArray *array=[[aryInfo lastObject] componentsSeparatedByString:@";"];
            NSMutableString *Common=[NSMutableString string];
            for (int i=0; i<[array count]-1; i++) {
                NSString *str=[array objectAtIndex:i];
                NSArray *itemAry = [str componentsSeparatedByString:@"@"];
                [Common appendFormat:@"%@ ",[itemAry objectAtIndex:1]];
            }
            [dic setValue:Common forKey:@"Common"];
            //            NSMutableDictionary *dicResult = [NSMutableDictionary dictionary];
            
            int c = [ary count];
            for (int z=0; z<c-1; z++) {
                NSString *str = [ary objectAtIndex:z];
                NSArray *itemAry = [str componentsSeparatedByString:@"@"];
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                [mutDic setValue:[itemAry objectAtIndex:1]   forKey:@"orderId"];
                [mutDic setValue:[itemAry objectAtIndex:2]   forKey:@"PKID"];
                [mutDic setValue:[itemAry objectAtIndex:3]   forKey:@"Pcode"];
                [mutDic setValue:[itemAry objectAtIndex:4]   forKey:@"PCname"];
                [mutDic setValue:[itemAry objectAtIndex:5]   forKey:@"Tpcode"];
                [mutDic setValue:[itemAry objectAtIndex:6]   forKey:@"TPNAME"];
                [mutDic setValue:[itemAry objectAtIndex:7]   forKey:@"TPNUM"];
                [mutDic setValue:[itemAry objectAtIndex:8]   forKey:@"pcount"];
                [mutDic setValue:[itemAry objectAtIndex:9]   forKey:@"promonum"];
                [mutDic setValue:[itemAry objectAtIndex:10]  forKey:@"fujiacode"];
                [mutDic setValue:[itemAry objectAtIndex:11]  forKey:@"fujianame"];
                [mutDic setValue:[itemAry objectAtIndex:12]  forKey:@"talPreice"];
                [mutDic setValue:[itemAry objectAtIndex:13]  forKey:@"fujiaPrice"];
                [mutDic setValue:[itemAry objectAtIndex:14]  forKey:@"weight"];
                [mutDic setValue:[itemAry objectAtIndex:15]  forKey:@"weightflg"];
                [mutDic setValue:[itemAry objectAtIndex:16]  forKey:@"unit"];
                [mutDic setValue:[itemAry objectAtIndex:17]  forKey:@"ISTC"];
                [mutDic setValue:[itemAry objectAtIndex:18]  forKey:@"Urge"];//催菜次数
                [mutDic setValue:[itemAry objectAtIndex:19]  forKey:@"Over"];//划菜数量
                [mutDic setValue:[itemAry objectAtIndex:20]  forKey:@"IsQuit"];//推菜标志（0为退菜，1为正常）
                [mutDic setValue:[itemAry objectAtIndex:21]  forKey:@"QuitCause"];//退菜原因
                [mutDic setValue:[itemAry objectAtIndex:22]  forKey:@"CLASS"];
                [mutDic setValue:[itemAry objectAtIndex:23]  forKey:@"price"];
                if ([itemAry count]>24) {
                    [mutDic setValue:[itemAry objectAtIndex:24] forKey:@"fujiaCount"];
                    [mutDic setValue:[itemAry objectAtIndex:25] forKey:@"Sublistid"];
                    [mutDic setValue:[itemAry objectAtIndex:26] forKey:@"UnitCode"];
                    [mutDic setValue:[itemAry objectAtIndex:27] forKey:@"unitName"];
                    [mutDic setValue:[itemAry objectAtIndex:28] forKey:@"istemp"];
                    [mutDic setValue:[itemAry objectAtIndex:29] forKey:@"tempCode"];
                    [mutDic setValue:[itemAry objectAtIndex:30] forKey:@"tempName"];
                    if ([[itemAry objectAtIndex:28] intValue]==1) {
                        [mutDic setValue:[NSString stringWithFormat:@"%@-%@",[itemAry objectAtIndex:4],[itemAry objectAtIndex:30]] forKey:@"PCname"];
                    }
                }
                [aryResult addObject:mutDic];
            }
            
        }
        [dic setValue:aryResult forKey:@"data"];
        return dic;
    }else
    {
        return nil;
    }
}
#pragma mark  退菜    --------不使用
-(NSDictionary *)chkCode:(NSArray *)array info:(NSDictionary *)info{
    NSArray *dataArray=array;
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSMutableString *mutfood = [NSMutableString string];
    for (NSDictionary *info in array) {
        int count=[[info objectForKey:@"pcount"] intValue]-[[info objectForKey:@"Over"] intValue];
        if([[info objectForKey:@"ISTC"] intValue]==1&&![[info objectForKey:@"Pcode"] isEqualToString:[info objectForKey:@"Tpcode"]]){
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],[info objectForKey:@"PCname"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNAME"],@"0",[NSString stringWithFormat:@"-%@",[info objectForKey:@"CNT"]] ,[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],[info objectForKey:@"fujianame"],[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],[info objectForKey:@"unit"],[info objectForKey:@"ISTC"]];
            [mutfood appendString:@";"];
        }
        else
        {
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],[info objectForKey:@"PCname"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNAME"],@"0",[NSString stringWithFormat:@"-%d",count],[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],[info objectForKey:@"fujianame"],[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],[info objectForKey:@"unit"],[info objectForKey:@"ISTC"]];
            [mutfood appendString:@";"];
        }
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@&rebackReason=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[info objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,mutfood,[info objectForKey:@"INIT"]];
    NSDictionary *dict1 = [self bsService:@"checkFoodAvailable" arg:strParam];
    if (dict1) {
        NSString *result = [[[dict1 objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        if ([[ary1 objectAtIndex:0] intValue]==0) {
            for (NSDictionary *dict in dataArray) {
                FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
                if(![db open])
                {
                    NSLog(@"数据库打开失败");
                    return nil;
                }
                else
                {
                    NSLog(@"数据库打开成功");
                }
                FMResultSet *rs=[db executeQuery:@"select * from AllCheck where PKID=?",[dict objectForKey:@"PKID"]];
                NSString *pcount,*over;
                while ([rs next]) {
                    pcount=[rs stringForColumn:@"pcount"];
                    over=[rs stringForColumn:@"Over"];
                }
                int count=[pcount intValue]-[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue];
                int count1=[over intValue]-[[dict objectForKey:@"pcount"] intValue];
                if (count<1) {
                    NSString *qqq=[NSString stringWithFormat:@"delete from AllCheck WHERE PKID='%@'",[dict objectForKey:@"PKID"]];
                    [db executeUpdate:qqq];
                }
                else
                {
                    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET pcount = '%d',Over='%d' WHERE PKID = '%@'",count,count1,[dict objectForKey:@"PKID"]];
                    [db executeUpdate:str];
                }
                [db close];
                
            }
        }
    }
    return dict1;
}
#pragma mark 菜齐-----------不使用
-(void)suppProductsFinish
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    
    NSDictionary *dict = [self bsService:@"ProductsFinish" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:suppProductsFinishResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    }
    
}

#pragma mark  查询台位列表

- (NSDictionary *)pListTable:(NSDictionary *)info{
    NSString *user,*pdanum,*floor,*area,*status,*tableNum;
    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    floor = [info objectForKey:@"floor"];
    if (!floor)
        floor = @"";
    area = [info objectForKey:@"area"];
    if (!area)
        area = @"";
    status = [info objectForKey:@"state"];
    if (!status)
        status = @"";
    tableNum = [info objectForKey:@"tableNum"];
    if (!tableNum)
        tableNum = @"";
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&area=%@&floor=%@&state=%@&tableNum=%@",pdanum,user,area,floor,status,tableNum];
    NSDictionary *dict = [self bsService:@"pListTable" arg:strParam];
    if (dict){
        NSString *result = [[[dict objectForKey:@"ns:listTablesResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@";"];
        NSMutableArray *mutTables=[[NSMutableArray alloc] init];            //全部台位
        NSMutableArray *freeTableArray=[[NSMutableArray alloc] init];       //空闲台位
        NSMutableArray *occupationTableArray=[[NSMutableArray alloc] init]; //占用台位
        for (NSString *str in ary) {
            NSArray *aryTableInfo = [str componentsSeparatedByString:@"@"];
            NSMutableDictionary *mutTable = [NSMutableDictionary dictionary];
            if ([aryTableInfo count]>=4){
                [mutTable setObject:[aryTableInfo objectAtIndex:1] forKey:@"code"];
                [mutTable setObject:[aryTableInfo objectAtIndex:2] forKey:@"short"];
                [mutTable setObject:[aryTableInfo objectAtIndex:3] forKey:@"name"];
                [mutTable setObject:[aryTableInfo objectAtIndex:4] forKey:@"status"];
                [mutTable setObject:[aryTableInfo objectAtIndex:5] forKey:@"num"];
                [mutTable setObject:[aryTableInfo objectAtIndex:6] forKey:@"man"];
                [mutTables addObject:mutTable];
                
                int status=[[aryTableInfo objectAtIndex:4] intValue];
                if (status==1) {
                    [freeTableArray addObject:mutTable];
                }else if(status==2||status==3||status==10)
                {
                    [occupationTableArray addObject:mutTable];
                }
                
            } else{
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryTableInfo objectAtIndex:1],@"Message", nil];
            }
            
        }
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[NSDictionary dictionaryWithObjectsAndKeys:mutTables,@"tableList",freeTableArray,@"freeTableList",occupationTableArray,@"occupationTableList", nil],@"Message", nil];
    }
    else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[[CVLocalizationSetting sharedInstance] localizedString:@"Query failed"],@"Message", nil];;
    }

}

#pragma mark  发送菜品

- (NSDictionary *)checkFoodAvailable:(NSArray *)ary info:(NSDictionary *)info tag:(int)tag{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];//时间戳
    NSMutableString *mutfood = [NSMutableString string];
    int x = 0;
    //    PLUSD
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dict=[ary objectAtIndex:i];
        NSString *PKID=@"",*Pcode=@"",*Tpcode=@"",*TPNUM=@"",*pcount=@"",*Price=@"",*Weight=@"",*Weightflg=@"",*isTC=@"",*promonum=@"",*UNIT=@"",*promoReason=@"",*unitKay=@"",*istemp=@"0",*DES=@"";
        NSMutableString *Fujiacode,*FujiaName,*FujiaPrice,*FujiaCount;
        Fujiacode=[NSMutableString string];
        FujiaName=[NSMutableString string];
        FujiaPrice=[NSMutableString string];
        FujiaCount=[NSMutableString string];
        Price=[dict objectForKey:@"PRICE"];//价格
        pcount=[dict objectForKey:@"total"];//数量
        Weight=[dict objectForKey:@"Weight"];//第二单位重量
        Weightflg=[dict objectForKey:@"UNITCUR"];//第二单位标示
        promonum=[dict objectForKey:@"promonum"];//赠送数量
        promoReason=[dict objectForKey:@"promoReason"]==nil?@"":[dict objectForKey:@"promoReason"];//赠送原因
        isTC=[dict objectForKey:@"ISTC"];//套餐
        TPNUM=[dict objectForKey:@"TPNUM"];//套餐标示
        UNIT=[dict objectForKey:@"UNIT"];//单位
        NSArray *array=[dict objectForKey:@"addition"];//附加项
        for (NSDictionary *dict1 in array) {
            [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FCODE"]];//附加项编码
            [Fujiacode appendString:@"!"];
            [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FNAME"]];//附加项名称
            [FujiaName appendString:@"!"];
            [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FPRICE"]];//附加项价格
            [FujiaPrice appendString:@"!"];
            [FujiaCount appendFormat:@"%@",[dict1 objectForKey:@"total"]];//附加项价格
            [FujiaCount appendString:@"!"];
            
        }
        /**
         *  判断是套餐名称
         */
        if ([[dict objectForKey:@"ISTC"] intValue]==1&&![dict objectForKey:@"CNT"]) {
            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,x];
            Pcode=[dict objectForKey:@"ITCODE"];
            Tpcode=Pcode;//菜品编码与套餐编码相同
            x++;
        }
        else
        {
            /**
             *  判断是否是套餐明细
             */
            if ([dict objectForKey:@"CNT"])
            {
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,x-1];
                Pcode=[dict objectForKey:@"PCODE1"];//菜品编码
                Tpcode=[dict objectForKey:@"PCODE"];//套餐编码
                pcount=[dict objectForKey:@"total"];//菜品数量
            }
            else
            {
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,i];
                Pcode=[dict objectForKey:@"ITCODE"];
                x++;
            }
        }
        
        if ([isTC intValue]!=1) {
            unitKay=[dict objectForKey:[dict objectForKey:@"UNITKAY"]==nil?@"UNIT1":[dict objectForKey:@"UNITKAY"]];
        }
        
        istemp=[dict objectForKey:@"ISTEMP"];
        DES=[[dict objectForKey:@"ISTEMP"] intValue]==1?[dict objectForKey:@"DES"]:@"";
        [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",PKID,Pcode,@"",Tpcode,@"",TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC,promoReason,FujiaCount,unitKay,istemp,DES];
        [mutfood appendString:@";"];
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@&rebackReason=&immediateOrWait=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,mutfood,[info objectForKey:@"immediateOrWait"]];
    
    NSDictionary *dict3 = [self bsService:@"checkFoodAvailable" arg:strParam];
    if (dict3 && [Singleton sharedSingleton].isYudian==NO) {
        NSString *result = [[[dict3 objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        NSString *str=[ary1 objectAtIndex:0];
        if ([str isEqualToString:@"0"]) {
            [self delectCache];
        }
    }
    return dict3;
}

#pragma mark  查询已发送的菜品（已不用）
+(NSArray *)tableNum:(NSString *)table orderID:(NSString *)order
{
    
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@'and orderId='%@' and send='%@'",table,order,@"1"]];
    return ary;
}

#pragma mark  调用登录接口
- (NSDictionary *)pLoginUser:(NSDictionary *)info{
    NSString *user,*pwd;
    user = [info objectForKey:@"userCode"];
    pwd = [info objectForKey:@"usePass"];
    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&handvId=%@&userCode=%@&userPass=%@",pdaid,[self UUIDString],user,pwd];
    NSDictionary *dict = [[self bsService:@"pLoginUser" arg:strParam] objectForKey:@"ns:loginResponse"];
    
    return dict;
}
#pragma mark 提单
-(NSDictionary *)getOrderByAuthCode:(NSDictionary *)info{
    NSString *pdaid,*user,*table,*mancount,*womancounts,*openTag;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    table = [info objectForKey:@"name"];//台位号
    mancount = [info objectForKey:@"man"];//男人数
    womancounts = [info objectForKey:@"woman"];//女人数
    openTag=[info objectForKey:@"openTag"];
    NSDictionary *jsonDic=[NSDictionary dictionaryWithObjectsAndKeys:table,@"tablenum",mancount,"manPeolenum",womancounts,@"womancounts",[info objectForKey:@"auth_code"],@"auth_code", nil];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&json=%@",pdaid,user,[jsonDic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"getOrderByAuthCode" arg:strParam];
    if (dict) {
        if ([[dict objectForKey:@"return"] intValue]==0) {
            NSMutableArray *foodArray=[[NSMutableArray alloc] init];
            for (NSDictionary *food in [[dict objectForKey:@"remsg"] objectForKey:@"listNetOrderDtl"]) {
                NSMutableDictionary *foodDic=[[NSMutableDictionary alloc] init];
                [foodDic setObject:[food objectForKey:@"foodsid"] forKey:@"PKID"];
                [foodDic setObject:[food objectForKey:@"foodsname"] forKey:@"DES"];
                [foodDic setObject:[food objectForKey:@"price"] forKey:@"PRICE"];
                [foodDic setObject:[food objectForKey:@"foodnum"] forKey:@"total"];
                [foodDic setObject:@"1" forKey:@"UNITCUR"];
                [foodDic setObject:[food objectForKey:@"ispackage"] forKey:@"ISTC"];
                [foodDic setObject:[food objectForKey:@"pcode"] forKey:@"ITCODE"];
                [foodDic setObject:[food objectForKey:@"unitcode"] forKey:@"UNIT1"];
                [foodDic setObject:[food objectForKey:@"unit"] forKey:@"UNIT"];
                [foodDic setObject:@"0" forKey:@"ISTEMP"];
                [foodDic setObject:@"UNIT1" forKey:@"UNITKAY"];
                NSMutableArray *additionAry=[[NSMutableArray alloc] init];
                if ([food objectForKey:@"remark"]&&[[food objectForKey:@"remark"]length]>0) {
                    NSMutableDictionary *additionDic=[[NSMutableDictionary alloc] init];
                    [additionDic setObject:@"" forKey:@"FCODE"];
                    [additionDic setObject:[food objectForKey:@"remark"] forKey:@"FNAME"];
                    [additionDic setObject:@"" forKey:@"FPRICE"];
                    [additionDic setObject:@"PRODUCTTC_ORDER" forKey:@"PRODUCTTC_ORDER"];
                    [additionDic setObject:@"1" forKey:@"count"];
                    [additionDic setObject:@"自定义" forKey:@"name"];
                    [additionAry addObject:additionDic];
                }
                for (NSDictionary *dict in [food objectForKey:@"listDishAddItem"]) {
                    NSMutableDictionary *additionDic=[[NSMutableDictionary alloc] init];
                    [additionDic setObject:[dict objectForKey:@"fcode"] forKey:@"FCODE"];
                    [additionDic setObject:[dict objectForKey:@"redefineName"] forKey:@"FNAME"];
                    [additionDic setObject:[dict objectForKey:@"nprice"] forKey:@"FPRICE"];
                    [additionDic setObject:[dict objectForKey:@"ncount"] forKey:@"count"];
                    [additionAry addObject:additionDic];
                }
                if ([[foodDic objectForKey:@"ISTC"] intValue]==1) {
                    NSMutableArray * comboAry=[[NSMutableArray alloc] init];
                    for (NSDictionary *dict in [food objectForKey:@"listDishTcItem"]) {
                        NSMutableDictionary * comboDic=[[NSMutableDictionary alloc] init];
                        [comboDic setObject:[dict objectForKey:@"pk_orderpackagedetail"] forKey:@"PKID"];
                        [comboDic setObject:[dict objectForKey:@"tcpname"] forKey:@"DES"];
                        [comboDic setObject:[dict objectForKey:@"pcode"] forKey:@"PCODE1"];
                        [comboDic setObject:[foodDic objectForKey:@"ITCODE"] forKey:@"PCODE"];
                        [comboDic setObject:[foodDic objectForKey:@"tcprice"] forKey:@"PPRICE"];
                        [comboDic setObject:[dict objectForKey:@"unit"] forKey:@"UNIT"];
                        [comboDic setObject:@"1" forKey:@"ISTC"];
                        [comboDic setObject:[dict objectForKey:@"tcfoodnum"] forKey:@"total"];
                        [comboDic setObject:[dict objectForKey:@"unitcode"] forKey:@"UNIT1"];
                        [comboDic setObject:@"UNIT1" forKey:@"UNITKAY"];
                        NSMutableArray *comboAdditionAry=[[NSMutableArray alloc] init];
                        if ([food objectForKey:@"tcremark"]&&[[food objectForKey:@"tcremark"]length]>0) {
                            NSMutableDictionary *additionDic=[[NSMutableDictionary alloc] init];
                            [additionDic setObject:@"" forKey:@"FCODE"];
                            [additionDic setObject:[food objectForKey:@"tcremark"] forKey:@"FNAME"];
                            [additionDic setObject:@"" forKey:@"FPRICE"];
                            [additionDic setObject:@"PRODUCTTC_ORDER" forKey:@"PRODUCTTC_ORDER"];
                            [additionDic setObject:@"1" forKey:@"count"];
                            [additionDic setObject:@"自定义" forKey:@"name"];
                            [comboAdditionAry addObject:additionDic];
                        }
                        for (NSDictionary *dict in [food objectForKey:@"tclistDishAddItem"]) {
                            NSMutableDictionary *additionDic=[[NSMutableDictionary alloc] init];
                            [additionDic setObject:[dict objectForKey:@"fcode"] forKey:@"FCODE"];
                            [additionDic setObject:[dict objectForKey:@"redefineName"] forKey:@"FNAME"];
                            [additionDic setObject:[dict objectForKey:@"nprice"] forKey:@"FPRICE"];
                            [additionDic setObject:[dict objectForKey:@"ncount"] forKey:@"count"];
                            [comboAdditionAry addObject:additionDic];
                        }
                        [comboAry addObject:comboDic];
                    }
                    [foodDic setObject:comboAry forKey:@"combo"];
                }
                [foodArray addObject:foodDic];
                [self cache:foodArray];
            }
        }
    }else
    {
        return nil;
    }
    return dict;
}
#pragma mark 开台接口调用
- (NSDictionary *)pStart:(NSDictionary *)info{
    NSString *pdaid,*user,*table,*mancount,*womancounts,*openTag;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    table = [info objectForKey:@"name"];//台位号
    mancount = [info objectForKey:@"man"];//男人数
    womancounts = [info objectForKey:@"woman"];//女人数
    openTag=[info objectForKey:@"openTag"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&manCounts=%@&womanCounts=%@&ktKind=%@&openTablemwyn=%@",pdaid,user,table,mancount,womancounts,openTag,[info objectForKey:@"tag"]];
    NSDictionary *dict = [self bsService:@"pStart" arg:strParam] ;
    if(dict)
    {
        NSString *result = [[[dict objectForKey:@"ns:startcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if ([ary count]==1) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[ary objectAtIndex:0],@"Message", nil];
        }
        /**
         *  开台成功
         */
        if ([[ary objectAtIndex:0] intValue]==0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[ary objectAtIndex:1],@"Message", nil];
            
        }
        else{
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[ary objectAtIndex:1],@"Message", nil];
        }
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"开台失败",@"Message", nil];
    }


}


- (NSDictionary *)dictFromSQL{
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    NSMutableArray *mutAds = [NSMutableArray array];
    NSMutableArray *mutFileList = [NSMutableArray array];
    
    NSMutableArray *mutClass = [NSMutableArray array];
    
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    //   char *errorMsg;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        //Generate Ads & FileList
        //1 Ads
        sqlcmd = @"select * from ads";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                char *name = (char *)sqlite3_column_text(stat, 0);
                [mutAds addObject:[NSString stringWithUTF8String:name]];
            }
        }
        sqlite3_finalize(stat);
        [ret setObject:mutAds forKey:@"Ads"];
        //2 FileList
        sqlcmd = @"select * from imageFile";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                char *name = (char *)sqlite3_column_text(stat, 0);
                [mutFileList addObject:[NSString stringWithUTF8String:name]];
            }
        }
        sqlite3_finalize(stat);
        [ret setObject:mutFileList forKey:@"FileList"];
        
        
        //Generate Main Menu
        //1. Get image,name of MainMenu
        sqlcmd = @"select * from class";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                char *background = (char *)sqlite3_column_text(stat,0);
                int type = sqlite3_column_int(stat, 1);
                char *image = (char *)sqlite3_column_text(stat,2);
                char *name = (char *)sqlite3_column_text(stat, 3);
                char *recommend = (char *)sqlite3_column_text(stat, 4);
                
                NSMutableDictionary *mut = [NSMutableDictionary dictionary];
                [mut setObject:[NSNumber numberWithInt:type] forKey:@"type"];
                if (background)
                    [mut setObject:[NSString stringWithUTF8String:background] forKey:@"background"];
                if (image)
                    [mut setObject:[NSString stringWithUTF8String:image] forKey:@"image"];
                if (name)
                    [mut setObject:[NSString stringWithUTF8String:name] forKey:@"name"];
                if (recommend)
                    [mut setObject:[NSString stringWithUTF8String:recommend] forKey:@"recommend"];
                
                [mutClass addObject:mut];
            }
        }
        sqlite3_finalize(stat);
        
        //2. Genereate by Food
        for (int i=0;i<[mutClass count];i++){
            NSMutableDictionary *mutC = [mutClass objectAtIndex:i];
            NSString *strOrder;
            NSString *strPrice = [[NSUserDefaults standardUserDefaults] stringForKey:@"price"];
            if ([strPrice isEqualToString:@"PRICE"])
                strOrder = @"ITEMNO";
            else if ([strPrice isEqualToString:@"PRICE"])
                strOrder = @"ITEMNO2";
            else
                strOrder = @"ITEMNO3";
            sqlcmd = [NSString stringWithFormat:@"select * from food where GRPTYP = %d and HSTA = 'Y' order by %@",[[[mutClass objectAtIndex:i] objectForKey:@"type"] intValue],strOrder];
            NSMutableArray *foods = [NSMutableArray array];
            if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
                while (sqlite3_step(stat)==SQLITE_ROW) {
                    int count = sqlite3_column_count(stat);
                    NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                    for (int i=0;i<count;i++){
                        char *foodKey = (char *)sqlite3_column_name(stat, i);
                        char *foodValue = (char *)sqlite3_column_text(stat, i);
                        NSString *strKey = nil,*strValue = nil;
                        strKey = nil;
                        strValue = nil;
                        if (foodKey)
                            strKey = [NSString stringWithUTF8String:foodKey];
                        if (foodValue)
                            strValue = [NSString stringWithUTF8String:foodValue];
                        if (strKey && strValue)
                            [mutDC setObject:strValue forKey:strKey];
                    }
                    [foods addObject:mutDC];
                }
            }
            sqlite3_finalize(stat);
            
            if (foods && [foods count]>0)
                [mutC setObject:foods forKey:@"SubMenu"];
        }
        
        if (mutClass && [mutClass count]>0)
            [ret setObject:mutClass forKey:@"MainMenu"];
    }
    sqlite3_close(db);
    return ret;
}

#pragma mark  根据类别查询所有的菜品

+ (NSMutableArray *)getFoodList:(NSString *)cmd{
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where %@ ORDER BY cast(isortno as int) ASC",cmd]];
    if ([ary count]==0) {
        ary = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where %@ ORDER BY cast(item as int) ASC",cmd]];
    }
    NSArray *unitArray=[BSDataProvider getDataFromSQLByCommand:@"select * from measdoc"];
    for (NSDictionary *dict in ary) {
        for (int i=0; i<6; i++) {
            if ([[dict objectForKey:[NSString stringWithFormat:@"UNIT%d",i+1]] length]>0&&![[dict objectForKey:[NSString stringWithFormat:@"UNIT%d",i+1]] isEqualToString:[NSString stringWithFormat:@"~_UNIT%d_~",i+1]]) {
                for (NSDictionary *unit in unitArray) {
                    if ([[dict objectForKey:[NSString stringWithFormat:@"UNIT%d",i+1]] isEqualToString:[unit objectForKey:@"code"]]) {
                        [dict setValue:[unit objectForKey:@"name"] forKey:[NSString stringWithFormat:@"UNITS%d",i+1]];
                        if (i>=1) {
                            //多规格加标识
                            [dict setValue:@"1" forKey:@"ISUNITS"];
                        }
                        break;
                    }
                }
                
            }
        }
    }
    return [NSMutableArray arrayWithArray:ary];
}
#pragma mark 中餐查询菜品
+ (NSMutableArray *)ZCgetFoodList:(NSString *)cmd{
    NSMutableArray *ary = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where %@ ORDER BY cast(item as int) ASC",cmd]];
    return [NSMutableArray arrayWithArray:ary];
}
#pragma mark 根据类别查询菜品
-(NSMutableArray *)getAllFoodList:(NSArray *)classAry
{
    NSMutableArray *foodList=[[NSMutableArray alloc] init];
    for (int i=0; i<[classAry count]; i++) {
        NSArray *ary=[[NSArray alloc] init];
        ary = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where class='%@' ORDER BY cast(isortno as int) ASC",[[classAry objectAtIndex:i] objectForKey:@"GRP"]]];
        if ([ary count]==0) {
            ary = [BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where class='%@' ORDER BY cast(item as int) ASC",[[classAry objectAtIndex:i] objectForKey:@"GRP"]]];
        }
        [foodList addObject:ary];
    }
    return foodList;
}
#pragma mark 查询菜品单位
-(NSArray *)measdocArray
{
    return [BSDataProvider getDataFromSQLByCommand:@"select * from measdoc"];
}
#pragma mark 根据套餐编码查询套餐明细
-(NSMutableArray *)combo:(NSDictionary *)tag{
    
    /**
     *  根据套餐编码查询组
     */
    NSArray *groupArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT PNAME,PRICE1,PCODE1,PRODUCTTC_ORDER,MAXCNT,MINCNT FROM products_sub a WHERE defualtS = '0' and pcode='%@' GROUP BY PRODUCTTC_ORDER ORDER BY PRODUCTTC_ORDER  ASC",[tag objectForKey:@"ITCODE"]]];
    NSMutableArray *returnGroupArray=[NSMutableArray array];
    for (NSDictionary *groupDic in groupArray) {
        /**
         *  套餐明细
         */
        NSMutableArray *productArray;
//        if ([[tag objectForKey:@"TCMONEYMODE"] intValue]==2) {
            productArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT c.FUJIAMODE,c.ISTEMP,c.PRICE as PPRICE,c.DES,a.ISTC,a.TCMONEYMODE,b.* FROM food a,food c LEFT JOIN products_sub b ON a.itcode = b.pcode WHERE b.pcode = '%@' AND b.PRODUCTTC_ORDER = '%@' AND c.itcode IN (b.pcode1) ORDER BY defualtS ASC",[tag objectForKey:@"ITCODE"],[groupDic objectForKey:@"PRODUCTTC_ORDER"]]];
//        }else
//        {
//            productArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT a.*, b.*,c.FUJIAMODE AS FUJIAMODE,c.ISTEMP as ISTEMP,b.PNAME FROM food a,food c LEFT JOIN products_sub b ON a.itcode = b.pcode WHERE b.pcode = '%@' AND b.PRODUCTTC_ORDER = '%@' AND c.itcode in (b.pcode1) ORDER BY defualtS ASC",[tag objectForKey:@"ITCODE"],[groupDic objectForKey:@"PRODUCTTC_ORDER"]]];
//        }
//        
        /**
         *  将改组的最大最小数量放入数据中
         */
        for (NSDictionary *dict in productArray) {
            [dict setValue:[groupDic objectForKey:@"MAXCNT"] forKey:@"TYPMAXCNT"];
            [dict setValue:[groupDic objectForKey:@"MINCNT"] forKey:@"TYPMINCNT"];
            
        }
        /**
         *  删除 defualtS=0的数据
         */
        if ([productArray count]>1) {
            [productArray removeObjectAtIndex:0];
        }
        /**
         *  将菜品放在分组的数组中
         */
        [returnGroupArray addObject:productArray];
    }
    return returnGroupArray;
}
#pragma mark  查询全部的套餐明细
-(NSMutableArray *)allCombo{
    /**
     *  获取套餐编码
     */
    NSArray *pcodeArray=[BSDataProvider getDataFromSQLByCommand:@"SELECT PCODE from products_sub where defualtS = '0' AND PRODUCTTC_ORDER=1 ORDER BY pcode ASC"];
    /**
     *  返回的数组
     */
    NSMutableArray *returnArray=[NSMutableArray array];
    for (NSDictionary *pcodeDic in pcodeArray) {
        /**
         *  根据套餐编码查询组
         */
        NSArray *groupArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT PNAME,PRICE1,PCODE1,PRODUCTTC_ORDER,MAXCNT,MINCNT FROM products_sub a WHERE defualtS = '0' and pcode='%@' GROUP BY PRODUCTTC_ORDER ORDER BY PRODUCTTC_ORDER  ASC",[pcodeDic objectForKey:@"PCODE"]]];
        NSMutableArray *returnGroupArray=[NSMutableArray array];
        for (NSDictionary *groupDic in groupArray) {
            /**
             *  套餐明细
             */
            NSMutableArray *productArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT a.*,b.*,c.PRICE AS FPRICE,c.CLASS AS FCLASS FROM food a left JOIN products_sub b on a.ITCODE=b.pcode left JOIN food c ON b.PCODE1=c.ITCODE WHERE b.pcode='%@' and PRODUCTTC_ORDER='%@' ORDER BY defualtS ASC",[pcodeDic objectForKey:@"PCODE"],[groupDic objectForKey:@"PRODUCTTC_ORDER"]]];
            /**
             *  将改组的最大最小数量放入数据中
             */
            for (NSDictionary *dict in productArray) {
                [dict setValue:[groupDic objectForKey:@"MAXCNT"] forKey:@"TYPMAXCNT"];
                [dict setValue:[groupDic objectForKey:@"MINCNT"] forKey:@"TYPMINCNT"];
            }
            /**
             *  删除 defualtS=0的数据
             */
            if ([productArray count]>1) {
                [productArray removeObjectAtIndex:0];
            }
            /**
             *  将菜品放在分组的数组中
             */
            [returnGroupArray addObject:productArray];
        }
        /**
         *  将组数组放在返回的数组中
         */
        [returnArray addObject:returnGroupArray];
    }
    return returnArray;
}

#pragma mark  催菜
- (NSDictionary *)pGogo:(NSArray *)array{
    NSString *user;
    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSMutableString *mutfood = [NSMutableString string];
    for (NSDictionary *info in array) {
        [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],@"",[info objectForKey:@"Tpcode"],@"",[info objectForKey:@"TPNUM"],[info objectForKey:@"pcount"],[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],@"",[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],[info objectForKey:@"UnitCode"],[info objectForKey:@"ISTC"],[info objectForKey:@"Sublistid"],[info objectForKey:@"istemp"]];
        [mutfood appendString:@";"];
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",pdaid,user,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,mutfood];
    
    NSDictionary *dict = [self bsService:@"pGogo" arg:strParam];
    return dict;
}

#pragma mark 团购验证（已不用）
-(NSString *)consumerCouponCode:(NSDictionary *)info
{
    NSString *vcCode=[[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
    NSString *strParam = [NSString stringWithFormat:@"?&type=%@&code=%@&vscode=%@&vsname=&sqnum=%@&userName=%@&token=%@&userEmail=%@&voperator=%@",[info objectForKey:@"CONPONCODE"],[info objectForKey:@"num"],vcCode,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"USERNAME"],[info objectForKey:@"TOKEN"],[info objectForKey:@"USEREMAIL"],[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *dict = [self bsService:@"consumerCouponCode" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:consumerCouponCodeResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        return result;
    }else
    {
        return [NSString stringWithFormat:@"%@",dict];
    }
}
#pragma mark 取消支付
-(NSArray *)cancleUserPayment
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"cancleUserPayment" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:cancleUserPaymentResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        return ary1;
    }else
    {
        return nil;
    }
}
///**
// *  取消优惠
// *
// *  @return
// */
//-(NSArray *)cancleUserCounp
//{
//    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
//    NSDictionary *dict = [self bsService:@"cancleUserCounp" arg:strParam];
//    if (dict) {
//        NSString *result = [[[dict objectForKey:@"ns:cancleUserCounpResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
//        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
//        return ary1;
//    }else
//    {
//        return nil;
//    }
//
//}
#pragma mark 使用优惠
-(NSArray *)userCounp:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@&counpId=%@&counpCnt=%@&counpMoney=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"counpId"],[info objectForKey:@"counpCnt"],[info objectForKey:@"counpMoney"]];
    NSDictionary *dict = [self bsService:@"userCounp" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:userCounpResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        return ary1;
    }else
    {
        return nil;
    }
}
///**
// *  使用优惠
// *
// *  @param info 优惠信息
// *
// *  @return
// */
//-(NSArray *)userPayment:(NSDictionary *)info
//{
//    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@&paymentId=%@&paymentCnt=%@&mpaymentMoney=%@&payFinish=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"paymentId"],[info objectForKey:@"paymentCnt"],[info objectForKey:@"mpaymentMoney"],[info objectForKey:@"payFinish"]];
//    NSDictionary *dict = [self bsService:@"userPayment" arg:strParam];
//    if (dict) {
//        NSString *result = [[[dict objectForKey:@"ns:userPaymentResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
//        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
//        return ary1;
//    }else
//    {
//        return nil;
//    }
//}

#pragma mark - 中餐相关
#pragma mark  登录
- (NSDictionary *)ZCLoginUser:(NSDictionary *)info{
    NSString *user,*pwd;
    
    user = [info objectForKey:@"userCode"];
    pwd = [info objectForKey:@"usePass"];
    
    
    NSString *strParam = [NSString stringWithFormat:@"?user=%@&pass=%@&padid=%@&handvId=%@",user,pwd,[NSString stringWithFormat:@"%@-8",[self padID]],[self UUIDString]];
    
    NSDictionary *dict = [self bsService:@"ZCLogin" arg:strParam];
    
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        if ([ary count]==1) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[ary objectAtIndex:0],@"Message", nil];
        }
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSRange range = [content rangeOfString:@"ok"];
        result = [[content componentsSeparatedByString:@":"] objectAtIndex:1];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",result,@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",result,@"Message", nil];
    }
    
    return dict;
}
#pragma mark  台位列表信息
- (NSDictionary *)ZCpListTable:(NSDictionary *)info//中餐台位列表
{
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    
    NSString *user,*pdanum,*floor,*area,*status,*pwd;
    NSString *cmd;
    
    //    //   user = [NSString stringWithFormat:@"%@-%@",[info objectForKey:@"user"],[info objectForKey:@"pwd"]];
    user =[[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    //    [info objectForKey:@"user"];
    //    pwd =@"12369";
    //    [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
    pdanum = [NSString stringWithFormat:@"%@-8",[self padID]];
    floor = [info objectForKey:@"Floor"];
    if (!floor)
        floor = @"";
    area = [info objectForKey:@"area"];
    if (!area)
        area = @"";
    status = [info objectForKey:@"status"];
    if (!status)
        status = @"";
    
    
    cmd = [NSString stringWithFormat:@"+listtable<user:%@;pdanum:%@;floor:%@;area:%@;status:%@;>\r\n",user,pdanum,floor,area,status];
    
    NSString *strParam = [NSString stringWithFormat:@"?user=%@&floor=%@&area=%@&status=%@&pdaid=%@&irecno=",user,floor,area,status,pdanum];
    NSDictionary *dict = [self bsService:@"ZCListTable" arg:strParam];
    
    if (dict){
        
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        
        if (ary.count>1){
            NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
            NSArray *array=[content componentsSeparatedByString:@":"];
            if ([array count]<=2){
                
                //            NSRange range = [content rangeOfString:@"ok"];
                //             if (range.location!=NSNotFound){
                [mut setObject:[NSNumber numberWithBool:YES] forKey:@"Result"];
                
                NSArray *aryTables = [content componentsSeparatedByString:@"|"];
                
                NSMutableArray *mutTables = [[NSMutableArray alloc] init];
                NSMutableArray *freeTables=[[NSMutableArray alloc] init];
                NSMutableArray *usingTables=[[NSMutableArray alloc] init];
                for (NSString *strTable in aryTables){
                    
                    NSArray *aryTableInfo = [strTable componentsSeparatedByString:@"^"];
                    NSMutableDictionary *mutTable = [NSMutableDictionary dictionary];
                    
                    if ([aryTableInfo count]>=4){
                        [mutTable setObject:[aryTableInfo objectAtIndex:0] forKey:@"code"];
                        [mutTable setObject:[aryTableInfo objectAtIndex:1] forKey:@"short"];
                        [mutTable setObject:[aryTableInfo objectAtIndex:2] forKey:@"name"];
                        [mutTable setObject:[aryTableInfo objectAtIndex:4] forKey:@"status"];
                        [mutTable setObject:[aryTableInfo objectAtIndex:3] forKey:@"man"];
                        [mutTable setObject:[aryTableInfo objectAtIndex:5] forKey:@"serial"];
                        [mutTables addObject:mutTable];
                        if([[aryTableInfo objectAtIndex:4] intValue]==2){
                            [freeTables addObject:mutTable];
                        }else if ([[aryTableInfo objectAtIndex:4] intValue]==1||[[aryTableInfo objectAtIndex:4] intValue]==4){
                            [usingTables addObject:mutTable];
                        }
                    }
                    
                }
                
                [mut setObject:[NSDictionary dictionaryWithObjectsAndKeys:mutTables,@"allTable",freeTables,@"freeTable",usingTables,@"usingTable", nil] forKey:@"Message"];
                
                
//                if ([mutTables count]>0)
//                    [[NSNotificationCenter defaultCenter] postNotificationName:msgListTable object:nil userInfo:mut];
            }
            else{
                NSRange range = [content rangeOfString:@"error"];
                if (range.location!=NSNotFound){
//                    [[NSNotificationCenter defaultCenter] postNotificationName:msgListTable object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil]];
                }
            }
        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:msgListTable object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil]];
        }
        
    }
    return mut;
}
#pragma mark  查询区域
- (NSArray *)ZCgetArea{//根据区域区分
    NSMutableArray *ary =[BSDataProvider getDataFromSQLByCommand:@"select * from CODEDESC where code='AR'"];
    return ary;
}
#pragma mark 中餐开台
- (NSDictionary *)ZCStart:(NSDictionary *)info{
    //"+start<pdaid:%s;user:%s;table:%s;peoplenum:%s;waiter:%s;acct:%s;>\r\n")},//3.开台start
    NSString *pdaid,*user,*table,*peoplenum,*waiter,*acct,*pwd;
    //    NSString *cmd;
    
    pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    user =[[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd =[[Singleton sharedSingleton].userInfo objectForKey:@"password"];
    //    [info objectForKey:@"user"];
    //    pwd =@"12369";
    //    [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
    table = [info objectForKey:@"table"];
    peoplenum = [info objectForKey:@"man"];
    waiter = @"";
    if (!waiter)
        waiter = user;
    if (!peoplenum)
        peoplenum = @"0";
    acct = @"1";
    
    
    
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&acct=%@&tblInit=%@&pax=%@&waiter=%@&typ=%@",pdaid,user,acct,table,peoplenum,waiter,[[info objectForKey:@"openTag"] intValue]==1?@"0":@"1"];
    NSDictionary *dict = [self bsService:@"ZCStart" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent objectAtIndex:1],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent objectAtIndex:1],@"Message", nil];
    }
    return nil;
    //   点击确定后后跳出一个窗口，输入人数和服务员号，以及工号密码，服务员号和人数可不输，人数不输为0，服务员好为空。
    
}
#pragma mark 中餐换台
- (NSDictionary *)ZCChangeTable:(NSDictionary *)info{
    //+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n")},//6.换台changetable
    //+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n
    NSString *pdaid,*user,*oldtable,*newtable,*pwd;
    
    
    pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd = [[Singleton sharedSingleton].userInfo objectForKey:@"password"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
    oldtable = [info objectForKey:@"oldtable"];
    newtable = [info objectForKey:@"newtable"];
    
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&oldTblInit=%@&newTblInit=%@",pdaid,user,oldtable,newtable];
    NSDictionary *dict = [self bsService:@"ZCSignTeb" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        if ([result rangeOfString:@"ok"].location==NSNotFound){
            NSString *msg = [[[[result componentsSeparatedByString:@"error:"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",msg,@"Message",nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",nil];
    }
    return nil;
}
/**
 *  中餐查询菜品
 *
 *  @param cmd 类别编码
 *
 *  @return
 */
//+ (NSMutableArray *)ZCgetFoodList:(NSString *)cmd{
//    NSMutableArray *ary = [NSMutableArray array];
//        if ([cmd intValue]==88)
//            ary=[BSDataProvider getDataFromSQLByCommand:@"select * from PACKAGE"];
////            sqlcmd=@"select * from PACKAGE";
//        else
//            ary =[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where class=%@ order by cast(ITEM as int) ASC",cmd]];
//    if ([cmd intValue]==88) {
//        for (NSDictionary *dict in ary) {
//            [dict setValue:@"1" forKey:@"ISTC"];
//            [dict setValue:[dict objectForKey:@"PACKID"] forKey:@"ITCODE"];
//        }
//    }
//    return [NSMutableArray arrayWithArray:ary];
//}
#pragma mark 获取是所有的菜品
+(NSMutableArray *)ZCgetAllFoodList:(NSArray *)classAry
{
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    for (int i=0;i<[classAry count];i++) {
        NSDictionary *classDic=[classAry objectAtIndex:i];
        if (i==0) {
            [ary addObject:[BSDataProvider getDataFromSQLByCommand:@"select *,1 as ISTC,PACKID as ITCODE from PACKAGE"]];
        }else
        {
            [ary addObject:[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from food where class=%@ order by cast(ITEM as int) ASC",[classDic objectForKey:@"GRP"]]]];
        }
    }
//    if ([cmd intValue]==88)
//        
//    //            sqlcmd=@"select * from PACKAGE";
//    else
//        
//    if ([cmd intValue]==88) {
//        for (NSDictionary *dict in ary) {
//            [dict setValue:@"1" forKey:@"ISTC"];
//            [dict setValue:[dict objectForKey:@"PACKID"] forKey:@"ITCODE"];
//        }
//    }
    return [NSMutableArray arrayWithArray:ary];
}
#pragma mark 查询套餐里的可换购项
- (NSArray *)getShiftFoodPackage:(NSString *)packageid{
    NSString *cmd = [NSString stringWithFormat:@"select ITEM from PACKDTL where PACKID = %@",packageid];
    NSMutableArray *ary=[[NSMutableArray alloc] init];
    NSArray *ary1 = [BSDataProvider getDataFromSQLByCommand:cmd];
    for (NSDictionary *dict in ary1) {
        NSMutableArray *array=[NSMutableArray array];
        NSString *cmd1 = [NSString stringWithFormat:@"select a.*,b.* from food a, PACKDTL b  where a.item in (select item from PACKDTL where PACKID = %@ and ITEM = %@) and a.ITEM=b.ITEM and b.PACKID=%@",packageid,[dict objectForKey:@"ITEM"],packageid];
        NSArray *ary2 = [BSDataProvider getDataFromSQLByCommand:cmd1];
        NSString *cmd3 = [NSString stringWithFormat:@"select a.*,b.* from food a,ITEMPKG b where a.item in (select SUBITEM from ITEMPKG where PACKID = %@ and ITEM = %@) and a.item=b.SUBITEM",packageid,[dict objectForKey:@"ITEM"]];
        NSArray *ary3 = [BSDataProvider getDataFromSQLByCommand:cmd3];
        [array addObjectsFromArray:ary2];
        [array addObjectsFromArray:ary3];
        [ary addObject:array];
    }
    for (NSDictionary *dict in ary) {
        [dict setValue:packageid forKey:@"Tpcode"];
    }
    return ary;
}
#pragma mark  查询所有的套餐
-(NSMutableArray *)ZCallCombo{
    NSString *str=@"select PACKID,DES from PACKAGE";
    NSMutableArray *allcombo=[NSMutableArray array];
    NSArray *arry=[BSDataProvider getDataFromSQLByCommand:str];
    for (NSDictionary *dic in arry) {
        NSString *packageid=[dic objectForKey:@"PACKID"];
        NSString *cmd = [NSString stringWithFormat:@"select ITEM from PACKDTL where PACKID = %@",packageid];
        NSMutableArray *ary=[[NSMutableArray alloc] init];
        NSArray *ary1 = [BSDataProvider getDataFromSQLByCommand:cmd];
        for (NSDictionary *dict in ary1) {
            NSMutableArray *array=[NSMutableArray array];
            NSString *cmd1 = [NSString stringWithFormat:@"select a.*,b.DES AS tpname,b.PACKID AS tpcode FROM food a LEFT JOIN PACKAGE b where item in (select item from PACKDTL where PACKID = %@ and ITEM = %@) union all select a.*,b.DES AS tpname,b.PACKID AS tpcode FROM food a LEFT JOIN PACKAGE b where item in (select SUBITEM from ITEMPKG where PACKID = %@ and ITEM = %@)",packageid,[dict objectForKey:@"ITEM"],packageid,[dict objectForKey:@"ITEM"]];
            NSArray *ary2 = [BSDataProvider getDataFromSQLByCommand:cmd1];
            [array addObjectsFromArray:ary2];
            [ary addObject:array];
            
        }
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setObject:packageid forKey:@"Tpcode"];
        [dict setObject:[dic objectForKey:@"DES"] forKey:@"tpname"];
            [dict setObject:ary forKey:@"combo"];
        [allcombo addObject:dict];
    }
    return allcombo;
}
#pragma mark  中餐获取附加项
- (NSArray *)ZCgetAdditions{
    NSArray *classAry=[BSDataProvider getDataFromSQLByCommand:@"select RGRP from attach group by RGRP ORDER BY RGRP"];
    NSMutableArray *ary=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in classAry) {
        [ary addObject:[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from attach where RGRP=%@ ORDER BY cast(ITCODE as int) ASC",[dict objectForKey:@"RGRP"]]]];
    }
    return [NSArray arrayWithArray:ary];
    
}
#pragma mark 中餐查询账单

- (NSDictionary *)ZCpQuery{
    NSMutableDictionary *dicMut = [NSMutableDictionary dictionary];
    
    NSString *user,*pwd;
    NSString *pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd = [[Singleton sharedSingleton].userInfo objectForKey:@"password"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
    NSString *table = [Singleton sharedSingleton].Seat;
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&tblInit=%@&irecno=%@",pdaid,user,table,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"pQuery" arg:strParam];
    NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];//[[[[[[dict objectForKey:@"string"] objectForKey:@"text"]  componentsSeparatedByString:@"<Buffer>"] objectAtIndex:1] componentsSeparatedByString:@"</Buffer>"] objectAtIndex:0];
    NSArray *ary = [result componentsSeparatedByString:@"<"];
    if (ary==nil) {
        [dicMut setObject:[NSNumber numberWithBool:NO] forKey:@"Result"];
        [dicMut setObject:@"网络连接超时" forKey:@"Message"];
    }else if ([result rangeOfString:@"error"].location!=NSNotFound){
        [dicMut setObject:[NSNumber numberWithBool:NO] forKey:@"Result"];
        [dicMut setObject:[[[[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1] forKey:@"Message"];
    }else{
        if (![result isEqualToString:@"+query<end>"]){
            
            NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
            
            NSArray *aryFenhao = [content componentsSeparatedByString:@";"];
            NSMutableArray *settlementArray=[NSMutableArray array];
            NSMutableDictionary *Idic=[NSMutableDictionary dictionary];
            [Idic setObject:@"合计金额" forKey:@"name"];
            [Idic setObject:[[[aryFenhao objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] forKey:@"price"];
            [settlementArray addObject:Idic];
            float prict=[[Idic objectForKey:@"price"] floatValue];//账单金额
            if ([aryFenhao count]>3){
                NSString *tab = [[[aryFenhao objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1]; //台位
                NSString *total = [[[aryFenhao objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1];//账单金额
                NSString *people = [[[[[aryFenhao objectAtIndex:2] componentsSeparatedByString:@","] objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1];//人数
                NSString *mo=[NSString string];
                NSArray *classArray=[[aryFenhao objectAtIndex:2] componentsSeparatedByString:@","];
                for (NSString * str in classArray) {
                    NSArray *array=[str componentsSeparatedByString:@":"];
                    if ([[array objectAtIndex:0]isEqualToString:@"String"]) {
                        [Singleton sharedSingleton].man=[array objectAtIndex:1];
                    }else
                    {
                        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                        [dict setObject:[array objectAtIndex:0] forKey:@"name"];
                        [dict setObject:[array objectAtIndex:1] forKey:@"price"];
                        
                        if ([str isEqualToString:[classArray objectAtIndex:1]]) {//折扣
                            prict+=[[array objectAtIndex:1] floatValue];
                            [settlementArray addObject:dict];
                        }else if ([str isEqualToString:[classArray objectAtIndex:2]]){//服务
                            prict+=[[array objectAtIndex:1] floatValue];
                            [settlementArray addObject:dict];
                        }else if ([str isEqualToString:[classArray objectAtIndex:3]]){//免项
                            prict+=[[array objectAtIndex:1] floatValue];
                            [settlementArray addObject:dict];
                        }else if ([str isEqualToString:[classArray objectAtIndex:4]]){//包间
                            prict+=[[array objectAtIndex:1] floatValue];
                            [settlementArray addObject:dict];
                        }else if ([str isEqualToString:[classArray lastObject]]){//结算
                            prict-=[[array objectAtIndex:1] floatValue];
                            [settlementArray addObject:dict];
                            if ([AKsNetAccessClass sharedNetAccess].molingPrice) {
                                NSString  *tatal=[NSString stringWithFormat:@"%d",(int)(prict +1-[[AKsNetAccessClass sharedNetAccess].molingPrice doubleValue])];
//                                [dict setObject:[NSString stringWithFormat:@"%.2f",[tatal doubleValue]-prict] forKey:@"price"];
                                mo=[NSString stringWithFormat:@"%.2f",prict-[tatal doubleValue]];
                            }else
                            {
                                mo=@"0";
                            }
                            NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                            [dict setObject:@"抹零" forKey:@"name"];
                            [dict setObject:[NSString stringWithFormat:@"%.2f",[mo floatValue]] forKey:@"price"];
                            [settlementArray addObject:dict];
                            
                        }
                    }
                }
                if (prict>0) {
                    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                    [dict setObject:@"应付金额" forKey:@"name"];
                    [dict setObject:[NSString stringWithFormat:@"%.2f",prict-[mo doubleValue]] forKey:@"price"];
                    [settlementArray addObject:dict];
                }else
                {
                    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                    [dict setObject:@"应付金额" forKey:@"name"];
                    [dict setObject:@"0" forKey:@"price"];
                    [settlementArray addObject:dict];
                }
                [dicMut setObject:tab forKey:@"tab"];
                [Singleton sharedSingleton].CheckNum=tab;
                [dicMut setObject:total forKey:@"total"];
                [dicMut setObject:people forKey:@"people"];
                
                NSString *account = [[[aryFenhao objectAtIndex:3] componentsSeparatedByString:@":"] objectAtIndex:1];
                NSArray *aryAcc = [account componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
                int countAcc = [aryAcc count];
                
                NSMutableArray *aryMut = [NSMutableArray array];
                for (int i=0;i<countAcc;i++){
                    NSMutableDictionary *mutFood = [NSMutableDictionary dictionary];
                    NSString *strAcc = [aryAcc objectAtIndex:i];
                    NSArray *aryStr = [strAcc componentsSeparatedByString:@"^"];
                    
                    if ([aryStr count]>8){
                        [mutFood setObject:[aryStr objectAtIndex:0] forKey:@"num"];
                        if (![[aryStr objectAtIndex:1] boolValue]) {
                            [mutFood setObject:@"未发" forKey:@"CLASS"];
                        }else
                        {
                            if ([[aryStr objectAtIndex:3] boolValue]) {
                                if ([[aryStr objectAtIndex:4] boolValue]&&[[aryStr objectAtIndex:5] intValue]>0) {
                                    [mutFood setObject:@"起" forKey:@"CLASS"];
                                    [mutFood setValue:[NSString stringWithFormat:@"%d",[[aryStr objectAtIndex:5] intValue]-1]  forKey:@"Urge"];
                                }else
                                {
                                    [mutFood setObject:@"叫" forKey:@"CLASS"];
                                    [mutFood setValue:[aryStr objectAtIndex:5]  forKey:@"Urge"];
                                }
                            }else{
                                
                                [mutFood setObject:@"即" forKey:@"CLASS"];
                                [mutFood setValue:[aryStr objectAtIndex:5]  forKey:@"Urge"];
                            }
                        }
                        
                        if ([[aryStr objectAtIndex:7]length]>0) {
                            [mutFood setObject:[NSString stringWithFormat:@"%@-%@",[aryStr objectAtIndex:7],[aryStr objectAtIndex:8]] forKey:@"PCname"];
                        }else
                        {
                            [mutFood setObject:[aryStr objectAtIndex:8] forKey:@"PCname"];
                        }
                        if ([[aryStr objectAtIndex:2] boolValue]) {
                            [mutFood setValue:@"划"  forKey:@"Over"];
                        }
                        //                        if ([[aryStr objectAtIndex:18] floatValue]>0) {
                        //                            [mutFood setObject:[NSString stringWithFormat:@"%.1f/%@只",[[aryStr objectAtIndex:9] floatValue],[aryStr objectAtIndex:18]] forKey:@"pcount"];
                        //                        }else
                        //                        {
                        [mutFood setObject:[NSString stringWithFormat:@"%.1f",[[aryStr objectAtIndex:9] floatValue]] forKey:@"pcount"];
                        //                        }
                        
                        [mutFood setObject:[aryStr objectAtIndex:10] forKey:@"price"];
                        [mutFood setObject:[aryStr objectAtIndex:11] forKey:@"talPreice"];
                        //                        [mutFood setObject:[aryStr objectAtIndex:12] forKey:@"price"];
                        
                        [mutFood setObject:[aryStr objectAtIndex:13] forKey:@"unit"];
                        [mutFood setObject:[aryStr objectAtIndex:15] forKey:@"UNITCNT"];
                        NSMutableString *str=[NSMutableString string];
                        //                        账单明细号^0
                        //                        是否发送^1
                        //                        是否划菜^2
                        //                        是否 叫起^3
                        //                        是否即起^4
                        //                        催菜次数^5
                        //                        是否赠送^6
                        //                        套餐名称^7
                        //                        菜品名称^8
                        //                        菜品数量^9
                        //                        菜品单 价^10
                        //                        菜品金额^11
                        //                        菜品折扣^12
                        //                        菜品单位1^13
                        //                        菜 品单位2^14
                        //                        是否有修改数量^15
                        //                        赠送数量^16
                        //                        退菜数量^17
                        //                        只数^18
                        //                        附加项1^19
                        //                        附加项2^20
                        //                        附 加项3^21
                        //                        附加项4^22
                        //                        附加项5^23
                        //                        附加项金额 1^24
                        //                        附加项金额2^25
                        //                        附加项金额3^26
                        //                        附加项 金额4^27
                        //                        附加项金额5#(多个菜品之间用 #号隔开)
                        for (int i=19; i<24; i++) {
                            if ([[aryStr objectAtIndex:i] rangeOfString:@"null" options:NSCaseInsensitiveSearch].length==0&&[[aryStr objectAtIndex:i] length]>0) {
                                [str appendFormat:@"%@ ",[aryStr objectAtIndex:i]];
                            }
                        }
                        [mutFood setObject:str forKey:@"fujia"];
                        [aryMut addObject:mutFood];
                    }
                    
                }
                
                [dicMut setObject:aryMut forKey:@"data"];
                [dicMut setObject:settlementArray forKey:@"settlement"];
                [dicMut setObject:mo forKey:@"moling"];
            }
            
        }
    }
    return dicMut;
}
#pragma mark 估清
- (NSDictionary *)checkFoodAvailable:(NSArray *)ary{
    NSString *pdanum = [NSString stringWithFormat:@"%@-8",[self padID]];
    
    NSMutableString *mutfood = [NSMutableString string];
    
    for (int i=0;i<ary.count;i++){
        NSDictionary *foods = [ary objectAtIndex:i];
        //        for (int j=0;j<foods.count;j++){
        //            NSDictionary *food = [foods objectAtIndex:j];
        NSString *foodid = [foods objectForKey:@"ITCODE"];
        NSString *count = [foods objectForKey:@"total"];
        
        [mutfood appendFormat:@"%@^%@",foodid,count];
        [mutfood appendString:@";"];
        //        }
    }
    
    
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&oSerial=%@&user=%@-%@&grantEmp=%@&grantPass=&rsn=",pdanum,mutfood,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].Seat];
    NSDictionary *dict = [self bsService:@"ZCcheckFoodAvailable" arg:strParam];
    NSString *str = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
    
    NSMutableDictionary *mutret = [NSMutableDictionary dictionary];
    BOOL isOK = NO;
    NSString *msg = nil;
    if (str){
        if ([str rangeOfString:@"ok"].location!=NSNotFound){
            isOK = YES;
        }else{
            NSRange start = [str rangeOfString:@":"];
            NSRange end = [str rangeOfString:@">"];
            
            if (start.location!=NSNotFound && end.location!=NSNotFound){
                NSRange sub = NSMakeRange(start.location+1, ((int)end.location-(int)start.location-1)>=0?(end.location-start.location-1):0);
                if (sub.length>0)
                    msg = [str substringWithRange:sub];
                
            }
        }
    }
    
    [mutret setObject:[NSNumber numberWithBool:isOK] forKey:@"Result"];
    if (!isOK){
        [mutret setObject:msg?msg:@"查询沽清失败" forKey:@"Message"];
    }
    return mutret;
}
#pragma mark 发送菜品
- (NSDictionary *)pSendTab:(NSArray *)ary options:(NSDictionary *)info{
    if (ary && [ary count]>0){
        NSString *user,*acct,*tb,*pn,*type,*cmd,*pwd;
        NSMutableString *addition = [NSMutableString string];
        NSMutableString *tablist = [NSMutableString string];
        int tabid,foodnum;
        NSString *pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
        user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
        pwd = [[Singleton sharedSingleton].userInfo objectForKey:@"password"];
        if (pwd)
            user = [NSString stringWithFormat:@"%@-%@",user,pwd];
        tabid = dSendCount++;
        acct = [Singleton sharedSingleton].CheckNum;
        tb = [Singleton sharedSingleton].Seat;
        //        usr = [info objectForKey:@"usr"];
        //        usr = usr?usr:user;
        pn =[Singleton sharedSingleton].man;//@"4";
        if (pn==nil) {
            pn=@"1";
        }
        
        if (0==[pn intValue])
            pn = [Singleton sharedSingleton].man;
        foodnum = [ary count];
        type = [info objectForKey:@"type"];
        [addition appendString:@"|"];
        for (int i=0;i<foodnum;i++){
            NSDictionary *dic = [ary objectAtIndex:i];
            NSMutableArray *aryMut = [[NSMutableArray alloc] init];
            
           
            if ([info objectForKey:@"common"])
                [aryMut addObjectsFromArray:[info objectForKey:@"common"]];
            if ([dic objectForKey:@"addition"])
                [aryMut addObjectsFromArray:[dic objectForKey:@"addition"]];
            if ([[dic objectForKey:@"PRIORMTH"] intValue]==1) {
                [aryMut insertObject:[NSDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"DES"],@"DES",[dic objectForKey:@"PRICE"],@"PRICE1",nil] atIndex:0];
            }
            
            int additionCount = [aryMut count];
            for (int i=0;i<10;i++){
                if (i%2==0){
                    int index = i/2;
                    if (index<additionCount)
                        [addition appendString:[[aryMut objectAtIndex:index] objectForKey:@"DES"]];
                    [addition appendString:@"|"];
                }
                else{
                    int index = (i-1)/2;
                    if (index<additionCount){
                        NSString *additionprice = [[aryMut objectAtIndex:index] objectForKey:@"PRICE1"];
                        if (!additionprice)
                            additionprice = @"0.0";
                        [addition appendString:additionprice];
                    }
                    
                    [addition appendString:@"|"];
                }
                
            }
            
            NSString *TPNUM;
            if (![dic objectForKey:@"num"]) {
                [dic setValue:@"" forKey:@"num"];
            }
            int packid=0,packcnt=0;
            packid = [[dic objectForKey:@"Tpcode"] intValue];
           
            if (packid==0) {
                TPNUM=@"0";
            }else
            {
                TPNUM=[NSString stringWithFormat:@"%d",[[dic objectForKey:@"TPNUM"] intValue]];
                packcnt = 1;
            }
            packid = 0==packid?-1:packid;
            packcnt = -1==packid?0:packcnt;
//            PluseNum
            int PLUSE=[[dic objectForKey:@"PLUSD"] intValue];
            float fTotal = [[dic objectForKey:[dic objectForKey:@"priceKey"]?[dic objectForKey:@"priceKey"]:[[NSUserDefaults standardUserDefaults] stringForKey:@"price"]] floatValue];
            
            [tablist appendFormat:@"%d|%d|%@|%@|%@|%@|%.2f%@0|%@|%@||%@|%@|%@|%@|^",packid,packcnt,[dic objectForKey:@"ITCODE"],PLUSE==0?[dic objectForKey:@"total"]:[dic objectForKey:@"Weight"],[dic objectForKey:[dic objectForKey:@"unitKey"]]==nil?[dic objectForKey:@"UNIT"]:[dic objectForKey:[dic objectForKey:@"unitKey"]],[NSString stringWithFormat:@"%.2f",fTotal],PLUSE==1?[[dic objectForKey:@"total"] floatValue]:0,addition,[dic objectForKey:@"num"],TPNUM,PLUSE==0?@"N":@"Y",[dic objectForKey:@"PKID"],[dic objectForKey:@"foodCall"]==nil?@"N":[dic objectForKey:@"foodCall"],[dic objectForKey:@"PACKAMT"]==nil?@"":[dic objectForKey:@"PACKAMT"]];
            
            addition = [NSMutableString string];
            [addition appendFormat:@"|"];
        }
        NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&pdaSerial=%d&acct=%@&tblInit=%@&waiter=%@&pax=%@&zcnt=%d&typ=%@&buffer=%@",pdaid,user,0,acct,tb,@"",pn,foodnum,type,tablist];
        NSDictionary *dict;
        dict = [self bsService:@"pSendTab" arg:strParam];
        if (dict) {
            
            NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
            NSArray *ary = [result componentsSeparatedByString:@"<"];
            NSRange range = [[ary objectAtIndex:1] rangeOfString:@"ok"];
            if (range.location != NSNotFound) {
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[[[[[ary objectAtIndex:1] componentsSeparatedByString:@"msg:"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0],@"Message",[[[[[ary objectAtIndex:1] componentsSeparatedByString:@"msg"] objectAtIndex:0] componentsSeparatedByString:@":"] objectAtIndex:1],@"tab", nil];
            } else {
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",
                        [[[[[ary objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0],@"Message",nil];
            }
        }
    }
    
    return nil;
    
}
#pragma mark 催菜
- (NSDictionary *)ZCpGogo:(NSArray *)info{
    /**
     *  Description 催菜接口
     *  pdaid       pad编码
     *  user        用户名-密码
     *  acct        账单号
     *  oSerial     菜品num列表
     */
    NSString *user,*pwd;
    NSString *pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd = [[Singleton sharedSingleton].userInfo objectForKey:@"password"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
    int tab = [[Singleton sharedSingleton].CheckNum intValue];
    NSMutableString *str=[NSMutableString string];
    /**
     *  将菜品num用,分割
     */
    for (NSDictionary *dict in info) {
        [str appendFormat:@"%@,",[dict objectForKey:@"num"]];
    }
    [str substringToIndex:([str length]-1)];
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&acct=%d&oSerial=%@",pdaid,user,tab,str];
    
    NSDictionary *dict = [self bsService:@"ZCpGogo" arg:strParam];
    if (dict) {
        //        NSString *strValue = [[dict objectForKey:@"string"] objectForKey:@"text"];
        NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];//[[[[strValue componentsSeparatedByString:@"<oStr>"] objectAtIndex:1] componentsSeparatedByString:@"</oStr>"] objectAtIndex:0];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSRange range = [[ary objectAtIndex:1] rangeOfString:@"ok"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else{
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",
                    [[[[[ary objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0],@"Message",nil];
        }
    }else{
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"催菜失败",@"Message",nil];
    }
    return nil;
}
//pModiOrdrCnt(String pdaid, String user, String oSerial,String cnt, String oCnt, String oStr)
#pragma mark 修改人数
-(NSDictionary *)ZCpModiOrdrCnt:(NSDictionary *)info
{
    NSString *pdaid,*user;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user  =  [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&oSerial=%@&cnt=%@&oCnt=%@",pdaid,user,[info objectForKey:@"num"],[info objectForKey:@"oCnt"],[info objectForKey:@"pcount"]];
    
    NSDictionary *dict = [self bsService:@"ZCpModiOrdrCnt" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"result"] objectForKey:@"text"];
        if ([result intValue]==1) {
            return  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"修改成功",@"Message", nil];
        }else
        {
            return  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"修改失败",@"Message", nil];
        }
    }
    return nil;
}
#pragma mark 打印
- (NSDictionary *)ZCpPrintQuery:(NSDictionary *)info{
    //+printquery<pdaid:%s;user:%s;tab:%s;type:%s;>\r\n"
    NSString *pdaid,*user,*tab,*type,*pwd;
    
    
    pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    user  =  [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd =   [[Singleton sharedSingleton].userInfo objectForKey:@"password"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
    tab = [Singleton sharedSingleton].CheckNum;
    type = [info objectForKey:@"type"];
    
    
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&acct=%@&typ=%@",pdaid,user,tab,type];
    
    NSDictionary *dict = [self bsService:@"ZCPrintquery" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"Root"] objectForKey:@"OStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if ([aryContent count]<3) {
            return  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"打印失败",@"Message", nil];
        }
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent objectAtIndex:2],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent objectAtIndex:2],@"Message", nil];
    }
    return nil;
}
#pragma mark 查询退菜原因
- (NSMutableArray *)getCodeDesc{
    NSMutableArray *ary = [NSMutableArray array];
    ary=[BSDataProvider getDataFromSQLByCommand:@"select * from codedesc"];
    return ary;
}
#pragma mark 退菜
- (NSDictionary *)pChuck:(NSDictionary *)info{
    NSString *user,*userid,*pwd,*tab,*reason,*foodnum;
    /*
     function pChuck(PdaID,User,GrantEmp,GrantPass,oSerial,Rsn,Cnt,oStr:PChar):PChar; stdcall; //退菜
     
     参数说明：
     PdaID       :PDA号 //格式'1-1'第一个1为PDA编码，第二个为餐厅号 ，默认为1
     USER        :工号
     GrantEmp    :授权人工号
     GrantPass   :授权人密码
     oSerial     :菜品流水号
     Rsn         :退菜原因码
     Cnt         :退菜数量
     oStr        :返回值
     */
    NSString *pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    userid = [info objectForKey:@"user"];
    pwd = [info objectForKey:@"pwd"];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    //    if (pwd)
    user = [NSString stringWithFormat:@"%@-%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"]];
    
    tab = [[[info objectForKey:@"account"] objectAtIndex:0] objectForKey:@"num"];
    reason = [info objectForKey:@"rsn"];
    foodnum = [info objectForKey:@"total"];
    
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&grantEmp=%@&grantPass=%@&oSerial=%@&rsn=%@&cnt=%@",pdaid,user,userid,pwd,tab,reason,foodnum];
    
    
    NSDictionary *dict = [self bsService:@"pChuck" arg:strParam];
    //    NSString *strValue = [[dict objectForKey:@"string"] objectForKey:@"text"];
    if (dict){
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];//[[[[strValue componentsSeparatedByString:@"<oStr>"] objectAtIndex:1] componentsSeparatedByString:@"</oStr>"] objectAtIndex:0];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSRange range = [[ary objectAtIndex:1] rangeOfString:@"ok"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result", nil];
        }
        else{
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",
                    [[[[[ary objectAtIndex:1] componentsSeparatedByString:@":"] objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0],@"Message",nil];
        }
    }
    return nil;
}

#pragma mark 取消开台
- (NSDictionary *)ZCpOver:(NSDictionary *)info{
    //+over<pdaid:%s;user:%s;table:%s;>\r\n")},4.取消开台
    /*
     
     */
    NSString *pdaid,*user,*table;
    
    pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    user = [NSString stringWithFormat:@"%@-%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"]];
    
    table = [info objectForKey:@"table"];
    
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&tblInit=%@",pdaid,user,table];
    NSDictionary *dict = [self bsService:@"pOver" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent lastObject],@"Message", nil];
    }
    return nil;
}
#pragma mark  清理脏台
- (NSDictionary *)ZCpClearTable:(NSDictionary *)info{
    //+over<pdaid:%s;user:%s;table:%s;>\r\n")},4.取消开台
    /*
     
     */
    NSString *pdaid,*user,*table;
    
    pdaid = [NSString stringWithFormat:@"%@-8",[self padID]];
    user = [NSString stringWithFormat:@"%@-%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"]];
    
    table = [info objectForKey:@"table"];
    
    NSString *strParam = [NSString stringWithFormat:@"?pdaid=%@&user=%@&tblInit=%@",pdaid,user,table];
    NSDictionary *dict = [self bsService:@"ZCpClearTable" arg:strParam];
    return [dict objectForKey:@"result"];
}

#pragma mark 接口划菜
/**
 *  Description 接口划菜
 *
 *  @param dish 菜品数组
 *
 *  @return
 */
-(NSDictionary *)ZCscratch:(NSArray *)dish
{
    /*
     * @Description:通过台位号查询账单号和人数
     * @Title:getFolioNo
     * @Author:dwh
     * @Date:2014-6-23 下午3:58:14
     * @param pdaid pad编号
     * @param user 用户编号
     * @param folioNo 账单号
     * @param serials 菜品
     * @param  flag   N划菜 Y反划菜
     */
    NSMutableString *mutfood = [NSMutableString string];
    NSMutableString *fanfood=[NSMutableString string];
    for (NSDictionary *info in dish) {
        if ([info objectForKey:@"Over"]) {
            [fanfood appendFormat:@"%@",[info objectForKey:@"num"]];
            [fanfood appendString:@"^"];
        }
        else
        {
            [mutfood appendFormat:@"%@",[info objectForKey:@"num"]];
            [mutfood appendString:@"^"];
        }
    }
    if (![mutfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&folioNo=%@&serials=%@&flag=Y",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum,mutfood];
        NSDictionary *dict = [self bsService:@"ZCdrawItems" arg:strParam];
        if ([[[[dict objectForKey:@"root"] objectForKey:@"result"] objectForKey:@"text"] boolValue]!=YES) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"划菜失败",@"Message", nil];
        }
    }
    if (![fanfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&folioNo=%@&serials=%@&flag=N",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum,fanfood];
        NSDictionary *dict = [self bsService:@"ZCdrawItems" arg:strParam];
        if ([[[[dict objectForKey:@"root"] objectForKey:@"result"] objectForKey:@"text"] boolValue]!=YES) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"反划菜失败",@"Message", nil];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"成功",@"Message", nil];;
}
#pragma mark 手势划菜

-(NSString *)ZCscratch:(NSDictionary *)info andtag:(int)tag
{
    /*
     * @Description:通过台位号查询账单号和人数
     * @Title:getFolioNo
     * @Author:dwh
     * @Date:2014-6-23 下午3:58:14
     * @param pdaid pad编号
     * @param user 用户编号
     * @param folioNo 账单号
     * @param serials 菜品
     * @param  flag   N划菜 Y反划菜
     */
    NSMutableString *fanfood=[NSMutableString string];
    [fanfood appendFormat:@"%@",[info objectForKey:@"num"]];
    [fanfood appendString:@"^"];
    if (tag==0) {
        //        if ([[info objectForKey:@"Over"] intValue]==[[info objectForKey:@"pcount"] intValue]) {
        //        NSString *str2;
        NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&folioNo=%@&serials=%@&flag=N",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum,fanfood];
        NSDictionary *dict = [self bsService:@"ZCdrawItems" arg:strParam];
        return strParam;
    }else
    {
        //        NSString *str;
        NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&folioNo=%@&serials=%@&flag=Y",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum,fanfood];
        NSDictionary *dict = [self bsService:@"ZCdrawItems" arg:strParam];
        return strParam;
    }
}
#pragma mark 通过台位号查询账单号和人数
-(NSDictionary *)getFolioNo:(NSString *)table
{
    /*
     * @Description:通过台位号查询账单号和人数
     * @Title:getFolioNo
     * @Author:dwh
     * @Date:2014-6-23 下午3:58:14
     * @param pdaid pad编号
     * @param user 用户编号
     * @param tblInit 台位
     * @param
     */
    NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&tblInit=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],table];
    NSDictionary *dict = [self bsService:@"ZCgetFolioNo" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[[aryContent lastObject] componentsSeparatedByString:@"^"],@"Message", nil];
    }
    return nil;
}
#pragma mark 修改人数
-(NSDictionary *)modifyPax:(NSString *)order
{
    /*
     * @Description:修改人数
     * @Title:modifyPax
     * @Author:dwh
     * @Date:2014-6-23 下午3:58:14
     * @param pdaid pad编号
     * @param user 用户编号
     * @param folioNo 账单号
     * @param pax 人数
     */
    NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&folioNo=%@&pax=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum,order];
    NSDictionary *dict = [self bsService:@"ZCmodifyPax" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent lastObject],@"Message", nil];
    }
    return nil;
}
#pragma mark 查询支付方式
/**
 *  Description 查询支付方式
 *
 *  @return 支付方式的数据
 */
-(NSArray *)selecePayment
{
    NSArray *ary=[NSArray array];
    ary=[BSDataProvider getDataFromSQLByCommand:@"select * from paytyp"];
    for (NSDictionary *dic in ary) {
        NSArray *array1=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from payment where typ=%@",[dic objectForKey:@"cod"]]];
        [dic setValue:array1 forKey:@"payment"];
    }
    return ary;
}
#pragma mark 支付
-(NSDictionary *)ZCuserPayment:(NSDictionary *)info
{
    /*
     * @Description:支付接口
     * @Title:userPayment
     * @Author:dwh
     * @Date:2014-6-23 下午3:58:14
     * @param pdaid pad编号
     * @param user 用户编号
     * @param serial 账单号
     * @param cnt 数量
     * @param amt 金额
     * @param payment 支付方式
     * @param foliounite
     * @param flag 是否支付完成 （N:表示未支付完成 Y:表示支付完成）
     * @param nbzero 抹零金额
     * @return
     */
    NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&serial=%@&cnt=1&amt=%@&payment=%@&foliounite=0&flag=%@&nbzero=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum,[info objectForKey:@"paymentMoney"],[info objectForKey:@"payment"],[info objectForKey:@"flag"],[info objectForKey:@"moling"]];
    NSDictionary *dict = [self bsService:@"ZCuserPayment" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent lastObject],@"Message", nil];
    }
    return nil;
}

#pragma mark 查询支付记录
-(NSDictionary *)ZCqueryPayments
{
    /* 查询结算记录
     * @Description:
     * @Title:queryPayments
     * @Author:dwh
     * @Date:2014-7-16 下午3:16:39
     * @param pdaid pda编号
     * @param user 用户
     * @param folioNo 账单号
     * @return*/
    NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&folioNo=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"ZCqueryPayments" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
        }
        else
        {
            NSMutableArray *aryQueryPayments=[NSMutableArray array];
            NSMutableArray *aryQuery=[NSMutableArray arrayWithArray:[[aryContent lastObject] componentsSeparatedByString:@"^"]];
            [aryQuery removeLastObject];
            for (NSString *Payments in aryQuery) {
                NSArray *aryPayments=[Payments componentsSeparatedByString:@"@"];
                NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                [dic setObject:[aryPayments objectAtIndex:0] forKey:@"name"];   //支付方式名称
                [dic setObject:[aryPayments objectAtIndex:1] forKey:@"price"];  //支付金额
                [dic setObject:[aryPayments objectAtIndex:2] forKey:@"typ"];  //支付金额
                [aryQueryPayments addObject:dic];
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",aryQueryPayments,@"Message", nil];
        }
    }
    return nil;
}

#pragma mark 取消支付
-(NSDictionary *)ZCcancelPayment:(NSString *)password
{
    /**
	 *
	 * @Description:取消支付
	 * @Title:cancelPayment
	 * @Author:dwh
	 * @Date:2014-7-18 下午4:14:52
	 * @param pdaid pda编号
	 * @param user 用户
	 * @param serial 账单号
	 * @return
	 */
    NSString *strParam = [NSString stringWithFormat:@"?&padid=%@&user=%@-%@&serial=%@&cardPassword=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"],[Singleton sharedSingleton].CheckNum,password];
    NSDictionary *dict = [self bsService:@"ZCcancelPayment" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent lastObject],@"Message", nil];
    }
    return nil;
}
#pragma mark 中餐打印
/**
 *  中餐打印
 *  typ    1查询单    2结账单
 *  @return
 */
-(NSDictionary *)ZCpriPrintOrder:(NSString *)typ
{
    if ([typ isEqualToString:@"2"]) {
        typ=@"3";
    }
    NSString *pdanum = [NSString stringWithFormat:@"%@-8",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@-%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"]];
    NSString *strParam = [NSString stringWithFormat:@"?&pdaid=%@&user=%@&serial=%@&typ=%@",pdanum,user,[Singleton sharedSingleton].CheckNum,typ];
    NSDictionary *dict = [self bsService:@"ZCpPrintquery" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
        NSArray *aryContent = [content componentsSeparatedByString:@":"];
        NSRange range = [content rangeOfString:@"error"];
        if (range.location!=NSNotFound){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[aryContent lastObject],@"Message", nil];
        }
        else
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[aryContent lastObject],@"Message", nil];
    }
    return nil;
}
#pragma mark  获取预定信息
-(NSDictionary *)ZCpListResv
{
    NSString *pdanum = [NSString stringWithFormat:@"%@-8",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@-%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"]];
    NSString *strParam = [NSString stringWithFormat:@"?&pdaid=%@&user=%@&tblInit=%@",pdanum,user,[Singleton sharedSingleton].Seat];
    NSDictionary *dict = [self bsService:@"ZCpListResv" arg:strParam];
    return  [[dict objectForKey:@"result"] objectForKey:@"msg"];
}
#pragma mark  预定台转换
-(NSDictionary *)ZCpChangeResv
{
    NSString *pdanum = [NSString stringWithFormat:@"%@-8",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@-%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"]];
    NSString *strParam = [NSString stringWithFormat:@"?&pdaid=%@&user=%@&tblInit=%@",pdanum,user,[Singleton sharedSingleton].Seat];
    NSDictionary *dict = [self bsService:@"ZCpChangeResv" arg:strParam];
    if (dict) {
        return  [dict objectForKey:@"result"];
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"state",@"服务错误",@"msg", nil];
    }
    
}
#pragma mark  获取台位状态颜色
-(NSDictionary *)ZCgetTableColor
{
    NSDictionary *dict = [self bsService:@"getTableColor" arg:@""];
    return  [[dict objectForKey:@"result"] objectForKey:@"msg"];
}
#pragma mark  中餐估清设置
-(NSDictionary *)ZCSetEstimatesFoodList:(NSDictionary *)info
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       [[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"user",
                       [[Singleton sharedSingleton].userInfo objectForKey:@"password"],@"pass",
                       [NSString stringWithFormat:@"%@-8",[self padID]],@"padid",
                       [[info objectForKey:@"TAG"] intValue]==100?@"1":@"0",@"setting",
                       [info objectForKey:@"ITCODE"],@"itcode",
                       [info objectForKey:@"cnt"]==nil?@"0":[info objectForKey:@"cnt"],@"cnt",
                       nil];
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"ZCSetEstimatesFoodList" arg:strParam];
    return  [dict objectForKey:@"result"];
}
#pragma mark 中餐设置设备编码
-(NSDictionary *)ZCequipmentCoding:(NSString *)padid
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       padid,@"padid",
                       [self UUIDString],@"equipment",
                       nil];
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"ZCequipmentCoding" arg:strParam];
    return  [dict objectForKey:@"result"];
}
#pragma mark  查询估清列表
-(NSArray *)ZCEstimatesFoodList
{
    NSDictionary *dict = [self bsService:@"EstimatesFoodList" arg:@""];
    return  [[dict objectForKey:@"result"] objectForKey:@"msg"];
}
#pragma mark  查询挂账用户
-(NSArray *)ZCTmpacct{
    NSDictionary *dict = [self bsService:@"ZCTmpacct" arg:@""];
    return  [[dict objectForKey:@"result"] objectForKey:@"msg"];

}
#pragma mark  执行挂账
-(NSDictionary *)ZCTmpacctPost:(NSDictionary *)info
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       [NSString stringWithFormat:@"%@-%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[[Singleton sharedSingleton].userInfo objectForKey:@"password"]],@"user",
                       [NSString stringWithFormat:@"%@-8",[self padID]],@"padid",
                       [info objectForKey:@"TAG"],@"TAG",
                       [info objectForKey:@"ITCODE"],@"ITCODE",
                       [info objectForKey:@"AMT"],@"AMT",
                       [info objectForKey:@"payment"],@"PAYMENT",
                       [Singleton sharedSingleton].CheckNum,@"FOLIONO",
                       [Singleton sharedSingleton].Seat,@"TBLINIT",
                       nil];
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[dic JSONRepresentation]];
    NSDictionary *dict = [[self bsService:@"ZCTmpacctPost" arg:strParam] objectForKey:@"result"];
    return  dict;
}
#pragma mark 查询急推菜列表
-(NSArray *)ZCquickFood
{
    NSDictionary *dict = [self bsService:@"ZCquickFood" arg:@""];
    return  [[dict objectForKey:@"result"] objectForKey:@"msg"];
}
#pragma mark  十进制转颜色
-(UIColor *)getColorFromString:(NSString *)colorString{
    int colorInt=[colorString intValue];
    NSLog(@"%@",colorString);
    if (colorInt==255) {
        NSLog(@"aa");
    }
    if(colorInt<0)
        return [UIColor whiteColor];
    NSString *nLetterValue;
    NSString *colorString16 =@"";
    int ttmpig;
    for (int i = 0; i<9; i++)
    {
        ttmpig=colorInt%16;
        colorInt=colorInt/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
        }
        colorString16 = [nLetterValue stringByAppendingString:colorString16];
        if (colorInt == 0)
            break;
    }
    colorString16 = [[colorString16 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //去掉前后空格换行符
    // strip 0X if it appears
    if ([colorString16 hasPrefix:@"0X"])
        colorString16 = [colorString16 substringFromIndex:2];
    if ([colorString16 hasPrefix:@"#"])
        colorString16 = [colorString16 substringFromIndex:1];
    // String should be 6 or 8 characters
    if ([colorString16 length] < 6)
    {
        int cc=6-[colorString16 length];
        for (int i=0; i<cc; i++)
            colorString16=[@"0" stringByAppendingString:colorString16];
    }
//    NSLog(@"%@",colorString16);
    if ([colorString16 length] != 6)
        return [UIColor whiteColor];        // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *bString = [colorString16 substringWithRange:range];
    range.location = 2;
    NSString *gString = [colorString16 substringWithRange:range];
    range.location = 4;
    NSString *rString = [colorString16 substringWithRange:range];
    //     Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark  根据卡号查会员卡信息
/**
 *  @author ZhangPo, 15-05-07 14:05:10
 *
 *  @brief  根据卡号查询卡信息
 *
 *  @param cardNum 卡号
 *
 *  @return 卡信息
 *
 *  @since
 */
-(NSDictionary *)ZCqueryCardByCardNo:(NSString *)cardNum
{
    NSString *strParam = [NSString stringWithFormat:@"?&queryCardNo=%@",cardNum];
    NSDictionary *dict = [self bsService:@"queryCardByCardNo" arg:strParam];
    if (dict) {
        NSString *str=[dict objectForKey:@"data"];
        NSArray *array=[str componentsSeparatedByString:@"@"];
//        卡ID @卡号@卡姓名@手机号@有效期@卡状态@卡类别@卡余额@卡积分余额@电子券列表
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setObject:[array objectAtIndex:0] forKey:@"cardId"];
        [dic setObject:[array objectAtIndex:2] forKey:@"pszName"];
        [dic setObject:[array objectAtIndex:6] forKey:@"cardType"];
        [dic setObject:[array objectAtIndex:7] forKey:@"storedCardsBalance"];
        [dic setObject:[array objectAtIndex:8] forKey:@"integralOverall"];
        [dic setObject:cardNum forKey:@"cardNo"];
        NSMutableArray *ticketInfoList=[[NSMutableArray alloc] init];
        
        if([[array lastObject] length]>0)
        {
        NSArray *ary=[[array lastObject] componentsSeparatedByString:@"#"];
        
        for (NSString *string in ary) {
            NSArray *ticket=[string componentsSeparatedByString:@","];
            [ticketInfoList addObject:[NSDictionary dictionaryWithObjectsAndKeys:[ticket objectAtIndex:0],@"counpId",[ticket objectAtIndex:1],@"couponCode",[ticket objectAtIndex:2],@"counpName",@"1",@"counpNum",[ticket objectAtIndex:3],@"counpMoney", nil]];
        }
        }
        [dic setObject:ticketInfoList forKey:@"ticketInfoList"];
        return dic;
    }
    return dict;
}
#pragma mark  根据手机号查会员卡号
/**
 *  @author ZhangPo, 15-05-07 14:05:10
 *
 *  @brief  根据卡号查询卡信息
 *
 *  @param cardNum 卡号
 *
 *  @return 卡信息
 *
 *  @since
 */
-(NSDictionary *)ZCqueryCardByMobTel:(NSString *)mobtel
{
    NSString *strParam = [NSString stringWithFormat:@"?&queryMobTel=%@",mobtel];
    NSDictionary *dict = [self bsService:@"queryCardByMobTel" arg:strParam];
    if (dict) {
        NSString *str=[dict objectForKey:@"data"];
        NSArray *array=[str componentsSeparatedByString:@"@"];
        NSMutableArray *ary=[[NSMutableArray alloc] init];
        if ([[array lastObject] intValue]>0) {
            for (NSString *string in array) {
                [ary addObject:[NSDictionary dictionaryWithObjectsAndKeys:string,@"cardNo", nil]];
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:ary,@"cardData",@"1",@"ruturn",nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"ruturn",nil];
        }
        
        
    }
    return dict;
}
#pragma mark 中餐会员储值支付
-(NSDictionary *)ZCcardPayment:(NSDictionary *)info
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       [[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"user",
                       [[Singleton sharedSingleton].userInfo objectForKey:@"password"],@"password",
                       [NSString stringWithFormat:@"%@-8",[self padID]],@"padid",
                       [Singleton sharedSingleton].CheckNum,@"order",
                       [Singleton sharedSingleton].Seat,@"Table",
                       [info objectForKey:@"cardNo"],@"cardNo",
                       [info objectForKey:@"cardPassword"],@"cardPassword",
                       [info objectForKey:@"paymentMoney"],@"paymentAmt",
                       [info objectForKey:@"Amt"],@"Amt",
                       nil];
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"ZCcardPayment" arg:strParam];
    if (dict) {
        return [dict objectForKey:@"result"];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"state",@"执行失败",@"msg", nil];
}
#pragma mark 中餐活动
/*
 **
 *
 * @param json
 * user 用户名
 * password 密码
 * padid	设备编码
 * order	账单号
 * actmCode	活动编码
 * cardId	会员卡编码
 * cardNo   会员卡号
 * cardTyp  会员卡类别
 * cardPassword 会员卡密码
 * ticketCode   券编码
 * ticketId		券Id
 * ticketPrice	券金额
 * ticketCnt    券数量
 * phoneamt		手动优免金额
 * Amt			账单金额
 * phandcnt     手动优免数量
 * phanddes		手动优免原因
 */
-(NSDictionary *)ZCuserActm:(NSDictionary *)info
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       [[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"user",//用户名
                       [[Singleton sharedSingleton].userInfo objectForKey:@"password"],@"password", //密码
                       [NSString stringWithFormat:@"%@-8",[self padID]],@"padid",//padId
                       [Singleton sharedSingleton].CheckNum,@"order",//账单号
                       [info objectForKey:@"VCODE"],@"actmCode",//活动编码
                       [info objectForKey:@"cardId"]==nil?@"0":[info objectForKey:@"cardId"],@"cardId", //卡ID
                       [info objectForKey:@"cardNo"]==nil?@"":[info objectForKey:@"cardNo"],@"cardNo",  //卡号
                       [info objectForKey:@"cardTyp"]==nil?@"0":[info objectForKey:@"cardTyp"],@"cardTyp",//卡类型
                       [info objectForKey:@"cardPassword"]==nil?@"":[info                               objectForKey:@"cardPassword"],@"cardPassword",//卡密码
                       [info objectForKey:@"ticketCode"]==nil?@"":[info objectForKey:@"ticketCode"],@"ticketCode",// 券编码
                       [info objectForKey:@"ticketId"]==nil?@"0":[info objectForKey:@"ticketId"],@"ticketId",//券ID
                       [info objectForKey:@"ticketPrice"]==nil?@"":[info objectForKey:@"ticketPrice"],@"ticketPrice", //券金额
                       [info objectForKey:@"ticketCount"]==nil?@"0":[info objectForKey:@"ticketCount"],@"ticketCount", //券数量
                       [info objectForKey:@"phoneamt"]==nil?@"0":[info objectForKey:@"phoneamt"],@"phoneamt",//手动优免
                       [info objectForKey:@"phandcnt"]==nil?@"1":[info objectForKey:@"phandcnt"],@"phandcnt",//手动
                       [info objectForKey:@"phanddes"]==nil?@"":[info objectForKey:@"phanddes"],@"phanddes",//手动优免原因
                       [info objectForKey:@"food"]==nil?@"":[info objectForKey:@"food"],@"food",//优惠菜品
                       [info objectForKey:@"Amt"]==nil?@"":[info objectForKey:@"Amt"],@"Amt",//账单金额
                       nil];
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"ZCuserActm" arg:strParam];
    if (dict) {
        return [dict objectForKey:@"result"];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"state",@"执行失败",@"msg", nil];
}
#pragma mark 取消优惠
-(NSDictionary *)ZCcancelActm:(NSString *)password
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       [[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"user",
                       [[Singleton sharedSingleton].userInfo objectForKey:@"password"],@"password",
                       [NSString stringWithFormat:@"%@-8",[self padID]],@"padid",
                       [Singleton sharedSingleton].CheckNum,@"order",
                       password,@"cardPassword",nil];
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"ZCcancelActm" arg:strParam];
    if (dict) {
        return [dict objectForKey:@"result"];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"state",@"执行失败",@"msg", nil];

}
#pragma mark 支付完成
-(NSDictionary *)ZCpaymentFinish
{
    NSString *strParam = [NSString stringWithFormat:@"?&serial=%@",[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"ZCpaymentFinish" arg:strParam];
    if (dict) {
        return [dict objectForKey:@"result"];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"state",@"执行失败",@"msg", nil];
    
}
#pragma mark 活动查询
-(NSArray *)ZCselectCoupon
{
    NSArray *coupon_kindArray=[BSDataProvider getDataFromSQLByCommand:@"select distinct B.* from ACTM A,ACTTYP B where A.Pk_Acttypmin=B.PK_ACTTYPmin"];
    for (NSDictionary *dict in coupon_kindArray) {
        NSArray *coupon_mainArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from ACTM WHERE PK_ACTTYP='%@' and SHOWINPAD='Y'",[dict objectForKey:@"PK_ACTTYP"]]];
        [dict setValue:coupon_mainArray forKey:@"coupon_main"];
    }
    return coupon_kindArray;
}
#pragma mark 必选附加项
-(NSArray *)ZCPrivateAddition:(NSArray *)array
{
    return [self getDataFromSQLByCommandReturnArray:[NSString  stringWithFormat:@"select * from attach where ITCODE in %@",array]];
}


#pragma mark 中餐台位
/**
 *  Description 搜索台位
 *
 *  @param info 搜索信息
 *
 *  @return 成功，台位列表  失败，错误信息
 */
-(NSDictionary *)ZCqueryTables:(NSDictionary *)info
{
    /**
	 *
	 * @Description: 查询台位列表
	 * @Title:queryTables
	 * @Author:zp
	 * @Date:2014-7-14 上午10:32:54
	 * @param user 用户名
	 * @param floor 楼层
	 * @param area 区域
	 * @param status 状态
	 * @param pdaid pdaid编号
	 * @param condition 查询条件（缩写或者台位名称）
	 * @return <queryTables:24^C01^C01^5/10^1|32^C10^C10^6/10^1|>
     * @param   <开始 查询台位表示 :台位编码^台位名称^台位简码^台位人数^台位状态|
     
	 */
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    NSString *user,*pdanum,*floor,*area,*status,*pwd,*condition;
    user =[[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@-%@",user,pwd];
    pdanum = [NSString stringWithFormat:@"%@-8",[self padID]];
    condition=[info objectForKey:@"condition"];
    floor = [info objectForKey:@"floor"];
    if (!floor)
        floor = @"";
    area = [info objectForKey:@"area"];
    if (!area)
        area = @"";
    status = [info objectForKey:@"status"];
    if (!status)
        status = @"";
    if (!condition) {
        condition=@"";
    }
    
    
    //    cmd = [NSString stringWithFormat:@"+listtable<user:%@;pdanum:%@;floor:%@;area:%@;status:%@;>\r\n",user,pdanum,floor,area,status];
    
    NSString *strParam = [NSString stringWithFormat:@"?user=%@&floor=%@&area=%@&status=%@&pdaid=%@&condition=%@",user,floor,area,status,pdanum,condition];
    NSDictionary *dict = [self bsService:@"ZCqueryTables" arg:strParam];
    
    if (dict){
        
        NSString *result = [[[dict objectForKey:@"root"] objectForKey:@"oStr"] objectForKey:@"text"];
        
        NSArray *ary = [result componentsSeparatedByString:@"<"];
        
        if (ary.count>1){
            NSString *content = [[[ary objectAtIndex:1] componentsSeparatedByString:@">"] objectAtIndex:0];
            NSArray *array=[content componentsSeparatedByString:@":"];
            if ([array count]<=2){
                
                //            NSRange range = [content rangeOfString:@"ok"];
                //             if (range.location!=NSNotFound){
                [mut setObject:[NSNumber numberWithBool:YES] forKey:@"Result"];
                
                NSArray *aryTables = [content componentsSeparatedByString:@"|"];
                
                NSMutableArray *mutTables = [NSMutableArray array];
                
                for (NSString *strTable in aryTables){
                    
                    NSArray *aryTableInfo = [strTable componentsSeparatedByString:@"^"];
                    NSMutableDictionary *mutTable = [NSMutableDictionary dictionary];
                    
                    if ([aryTableInfo count]>=4){
                        [mutTable setObject:[aryTableInfo objectAtIndex:0] forKey:@"code"];  //台位编号
                        [mutTable setObject:[aryTableInfo objectAtIndex:1] forKey:@"short"];  //台位简码
                        [mutTable setObject:[aryTableInfo objectAtIndex:2] forKey:@"name"];     //台位名称
                        [mutTable setObject:[aryTableInfo objectAtIndex:4] forKey:@"status"];   //台位状态
                        [mutTable setObject:[aryTableInfo objectAtIndex:3] forKey:@"man"];      //台位人数
                        [mutTables addObject:mutTable];
                    }
                    
                }
                
                [mut setObject:mutTables forKey:@"Message"];
                
                
//                if ([mutTables count]>0)
//                    [[NSNotificationCenter defaultCenter] postNotificationName:msgListTable object:nil userInfo:mut];
            }
            else{
                NSRange range = [content rangeOfString:@"error"];
                if (range.location!=NSNotFound){
//                    [[NSNotificationCenter defaultCenter] postNotificationName:msgListTable object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil]];
                }
            }
        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:msgListTable object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil]];
        }
        
    }
    return mut;
}
#pragma mark 外送地址
-(NSDictionary *)deliveryAddress:(NSString *)address
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:
                       address,@"addr",
                       [Singleton sharedSingleton].CheckNum,@"FOLIONO",
                       nil];
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"ZCsetDeliveryAddress" arg:strParam];
    return  [dict objectForKey:@"result"];
}
#pragma mark -
#pragma mark WebPos相关的

/**
 *  下载数据
 */
-(BOOL)downloadData
{
    /**
     *  array对应的是表名及接口的标示
     */
    NSArray *array=[[NSArray alloc]initWithObjects:@"class",@"food",@"state",@"storearear_mis",@"products_sub",@"package",@"FoodFuJia",@"PrivateFujia",@"presentreason",@"coupon_kind",@"coupon_main",@"settlementoperate",@"specialremark", nil];
    for (NSString *str in array) {
        NSString *url=@"";
        if ([str isEqualToString:@"FoodFuJia"]) {
            url=[NSString stringWithFormat:@"?pk_store=%@&pk_redefine_type=",[Singleton sharedSingleton].pk_store];
        }else
        {
            url=[NSString stringWithFormat:@"?pk_store=%@",[Singleton sharedSingleton].pk_store];
        }
        NSDictionary *dict=[self bsService:str arg:url];
        if (dict) {
            NSArray *ary=[dict objectForKey:@"root"];
            if ([ary isEqual:@"null"]) {
                return NO;
            }
            [self NSDictionaryToSQLite:dict withTable:str];
        }else
        {
            return NO;
        }
    }
    return YES;
}
/**
 *  将字典的值插入到SQLite库中
 *
 *  @param info  字典
 *  @param table 表名
 */
-(void)NSDictionaryToSQLite:(NSDictionary *)info withTable:(NSString *)table
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BookSystem.sqlite"];
    FMDatabase *db=[[FMDatabase alloc] initWithPath:path];
    if(![db open])
    {
        NSLog(@"数据库打开失败");
    }
    else
    {
        NSLog(@"数据库打开成功");
    }
    
    NSString *settingPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"SQLiteSynchronization.plist"];
    NSDictionary *dict= [NSDictionary dictionaryWithContentsOfFile:settingPath];
    NSDictionary *dict1=[dict objectForKey:table];
    NSMutableString *string=[NSMutableString string];
    [string appendString:@""];
    for (NSString *str in [dict1 allKeys]) {
        [string appendFormat:@"'%@',",str];
    }
    NSRange range = {[string length]-1,1};
    if ([table isEqualToString:@"package"]) {
        table=@"food";
    }else if ([table isEqualToString:@"PrivateFujia"])
    {
        table=@"FoodFuJia";
        
    }
    else
    {
        [db executeUpdate:[NSString stringWithFormat:@"delete from %@",table]];
    }
    [string deleteCharactersInRange:range];
    
    NSArray *ary=[info objectForKey:@"root"];
    for (int i=0;i<[ary count];i++) {
        NSMutableString *string1=[NSMutableString string];
        [string1 appendString:@""];
        for (NSString *str in [dict1 allValues]) {
            NSArray *arra=[str componentsSeparatedByString:@"<"];
            if ([arra count]<2) {
                [string1 appendFormat:@"'%@',",[[ary objectAtIndex:i] objectForKey:str]==nil?@"":[[ary objectAtIndex:i] objectForKey:str]];
            }else
            {
                [string1 appendFormat:@"'%@',",[NSString stringWithFormat:@"%@",[arra objectAtIndex:1]]];
            }
            
        }
        NSRange range1 = {[string1 length]-1,1};
        
        [string1 deleteCharactersInRange:range1];
        NSString *sql=[NSString stringWithFormat:@"insert into %@ (%@) values (%@)",table,string,string1];
        [db executeUpdate:sql];
    }
    [db close];
}
/**
 *  查询区域
 *
 *  @return
 */
- (NSArray *)WebgetArea{//根据区域区分
    NSMutableArray *ary = [NSMutableArray array];
    ary=[BSDataProvider getDataFromSQLByCommand:@"select * from storearear_mis"];
    return ary;
}
/**
 *  查询状态
 *
 *  @return
 */
- (NSArray *)WebgetState{//根据区域区分
    NSMutableArray *ary = [NSMutableArray array];
    ary=[BSDataProvider getDataFromSQLByCommand:@"select * from state"];
    return ary;
}
//- (NSArray *)ZCgetArea{
//    return [BSDataProvider getDataFromSQLByCommand:@"select * from codedesc where code = 'AR'"];
//    
//}
/**
 *  查询台位列表
 *
 *  @return
 */
- (NSDictionary *)WebpListTable
{
    NSDictionary *dict=[self bsService:@"webListTable" arg:[NSString stringWithFormat:@"?pk_store=%@",[Singleton sharedSingleton].pk_store]];
    if (dict) {
        return dict;
    }else
    {
        return Nil;
    }
}
/**
 *  查询菜品类别
 *
 *  @return
 */
-(NSArray *)WebgetClassById
{
    NSMutableArray *array=[BSDataProvider getDataFromSQLByCommand:@"SELECT * FROM class a WHERE a.pk_father in (SELECT b.pk_marsaleclass FROM class b WHERE b.pk_father in (SELECT c.pk_marsaleclass FROM class c WHERE c.pk_father='~'))"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    /**
     *  由于没有套餐类别在这里插入
     */
    [dict setObject:@"88" forKey:@"pk_marsaleclass"];
    [dict setObject:@"套餐" forKey:@"DES"];
    [array addObject:dict];
    return array;
}

/**
 *  根据套餐编码查询套餐明细
 *
 *  @param tag 套餐编码
 *
 *  @return
 */
-(NSMutableArray *)Webcombo:(NSString *)tag{
    
    /**
     *  根据套餐编码查询组
     */
    NSArray *groupArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT PNAME,PRICE1,PCODE1,PRODUCTTC_ORDER,MAXCNT,MINCNT FROM products_sub a WHERE defualtS = '1' and pcode='%@' GROUP BY PRODUCTTC_ORDER ORDER BY PRODUCTTC_ORDER  ASC",tag]];
    NSMutableArray *returnGroupArray=[NSMutableArray array];
    for (NSDictionary *groupDic in groupArray) {
        /**
         *  套餐明细
         */
        NSMutableArray *productArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT * FROM food a left JOIN products_sub b on a.item=b.pcode WHERE b.pcode='%@' and PRODUCTTC_ORDER='%@' ORDER BY defualtS desc",tag,[groupDic objectForKey:@"PRODUCTTC_ORDER"]]];
        /**
         *  将改组的最大最小数量放入数据中
         */
        for (NSDictionary *dict in productArray) {
            [dict setValue:[groupDic objectForKey:@"MAXCNT"] forKey:@"TYPMAXCNT"];
            [dict setValue:[groupDic objectForKey:@"MINCNT"] forKey:@"TYPMINCNT"];
            
        }
        /**
         *  删除 defualtS=0的数据
         */
        if ([productArray count]>1) {
            [productArray removeObjectAtIndex:0];
        }
        /**
         *  将菜品放在分组的数组中
         */
        [returnGroupArray addObject:productArray];
    }
    return returnGroupArray;
}
/**
 *  查询全部的套餐明细
 *
 *  @return
 */

-(NSMutableArray *)WeballCombo{
    /**
     *  获取套餐编码
     */
    NSArray *pcodeArray=[BSDataProvider getDataFromSQLByCommand:@"SELECT ITEM from food where ISTC='1'"];
    /**
     *  返回的数组
     */
    NSMutableArray *returnArray=[NSMutableArray array];
    for (NSDictionary *pcodeDic in pcodeArray) {
        /**
         *  根据套餐编码查询组
         */
        NSArray *groupArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT PNAME,PRICE1,PCODE1,PRODUCTTC_ORDER,MAXCNT,MINCNT FROM products_sub a WHERE defualtS = '1' and pcode='%@' GROUP BY PRODUCTTC_ORDER ORDER BY PRODUCTTC_ORDER  ASC",[pcodeDic objectForKey:@"ITEM"]]];
        NSMutableArray *returnGroupArray=[NSMutableArray array];
        for (NSDictionary *groupDic in groupArray) {
            /**
             *  套餐明细
             */
            NSMutableArray *productArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT * FROM food a left JOIN products_sub b on a.ITEM=b.pcode WHERE b.pcode='%@' and PRODUCTTC_ORDER='%@' ORDER BY defualtS ASC",[pcodeDic objectForKey:@"ITEM"],[groupDic objectForKey:@"PRODUCTTC_ORDER"]]];
            /**
             *  将改组的最大最小数量放入数据中
             */
            for (NSDictionary *dict in productArray) {
                [dict setValue:[groupDic objectForKey:@"MAXCNT"] forKey:@"TYPMAXCNT"];
                [dict setValue:[groupDic objectForKey:@"MINCNT"] forKey:@"TYPMINCNT"];
            }
            /**
             *  删除 defualtS=0的数据
             */
            if ([productArray count]>1) {
                [productArray removeObjectAtIndex:0];
            }
            /**
             *  将菜品放在分组的数组中
             */
            [returnGroupArray addObject:productArray];
        }
        /**
         *  将组数组放在返回的数组中
         */
        [returnArray addObject:returnGroupArray];
    }
    return returnArray;
}

/**
 *  webPos查询公共附加项
 *
 *  @return
 */
-(NSArray *)WebSelectAddition
{
    NSMutableArray * ary=[NSMutableArray array];
    NSArray *array=[BSDataProvider getDataFromSQLByCommand:@"select PRODUCTTC_ORDER from foodfujia where pcode is null GROUP BY PRODUCTTC_ORDER"];
    for (NSDictionary * dict in array) {
        NSArray *arry=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from foodfujia where PRODUCTTC_ORDER='%@' and pcode is null",[dict objectForKey:@"PRODUCTTC_ORDER"]]];
        [ary addObject:arry];
    }
    return ary;
}
/**
 *  查询固定附加项
 *
 *  @param pcode 菜品主键
 *
 *  @return
 */
-(NSArray *)webSelectPrivateAddition:(NSString *)pcode
{
    NSMutableArray * ary=[NSMutableArray array];
    NSArray *array=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select PRODUCTTC_ORDER from foodfujia where pcode='%@'  GROUP BY PRODUCTTC_ORDER",pcode]];
    for (NSDictionary * dict in array) {
        NSArray *arry=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from foodfujia where PRODUCTTC_ORDER='%@' and pcode ='%@'",[dict objectForKey:@"PRODUCTTC_ORDER"],pcode]];
        [ary addObject:arry];
    }
    return ary;
}

/**
 *  web开台
 *
 *  @param info 台位信息
 *
 *  @return 成功
 */
- (NSDictionary *)WebStart:(NSDictionary *)info
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    [dict setValue:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
    NSString *url=[NSString stringWithFormat:@"?sitedefines=%@",[dict JSONRepresentation]];
    NSDictionary *dict1=[self bsService:@"WebStart" arg:url];
    if (dict1) {
        return dict1;
    }else
    {
        return Nil;
    }
    
}
/**
 *  webPos登录
 *
 *  @param info 登录信息
 *
 *  @return
 */
-(NSDictionary *)WebLogin:(NSDictionary *)info
{
    //    --pad登录(syscode:pad硬件号，empcode：登录员工编码，emppass：登录员工密码）
    //            http://192.168.0.236:8888/userInfoController/padLogin?syscode=13165187&empcode=1&emppass=1
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    [dict setValue:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
    NSString *url=[NSString stringWithFormat:@"?syscode=%@&empcode=%@&emppass=%@",[self UUIDString],[info objectForKey:@"userCode"],[info objectForKey:@"usePass"]];
    NSDictionary *dict1=[self bsService:@"WebLogin" arg:url];
    if (dict1) {
        return dict1;
    }else
    {
        return Nil;
    }
}
/**
 *  webPos开台
 *
 *  @param info 开台信息
 *
 *  @return
 */
-(NSDictionary *)WebOpenTable:(NSDictionary *)info
{
    //    parameter：folios（内容如下）
    //
    //pk_store:门店主键
    //pk_inemp:操作员主键
    //pk_site:台位主键
    //pk_pos:pos主键 （pad主键 区别与pos主键）--重新获取赋值
    //    iopenstate：开台类型 （1：开子台位 0：开主台位）
    //ipeolenum:总人数
    //ipeolenumman:男人数
    //ipeolenumwoment:女人数
    //ioldpeoplenum:老人数
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setValue:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
    [dict setValue:[Singleton sharedSingleton].pk_pos forKey:@"pk_pos"];
    [dict setValue:[Singleton sharedSingleton].pk_inemp forKey:@"pk_inemp"];
    [dict setValue:[info objectForKey:@"iopenstate"] forKey:@"iopenstate"];
    [dict setValue:[info objectForKey:@"pk_sited"] forKey:@"pk_site"];
    if (![info objectForKey:@"man"]) {
        [info setValue:@"0" forKey:@"man"];
    }
    if (![info objectForKey:@"woman"]) {
        [info setValue:@"0" forKey:@"woman"];
    }
    [dict setValue:[info objectForKey:@"man"] forKey:@"ipeolenumman"];
    [dict setValue:[info objectForKey:@"woman"] forKey:@"ipeolenumwoment"];
    [dict setValue:@"0" forKey:@"ioldpeoplenum"];
    [dict setValue:@"0" forKey:@"ichildrennum"];
    [dict setValue:[NSNumber numberWithInt:([[info objectForKey:@"man"] intValue]+[[info objectForKey:@"woman" ] intValue])] forKey:@"ipeolenum"];
    NSArray *array=[[NSArray alloc] initWithObjects:dict, nil];
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:array,@"root", nil];
    NSString *url=[NSString stringWithFormat:@"?folios=%@",[dic JSONRepresentation]];
    NSDictionary *dict1=[self bsService:@"WebOpenTable" arg:url];
    if (dict1) {
        return dict1;
    }else
    {
        return Nil;
    }
}
/**
 *  根据台位主键和台位号查询账单主表
 *
 *  @param tableInfo
 *
 *  @return
 */
-(NSDictionary *)WebgetFolioNo:(NSDictionary *)tableInfo
{
//pk_sited:台位主键
//vtablenum:台位号
    //    http://192.168.0.236:8888/saleInfoController/getFolioListFromTableNum?pk_sited=D39D07FAEE354549B61D&vtablenum=9
    NSString *url=[NSString stringWithFormat:@"?pk_sited=%@&vtablenum=%@",[tableInfo objectForKey:@"pk_sited"],[tableInfo objectForKey:@"vcode"]];
    NSDictionary *dict1=[self bsService:@"WebgetFolioNo" arg:url];
    if (dict1) {
        return dict1;
    }else
    {
        return Nil;
    }
}
/**
 *  web换台
 *
 *  @param info 换台信息
 *
 *  @return
 */
- (NSDictionary *)WebChangeTable:(NSDictionary *)info{
    
    //    --换台
    //parameter: sitedefines (两条记录的json 第一条记录为原台信息   第二条记录为目标台信息)
    //pk_storeid:门店主键
    //vcode:台位号/台位缩写
    //    例子：(将13台换到15台）
    //        http:192.168.0.236:8888/tableInfoController/changeSitedefinehand?sitedefines={"root":[{"pk_storeid":"c97221b714e14f91b8f4","vcode":"11"},{"pk_storeid":"c97221b714e14f91b8f4","vcode":"12"}]}
    NSArray *array=[[NSArray alloc] initWithObjects:[info objectForKey:@"oldtable"],[info objectForKey:@"newtable"], nil];
    NSMutableArray *ary=[NSMutableArray array];
    for (NSString *table in array) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:table forKey:@"vcode"];
        [dic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_storeid"];
        [ary addObject:dic];
    }
    NSMutableDictionary *rootDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:ary,@"root", nil];
    NSDictionary *dict = [self bsService:@"WebChangeTable" arg:[NSString stringWithFormat:@"?sitedefines=%@",[rootDic JSONRepresentation]]];
    if (dict) {
        return dict;
    }
    return nil;
}
/**
 *  webPos发送接口
 *
 *  @param food 菜品列表
 *
 *  @return
 */
-(NSDictionary *)WebSendFood:(NSArray *)food withTag:(NSString *)tag withComment:(NSArray *)comment
{
    //    --点菜
    //    parameter:orders
    //    pk_store:门店主键
    //    vrecode :员工主键
    //    vposid  :pos主键
    //    vbcode  :账单号（手持机输台位号/台位缩写）
    //    Vpcode  :菜品编码/套餐编码/套餐明细编码/附加项编码
    //    vpname  :菜品名称/套餐名称/套餐明细名称/附加项名称
    //    nprice  :菜品价格/套餐价格/套餐明细价格/附加项价格
    //    ncount  :菜品数量/套餐数量/套餐明细数量/附加项数量
    //    vunit   :单位次序（0:单位1 1:单位2 2:单位3 3:单位4）
    //    iflag   :菜品标志(0-普通单点菜品 1-套餐 2-套餐明细 24-带附加项套餐明细 3-带附加项菜品 4-附加项)
    //    vdone   :叫起标识(0-既起 1-叫起 2-补单)
    //http://192.168.0.236:8888/saleInfoController/commitOrdrhand?orders={"root":[{"pk_store"="c97221b714e14f91b8f4","vrecode":"1","vposid":"20BE603CC84A4163B67E","vbcode":"15","vpcode":"201007","vpname"="加多宝","nprice"="0",ncount="1","vunit"="1","iflag"="0","vdone"="0"},{"pk_store"="c97221b714e14f91b8f4","vrecode":"1","vposid":"20BE603CC84A4163B67E","vbcode":"15","vpcode":"201007","vpname"="加多宝","nprice"="0",ncount="1","vunit"="1","iflag"="0","vdone"="0"}]}
    NSMutableArray * foodArray=[NSMutableArray array];
    /**
     *  菜品
     */
    for (NSDictionary *dict in food) {
        NSMutableDictionary *foodDic=[NSMutableDictionary dictionary];
        [foodDic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
        [foodDic setObject:[Singleton sharedSingleton].pk_inemp forKey:@"vrecode"];
        [foodDic setObject:[Singleton sharedSingleton].pk_pos forKey:@"vposid"];
        [foodDic setObject:[Singleton sharedSingleton].vbcode forKey:@"vbcode"];
        [foodDic setObject:[dict objectForKey:@"ITCODE"] forKey:@"vpcode"];
        [foodDic setObject:[dict objectForKey:@"DES"] forKey:@"vpname"];
        [foodDic setObject:[dict objectForKey:[dict objectForKey:@"PriceKey"]] forKey:@"nprice"];
        [foodDic setObject:[dict objectForKey:@"total"] forKey:@"ncount"];
        /**
         *  判断是否赠送
         */
        if (![dict objectForKey:@"promonum"]) {
            [dict setValue:@"0" forKey:@"promonum"];
            [dict setValue:@"" forKey:@"VCode"];
            [dict setValue:@"" forKey:@"VName"];
        }
        [foodDic setObject:[dict objectForKey:@"promonum"] forKey:@"nzcount"];
        [foodDic setObject:[dict objectForKey:@"VCode"] forKey:@"vreturnreasoncode"];
        [foodDic setObject:[dict objectForKey:@"VName"] forKey:@"vretrunreasonname"];
        NSArray *array=[[NSArray alloc] initWithObjects:@"UNIT",@"UNIT2",@"UNIT3",@"UNIT4",@"UNIT5", nil];
        /**
         *  获取单位
         */
        int i=0;
        for (;i<[array count]; i++) {
            if ([[array objectAtIndex:i] isEqualToString:[dict objectForKey:@"UnitKey"]]) {
                break;
            }
        }
        [foodDic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"vunit"];
        [foodDic setObject:tag forKey:@"vdone"];
        if ([[dict objectForKey:@"ISTC"] intValue]==1) {
            NSArray *array=[dict objectForKey:@"combo"];
            [foodDic setObject:@"1" forKey:@"iflag"];
            [foodArray addObject:foodDic];
            /**
             *  套餐明细
             */
            for (NSDictionary *dic in array) {
                NSMutableDictionary *comboDic=[NSMutableDictionary dictionary];
                [comboDic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
                [comboDic setObject:[Singleton sharedSingleton].pk_inemp forKey:@"vrecode"];
                [comboDic setObject:[Singleton sharedSingleton].pk_pos forKey:@"vposid"];
                [comboDic setObject:[Singleton sharedSingleton].vbcode forKey:@"vbcode"];
                [comboDic setObject:[dic objectForKey:@"PCODE1"] forKey:@"vpcode"];
                [comboDic setObject:[dic objectForKey:@"PNAME"] forKey:@"vpname"];
                [comboDic setObject:[dic objectForKey:@"PRICE"] forKey:@"nprice"];
                [comboDic setObject:[dic objectForKey:@"total"] forKey:@"ncount"];
                [comboDic setObject:@"0" forKey:@"vunit"];
                [comboDic setObject:tag forKey:@"vdone"];
                //判断明细附加项
                if ([dic objectForKey:@"addition"]&&[[dic objectForKey:@"addition"] count]>0) {
                    [comboDic setObject:@"24" forKey:@"iflag"];
                    [foodArray addObject:comboDic];
                    /**
                     *  套餐明细附加项
                     */
                    for (NSDictionary *dic1 in [dic objectForKey:@"addition"]) {
                        NSMutableDictionary *additionDic=[NSMutableDictionary dictionary];
                        [additionDic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
                        [additionDic setObject:[Singleton sharedSingleton].pk_inemp forKey:@"vrecode"];
                        [additionDic setObject:[Singleton sharedSingleton].pk_pos forKey:@"vposid"];
                        [additionDic setObject:[Singleton sharedSingleton].vbcode forKey:@"vbcode"];
                        /**
                         *  自定义附加项
                         */
                        if (![dic objectForKey:@"FOODFUJIA_ID"]) {
                            [dic setValue:[dic objectForKey:@"FoodFuJia_Des"] forKey:@"FOODFUJIA_ID"];
                            [dic setValue:@"0" forKey:@"Fprice"];
                        }
                        [additionDic setObject:[dic1 objectForKey:@"FOODFUJIA_ID"] forKey:@"vpcode"];
                        [additionDic setObject:[dic1 objectForKey:@"FoodFuJia_Des"] forKey:@"vpname"];
                        [additionDic setObject:[dic1 objectForKey:@"Fprice"] forKey:@"nprice"];
                        [additionDic setObject:[dic1 objectForKey:@"total"] forKey:@"ncount"];
                        [additionDic setObject:@"0" forKey:@"vunit"];
                        [additionDic setObject:tag forKey:@"vdone"];
                        [additionDic setObject:@"4" forKey:@"iflag"];
                        [foodArray addObject:additionDic];
                    }
                    
                }else
                {
                    /**
                     *  没有附加项的明细
                     */
                    [comboDic setObject:@"2" forKey:@"iflag"];
                    [foodArray addObject:comboDic];
                }
                if (comment) {
                    for (NSDictionary *dic1 in comment) {
                        NSMutableDictionary *comDic=[NSMutableDictionary dictionary];
                        [comDic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
                        [comDic setObject:[Singleton sharedSingleton].pk_inemp forKey:@"vrecode"];
                        [comDic setObject:[Singleton sharedSingleton].pk_pos forKey:@"vposid"];
                        [comDic setObject:[Singleton sharedSingleton].vbcode forKey:@"vbcode"];
                        [comDic setObject:[dic1 objectForKey:@"Id"] forKey:@"vpcode"];
                        [comDic setObject:[dic1 objectForKey:@"DES"] forKey:@"vpname"];
                        [comDic setObject:@"0" forKey:@"nprice"];
                        [comDic setObject:@"1" forKey:@"ncount"];
                        [comDic setObject:@"0" forKey:@"vunit"];
                        [comDic setObject:tag forKey:@"vdone"];
                        [comDic setObject:@"5" forKey:@"iflag"];
                        [foodArray addObject:comDic];
                    }

                }
                
            }
        }else
        {
            /**
             *  单品
             */
            if ([dict objectForKey:@"addition"]&&[[dict objectForKey:@"addition"] count]>0) {
                [foodDic setObject:@"3" forKey:@"iflag"];
                [foodArray addObject:foodDic];
                /**
                 *  单品附加项
                 */
                for (NSDictionary *dic in [dict objectForKey:@"addition"]) {
                    NSMutableDictionary *additionDic=[NSMutableDictionary dictionary];
                    [additionDic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
                    [additionDic setObject:[Singleton sharedSingleton].pk_inemp forKey:@"vrecode"];
                    [additionDic setObject:[Singleton sharedSingleton].pk_pos forKey:@"vposid"];
                    [additionDic setObject:[Singleton sharedSingleton].vbcode forKey:@"vbcode"];
                    /**
                     *  自定义附加项
                     */
                    if (![dic objectForKey:@"FOODFUJIA_ID"]) {
                        [dic setValue:[dic objectForKey:@"FoodFuJia_Des"] forKey:@"FOODFUJIA_ID"];
                        [dic setValue:@"0" forKey:@"Fprice"];
                    }
                    [additionDic setObject:[dic objectForKey:@"FOODFUJIA_ID"] forKey:@"vpcode"];
                    [additionDic setObject:[dic objectForKey:@"FoodFuJia_Des"] forKey:@"vpname"];
                    [additionDic setObject:[dic objectForKey:@"Fprice"] forKey:@"nprice"];
                    [additionDic setObject:[dic objectForKey:@"total"] forKey:@"ncount"];
                    [additionDic setObject:@"0" forKey:@"vunit"];
                    [additionDic setObject:tag forKey:@"vdone"];
                    [additionDic setObject:@"4" forKey:@"iflag"];
                    [foodArray addObject:additionDic];
                }
                
            }else
            {
                /**
                 *  没有附加项单品
                 */
                [foodDic setObject:@"0" forKey:@"iflag"];
                [foodArray addObject:foodDic];
            }
            if (comment) {
                for (NSDictionary *dic1 in comment) {
                    NSMutableDictionary *comDic=[NSMutableDictionary dictionary];
                    [comDic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
                    [comDic setObject:[Singleton sharedSingleton].pk_inemp forKey:@"vrecode"];
                    [comDic setObject:[Singleton sharedSingleton].pk_pos forKey:@"vposid"];
                    [comDic setObject:[Singleton sharedSingleton].vbcode forKey:@"vbcode"];
                    [comDic setObject:[dic1 objectForKey:@"Id"] forKey:@"vpcode"];
                    [comDic setObject:[dic1 objectForKey:@"DES"] forKey:@"vpname"];
                    [comDic setObject:@"0" forKey:@"nprice"];
                    [comDic setObject:@"1" forKey:@"ncount"];
                    [comDic setObject:@"0" forKey:@"vunit"];
                    [comDic setObject:tag forKey:@"vdone"];
                    [comDic setObject:@"5" forKey:@"iflag"];
                    [foodArray addObject:comDic];
                }
                
            }

        }
    }
    NSMutableDictionary *rootDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:foodArray,@"root", nil];
    NSDictionary *dict=[self postData:@"WebSend" with:[NSString stringWithFormat:@"orders=%@",[rootDic JSONRepresentation]]];
    return dict;
}
/**
 *  webPos查询账单
 *
 *  @return
 */
-(NSMutableArray *)WebgetOrderList
{
    NSDictionary *dict = [self bsService:@"WebgetOrderList" arg:[NSString stringWithFormat:@"?pk_store=%@&vtablenum=%@",[Singleton sharedSingleton].pk_store,[Singleton sharedSingleton].Seat]];
    if (dict) {
        //    iflag   :菜品标志(0-普通单点菜品 1-套餐 2-套餐明细 24-带附加项套餐明细 3-带附加项菜品 4-附加项)
        NSArray * array=[dict objectForKey:@"root"];
        NSMutableArray *foodArray=[NSMutableArray array];
        NSMutableArray *singleArray=[NSMutableArray array];
        NSMutableArray *comboArray=[NSMutableArray array];
        NSMutableArray *addArray=[NSMutableArray array];
        /**
         *  将返回值分组
         */
        if ([(NSString *)array isEqual:@"null"]) {
            return nil;
        }
        for (NSDictionary *dic in array) {
            if ([[dic objectForKey:@"iflag"] intValue]==0||[[dic objectForKey:@"iflag"] intValue]==1||[[dic objectForKey:@"iflag"] intValue]==3) {
                /**
                 *  单品和套餐头
                 */
                [singleArray addObject:dic];
            }else if ([[dic objectForKey:@"iflag"] intValue]==2)
            {
                /**
                 *  套餐明细
                 */
                [comboArray addObject:dic];
            }else{
                /**
                 *  附加项
                 */
                [addArray addObject:dic];
            }
        }
        /**
         *  遍历单品和套餐头
         */
        for (NSDictionary *dic in singleArray) {
            if ([[dic objectForKey:@"iflag"] intValue]==0) {//普通单品
                [foodArray addObject:dic];
            }else if([[dic objectForKey:@"iflag"] intValue]==1){
                /**
                 *  套餐头，遍历套餐明细
                 */
                [foodArray addObject:dic];
                for (NSDictionary *comdoDic in comboArray) {
                    /**
                     *  判断编码是该套餐明细
                     */
                    if ([[comdoDic objectForKey:@"pk_package"] isEqualToString:[dic objectForKey:@"pk_ordr"]]) {
                        NSMutableArray *additionArray=[NSMutableArray array];
                        /**
                         *  遍历附加项
                         */
                        for (NSDictionary *addDic in addArray) {
                            if ([[addDic objectForKey:@"pk_package"] isEqualToString:[comdoDic objectForKey:@"pk_ordr"]]) {
                                [additionArray addObject:addDic];
                            }
                        }
                        if ([additionArray count]>0) {
                            [comdoDic setValue:additionArray forKey:@"addition"];
                        }
                        [foodArray addObject:comdoDic];
                    }
                }
            }//套餐
            else if ([[dic objectForKey:@"iflag"] intValue]==3){
                /**
                 *  遍历附加项
                 */
                NSMutableArray *additionArray=[NSMutableArray array];
                for (NSDictionary *addDic in addArray) {
                    if ([[addDic objectForKey:@"pk_package"] isEqualToString:[dic objectForKey:@"pk_ordr"]]) {
                        [additionArray addObject:addDic];
                    }
                }
                if ([additionArray count]>0) {
                    [dic setValue:additionArray forKey:@"addition"];
                }
                [foodArray addObject:dic];
            }//附加项菜品
        }
        return foodArray;
    }else{
        return nil;
    }
}
/**
 *  催菜
 *
 *  @param order 催菜列表
 *
 *  @return
 */
-(NSDictionary *)WebcommitUrgeOrdrhand:(NSArray *)order
{
//    --单菜催菜
//    parameter:orders
//    pk_store:门店主键
//    vbcode  :账单号（手持机输台位号/台位缩写）
//    vpcode  :菜品编码
    NSMutableArray *orderArray=[NSMutableArray array];
    for (NSDictionary *dict in order) {
        NSMutableDictionary *orderDic=[NSMutableDictionary dictionary];
        [orderDic setObject:[dict objectForKey:@"vpcode"] forKey:@"vpcode"];
        [orderDic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
        [orderDic setObject:[Singleton sharedSingleton].Seat forKey:@"vbcode"];
        
        [orderArray addObject:orderDic];
    }
    NSMutableDictionary *rootDic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:orderArray,@"root", nil];
    NSDictionary *dict = [self bsService:@"WebcommitUrgeOrdrhand" arg:[NSString stringWithFormat:@"?orders=%@",[rootDic JSONRepresentation]]];
//    NSDictionary *dict =[self pustData:dic with:@"WebcommitUrgeOrdrhand"];
    return dict;
}
/**
 *  打印查询单
 *
 *  @return
 */
-(NSDictionary *)WebprintFirstBillFolio
{
//    --打印查询单据
//    parameter：folios（内容如下）
//    
//pk_store:门店主键
//    pk_pos  :pos主键
//pk_inemp:员工主键
//vtablenum:台位编号（台位简码vinit）--重新获取赋值   B18
    NSMutableDictionary *message=[NSMutableDictionary dictionary];
    [message setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
    [message setObject:[Singleton sharedSingleton].pk_pos forKey:@"pk_pos"];
    [message setObject:[Singleton sharedSingleton].pk_inemp forKey:@"pk_inemp"];
    [message setObject:[Singleton sharedSingleton].Seat forKey:@"vtablenum"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:[NSArray arrayWithObject:message] forKey:@"root"];
     NSDictionary *dict = [self bsService:@"WebprintSelectBillFolio" arg:[NSString stringWithFormat:@"?folios=%@",[dic JSONRepresentation]]];
    return dict;
    
}
-(NSMutableArray *)WebgetFolioPaymentList
{
//    --查询付款及其营销活动执行明细
//    parameter:
//    vbcode:账单号
//    http://192.168.0.206:8888/saleInfoController/getFolioPaymentList?vbcode=1120140829P000001
    NSDictionary *dict = [self bsService:@"WebgetFolioPaymentList" arg:[NSString stringWithFormat:@"?vbcode=%@",[Singleton sharedSingleton].vbcode]];
    if (dict) {
        NSMutableArray *array=[dict objectForKey:@"root"];
        if (![array isEqual:@"null"] ) {
            return array;
        }else
        {
            return nil;
        }
    }else
    {
        return nil;
    }
}
/**
 *  联台
 *
 *  @param info 联台信息
 *
 *  @return
 */
-(NSDictionary *)WebjoinOpenSitedefinehand:(NSDictionary *)info
{
    //--联台
    //parameter: sitedefines (两条记录的json 第一条记录为原台信息   第二条记录为目标台信息)
    //pk_storeid:门店主键
    //vcode:台位号/台位缩写
    //例子：(将12台并到11台）
    //    http://192.168.0.236:8888/tableInfoController/joinOpenSitedefinehand?sitedefines={"root":[{"pk_storeid":"c97221b714e14f91b8f4","vcode":"11"},{"pk_storeid":"c97221b714e14f91b8f4","vcode":"12"}]}
    NSMutableArray *array=[NSMutableArray array];
    for (NSString *key in [info allKeys]) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:[info objectForKey:key] forKey:@"vcode"];
        [dic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_storeid"];
        [array addObject:dic];
    }
    NSMutableDictionary *rootDic=[NSMutableDictionary dictionary];
    [rootDic setObject:array forKey:@"root"];
    NSDictionary *dict = [self bsService:@"WebjoinOpenSitedefinehand" arg:[NSString stringWithFormat:@"?sitedefines=%@",[rootDic JSONRepresentation]]];
    return dict;
}
/**
 *  清台
 *
 *  @param info 清台信息
 *
 *  @return
 */
-(NSDictionary *)WebclearSitedefine:(NSDictionary *)info
{
    NSMutableArray *array=[NSMutableArray array];
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setObject:[info objectForKey:@"pk_sited"] forKey:@"pk_sited"];
    [array addObject:dic];
//        [dic setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_storeid"];
    NSMutableDictionary *rootDic=[NSMutableDictionary dictionary];
    [rootDic setObject:array forKey:@"root"];
    NSDictionary *dict=[self postData:@"WebclearSitedefine" with:[NSString stringWithFormat:@"sitedefines=%@",[rootDic JSONRepresentation]]];
    return dict;

}
//saleInfoController/cancelDelFolioFromVbcode
/**
 *  取消账单
 *
 *  @return
 */
-(NSDictionary *)WebcancelDelFolioFromVbcode
{
    /**
     *  门店主键 pk_store   账单号 vbcode
     */
    NSDictionary *dict = [self bsService:@"WebcancelDelFolioFromVbcode" arg:[NSString stringWithFormat:@"?pk_store=%@&vbcode=%@",[Singleton sharedSingleton].pk_store,[Singleton sharedSingleton].vbcode]];
    return dict;

}
/**
 *  营销活动执行
 *
 *  @param info 活动信息
 *
 *  @return
 */
-(NSDictionary *)WebexecuteMarketing:(NSDictionary *)info
{
    //--营销活动执行
    //pk_store： 门店主键
    //pk_pos：pos主键
    //pk_operator：操作员主键
    //vbcode：帐单号
    //vcode：营销活动编码
    //acttypvcode：营销活动类编码（可直接填空字符）
    NSDictionary *dict = [self bsService:@"WebexecuteMarketing" arg:[NSString stringWithFormat:@"?pk_store=%@&pk_pos=%@&pk_operator=%@&vbcode=%@&vcode=%@",[Singleton sharedSingleton].pk_store,[Singleton sharedSingleton].pk_pos,[Singleton sharedSingleton].pk_inemp,[Singleton sharedSingleton].vbcode,[info objectForKey:@"CODE"]]];
    return dict;
}
/**
 *  现金银行卡使用
 *
 *  @param info 信息
 *
 *  @return 
 */
-(NSDictionary *)WebcommitFolioPayment:(NSDictionary *)info{
    //--付款方式提交
    //parameter:foliopayments
    //字段内容：
    //pk_store:门店主键
    //pk_pos:pos主键
    //pk_operator:操作员主键
    //vbcode:账单号
    //voperate:支付方式编码
    //vcashname:支付方式名称
    //nmoney：支付金额
    //http://192.168.0.206:8888/saleInfoController/commitFolioPayment?foliopayments={"root":[{"pk_store"="c97221b714e14f91b8f4","pk_pos":"","pk_operator":"","vbcode":"11","voperator":"101026","vcashname":"现金"}]}
    NSMutableDictionary *message=[NSMutableDictionary dictionary];
    [message setObject:[Singleton sharedSingleton].pk_store forKey:@"pk_store"];
    [message setObject:[Singleton sharedSingleton].pk_pos forKey:@"pk_pos"];
    [message setObject:[Singleton sharedSingleton].pk_inemp forKey:@"pk_operator"];
    [message setObject:[Singleton sharedSingleton].vbcode forKey:@"vbcode"];
    [message setObject:[info objectForKey:@"OPERATENAME"] forKey:@"vcashname"];
    [message setObject:[info objectForKey:@"OPERATE"] forKey:@"voperate"];
    [message setObject:[info objectForKey:@"OPERATEVALUE"] forKey:@"nmoney"];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:[NSArray arrayWithObject:message] forKey:@"root"];
//    NSDictionary *dict=[self postData:@"WebcommitFolioPayment" with:[NSString stringWithFormat:@"?foliopayments=%@",[dic JSONRepresentation]]];
//    NSString *str=[[NSString stringWithFormat:@"?foliopayments=%@",[dic JSONRepresentation]] ];
    NSDictionary *dict =[self postData:@"WebcommitFolioPayment" with:[NSString stringWithFormat:@"foliopayments=%@",[dic JSONRepresentation]]];
    
//    NSDictionary *dict = [self bsService:@"WebcommitFolioPayment" arg:[NSString stringWithFormat:@"?foliopayments=%@",[dic JSONRepresentation]]];
    return dict;

}
/**
 *  取消优惠
 *
 *  @return
 */
-(NSDictionary *)WebcancelMarketing_Cut
{
    //--取消营销活动
    //pk_store： 门店主键
    //pk_pos：pos主键
    //pk_operator：操作员主键
    //vbcode：帐单号
    //http://192.168.0.206:8888/marketingInfoController/cancelMarketing_Cut?pk_store=c97221b714e14f91b8f4&pk_pos=20BE603CC84A4163B67E&pk_operator=1111111&vbcode=1220140903P000004
    NSDictionary *dict = [self bsService:@"WebcancelMarketing_Cut" arg:[NSString stringWithFormat:@"?pk_store=%@&pk_pos=%@&pk_operator=%@&vbcode=%@",[Singleton sharedSingleton].pk_store,[Singleton sharedSingleton].pk_pos,[Singleton sharedSingleton].pk_inemp,[Singleton sharedSingleton].vbcode]];
    return dict;
}
-(NSDictionary *)WebcancelFolioPayment
{
//    --取消支付
//    vbcode：账单号码
//http://192.168.0.206:8888/saleInfoController/cancelFolioPayment?vbcode=1220140903P000004
    NSDictionary *dict = [self bsService:@"WebcancelFolioPayment" arg:[NSString stringWithFormat:@"?vbcode=%@",[Singleton sharedSingleton].vbcode]];
    return dict;
}
/**
 *  设备注册
 *
 *  @return
 */
-(NSDictionary *)WebAddHand
{
    //--pad注册信息发送
    //parameter:hands
    //vdevid:设备硬件号
    //http://192.168.0.236:8888/userInfoController/addHand?hands={"root":[{"vdevid":"c97221b714e14f91b8f4"}]}
    NSMutableDictionary *message=[NSMutableDictionary dictionary];
    [message setObject:[self UUIDString] forKey:@"vdevid"];
    NSDictionary *dic=[[NSDictionary alloc]  initWithObjectsAndKeys:[NSArray arrayWithObjects:message, nil],@"root", nil];
    NSDictionary *dict = [self bsService:@"WebaddHand" arg:[NSString stringWithFormat:@"?hands=%@",[dic JSONRepresentation]]];
    return dict;
}
/**
 *  根据手机号查询卡号
 *
 *  @param info 手机信息
 *
 *  @return
 */
-(NSDictionary *)WebreadCardByPhoneNo:(NSDictionary *)info
{
    NSDictionary *dict=[self bsService:@"WebreadCardByPhoneNo" arg:[NSString stringWithFormat:@"?queryPhoneNo=%@",[info objectForKey:@"phoneNum"]]];
    return dict;
}
//http://192.168.0.236:8888/cardController/readCardByCardNo_pad?queryCardNo=000238&vbcodd=1120140919P000006
/**
 *  根据卡号查卡信息
 *
 *  @param info 卡号信息
 *
 *  @return 
 */
-(NSDictionary *)WebreadCardByCardNo_pad:(NSDictionary *)info{
    NSDictionary *dict=[self bsService:@"WebreadCardByCardNo_pad" arg:[NSString stringWithFormat:@"?queryCardNo=%@&vbcodd=%@",[info objectForKey:@"cardNum"],[Singleton sharedSingleton].vbcode]];
    return dict;
}
/**
 *  手势划菜
 *
 *  @param info 划菜信息
 *  @param tag  划菜标示
 *
 *  @return
 */
-(NSString *)Webscratch:(NSDictionary *)info andtag:(int)tag
{
    NSString *strParam = [NSString stringWithFormat:@"?pk_ordrs=%@",[[NSArray arrayWithObject:[info objectForKey:@"pk_ordr"]]JSONRepresentation]];
    if (tag==0) {
        NSDictionary *dict = [self bsService:@"WebunzoneDishesByOrdrBatch" arg:strParam];
        NSString *result = [dict objectForKey:@"message"];
        return result;
    }else
    {
        NSDictionary *dict = [self bsService:@"WebzoneDishesByOrdrBatch" arg:strParam];
        NSString *result = [dict objectForKey:@"message"];
        return result;
    }
}
/**
 *  划菜按钮
 *
 *  @param dish
 *
 *  @return
 */
-(NSDictionary *)Webscratch:(NSArray *)dish
{
    NSMutableArray *mutfood = [NSMutableArray array];
    NSMutableArray *fanfood=[NSMutableArray array];
    for (NSDictionary *info in dish) {
        if ([[info objectForKey:@"nzonedcount"] intValue]==[[info objectForKey:@"ncount"] intValue])
            [fanfood addObject:[info objectForKey:@"pk_ordr"]];
        else
            [mutfood addObject:[info objectForKey:@"pk_ordr"]];
    }
    NSDictionary *dict1;
    if ([mutfood count]>0) {
        NSString *strParam = [NSString stringWithFormat:@"?pk_ordrs=%@",[mutfood JSONRepresentation]];
        NSDictionary *dict = [self bsService:@"WebzoneDishesByOrdrBatch" arg:strParam];
//        NSString *result = [dict objectForKey:@"message"];
        dict1=dict;
    }
    if ([fanfood count]>0) {
        NSString *strParam = [NSString stringWithFormat:@"?pk_ordrs=%@",[fanfood JSONRepresentation]];
        NSDictionary *dict = [self bsService:@"WebunzoneDishesByOrdrBatch" arg:strParam];
//        NSString *result = [dict objectForKey:@"message"];
        if (dict1==nil) {
            dict1=dict;
        }
    }
    return dict1;
}
#pragma mark 计算服务费
-(NSDictionary *)ComputingServicefee:(NSString *)type
{
    /*
     deviceId：设备编号
     
     userCode：用户编码
     
     type: 操作类型  0 取消服务费  1 计算服务费
     
     tableNum：桌号
     
     ordered   账单号
     
     lclass    账单类型： 1 堂食  2 外带  3 外送 ….
     */
    NSString *pdaid,*user;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&type=%@&orderId=%@&lclass=%@",pdaid,user,[Singleton sharedSingleton].Seat,type,[Singleton sharedSingleton].CheckNum,@"1"];
    NSDictionary *dict = [[self bsService:@"ComputingServicefee" arg:strParam] objectForKey:@"ns:ComputingServicefeeResponse"];
    return dict;
}
#pragma mark -销售预估
-(NSDictionary *)productEstimate:(NSString *)classid
{
    //    NSString *result = @"0@pcode;菜品名称;实际销售量;预估销售量;百分比@pcode;菜品名称;实际销售量;预估销售量;百分比";
    //    NSArray *array=[result componentsSeparatedByString:@"@"];
    //    return array;
    
    NSString *strParam = [NSString stringWithFormat:@"?&deviceid=%@&usercode=%@&classid=%@&pagenum=",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user" ],classid];
    NSDictionary *dict = [self bsService:@"productEstimate" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:productEstimateResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[result componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] isEqualToString:@"0"]) {
            NSArray *ary=[NSArray arrayWithArray:array];
            NSMutableArray *data=[[NSMutableArray alloc] init];
            for (NSString *str in ary) {
                NSArray *dataAry=[str componentsSeparatedByString:@";"];
                NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:[dataAry objectAtIndex:0],@"code",[dataAry objectAtIndex:1],@"DES",[dataAry objectAtIndex:2],@"actual",[dataAry objectAtIndex:3],@"estimate",[dataAry objectAtIndex:4],@"ratio", nil];
                [data addObject:dict];
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",data,@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
        }
        
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil];
    }

}
#pragma mark 查询全部账单
-(NSDictionary *)queryAllOrders
{
    //    NSString *result = @"0@pcode;菜品名称;实际销售量;预估销售量;百分比@pcode;菜品名称;实际销售量;预估销售量;百分比";
    //    NSArray *array=[result componentsSeparatedByString:@"@"];
    //    return array;
    
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user" ]];
    NSDictionary *dict = [self bsService:@"queryAllOrders" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:queryAllOrdersResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[result componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] intValue]==0) {
            NSMutableArray *array1=[[array objectAtIndex:1] componentsSeparatedByString:@"&"];
            if ([array1 count]>1) {
                [array1 removeLastObject];
            }
            
            NSMutableArray *returnArray=[[NSMutableArray alloc] init];
            for (NSString *str in array1) {
                NSArray *array2=[str componentsSeparatedByString:@";"];
                NSMutableDictionary *dict1=[[NSMutableDictionary alloc] init];
                [dict1 setObject:[array2 objectAtIndex:0] forKey:@"orderid"];
                [dict1 setObject:[array2 objectAtIndex:1] forKey:@"Tablename"];
                [dict1 setObject:[array2 objectAtIndex:2] forKey:@"Orderstate"];
                [returnArray addObject:dict1];
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"tag",returnArray,@"message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"tag",[array objectAtIndex:1],@"message", nil];
        }
    }else
    {
        return nil;
    }
}
#pragma mark - 在线会员
//string onelineQueryCardByMobTel(string deviceId,QString userCode,QString telNum );
/**
 *  @author ZhangPo, 15-05-07 14:05:03
 *
 *  @brief  根据手机号查询卡号
 *
 *  @param telNum 手机号
 *
 *  @return 手机号
 *
 *  @since
 */
-(NSDictionary *)onelineQueryCardByMobTel:(NSString *)telNum
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&telNum=%@&orderid=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],telNum,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"onelineQueryCardByMobTel" arg:strParam];
    if (dict) {
        NSString *jsonStr=[[[dict objectForKey:@"ns:onelineQueryCardByMobTelResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *dicMessageInfo = [parser objectWithString:jsonStr];
        return dicMessageInfo;
    }
    
    return dict;
}
/**
 *  @author ZhangPo, 15-05-07 14:05:10
 *
 *  @brief  根据卡号查询卡信息
 *
 *  @param cardNum 卡号
 *
 *  @return 卡信息
 *
 *  @since
 */
-(NSDictionary *)onelineQueryCardByCardNo:(NSString *)cardNum
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&cardNum=%@&orderid=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],cardNum,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"onelineQueryCardByCardNo" arg:strParam];
    if (dict) {
        NSString *jsonStr=[[[dict objectForKey:@"ns:onelineQueryCardByCardNoResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *dicMessageInfo = [parser objectWithString:jsonStr];
        return dicMessageInfo;
    }
    return dict;
}
#pragma mark - 活动使用
-(NSDictionary *)activityUserCounp:(NSDictionary *)info{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[info objectForKey:@"money"]==nil?@"0":@"1",@"jmtyp",[info objectForKey:@"money"]==nil?@"0":[info objectForKey:@"TAG"],@"ryzktyp", nil];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@&counpId=%@&counpCnt=%@&counpMoney=%@&json=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"CODE"],@"1",[info objectForKey:@"money"]==nil?[info objectForKey:@"OPERATEVALUE"]:[info objectForKey:@"money"],[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"userCounp" arg:strParam];
    if (dict) {
        NSString *returnStr=[[[dict objectForKey:@"ns:userCounpResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[returnStr componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] intValue]==0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"成功",@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil];
}
#pragma mark - 查询必选附加项
-(NSArray *)SelectPrivateAddition:(NSString *)pcode
{
    NSMutableArray * ary=[NSMutableArray array];
    NSArray *array=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select PRODUCTTC_ORDER from foodfujia where pcode='%@'  GROUP BY PRODUCTTC_ORDER",pcode]];
    for (NSDictionary * dict in array) {
        NSMutableArray *arry=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from foodfujia where PRODUCTTC_ORDER='%@' and pcode ='%@' ORDER BY DEFUALTS ASC",[dict objectForKey:@"PRODUCTTC_ORDER"],pcode]];
        NSDictionary *dict=[arry objectAtIndex:0];
        [arry removeObjectAtIndex:0];
        for (NSDictionary *dic in arry) {
            [dic setValue:[dict objectForKey:@"FNAME"] forKey:@"name"];
            [dic setValue:[dict objectForKey:@"MINCNT"] forKey:@"FMINCNT"];
            [dic setValue:[dict objectForKey:@"MAXCNT"] forKey:@"FMAXCNT"];
        }
        for (int i=0;i<[arry count];i++) {
            for (int j=i+1;j<[arry count]; j++) {
                if ([[[arry objectAtIndex:i] objectForKey:@"sortno"] intValue]>[[[arry objectAtIndex:j] objectForKey:@"sortno"] intValue]) {
                    [arry exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }
        }
        [ary addObject:arry];
    }
    return ary;
}
#pragma mark - 预结算账单查询
-(NSDictionary *)paymentViewQueryProduct
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@&comOrDetach=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,@"1"];
    NSDictionary *dict = [self bsService:@"queryProduct" arg:strParam];
    if (dict) {
        float foodPrice=0.0000,paymentPrice=0.0000;
        NSMutableDictionary *returnDict=[[NSMutableDictionary alloc] init];
        NSString *returnStr=[[[dict objectForKey:@"ns:queryProductResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[returnStr componentsSeparatedByString:@"#"];
        //菜品解析
        if ([array count]==1) {
            NSArray *foodAry=[[array objectAtIndex:0] componentsSeparatedByString:@"@"];
            if ([[foodAry objectAtIndex:0] intValue]!=0) {
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil];
            }
        }
        NSMutableArray *foodArrayC=[[array objectAtIndex:0] componentsSeparatedByString:@";"];
        [foodArrayC removeLastObject];
        NSMutableArray *foodArray=[[NSMutableArray alloc] init];
        for (NSString *foodStr in foodArrayC) {
            NSArray *foodAry=[foodStr componentsSeparatedByString:@"@"];
            if ([[foodAry objectAtIndex:0] intValue]!=0) {
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil];
            }
            NSMutableDictionary *foodDic=[[NSMutableDictionary alloc] init];
            [foodDic setObject:[foodAry objectAtIndex:2] forKey:@"PKID"];
            [foodDic setObject:[foodAry objectAtIndex:3] forKey:@"pcode"];
            [foodDic setObject:[foodAry objectAtIndex:4] forKey:@"PCname"];
            [foodDic setObject:[foodAry objectAtIndex:5] forKey:@"tpcode"];
            [foodDic setObject:[foodAry objectAtIndex:6] forKey:@"TPNAME"];
            [foodDic setObject:[foodAry objectAtIndex:7] forKey:@"TPNUM"];
            [foodDic setObject:[foodAry objectAtIndex:8] forKey:@"pcount"];
            [foodDic setObject:[foodAry objectAtIndex:9] forKey:@"promonum"];
            [foodDic setObject:[foodAry objectAtIndex:10] forKey:@"fujiacode"];
            [foodDic setObject:[foodAry objectAtIndex:11] forKey:@"fujianame"];
            [foodDic setObject:[foodAry objectAtIndex:12] forKey:@"price"];
            [foodDic setObject:[foodAry objectAtIndex:13] forKey:@"fujiaprice"];
            [foodDic setObject:[foodAry objectAtIndex:14] forKey:@"weight"];
            [foodDic setObject:[foodAry objectAtIndex:15] forKey:@"weightflg"];
            [foodDic setObject:[foodAry objectAtIndex:16] forKey:@"unit"];
            [foodDic setObject:[foodAry objectAtIndex:17] forKey:@"ISTC"];
            [foodDic setObject:[NSString stringWithFormat:@"%.2f",[[foodAry objectAtIndex:12] floatValue]+[[foodAry objectAtIndex:13] floatValue]] forKey:@"price"];
            foodPrice+=[[foodAry objectAtIndex:12] floatValue]+[[foodAry objectAtIndex:13] floatValue];
            [foodArray addObject:foodDic];
        }
        [returnDict setObject:foodArray forKey:@"foodList"];
        NSMutableArray *paymentArrayC=[NSMutableArray arrayWithArray:[[array objectAtIndex:1] componentsSeparatedByString:@";"]];
        [paymentArrayC removeLastObject];
        double calculateZero=0.0000;
        NSMutableArray *paymentArray=[[NSMutableArray alloc] init];
        for (NSString *paymentStr in paymentArrayC) {
            NSArray *paymentAry=[paymentStr componentsSeparatedByString:@"@"];
            if ([[paymentAry objectAtIndex:0] intValue]!=0) {
                return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil];
            }
            NSMutableDictionary *paymentDic=[[NSMutableDictionary alloc] init];
            [paymentDic setObject:[paymentAry objectAtIndex:2] forKey:@"paymentName"];
            [paymentDic setObject:[paymentAry objectAtIndex:3] forKey:@"paymentPrice"];
            [paymentDic setObject:[paymentAry objectAtIndex:4] forKey:@"paymentCode"];
            [paymentDic setObject:[paymentAry objectAtIndex:5] forKey:@"paymentShowPrice"];
            if ([[paymentAry objectAtIndex:6] intValue]==1) {
                calculateZero+=[[paymentAry objectAtIndex:6] doubleValue];
            }
            paymentPrice+=[[paymentAry objectAtIndex:3] floatValue];
            [paymentArray addObject:paymentDic];
        }
        double ClearZeroMoney=[self ClearZeroFunSumYmoney:foodPrice-calculateZero];
        //        double
        NSMutableDictionary *paymentDic=[[NSMutableDictionary alloc] init];
        [paymentDic setObject:@"账单金额" forKey:@"paymentName"];
        [paymentDic setObject:[NSString stringWithFormat:@"%.2f",foodPrice] forKey:@"paymentShowPrice"];
        [paymentArray insertObject:paymentDic atIndex:0];
        [returnDict setObject:paymentArray forKey:@"paymentList"];
        NSArray *ary2=[[array objectAtIndex:2] componentsSeparatedByString:@"@"];
        if ([[ary2 objectAtIndex:0] intValue]==0) {
            [Singleton sharedSingleton].man=[ary2 objectAtIndex:1];
            [Singleton sharedSingleton].woman=[ary2 objectAtIndex:2];
        }
        NSArray *ary3=[[array objectAtIndex:3] componentsSeparatedByString:@";"];
        NSMutableString *str=[NSMutableString string];
        for (NSString *result2 in ary3) {
            NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
            if ([ary3 count]==2) {
                [str appendFormat:@"%@ ",[ary3 objectAtIndex:1]];
            }
        }
        [returnDict setObject:str forKey:@"whole"];
        [returnDict setObject:[NSString stringWithFormat:@"%.2f",ClearZeroMoney] forKey:@"CLEARZERO"];
        [returnDict setObject:[NSString stringWithFormat:@"%.2f",foodPrice] forKey:@"foodPrice"];
        [returnDict setObject:[NSString stringWithFormat:@"%.2f",foodPrice-paymentPrice-ClearZeroMoney] forKey:@"paymentPrice"];
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",returnDict,@"Message", nil];
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"查询失败",@"Message", nil];
}
#pragma mark - 会员支付
-(NSDictionary *)onelineCardOutAmt:(NSDictionary *)info{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&json=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[info JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"onelineCardOutAmt" arg:strParam];
    if (dict) {
        NSString *returnStr=[[[dict objectForKey:@"ns:onelineCardOutAmtResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *dicMessageInfo = [parser objectWithString:returnStr];
        return dicMessageInfo;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"return",@"查询失败",@"error", nil];
}
#pragma mark - 根据券查询活动
-(NSDictionary *)couponForTicket:(NSDictionary *)ticket
{
    return [[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from coupon_main where VVOUCHERCODE ='%@'",[ticket objectForKey:@"couponCode"]]] lastObject];
}
#pragma mark - 现金银行卡支付
-(NSDictionary *)userPayment:(NSDictionary *)info{
    
    NSMutableDictionary *jsonDic=[[NSMutableDictionary alloc] init];
    [jsonDic setObject:[info objectForKey:@"timestamp"] forKey:@"timestamp"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@&paymentId=%@&paymentCnt=%@&mpaymentMoney=%@&payFinish=%@&integralOverall=%@&cardNumber=%@&json=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user" ],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[NSString stringWithFormat:@"%@!",[info objectForKey:@"paymentID"]],[NSString stringWithFormat:@"%@!",[info objectForKey:@"paymentCnt"]],[NSString stringWithFormat:@"%@!",[info objectForKey:@"paymentMoney"]],[NSString stringWithFormat:@"0!%@",[info objectForKey:@"payFinish"]],[info objectForKey:@"integralOverall"],[info objectForKey:@"cardNumber"]==nil?@"":[info objectForKey:@"cardNumber"],[jsonDic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"userPayment" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:userPaymentResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[result componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] intValue]==0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"支付完成",@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"支付失败",@"Message", nil];
        }
    }else
    {
        return nil;
    }
}
#pragma mark - 活动查询
-(NSArray *)selectCoupon
{
    NSArray *coupon_kindArray=[BSDataProvider getDataFromSQLByCommand:@"select * from coupon_kind"];
    for (NSDictionary *dict in coupon_kindArray) {
        NSArray *coupon_mainArray=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from coupon_main WHERE KINDID='%@' and ISSHOW='1'",[dict objectForKey:@"KINDID"]]];
        [dict setValue:coupon_mainArray forKey:@"coupon_main"];
    }
    return coupon_kindArray;
}
#pragma mark - 取消支付接口
-(NSDictionary *)cancleUserPayment:(NSString *)passWord
{
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:passWord,@"cardPassword", nil];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@&json=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user" ],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[dic JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"cancleUserPayment" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:cancleUserPaymentResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[result componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] intValue]==0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[array objectAtIndex:1],@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
        }
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"取消支付失败",@"Message", nil];
    }
}
#pragma mark - 取消优惠
-(NSDictionary *)cancleUserCounp
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user" ],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"cancleUserCounp" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:cancleUserCounpResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[result componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] intValue]==0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[array objectAtIndex:2],@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
        }
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"取消优惠失败",@"Message", nil];
    }
}
//@"SELECT *FROM settlementoperate WHERE OPERATEGROUPID='5'"
#pragma mark - 查询银行卡
-(NSArray *)selectBankArray
{
    return [BSDataProvider getDataFromSQLByCommand:@"SELECT *FROM settlementoperate WHERE OPERATEGROUPID='31'"];
}
#pragma mark - 查询现金
-(NSArray *)selectCashArray
{
    return [BSDataProvider getDataFromSQLByCommand:@"SELECT *FROM settlementoperate WHERE OPERATEGROUPID='5'"];
}
#pragma mark - 查询网络支付
-(NSArray *)selectOnlinePaymentArray
{
    return [BSDataProvider getDataFromSQLByCommand:@"SELECT *FROM settlementoperate WHERE OPERATEGROUPID in('50','48')"];
}
#pragma mark - 查询是否存在会员消费
-(NSDictionary *)memberConsumptionRecord
{
    return [self querySqlInterface:[NSString stringWithFormat:@"select count(*) from cardordrs where PCONACCT = '%@' and pserial not in(select pserialor from changeamt where pflag = '2') ORDER BY miscode DESC",[Singleton sharedSingleton].CheckNum]];
}
#pragma mark - 查询需要支付列表
-(NSDictionary *)shouldCheckData
{
    return [self querySqlInterface:@"SELECT a.TABLENUM,a.ORDERID,b.TBLNAME,a.PEOLENUMMAN,a.PEOLENUMWOMEN FROM handevtableorder_relation a left JOIN storetables_mis b ON a.TABLENUM=b.TABLENUM WHERE TABLESTATE='0' and MOBILEBILLOK='1'"];
    //    return [self querySqlInterface:@"SELECT a.TABLENUM,a.ORDERID,b.TBLNAME,a.PEOLENUMMAN,a.PEOLENUMWOMEN FROM handevtableorder_relation a left JOIN storetables_mis b ON a.TABLENUM=b.TABLENUM WHERE TABLESTATE='0'"];
}
-(NSDictionary *)updateTableStata
{
    return [self querySqlInterface:[NSString stringWithFormat:@"UPDATE handevtableorder_relation SET TABLESTATE ='0' WHERE ORDERID='%@'",[Singleton sharedSingleton].CheckNum]];
}

#pragma mark - 扫描支付
//传入所有的支付信息
-(NSDictionary *)scanCode:(NSDictionary *)alipayDic
{
    NSString *type=nil;
    //判断支付方式编码settlementoperate表里的OPERATEGROUPID字段
    
    if ([[alipayDic objectForKey:@"OPERATEGROUPID"] intValue]==50) {
        type=@"1";
    }else
    {
        type=@"2";
    }
    /*
     键              值
     operate        OPERATE支付方式settlementoperate表里的OPERATE
     auth_code      扫描二维码获取
     total_fee      账单金额默认一次支付完成
     orderid        账单号
     finished       支付完成
     type           支付类型
     */
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:[alipayDic objectForKey:@"OPERATE"],@"operate",[alipayDic objectForKey:@"auth_code"],@"auth_code",@"0.01",@"total_fee",[Singleton sharedSingleton].CheckNum,@"orderid",@"1",@"finished",type,@"type",nil];
    // 拼接串   [dic JSONRepresentation] 将dic 转成json格式
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&json=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[dic JSONRepresentation]];
    //调用接口scanCode返回值为dict
    NSDictionary *dict = [self bsService:@"scanCode" arg:strParam];
    if (dict) {
        NSString *returnStr=[[[dict objectForKey:@"ns:scanCodeResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        //将返回值转成json
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *dicMessageInfo = [parser objectWithString:returnStr];
        return dicMessageInfo;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"return",@"支付失败",@"error", nil];
}
#pragma mark - 微信上传
-(NSDictionary *)pushWeChatCheckOut:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&json=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[info JSONRepresentation]];
    NSDictionary *dict = [self bsService:@"pushWeChatCheckOut" arg:strParam];
    if (dict) {
        NSString *returnStr=[[[dict objectForKey:@"ns:pushWeChatCheckOutResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *dicMessageInfo = [parser objectWithString:returnStr];
        return dicMessageInfo;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"return",@"上传失败",@"error", nil];
}
#pragma mark - 更新版本号
-(NSDictionary *)updateDataVersion:(NSString *)dataVersion
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&dataVersion=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],dataVersion];
    NSDictionary *dict = [self bsService:@"updateDataVersion" arg:strParam];
    if (dict) {
        NSString *returnStr=[[[dict objectForKey:@"ns:updateDataVersionResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[returnStr componentsSeparatedByString:@"@"];
        if ([[array objectAtIndex:0] intValue]==0) {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[array objectAtIndex:1],@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"更新失败",@"Message", nil];
    //    return [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"return",@"上传失败",@"error", nil];
}
#pragma mark - 通用查询 sql 语句接口
-(NSDictionary *)querySqlInterface:(NSString *)sql
{
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//    NSInteger interval = [zone secondsFromGMTForDate:datenow];
//    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [localeDate]
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy"];
//    //用[NSDate date]可以获取系统当前时间
//    int  yy = [[dateFormatter stringFromDate:localeDate] intValue];
//    [dateFormatter setDateFormat:@"MM"];
//    //用[NSDate date]可以获取系统当前时间
//    int MM = [[dateFormatter stringFromDate:localeDate] intValue];
//    [dateFormatter setDateFormat:@"dd"];
    //用[NSDate date]可以获取系统当前时间
//    int dd = [[dateFormatter stringFromDate:localeDate] intValue];
//    NSString *str=[NSString stringWithFormat:@"HHT%d%.2d%.2d",yy+1,MM-1,dd+1];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&strsql=%@&parityBit=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],sql,@""];
    NSDictionary *dict = [self bsService:@"querySqlInterface" arg:strParam];
    if (dict) {
        NSString *returnStr=[[[dict objectForKey:@"ns:querySqlInterfaceResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *dicMessageInfo = [parser objectWithString:returnStr];
        return dicMessageInfo;
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:@"-1",@"return",@"查询失败",@"error", nil];
}
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
/****************
 功能：抹零金额计算
 修改时间：2014-04-16
 参数1 抹零方式        clearMoneyYN  1 向下 2 向上 3 四舍五入
 要抹零的金额          sumYmoney
 抹零金额              ClearZeroMoney
 抹零到那一位          dClearBit 100 抹零到百位 10 抹零到十位 1 抹零到个位 0.1抹零到第一位小数 0.01抹零到两位小数
 抹零金额保留位小数位   iDoubleBitn
 ***************/
-(double)ClearZeroFunSumYmoney:(double)sumYmoney
{
    NSDictionary *dict=[[BSDataProvider getDataFromSQLByCommand:@"select * from posdb"] lastObject];
    double ClearZeroMoney =0.000000;
    double desMoney = sumYmoney;//抹零前合计金额
    if([[dict objectForKey:@"CLEARMONEYYN"] intValue]==1)
    {//向下抹零
        if(desMoney>0.0001 || desMoney>-0.0001){
            desMoney = desMoney+0.001;
        }
        else
        {
            desMoney = desMoney-0.001;
        }
        ClearZeroMoney =fmod(desMoney,[[dict objectForKey:@"CLEARMONEYBIT"] floatValue]);//取余数 要抹掉部分
    }
    else if([[dict objectForKey:@"CLEARMONEYYN"] intValue]==2)
    {//向上抹零
        ClearZeroMoney =fmod(desMoney,[[dict objectForKey:@"CLEARMONEYBIT"] floatValue]);
        if(!(ClearZeroMoney>-0.001 && ClearZeroMoney<0.001))
        {
            ClearZeroMoney = [[dict objectForKey:@"CLEARMONEYBIT"] floatValue]-ClearZeroMoney;
        }
        if(!(ClearZeroMoney>-0.001 && ClearZeroMoney<0.001))
        {
            ClearZeroMoney=-ClearZeroMoney;
        }
    }
    else
    {//四舍五入
        ClearZeroMoney =fmod(desMoney,[[dict objectForKey:@"CLEARMONEYBIT"] floatValue]);
        ClearZeroMoney=[[NSString stringWithFormat:@"%.6f",ClearZeroMoney] doubleValue];
        double ipart = [[dict objectForKey:@"CLEARMONEYBIT"] floatValue]/2;
        double diff = ClearZeroMoney-ipart;
        if(!(ClearZeroMoney>-0.0001 && ClearZeroMoney<0.0001))
        {
            if(ClearZeroMoney<=([[dict objectForKey:@"CLEARMONEYBIT"] floatValue]-ClearZeroMoney) && !(diff<0.0001 && diff>-0.0001))
            {//舍
                sumYmoney = desMoney-ClearZeroMoney;
            }
            else
            {//入
                sumYmoney = desMoney+([[dict objectForKey:@"CLEARMONEYBIT"] floatValue]-ClearZeroMoney);
                ClearZeroMoney =ClearZeroMoney-[[dict objectForKey:@"CLEARMONEYBIT"] floatValue];
            }
        }
    }
    return ClearZeroMoney;
}
#pragma mark - 退菜
-(NSDictionary *)cancleProducts:(NSDictionary *)info
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:[Singleton sharedSingleton].CheckNum forKey:@"orderid"];
    [dic setObject:[[info objectForKey:@"info"] objectForKey:@"user"] forKey:@"accreditcode"];
    [dic setObject:[[info objectForKey:@"info"] objectForKey:@"INIT"] forKey:@"backreason"];
    NSMutableArray *foodArray=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in [info objectForKey:@"dataArray"]) {
        NSMutableDictionary *food=[[NSMutableDictionary alloc] init];
        [food setObject:[dict objectForKey:@"Pcode"] forKey:@"pcode"];
        [food setObject:[dict objectForKey:@"pcount"] forKey:@"canclecount"];
        [food setObject:[dict objectForKey:@"PKID"] forKey:@"pkid"];
        [food setObject:[dict objectForKey:@"weightflg"] forKey:@"weightflg"];
        [food setObject:[dict objectForKey:@"ISTC"] forKey:@"istc"];
        [food setObject:[dict objectForKey:@"UnitCode"] forKey:@"unitcode"];
        [food setObject:[dict objectForKey:@"istemp"] forKey:@"istemp"];
        [food setObject:[dict objectForKey:@"CLASS"] forKey:@"jiorjiao"];
        [food setObject:[dict objectForKey:@"fujiacode"] forKey:@"fujiacode"];
        [foodArray addObject:food];
    }
    [dic setObject:foodArray forKey:@"dishList"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&json=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user" ],[dic JSONRepresentation]];
    NSDictionary *returnDic = [self bsService:@"cancleProducts" arg:strParam];
    if (returnDic) {
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:cancleProductsResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSMutableDictionary *dicMessageInfo = [parser objectWithString:strResponser];
        return dicMessageInfo;
    }
    return returnDic;
}
/**
 *  webPos查询公共附加项
 *
 *  @return
 */
-(NSArray *)getAdditionsAndClass
{
    NSMutableArray * ary=[NSMutableArray array];
    NSArray *array=[BSDataProvider getDataFromSQLByCommand:@"select pk_redefine_type from redefine_type"];
    for (NSDictionary * dict in array) {
        NSArray *arry=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT * FROM redefine_type a LEFT JOIN FoodFuJia b WHERE a.pk_redefine_type=b.rgrp and b.rgrp='%@' AND (b.PCODE ='' or b.PCODE='~_PCODE_~')",[dict objectForKey:@"pk_redefine_type"]]];
        [ary addObject:arry];
    }
    return ary;
}
#pragma mark - 权限验证
-(NSDictionary *)selectRolemodule:(NSString *)moduleCode
{
    BOOL ROLE,ROLEYN;
    NSArray *array=[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"SELECT b.code as rolecode from module a,role b,ROLEMODULE c where a.PK_MODULE =c.PK_MODULE and b.PK_ROLE=c.PK_ROLE and a.CODE='%@'",moduleCode]];
    NSMutableArray *ary=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        [ary addObject:[dic objectForKey:@"rolecode"]];
    }
    //判断权限是否存在，如果不存在没有权限验证
    if ([ary count]==0) {
        ROLE=YES;
    }else{
        //判断权限执行的角色是否是登录角色
        if (![ary containsObject:[Singleton sharedSingleton].jurisdiction]) {
            ROLE=NO;
        }else
        {
            ROLE=YES;
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:ROLE],@"ROLE",[NSNumber numberWithBool:ROLEYN],@"ROLEYN", nil];
}
#pragma mark - 获取等位类型
-(NSArray *)queryTyp
{
    NSString *strParam = [NSString stringWithFormat:@"?&pk_store=%@&lineno=",[Singleton sharedSingleton].pk_store];
    NSDictionary *returnDic = [self bsService:@"queryTyp" arg:strParam];
    if (returnDic) {
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:queryTypResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSMutableArray *dicMessageInfo = [parser objectWithString:strResponser];
        [dicMessageInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"全部",@"vname",@"",@"vcode", nil]];
        [dicMessageInfo addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"历史",@"vname",@"LS",@"vcode",@"Y",@"history", nil]];
        return dicMessageInfo;
    }
    return nil;
}
#pragma mark - 取号
-(NSDictionary *)takeNO:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&pk_store=%@&pnum=%@&tele=%@&wechat=&lineno=",[Singleton sharedSingleton].pk_store,[info objectForKey:@"people"],[info objectForKey:@"phone"]];
    NSDictionary *returnDic = [self bsService:@"takeNO" arg:strParam];
    if (returnDic) {
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:takeNOResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSRange range = [strResponser rangeOfString:@"ERROR"];
        if (range.location!=NSNotFound){
            NSArray *array=[strResponser componentsSeparatedByString:@"-"];
            int i=[[array objectAtIndex:1] intValue];
            NSString *str=nil;
            if (i==9001) {
                str=@"分店参数必传";
            }else if (i==9002) {
                str=@"人数参数必传不得小于0";
            }else if (i==9004) {
                str=@"未设置等位类型";
            }else if (i==9005) {
                str=@"未满足此人数的等位类型";
            }else if (i==9006) {
                str=@"无此分店";
            }else if (i==9007) {
                str=@"分店餐次时间未设置";
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",str,@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",strResponser,@"Message", nil];
        }

//        NSMutableDictionary *dicMessageInfo = [parser objectWithString:strResponser];
//        return dicMessageInfo;
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result","失败",@"Message", nil];
    }
    return nil;
}
#pragma mark - 获取取号信息
-(NSArray *)queryNO:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&pk_store=%@&lineno=&history=",[Singleton sharedSingleton].pk_store,[info objectForKey:@"lineno"],[info objectForKey:@"history"]];
    NSDictionary *returnDic = [self bsService:@"queryNO" arg:strParam];
    if (returnDic) {
        SBJsonParser * parser = [[SBJsonParser alloc]init];
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:queryNOResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSMutableArray *dicMessageInfo = [parser objectWithString:strResponser];
        return dicMessageInfo;
    }
    return nil;
}
///waitSeat/cancelSeat.do? pk_store=&tele=&sta=&wechar=&rec=
//参数：pk_store  分店编码（必选）
//tele/wechat  手机号/微信号二选一（必选）
//sta       等位状态(C:取消等位,D:叫号)（必选）
//rec       顺序号
#pragma mark - 过号取号
-(NSDictionary *)cancelSeat:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&pk_store=%@&tele=%@&sta=%@&wechat=&rec=%@",[Singleton sharedSingleton].pk_store,[info objectForKey:@"tele"],[info objectForKey:@"sta"],[info objectForKey:@"rec"]];
    NSDictionary *returnDic = [self bsService:@"cancelSeat" arg:strParam];
    if (returnDic) {
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:cancelSeatResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        if ([strResponser intValue]==0) {
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"成功",@"Message", nil];
            return dict;
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
        }
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
    }
    return nil;
}
-(NSDictionary *)callNumber:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&json=%@",[info JSONRepresentation]];
    NSDictionary *returnDic = [self bsService:@"callNumber" arg:strParam];
    if (returnDic) {
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:callNumberResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        if ([strResponser intValue]==0) {
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",@"成功",@"Message", nil];
            return dict;
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
        }
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
    }
    return nil;
}
#pragma mark - 查询等位列表
-(NSDictionary *)queryReserveTableNum
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *returnDic = [self bsService:@"queryReserveTableNum" arg:strParam];
    if (returnDic) {
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:queryReserveTableNumResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[strResponser componentsSeparatedByString:@"@"];
        NSMutableArray *_waitSeatArray=[[NSMutableArray alloc] init];
        if ([[array objectAtIndex:0] length]>3) {
            for (NSString *str in array)
            {
                NSArray *values = [str componentsSeparatedByString:@";"];
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[values objectAtIndex:1],@"phoneNum",[values objectAtIndex:2],@"CheakNum",[values objectAtIndex:3],@"waitNum",[values objectAtIndex:4],@"manNum",[values objectAtIndex:5],@"womanNum", nil];
                [_waitSeatArray addObject:dic];
            }
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",_waitSeatArray,@"Message", nil];
        }else
        {
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
        }
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
    }
}
#pragma mark - 取消预定
-(NSDictionary *)cancelReserveTableNum:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&misOrderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[info objectForKey:@"phoneNum"],[info objectForKey:@"waitNum"]];
    NSDictionary *returnDic = [self bsService:@"cancelReserveTableNum" arg:strParam];
    if (returnDic) {
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:cancelReserveTableNumResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[strResponser componentsSeparatedByString:@"@"];
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[[array objectAtIndex:0] intValue]==0?YES:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
    }
}
#pragma mark - 预定开台
-(NSDictionary *)reserveTableNum:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&manCounts=%@&womanCounts=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[info objectForKey:@"phone"],[info objectForKey:@"people"],[info objectForKey:@"woman"]];
    NSDictionary *returnDic = [self bsService:@"reserveTableNum" arg:strParam];
    if (returnDic) {
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:reserveTableNumResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[strResponser componentsSeparatedByString:@"@"];
        if([[array objectAtIndex:0]intValue]==0){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[NSDictionary dictionaryWithObjectsAndKeys:[array objectAtIndex:1],@"CheakNum",[array objectAtIndex:2],@"waitNum", nil],@"Message", nil];
        }
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[[array objectAtIndex:0] intValue]==0?YES:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
    }
}
#pragma mark - 预定开台
-(NSDictionary *)changeTableNum:(NSDictionary *)info
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tablenumSource=%@&tablenumDest=%@&orderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[info objectForKey:@"newtable"],[Singleton sharedSingleton].CheckNum];
    NSDictionary *returnDic = [self bsService:@"changeTableNum" arg:strParam];
    if (returnDic) {
        NSMutableString *strResponser=[[[returnDic objectForKey:@"ns:changeTableNumResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *array=[strResponser componentsSeparatedByString:@"@"];
        if([[array objectAtIndex:0]intValue]==0){
            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",[array objectAtIndex:1],@"Message", nil];
        }
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:[[array objectAtIndex:0] intValue]==0?YES:NO],@"Result",[array objectAtIndex:1],@"Message", nil];
    }else
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"Result",@"失败",@"Message", nil];
    }
}

@end
