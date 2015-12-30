//
//  AKDeskMainViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import <UIKit/UIKit.h>
#import "AKSwitchTableView.h"
#import "BSOpenTableView.h"         //开台类
#import "WebChildrenTable.h"
#import "AKShouldCheckView.h"
#import "AKScanTableView.h"         //扫描操作
#import "AKTableCell.h"             //台位Cell


#define kOpenTag    700
#define kCancelTag  701
#define kdish       702

@interface AKDeskMainViewController : UIViewController<AKSwitchTableViewDelegate,OpenTableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UISearchBarDelegate,WebChildrenTableDelegate,AKShouldCheckViewDelegate,AKScanTableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AKTableCellDelegate,QRCodeReaderDelegate>
{
    AKSwitchTableView *vSwitch;
    BSOpenTableView *vOpen;
    NSMutableArray *deskClassArray;
}
@end
