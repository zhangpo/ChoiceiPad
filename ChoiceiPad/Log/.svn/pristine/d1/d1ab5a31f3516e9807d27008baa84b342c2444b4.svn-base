//
//  BSCommonView.h
//  BookSystem
//
//  Created by Dream on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol CommonViewDelegate

- (void)setCommon:(NSArray *)ary;

@end

@interface BSCommonView : BSRotateView <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UITableView *tv;
    UIButton *btnConfirm,*btnCancel;
    
    NSMutableArray *arySelectedAdditions,*aryAdditions,*aryCustomAdditions,*arySearchMatched;
    
    id<CommonViewDelegate> delegate;
    
    UISearchBar *barAddition;
    UIView *vAddition;
}
@property (nonatomic,retain) NSMutableArray *arySelectedAdditions,*aryAdditions,*arySearchMatched,*aryCustomAdditions;
@property (nonatomic,assign) id<CommonViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame info:(NSArray *)info;

@end
