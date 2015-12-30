//
//  AKuserPayment.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/15.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKuserPayment.h"
#import "AKuserPaymentButton.h"

@implementation AKuserPayment
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withPaymentArray:(NSArray *)paymentArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIScrollView *_viewbank=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 470, 300)];
        _viewbank.backgroundColor=[UIColor colorWithRed:26/255.0 green:76/255.0 blue:109/255.0 alpha:1];
        for (int i=0; i<[paymentArray count]; i++)
        {
            AKuserPaymentButton *button = [AKuserPaymentButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"PrivilegeView.png"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"PrivilegeViewSelect.png"] forState:UIControlStateHighlighted];
            button.userPaymentInfo=[paymentArray objectAtIndex:i];
            button.titleLabel.numberOfLines=0;
            button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
            button.titleLabel.font=[UIFont systemFontOfSize:20];
            [button setTitle:[NSString stringWithFormat:@"%@",[[paymentArray objectAtIndex:i] objectForKey:@"OPERATENAME"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame=CGRectMake(i%3*150+10,i/3*75+10, 140, 65);
            [_viewbank addSubview:button];
            _viewbank.contentSize=CGSizeMake(470, i/3*75+75);
        }
        [self addSubview:_viewbank];
    }
    return self;
}
-(void)buttonClick:(AKuserPaymentButton *)button
{
    [_delegate userPaymentClick:button.userPaymentInfo];
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
