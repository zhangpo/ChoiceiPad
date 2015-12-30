//
//  AKWaitSeatTakeNOView.m
//  ChoiceiPad
//
//  Created by chensen on 15/6/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKWaitSeatTakeNOView.h"
#import "LNNumberpad.h"

@implementation AKWaitSeatTakeNOView
{
    UITextField *_phoneField;
    UITextField *_peopleField;
    UITextField *_womanField;
}
@synthesize delegate=_delegate;
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0,768, 25);
        
        [button setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        button.tag=1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 25, 768, 350)];
        view.backgroundColor=[UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:0.95];
        [self addSubview:view];
        UIView *inputView=[LNNumberpad defaultLNNumberpad];
        inputView.frame=CGRectMake(768-380, 10, 370, 355);
        [view addSubview:inputView];
        _phoneField=[[UITextField alloc] init];
        _peopleField=[[UITextField alloc] init];
        _womanField=[[UITextField alloc] init];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"])
        {
            for (int i=0; i<2; i++) {
                UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(50, 20+60*i, 280, 45)];
                view1.layer.masksToBounds = YES;
                view1.layer.cornerRadius = 6.0;
                view1.layer.borderWidth = 1.0;
                view1.backgroundColor=[UIColor whiteColor];
                UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 35)];
                [image setImage:[UIImage imageNamed:i==0?@"dianhuakong.png":@"renshukong.png"]];
                [view1 addSubview:image];
                UITextField *textField=i==0?_phoneField:_peopleField;
                textField.frame=CGRectMake(70, 5, 200, 35);
                textField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
                if (i==0) {
                    [textField becomeFirstResponder];
                }
                textField.inputView=inputView;
                textField.delegate=self;
                [view1 addSubview:textField];
                [view addSubview:view1];
            }
        }else
        {
            for (int i=0; i<3; i++) {
                UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(50, 20+60*i, 280, 45)];
                view1.layer.masksToBounds = YES;
                view1.layer.cornerRadius = 6.0;
                view1.layer.borderWidth = 1.0;
                view1.backgroundColor=[UIColor whiteColor];
                UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 35)];
                [image setImage:[UIImage imageNamed:i==0?@"dianhuakong.png":(i==1?@"manNum.png":@"womanNum.png")]];
                [view1 addSubview:image];
                UITextField *textField=i==0?_phoneField:(i==1?_peopleField:_womanField);
                textField.frame=CGRectMake(70, 5, 200, 35);
                textField.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
                if (i==0) {
                    [textField becomeFirstResponder];
                }
                textField.inputView=inputView;
                textField.delegate=self;
                [view1 addSubview:textField];
                [view addSubview:view1];
            }
        }
        UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame=CGRectMake(50, 180, 300, 150);
        [button1 setImage:[UIImage imageNamed:@"querenquhao_up.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag=2;
        [view addSubview:button1];
        
    }
    return self;
}
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==1) {
        [_delegate AKWaitSeatTakeNOViewClick:nil];
    }else
    {

        [_delegate AKWaitSeatTakeNOViewClick:[NSDictionary dictionaryWithObjectsAndKeys:@"2",@"openTag",_phoneField.text,@"phone",_peopleField.text,@"people",_womanField.text==nil?@"":_womanField.text,@"woman", nil]];
        _phoneField.text=@"";
        _peopleField.text=@"";
    }
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
