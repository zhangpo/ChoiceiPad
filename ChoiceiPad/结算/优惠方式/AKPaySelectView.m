//
//  AKPaySelectView.m
//  ChoiceiPad
//
//  Created by chensen on 15/8/20.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKPaySelectView.h"

@implementation AKPaySelectView
{
    int _tag;
    NSDictionary *_infoDic;
    UITextField  *textField;
}
@synthesize delegate=_delegate;
-(id)initWithFrame:(CGRect)frame withInfoDic:(NSDictionary *)info
{
    self=[super initWithFrame:frame];
    if (self) {
        [self setTitle:[info objectForKey:@"NAM"]];
        _infoDic=info;
        NSArray *array=[[NSArray alloc] initWithObjects:@"金额",@"比例", nil];
        UISegmentedControl *segment=[[UISegmentedControl alloc]initWithItems:array];
        segment.frame=CGRectMake(10, 54,455, 30);
        segment.selectedSegmentIndex = 0;//设置默认选择项索引
        segment.tag=1002;
        [self addSubview:segment];
        [segment addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
        
        textField=[[UITextField alloc] initWithFrame:CGRectMake(20, 90, 430, 40)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.tag=1003;
        textField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
        //        textField.backgroundColor=[UIColor whiteColor];
        [self addSubview:textField];
        NSArray *ary=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"],[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"], nil];
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
        _tag=0;
    }
    return self;
}
-(void)segmentAction:(UISegmentedControl *)segmented
{
    _tag=segmented.selectedSegmentIndex;
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==100) {
        [_infoDic setValue:[NSString stringWithFormat:@"%d",_tag] forKey:@"TAG"];
        [_infoDic setValue:[NSString stringWithFormat:@"%.2f",[textField.text floatValue]] forKey:@"money"];
        [_delegate AKPaySelectViewClick:_infoDic];
    }else
    {
        [_delegate AKPaySelectViewClick:nil];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
