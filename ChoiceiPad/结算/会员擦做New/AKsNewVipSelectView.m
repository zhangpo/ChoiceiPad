//
//  AKsNewVipSelectView.m
//  ChoiceiPad
//
//  Created by chensen on 15/6/15.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKsNewVipSelectView.h"

@implementation AKsNewVipSelectView
{
    UIPickerView *_pickerView;
    NSString     *_cardNo;
    NSArray      *_cardArray;
}

@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setTitle:@"会员卡"];
        NSArray *array=[[NSArray alloc] initWithObjects:@"手机号",@"会员卡号", nil];
        UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:array];
        segment.frame=CGRectMake(10, 54,455, 30);
        segment.selectedSegmentIndex = 0;//设置默认选择项索引
        segment.tag=1002;
        [self addSubview:segment];
        [segment addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
        
        UITextField *textField=[[UITextField alloc] initWithFrame:CGRectMake(20, 90, 430, 40)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.tag=1003;
//        textField.backgroundColor=[UIColor whiteColor];
        [self addSubview:textField];
        _pickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(20, 135, 430, 130)];
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
        [self addSubview:_pickerView];
        NSArray *ary=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"],[[CVLocalizationSetting sharedInstance] localizedString:@"Cancal"], nil];
        int i=0;
        for (NSString *str in ary) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(245+100*i, 265, 90, 40);
            btn.titleLabel.font=[UIFont italicSystemFontOfSize:20];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTintColor:[UIColor whiteColor]];
            [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
            btn.tag=100+i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            i++;
        }
    }
    return self;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_cardArray count];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger) component{
    return [[_cardArray objectAtIndex:row] objectForKey:@"cardNo"];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _cardNo=[[_cardArray objectAtIndex:row] objectForKey:@"cardNo"];
   
    
}
-(void)segmentAction:(UISegmentedControl *)segmented
{
    [_pickerView removeFromSuperview];
    if (segmented.selectedSegmentIndex==0) {
        [segmented addSubview:_pickerView];
    }
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==100) {
        int index=((UISegmentedControl *)[self viewWithTag:1002]).selectedSegmentIndex;
        NSString *number=((UITextField *)[self viewWithTag:1003]).text;
        if (index==0&&_cardNo==nil) {
            BSDataProvider *bp=[BSDataProvider sharedInstance];
            
            NSDictionary *dic=[bp ZCqueryCardByMobTel:number];
            if ([[dic objectForKey:@"ruturn"] intValue]>0) {
                _cardArray = [dic objectForKey:@"cardData"];
                _cardNo=[[_cardArray objectAtIndex:0] objectForKey:@"cardNo"];
                [_pickerView reloadAllComponents];
            }
            return;
        }
        NSDictionary *dict=[[BSDataProvider sharedInstance] ZCqueryCardByCardNo:_cardNo];
    
//        NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:number,@"number",[NSString stringWithFormat:@"%d",((UISegmentedControl *)[self viewWithTag:1002]).selectedSegmentIndex],@"TYP", nil];
        [_delegate AKsNewVipSelectView:dict];
    }else
    {
        [_delegate AKsNewVipSelectView:nil];
    }
}


@end
