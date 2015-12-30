//
//  AKSettlement.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-9-16.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "AKSettlement.h"
#import "AKuserPaymentButton.h"

@implementation AKSettlement
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)AryInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:frame];
        scroll.backgroundColor=[UIColor colorWithRed:26/255.0 green:76/255.0 blue:109/255.0 alpha:1];
        //    [_viewbank addGestureRecognizer:_pan];
        for (int i=0; i<[AryInfo count]; i++)
        {
            AKuserPaymentButton *button = [AKuserPaymentButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeView.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeViewSelect.png"] forState:UIControlStateHighlighted];
            button.titleLabel.font=[UIFont systemFontOfSize:20];
            button.titleLabel.textAlignment=NSTextAlignmentCenter;
            button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
            button.userPaymentInfo=[AryInfo objectAtIndex:i];
            
            [button setTitle:[NSString stringWithFormat:@"%@",[[AryInfo objectAtIndex:i] objectForKey:@"OPERATENAME"]] forState:UIControlStateNormal];
            button.tag=i;
            [button addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame=CGRectMake(i%3*150+10,i/3*75+10, 140, 65);
            [scroll addSubview:button];
            scroll.contentSize=CGSizeMake(470, i/3*75+75);
            
        }
        [self addSubview:scroll];
    }
    return self;
}
-(void)ButtonClick:(AKuserPaymentButton *)button
{
        [_delegate AKSettlementButtonClick:button.userPaymentInfo];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
