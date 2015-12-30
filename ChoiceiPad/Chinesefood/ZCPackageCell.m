//
//  ZCPackageCell.m
//  ChoiceiPad
//
//  Created by chensen on 15/4/9.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCPackageCell.h"
#import "AKComboButton.h"

@implementation ZCPackageCell

@synthesize dataInfo=_dataInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
//        imageView.tag=100;
//        [self.contentView addSubview:imageView];
        AKComboButton *btn=[AKComboButton buttonWithType:UIButtonTypeCustom];
        btn.tag=100;
        btn.frame=CGRectMake(0, 0, 120, 80);
        [self.contentView addSubview:btn];
        btn.userInteractionEnabled=NO;
//        btn.backgroundColor=[UIColor clearColor];
        
        
    }
    return self;
}
-(void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataInfo=dataInfo;
    AKComboButton *btn=(AKComboButton *)[self.contentView viewWithTag:100];
    if ([[dataInfo objectForKey:@"total"] intValue]>0) {
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"] forState:UIControlStateNormal];
        btn.lblCount.text=[dataInfo objectForKey:@"total"];
    }else
    {
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"] forState:UIControlStateNormal];
        btn.lblCount.text=@"";
    }
//    btn.titleLabel.text=[dataInfo objectForKey:@"DES"];
    btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
    btn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [btn setTitle:[dataInfo objectForKey:@"DES"] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
//    btn.titleLabel.textColor=[UIColor whiteColor];
}
/*s
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
