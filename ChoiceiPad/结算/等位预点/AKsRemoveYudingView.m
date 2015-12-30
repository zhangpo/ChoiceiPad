//
//  AKsRemoveYudingView.m
//  BookSystem
//
//  Created by sundaoran on 13-12-29.
//
//

#import "AKsRemoveYudingView.h"
#import "CVLocalizationSetting.h"

@implementation AKsRemoveYudingView
{
    UITextField  *_yudingxuhao;
    
    UITextField  *_phoneNum;
    
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setTitle:@"取消预定台位"];
        
        _yudingxuhao=[[UITextField alloc]initWithFrame:CGRectMake(100, 70, 300, 40)];
        _yudingxuhao.borderStyle=UITextBorderStyleRoundedRect;
        _yudingxuhao.backgroundColor=[UIColor whiteColor];
        _yudingxuhao.clearButtonMode=UITextFieldViewModeAlways;
        _yudingxuhao.placeholder=@"请输入预定序号";
        _yudingxuhao.font=[UIFont systemFontOfSize:23];
        [self addSubview:_yudingxuhao];
        
        _phoneNum=[[UITextField alloc]initWithFrame:CGRectMake(100, 130, 300, 40)];
        _phoneNum.borderStyle=UITextBorderStyleRoundedRect;
        _phoneNum.backgroundColor=[UIColor whiteColor];
        _phoneNum.clearButtonMode=UITextFieldViewModeAlways;
        _phoneNum.placeholder=@"请输入手机号码";
        _phoneNum.font=[UIFont systemFontOfSize:23];
        [self addSubview:_phoneNum];
        
//        _yudingxuhao.delegate=self;
        _phoneNum.delegate=self;
        
        UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSure.frame=CGRectMake(240, 265, 90, 40);
        [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        buttonSure.titleLabel.textColor=[UIColor whiteColor];
        buttonSure.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [buttonSure setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        [buttonSure addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonSure];
        
        UIButton *buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancle.frame=CGRectMake(345, 265, 90, 40);
        buttonCancle.titleLabel.textColor=[UIColor whiteColor];
        buttonCancle.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [buttonCancle setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [buttonCancle setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [buttonCancle addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonCancle];

        
    }
    return self;
}

-(void)sureButtonClick
{
    if(_phoneNum.text || _yudingxuhao.text)
    {
     [_delegate sureAKsRemoveYudingView:_phoneNum.text andMisNum:_yudingxuhao.text];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"预定序号或手机号不能同时为空，确定重新输入"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                  otherButtonTitles:nil];
           
            [alert show];
            
        });

    }
}

-(void)cancleButtonClick
{
    [_delegate cancleAKsRemoveYudingView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
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
