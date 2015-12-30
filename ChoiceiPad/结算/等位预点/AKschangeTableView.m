//
//  AKschangeTableView.m
//  BookSystem
//
//  Created by sundaoran on 13-12-27.
//
//

#import "AKschangeTableView.h"
#import "Singleton.h"
#import "CVLocalizationSetting.h"
#import "BSDataProvider.h"

@implementation AKschangeTableView
{
    UITextField *_nowTableNum;
    UITextField *_goalTableNum;
    NSString *_phoneNum;
}

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame andPhoneNum:(NSString *)phoneNum
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setTitle:@"预定台位转台"];
        
        _phoneNum=phoneNum;
        NSArray *array=[[NSArray alloc] initWithObjects:@"手机:",@"序号:",@"台位:", nil];
        for (int i=0; i<[array count]; i++) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(60, 70+60*i,100, 40)];
            lb.text=[array objectAtIndex:i];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            lb.textColor=[UIColor blackColor];
            lb.backgroundColor=[UIColor clearColor];
            [self addSubview:lb];
        }
        
        _nowTableNum=[[UITextField alloc]initWithFrame:CGRectMake(125, 70, 270, 40)];
        _nowTableNum.borderStyle=UITextBorderStyleRoundedRect;
        _nowTableNum.backgroundColor=[UIColor whiteColor];
        _nowTableNum.clearButtonMode=UITextFieldViewModeAlways;
        _nowTableNum.text=phoneNum;
        _nowTableNum.userInteractionEnabled=NO;
        _nowTableNum.font=[UIFont systemFontOfSize:23];
        [self addSubview:_nowTableNum];
        UITextField *tfNUM=[[UITextField alloc] initWithFrame:CGRectMake(125, 130, 270, 40)];
        tfNUM.borderStyle=UITextBorderStyleRoundedRect;
        _nowTableNum.backgroundColor=[UIColor whiteColor];
        tfNUM.clearButtonMode=UITextFieldViewModeAlways;
        tfNUM.text=[Singleton sharedSingleton].WaitNum;
        tfNUM.font=[UIFont systemFontOfSize:23];
        tfNUM.userInteractionEnabled=NO;
        [self addSubview:tfNUM];
        
        _goalTableNum=[[UITextField alloc]initWithFrame:CGRectMake(125, 190, 270, 40)];
        _goalTableNum.borderStyle=UITextBorderStyleRoundedRect;
        _goalTableNum.backgroundColor=[UIColor whiteColor];
        _goalTableNum.clearButtonMode=UITextFieldViewModeAlways;
        _goalTableNum.placeholder=@"请输入目标台位";
        [_goalTableNum becomeFirstResponder];
        _goalTableNum.font=[UIFont systemFontOfSize:23];
        [self addSubview:_goalTableNum];
        
        
        UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSure.frame=CGRectMake(240, 265, 90, 40);
        buttonSure.titleLabel.textColor=[UIColor whiteColor];
        buttonSure.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
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
    if([_goalTableNum.text length]!=0)
    {
    [_delegate AkschangtableSure:_phoneNum and:_goalTableNum.text];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入目标台位"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                  otherButtonTitles:nil];
            alert.tag=1002;
            [alert show];
            
        });

    }
}
-(void)cancleButtonClick
{
    [_delegate Akschangtablecancle];
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
