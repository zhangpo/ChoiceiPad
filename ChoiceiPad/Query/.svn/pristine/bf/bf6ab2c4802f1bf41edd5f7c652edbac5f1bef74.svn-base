//
//  BSQueryView.m
//  BookSystem
//
//  Created by Dream on 11-5-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSQueryView.h"
#import "BSDataProvider.h"

@implementation BSQueryView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        

        // Initialization code
        [self setTitle:[langSetting localizedString:@"QueryBill"]];
        
        lblAcct = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 50, 30)];
        lblAcct.textAlignment = UITextAlignmentRight;
        lblAcct.backgroundColor = [UIColor clearColor];
        lblAcct.text = [langSetting localizedString:@"User:"];
        [self addSubview:lblAcct];
        [lblAcct release];
        
        lblPwd = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 50, 30)];
        lblPwd.textAlignment = UITextAlignmentRight;
        lblPwd.backgroundColor = [UIColor clearColor];
        lblPwd.text = [langSetting localizedString:@"Password:"];
        [self addSubview:lblPwd];
        [lblPwd release];
        
        lblPeople = [[UILabel alloc] initWithFrame:CGRectMake(15, 180, 50, 30)];
        lblPeople.textAlignment = UITextAlignmentRight;
        lblPeople.backgroundColor = [UIColor clearColor];
        lblPeople.text = [langSetting localizedString:@"Table:"];
        [self addSubview:lblPeople];
        [lblPeople release];
        
        tfAcct = [[UITextField alloc] initWithFrame:CGRectMake(70, 80, 380, 30)];
        tfPwd = [[UITextField alloc] initWithFrame:CGRectMake(70, 130, 380, 30)];
        tfPeople = [[UITextField alloc] initWithFrame:CGRectMake(70, 180, 380, 30)];
        tfAcct.borderStyle = UITextBorderStyleRoundedRect;
        tfPwd.borderStyle = UITextBorderStyleRoundedRect;
        tfPeople.borderStyle = UITextBorderStyleRoundedRect;
        
//        tfPeople.keyboardType = UIKeyboardTypeNumberPad;
//        tfPeople.text = @"1";
        
        tfPwd.secureTextEntry = YES;
        
        [self addSubview:tfAcct];
        [self addSubview:tfPwd];
        [self addSubview:tfPeople];
        
        [tfAcct release];
        [tfPwd release];
        [tfPeople release];
        
        btnSendNow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnSendNow.frame = CGRectMake(105, 265, 100, 30);
        [btnSendNow setTitle:[langSetting localizedString:@"Query"] forState:UIControlStateNormal];
        [self addSubview:btnSendNow];
        btnSendNow.tag = 700;
        [btnSendNow addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnSendWait = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnSendWait.frame = CGRectMake(245, 265, 100, 30);
        [btnSendWait setTitle:[langSetting localizedString:@"Cancel"] forState:UIControlStateNormal];
        [self addSubview:btnSendWait];
        btnSendWait.tag = 701;
        [btnSendWait addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        tfAcct.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"username"];
        tfPwd.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"password"];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    [super dealloc];
}

- (void)confirm{
    BOOL bAuth = NO;
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    
    if ([tfAcct.text length]>0 && [tfPwd.text length]>0)
        bAuth = YES;
    
    if (bAuth){
        NSDictionary *dict;

        dict = [NSDictionary dictionaryWithObjectsAndKeys:tfAcct.text,@"user",tfPwd.text,@"pwd",tfPeople.text,@"table", nil];

        [delegate queryOrderWithOptions:dict];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"User and Password could not be empty"] 
                                                        message:[langSetting localizedString:@"Please type again and retry"]
                                                       delegate:nil 
                                              cancelButtonTitle:[langSetting localizedString:@"OK"]
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
}

- (void)cancel{
    [delegate queryOrderWithOptions:nil];
}

@end