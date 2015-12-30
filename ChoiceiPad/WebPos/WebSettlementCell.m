//
//  WebSettlementCell.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-9-18.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "WebSettlementCell.h"

@implementation WebSettlementCell
@synthesize lblCount=_lblCount,lblName=_lblName,lblPrice=_lblPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //数量
        _lblCount=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 60, 45)];
        _lblCount.textAlignment=NSTextAlignmentCenter;
        _lblCount.backgroundColor=[UIColor clearColor];
        _lblCount.font=[UIFont systemFontOfSize:17];
        _lblCount.textColor=[UIColor blackColor];
        [self.contentView addSubview:_lblCount];
        //名称
        _lblName=[[UILabel alloc]initWithFrame:CGRectMake(60,0, 190, 45)];
        _lblName.textAlignment=NSTextAlignmentLeft;
        _lblName.backgroundColor=[UIColor clearColor];
        _lblName.textColor=[UIColor blackColor];
        _lblName.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:_lblName];
        //价格
        _lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(240,0, 70, 45)];
        _lblPrice.textAlignment=NSTextAlignmentRight;
        _lblPrice.textColor=[UIColor blackColor];
        _lblPrice.backgroundColor=[UIColor clearColor];
        _lblPrice.font=[UIFont systemFontOfSize:17];
        [self.contentView addSubview:_lblPrice];
        UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 310, 1)];
        line.backgroundColor=[UIColor blackColor];
        line.alpha=0.7;
        [self.contentView addSubview:line ];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
