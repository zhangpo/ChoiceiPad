//
//  AKsAuthorizationView.m
//  BookSystem
//
//  Created by sundaoran on 14-1-3.
//
//

#import "AKsAuthorizationView.h"
#import "CVLocalizationSetting.h"
#import "BSDataProvider.h"

@implementation AKsAuthorizationView
{
    UITextField *userName;
    UITextField *userPass;
    BSLogCell *_cell;
}

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame andCell:(BSLogCell *)cell
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTitle:@"赠菜授权"];
        
        _cell=cell;
        
        userName=[[UITextField alloc]initWithFrame:CGRectMake(100, 70, 300, 40)];
        userName.borderStyle=UITextBorderStyleRoundedRect;
        userName.backgroundColor=[UIColor whiteColor];
        userName.clearButtonMode=UITextFieldViewModeAlways;
        userName.placeholder=@"请输入授权用户名";
        userName.font=[UIFont systemFontOfSize:23];
        [self addSubview:userName];
        
        userPass=[[UITextField alloc]initWithFrame:CGRectMake(100, 130, 300, 40)];
        userPass.borderStyle=UITextBorderStyleRoundedRect;
        userPass.backgroundColor=[UIColor whiteColor];
        userPass.clearButtonMode=UITextFieldViewModeAlways;
        userPass.placeholder=@"请输入授权密码";
        userPass.font=[UIFont systemFontOfSize:23];
        [self addSubview:userPass];
        
        userName.delegate=self;
        userPass.delegate=self;
        
        UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSure.frame=CGRectMake(100, 200, 80, 40);
        [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonBlue.png"] forState:UIControlStateNormal];
        [buttonSure setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        [buttonSure addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonSure];
        
        UIButton *buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancle.frame=CGRectMake(320, 200, 80, 40);
        [buttonCancle setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonBlue.png"] forState:UIControlStateNormal];
        [buttonCancle setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        [buttonCancle addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonCancle];

    }
    return self;
}

-(void)sureButtonClick
{
    if(userName.text && userPass.text)
    {
        [_delegate sureAKsAuthorizationView:userName.text anduserPass:userPass.text andCell:_cell];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入正确的授权账号"
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
    [_delegate cancleAKsAuthorizationView];
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
