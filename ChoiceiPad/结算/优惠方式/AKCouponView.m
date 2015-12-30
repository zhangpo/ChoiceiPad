//
//  AKCouponView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/14.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKCouponView.h"
#import "BSDataProvider.h"
#import "AKComboButton.h"

@implementation AKCouponView
{
    NSArray        *_dataArray;
    NSMutableArray *_buttonArray;
    UIScrollView   *_scrollView;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView=[[UIScrollView alloc] init];
        _scrollView.backgroundColor=[UIColor clearColor];
        [self addSubview:_scrollView];
        BSDataProvider * bs=[[BSDataProvider alloc] init];
        if ([Mode isEqualToString:@"zc"]) {
            _dataArray=[bs ZCselectCoupon];
        }else
        {
            _dataArray=[bs selectCoupon];
        }
        //类别
        int k=0;
        for (int i=0; i<([_dataArray count]/3+([_dataArray count]%3==0?0:1)); i++) {
            NSMutableArray * _itemArray=[[NSMutableArray alloc] init];
            for (int j=i*3;j<3*(i+1);j++) {
                [_itemArray addObject:![Mode isEqualToString:@"zc"]?[[_dataArray objectAtIndex:j] objectForKey:@"NAM"]:[[_dataArray objectAtIndex:j] objectForKey:@"VNAME"]];
                if (j+1==[_dataArray count]) {
                    break;
                }
            }
            UISegmentedControl *segment=[[UISegmentedControl alloc] initWithItems:_itemArray];
            segment.frame=CGRectMake(0, i*60, 430, 50);
            k=i*60;
            segment.tag=i;
            
            [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:segment];
            if (i==0) {
                segment.selectedSegmentIndex=0;
                [self segmentClick:segment];
            }
            
        }
        _scrollView.frame= CGRectMake(0,k+60,430, 600+50);
    }
    return self;
}
-(void)segmentClick:(UISegmentedControl *)segment
{
    int i=segment.tag*3+segment.selectedSegmentIndex;
    if (!_buttonArray) {
        _buttonArray =[[NSMutableArray alloc] init];
        for (NSDictionary *dict in _dataArray) {
            NSMutableArray *buttonAry=[[NSMutableArray alloc] init];
            int j=0;
            for (NSDictionary *main in [dict objectForKey:@"coupon_main"]) {
                AKComboButton *button=[AKComboButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[UIImage imageNamed:@"PrivilegeView.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"PrivilegeViewSelect.png"] forState:UIControlStateHighlighted];
                button.tag=i;
                button.dataInfo=main;
                [button setTitle:![Mode isEqualToString:@"zc"]?[main objectForKey:@"NAM"]:[main objectForKey:@"VNAME"] forState:UIControlStateNormal];
                button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                button.titleLabel.numberOfLines=0;
                button.frame=CGRectMake(10+j%3*140, 10+j/3*80, 130, 70);
                [button addTarget:self action:@selector(ButonClick:) forControlEvents:UIControlEventTouchUpInside];
                [buttonAry addObject:button];
                j++;
            }
            [_buttonArray addObject:buttonAry];
        }
    }
    segment.selectedSegmentIndex=-1;
    _scrollView.contentSize=CGSizeMake(430, ([[[_dataArray objectAtIndex:i] objectForKey:@"coupon_main"] count]/3+1)*80);
A:
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
        goto A;
    }
    for (UIButton *btn in [_buttonArray objectAtIndex:i]) {
        [_scrollView addSubview:btn];
    }
}
-(void)ButonClick:(AKComboButton *)button
{
    [_delegate couponSelect:button.dataInfo];
}


@end
