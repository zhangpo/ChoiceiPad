//
//  AKsAuthorizationView.h
//  BookSystem
//
//  Created by sundaoran on 14-1-3.
//
//

#import "BSRotateView.h"
#import "BSLogCell.h"

@protocol AKsAuthorizationViewDelegate <NSObject>

-(void)sureAKsAuthorizationView:(NSString *)userName anduserPass:(NSString *)userPass andCell:(BSLogCell *)cell;

-(void)cancleAKsAuthorizationView;

@end

@interface AKsAuthorizationView : BSRotateView<UITextFieldDelegate>
{
    id<AKsAuthorizationViewDelegate>_delegate;
}

@property(nonatomic,retain) id<AKsAuthorizationViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame andCell:(BSLogCell *)cell;

@end
