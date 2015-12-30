//
//  BSQueryCell.h
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSQueryCell;
@protocol BSQueryCellDelegate <NSObject>
-(void)cell:(BSQueryCell *)cell Over:(NSString *)str;
-(void)cell:(BSQueryCell *)cell cuiClick:(NSString *)str;
-(void)cell:(BSQueryCell *)cell tuiClick:(NSString *)str;
-(void)cell:(BSQueryCell *)cell hua:(NSString *)str1;

@end

@interface BSQueryCell : UITableViewCell
{
     id<BSQueryCellDelegate>_delegate;
    
}
@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,strong)UIImageView *btn;
@property(nonatomic,strong)UILabel *lblCame,*lblCount,*lblPrice,*lblUnit,*lblcui,*lbltalPreice,*over,*lblstart,*lblfujia,*lblhua;
@property(nonatomic,strong)UIView *view;
@property(nonatomic,strong)UIImageView *lblover;
@property(nonatomic,retain)id<BSQueryCellDelegate>delegete;
@end
