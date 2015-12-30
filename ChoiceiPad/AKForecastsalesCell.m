//
//  AKForecastsalesCell.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14/12/5.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "AKForecastsalesCell.h"

@implementation AKForecastsalesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        for (int j=0; j<5; j++) {
            UILabel *lb=[[UILabel alloc]init];
            lb.frame=CGRectMake(10+(768-20)/5*j, 0, (748-20)/5, 50);
            lb.tag=100+j;
            [self.contentView addSubview:lb];
        }
        
    }
    return self;
}
-(void)setData:(NSDictionary *)dict
{
    UILabel *lb=(UILabel *)[self viewWithTag:100];
    lb.text=[dict objectForKey:@"code"];
    lb=(UILabel *)[self viewWithTag:101];
    lb.text=[dict objectForKey:@"DES"];
    lb=(UILabel *)[self viewWithTag:102];
    lb.text=[dict objectForKey:@"actual"];
    lb.textAlignment=UITextAlignmentRight;
    lb=(UILabel *)[self viewWithTag:103];
    lb.textAlignment=UITextAlignmentRight;
    lb.text=[dict objectForKey:@"estimate"];
    lb=(UILabel *)[self viewWithTag:104];
    lb.textAlignment=UITextAlignmentRight;
    lb.text=[dict objectForKey:@"ratio"];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
