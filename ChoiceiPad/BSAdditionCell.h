//
//  BSAdditionCell.h
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BSAdditionCell : UITableViewCell {
    BOOL bSelected;
    UILabel *lblContent;
    UILabel *lblPrice;
    UIButton *btn;
    
    NSDictionary *info;
}
@property BOOL bSelected;
@property (nonatomic,retain) NSDictionary *info;

- (void)setHeight:(float)height;
- (void)setContent:(NSDictionary *)dict;
@end
