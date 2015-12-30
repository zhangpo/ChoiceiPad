//
//  AKSettingUpViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import <UIKit/UIKit.h>
#import "AKsNetAccessClass.h"

@interface AKSettingUpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *aTableView;
    UIPopoverController *deskPop;
    NSArray *deskArray;
}
@property (retain, nonatomic)UILabel *deskLabel;
@end
