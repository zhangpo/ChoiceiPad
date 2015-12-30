//
//  AKsWaitSeat.h
//  BookSystem
//
//  Created by sundaoran on 13-12-25.
//
//

#import <UIKit/UIKit.h>
#import "AKsNetAccessClass.h"
#import "AKsWaitSeatClass.h"

@protocol AKsWaitSeatDelegate <NSObject>

@optional
-(void)clickAddButton;
-(void)clickMissButton;
-(void)clickTableViewIndexRow:(AKsWaitSeatClass *)waitSeatPeople;

-(void)removeHudOnMainThread;

-(void)refushTableView;


@end


@interface AKsWaitSeat : UIView<UITableViewDataSource,UITableViewDelegate,AKsNetAccessClassDelegate>
{
    id<AKsWaitSeatDelegate>_delegate;
}
-(void)addshowTableView;
-(void)reloadDataWaitTableView;
@property(nonatomic,retain)id<AKsWaitSeatDelegate>delegate;
@end
