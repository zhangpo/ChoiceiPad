//
//  AKDataQueryClass.h
//  BookSystem
//
//  Created by sundaoran on 13-12-2.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface AKDataQueryClass : NSObject


-(NSArray *)selectDataFromSqlite:(NSString *)selectSentence;

+(AKDataQueryClass *)sharedAKDataQueryClass;

-(void)savePhoneNumWhithZhangdanId:(NSString *)phoneNum andZhangDanId:(NSString *)zhangdan;
-(void)delectPhoneNumWhithZhangdanId:(NSString *)zhangdan;


-(void)saveCardNumforVip:(NSString *)cardNum  andPhoneNum:(NSString *)phoneNum andzhangdanId:(NSString *)zhangdan andIntegralOverall:(NSString *)IntegralOverall;


@end
