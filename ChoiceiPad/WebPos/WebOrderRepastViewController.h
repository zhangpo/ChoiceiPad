//
//  AKOrderRepastViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-13.
//
//
/*
 点菜界面
 */
#import <UIKit/UIKit.h>
#import "BSDataProvider.h"//数据请求类
#import "AKMySegmentAndView.h"//顶上信息类
#import "AKAdditionView.h"//附加项累
#import "AKPrivateAdditionView.h"
@interface WebOrderRepastViewController : UIViewController<UISearchBarDelegate,AKMySegmentAndViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,AKAdditionViewDelegate,AKPrivateAdditionDelegate,UIActionSheetDelegate>
{
    NSArray *classArray;
    UIScrollView *aScrollView;
}
@end
