//
//  AKsWaitSeatOpenTable.h
//  BookSystem
//
//  Created by sundaoran on 13-12-26.
//
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"
#import "AKsNetAccessClass.h"

@protocol AKsWaitSeatOpenTableDelegate

- (void)openWaitTableWithOptions:(NSDictionary *)info;
-(void)VipClickWait;

-(void)cancleAKsWaitSeat;

@end


@interface AKsWaitSeatOpenTable : BSRotateView<UITextFieldDelegate>
{
    UIButton *btnConfirm,*btnCancel;
    UILabel *lblUser,*lblPeople,*lblWaiter;
    UITextField *tfUser,*tfPeople,*tfWaiter,*tfPhoenNum;
    
    id<AKsWaitSeatOpenTableDelegate>_delegate;
}


@property(nonatomic,assign)UIButton *btn;
@property (nonatomic,retain) id<AKsWaitSeatOpenTableDelegate>delegate;

@end
