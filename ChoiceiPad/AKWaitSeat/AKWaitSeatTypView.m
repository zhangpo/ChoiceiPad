//
//  AKWaitSeatTypView.m
//  ChoiceiPad
//
//  Created by chensen on 15/6/25.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKWaitSeatTypView.h"
#import "AKWaitSeatTypButton.h"
#import "BSDataProvider.h"

@implementation AKWaitSeatTypView
{
    NSMutableArray *buttonArray;
}
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        BSDataProvider *bs=[BSDataProvider sharedInstance];
        NSMutableArray *array=[bs queryTyp];
        
        UIScrollView *scroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 728, 80)];
        buttonArray=[[NSMutableArray alloc] init];
        for (int i=0;i<[array count];i++) {
            AKWaitSeatTypButton *button=[AKWaitSeatTypButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(728/5*i, 0, 728/5, 60);
            button.info=[array objectAtIndex:i];
            [button setTitle:[[array objectAtIndex:i] objectForKey:@"vname"] forState:UIControlStateNormal];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 20.0;
//            button.layer.borderWidth = 1.0;
//            button.backgroundColor=[UIColor whiteColor];
//            button.layer.borderColor = [[UIColor redColor] CGColor];
            button.titleLabel.font=[UIFont systemFontOfSize:30];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonArray addObject:button];
            [scroll addSubview:button];
        }
        scroll.backgroundColor=[UIColor clearColor];
        
        scroll.contentSize = CGSizeMake(728/5*[array count], 0);
        [self addSubview:scroll];

    }
    return self;
}
-(void)setDelegate:(id<AKWaitSeatTypViewDelegate>)delegate
{
    _delegate=delegate;
    if ([buttonArray count]>0) {
        AKWaitSeatTypButton *button=[buttonArray objectAtIndex:0];
        [self buttonClick:button];
    }
    
}
-(void)buttonClick:(AKWaitSeatTypButton *)btn
{
    for (AKWaitSeatTypButton *button in buttonArray) {
        button.selected=NO;
        [button setBackgroundColor:[UIColor clearColor]];
    }
    btn.selected=YES;
    [btn setBackgroundColor:[UIColor colorWithRed:35/255.0 green:33/255.0 blue:95/255.0 alpha:1]];
    [_delegate AKWaitSeatTypViewClick:btn.info];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
