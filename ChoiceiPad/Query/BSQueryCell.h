//
//  BSQueryCell.h
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@class BSQueryCell;
@protocol BSQueryCellDelegate <NSObject>

-(void)cell:(BSQueryCell *)cell hua:(NSString *)str1;
-(void)changeCountCell:(BSQueryCell *)cell;

@end

@interface BSQueryCell : UITableViewCell
{
    __weak id<BSQueryCellDelegate>_delegate;
    UILabel *lblCame,*lblCount,*lblPrice,*lblUnit,*lblcui,*lbltalPreice,*over,*lblstart,*lblfujia,*lblhua,*view;
    UIImageView *btn,*lblover;
    
}
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)NSDictionary *ZCdataDic;
@property(nonatomic,weak)__weak id<BSQueryCellDelegate>delegete;
@end
