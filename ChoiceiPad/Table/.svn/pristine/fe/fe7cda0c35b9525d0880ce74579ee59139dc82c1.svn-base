//
//  BSSearchViewController.h
//  BookSystem
//
//  Created by Dream on 11-6-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSSearchViewController.h"

@interface BSResvSearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *aryFoods,*aryDisplayList;
    
    UITableView *tvFoods;
    
    NSString *strInput;
    
    id<BSSearchDelegate> delegate;
    
    UIView *vHeader;
}
@property (nonatomic,copy) NSString *strInput;
@property (nonatomic,retain) NSMutableArray *aryFoods,*aryDisplayList;
@property (nonatomic,assign) id<BSSearchDelegate> delegate;
@end
