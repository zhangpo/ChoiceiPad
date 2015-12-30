//
//  AKsMoneyVIew.h
//  BookSystem
//
//  Created by sundaoran on 13-12-3.
//
//

//现金录入
#import "BSRotateView.h"

@protocol AKsMoneyVIewDelegate <NSObject>

-(void)AKsMoneyVIewClick:(NSDictionary *)info;
//-(void)sureMoney:(NSString *)money andName:(NSString *)name andTag:(int)btnTag;

@end

@interface AKsMoneyVIew : BSRotateView<UITextFieldDelegate>

@property(nonatomic,weak)__weak id<AKsMoneyVIewDelegate>delegate;


- (id)initWithFrame:(CGRect)frame withPayment:(NSDictionary *)paymentDic;
@end
