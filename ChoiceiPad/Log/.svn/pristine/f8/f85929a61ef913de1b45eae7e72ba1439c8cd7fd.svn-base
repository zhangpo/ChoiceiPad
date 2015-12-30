//
//  BSSearchCell.m
//  BookSystem
//
//  Created by Wu Stan on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BSSearchCell.h"

@implementation BSSearchCell
@synthesize dicInfo;

- (void)dealloc{
    self.dicInfo = nil;
    
    [super dealloc];
}

- (void)showInfo:(NSDictionary *)info{
    UILabel *lblCode = (UILabel *)[self.contentView viewWithTag:700];
    UILabel *lblName = (UILabel *)[self.contentView viewWithTag:701];
    UILabel *lblUnit = (UILabel *)[self.contentView viewWithTag:702];
    UILabel *lblPrice = (UILabel *)[self.contentView viewWithTag:703];
    
    self.dicInfo = info;
    NSDictionary *dic = info;
    lblCode.text = [dic objectForKey:@"ITCODE"];
    lblName.text = [dic objectForKey:@"DES"];
    lblUnit.text = [dic objectForKey:@"UNIT"];
    lblPrice.text = [dic objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:@"price"]];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *lblCode = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 75, 60)];
        lblCode.tag = 700;
        lblCode.backgroundColor = [UIColor clearColor];
        lblCode.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblCode];
        [lblCode release];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 75, 60)];
        lblName.tag = 701;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblName];
        [lblName release];
        lblName.numberOfLines = 9;
        
        UILabel *lblUnit = [[UILabel alloc] initWithFrame:CGRectMake(165, 0, 50, 60)];
        lblUnit.tag = 702;
        lblUnit.backgroundColor = [UIColor clearColor];
        lblUnit.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblUnit];
        [lblUnit release];
        
        UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(220, 0, 50, 60)];
        lblPrice.tag = 703;
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:lblPrice];
        [lblPrice release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
