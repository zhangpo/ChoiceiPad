//
//  AKsVipPayViewController.h
//  BookSystem
//
//  Created by sundaoran on 13-12-5.
//
//

#import <UIKit/UIKit.h>
#import "AKsPassWordView.h"
#import "AKMySegmentAndView.h"
#import "Singleton.h"



@interface AKsNewVipPayViewController : UIViewController<AKsPassWordViewDelegate,AKMySegmentAndViewDelegate,UITextFieldDelegate>
-(id)initWithArray:(NSMutableArray *)array;

@end
