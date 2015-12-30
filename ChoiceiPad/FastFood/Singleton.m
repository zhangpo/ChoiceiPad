//
//  Singleton.m
//  BookSystem
//
//  Created by chensen on 13-11-22.
//
//

#import "Singleton.h"

@implementation Singleton
@synthesize dishArray=_dishArray,order=_order;
@synthesize userInfo=_userInfo;
@synthesize Seat=_Seat,CheckNum=_CheckNum,man=_man,woman=_woman,quandan=_quandan;
@synthesize isYudian=_isYudian,userName=_userName,SELEVIP=_SELEVIP,WaitNum=_WaitNum,pk_store=_pk_store,pk_inemp=_pk_inemp,pk_pos=_pk_pos,vbcode=_vbcode,jurisdiction=_jurisdiction,tableName=_tableName,VIPCardInfo=_VIPCardInfo,cardMessage=_cardMessage,dueAmt=_dueAmt,dataVersion=_dataVersion;
static Singleton *_sharedSingleton;
+(Singleton *)sharedSingleton
{
    if (!_sharedSingleton) {
        _sharedSingleton=[[Singleton alloc] init];
    }
    return _sharedSingleton;
}

@end
