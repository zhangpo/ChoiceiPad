//
//  AKschangeTableView.h
//  BookSystem
//
//  Created by sundaoran on 13-12-27.
//
//

#import "BSRotateView.h"

@protocol AKschangeTableViewDelegate <NSObject>

-(void)AkschangtableSure:(NSString *)phoneNum and:(NSString *)tableNum;
-(void)Akschangtablecancle;

@end
@interface AKschangeTableView : BSRotateView
{
    id<AKschangeTableViewDelegate>_delegate;

}
@property(nonatomic,retain)id<AKschangeTableViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andPhoneNum:(NSString *)phoneNum;
@end
