//
//  Singleton.h
//  BookSystem
//
//  Created by chensen on 13-11-22.
//
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
{
    BOOL     _isYudian;
}
@property(nonatomic,strong)NSMutableArray *dishArray;
@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,strong)NSString *Seat;
@property(nonatomic,strong)NSString *CheckNum;
@property(nonatomic,strong)NSString *Time;
@property(nonatomic,strong)NSString *man;
@property(nonatomic,strong)NSString *jurisdiction;
@property(nonatomic,strong)NSString *woman;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *dueAmt;
@property(nonatomic)int segment;
@property(nonatomic,strong)NSMutableArray *order;
@property(nonatomic)BOOL quandan;
@property(nonatomic)BOOL SELEVIP;
@property(nonatomic,strong)NSString *WaitNum;
@property(nonatomic,strong)NSString *tableName;
@property(nonatomic,strong)NSString *pk_store;//门店主键
@property(nonatomic,strong)NSString *pk_inemp;//操作员主键
@property(nonatomic,strong)NSString *pk_pos;  //pos主键
@property(nonatomic,strong)NSString *vbcode;//账单
@property(nonatomic,strong)NSString *dataVersion; //数据版本号
@property(nonatomic)BOOL isYudian;
@property(nonatomic,strong)NSDictionary *VIPCardInfo;
@property(nonatomic,strong)NSDictionary *cardMessage;
+(Singleton *)sharedSingleton;
@end
