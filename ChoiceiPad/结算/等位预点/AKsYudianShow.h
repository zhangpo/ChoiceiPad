//
//  AKsYudianShow.h
//  BookSystem
//
//  Created by sundaoran on 13-12-28.
//
//

#import <UIKit/UIKit.h>
#import "AKsYuDianListCell.h"

@protocol AKsYudianShowDelegate <NSObject>

-(void)AKsYudianShowSure;
-(void)AKsYudianShowCancle;
-(void)AKsYudianShowAddDish;
-(void)AKsYudianDismiss;

@end

@interface AKsYudianShow : UIView<UITableViewDataSource,UITableViewDelegate>
{
    id<AKsYudianShowDelegate>_delegate;
}
@property(nonatomic,retain)id<AKsYudianShowDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andArray:(NSMutableArray *)array andPayArray:(NSMutableArray *)payArray;

@end
