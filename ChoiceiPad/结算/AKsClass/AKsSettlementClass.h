//
//  AKsSettlementClass.h
//  BookSystem
//
//  Created by sundaoran on 13-12-3.
//
//

//支付方式保存
#import <Foundation/Foundation.h>

@interface AKsSettlementClass : NSObject
{
    NSString *_SettlementId;
    NSString *_SettlementName;
    NSString *_SettlementkindId;

}

@property(nonatomic,strong) NSString *SettlementId;
@property(nonatomic,strong) NSString *SettlementName;
@property(nonatomic,strong) NSString *SettlementkindId;
@end
