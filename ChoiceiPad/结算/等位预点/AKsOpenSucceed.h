//
//  AKsOpenSucceed.h
//  BookSystem
//
//  Created by chensen on 14-3-20.
//
//

#import "BSRotateView.h"

@protocol AKsOpenSucceedDelegate <NSObject>

-(void)OpenSucceed:(int)tag;

@end

@interface AKsOpenSucceed : BSRotateView
@property(nonatomic,weak)__weak id<AKsOpenSucceedDelegate>delegate;

@end
