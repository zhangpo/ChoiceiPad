//
//  AKSwitchTableViewCell.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/1/16.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKSwitchTableViewCell.h"

@implementation AKSwitchTableViewCell
@synthesize dataInfo=_dataInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
