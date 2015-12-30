//
//  AKsWaitSeatClass.h
//  BookSystem
//
//  Created by sundaoran on 13-12-27.
//
//

#import <Foundation/Foundation.h>

@interface AKsWaitSeatClass : NSObject
{
    NSString *_waitNum;
    NSString *_phoneNum;
    NSString *_zhangdan;
    NSString *_manNum;
    NSString *_womanNum;
}
@property(nonatomic,strong) NSString *waitNum;
@property(nonatomic,strong) NSString *phoneNum;
@property(nonatomic,strong) NSString *zhangdan;
@property(nonatomic,strong) NSString *manNum;
@property(nonatomic,strong) NSString *womanNum;
@end
