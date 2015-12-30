//
//  AKsRemoveYudingView.h
//  BookSystem
//
//  Created by sundaoran on 13-12-29.
//
//

#import "BSRotateView.h"

@protocol AKsRemoveYudingViewDelegate <NSObject>

-(void)sureAKsRemoveYudingView:(NSString *)phoneNum andMisNum:(NSString *)MisNum;

-(void)cancleAKsRemoveYudingView;

@end

@interface AKsRemoveYudingView : BSRotateView<UITextFieldDelegate>
{
    id<AKsRemoveYudingViewDelegate>_delegate;
}
@property(nonatomic,retain)id<AKsRemoveYudingViewDelegate>delegate;

@end
