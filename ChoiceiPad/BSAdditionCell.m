//
//  BSAdditionCell.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSAdditionCell.h"
#import "CVLocalizationSetting.h"
#define Mode            [[NSUserDefaults standardUserDefaults] objectForKey:@"switch"]


@implementation BSAdditionCell
@synthesize info;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        bSelected = NO;
        
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Unselected.png"] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.userInteractionEnabled = NO;
        
        [self.contentView addSubview:btn];
        
        lblContent = [[UILabel alloc] init];
        lblContent.backgroundColor = [UIColor clearColor];
        lblContent.font = [UIFont boldSystemFontOfSize:22];
        
        lblPrice = [[UILabel alloc] init];
        lblPrice.textAlignment = UITextAlignmentRight;
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.font = [UIFont boldSystemFontOfSize:22];
        
        [self addSubview:lblContent];
        [self addSubview:lblPrice];
        
        
    }
    return self;
}



- (void)setHeight:(float)height{
    btn.center = CGPointMake(5+btn.frame.size.width/2.0f, height/2.0f);
    lblContent.frame = CGRectMake(5+btn.frame.size.width*1.5f, 0, 180, height);
    lblPrice.frame = CGRectMake(lblContent.frame.origin.x+180, 0, 70, height);
}

- (void)setContent:(NSDictionary *)dict{
    self.info = dict;
    lblContent.text = [dict objectForKey:@"DES"];
    lblPrice.text=[dict objectForKey:@"PRICE1"];
    [btn setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:[[dict objectForKey:@"SELECT"] boolValue]?@"Selected.png":@"Unselected.png"] forState:UIControlStateNormal];
    [self setHeight:40];
}
@end
