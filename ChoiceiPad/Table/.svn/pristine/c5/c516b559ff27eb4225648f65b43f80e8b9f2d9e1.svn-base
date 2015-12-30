//
//  BSCancelTableView.m
//  BookSystem
//
//  Created by Dream on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSCancelTableView.h"
#import "CVLocalizationSetting.h"

@implementation BSCancelTableView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        // Initialization code
        self.transform = CGAffineTransformIdentity;
        
        [self setTitle:[langSetting localizedString:@"Cancel Table"]];
        
        lblUser = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 80, 30)];
        lblUser.textAlignment = UITextAlignmentRight;
        lblUser.backgroundColor = [UIColor clearColor];
        lblUser.text = [langSetting localizedString:@"User:"];
        [self addSubview:lblUser];
        [lblUser release];
        

        
        
        
        tfUser = [[UITextField alloc] initWithFrame:CGRectMake(100, 130, 350, 30)];
        tfUser.borderStyle = UITextBorderStyleRoundedRect;

        
        
        
        [self addSubview:tfUser];

        
        [tfUser release];

        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnConfirm.frame = CGRectMake(105, 265, 100, 30);
        [btnConfirm setTitle:[langSetting localizedString:@"OK"] forState:UIControlStateNormal];
        [self addSubview:btnConfirm];
        btnConfirm.tag = 700;
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(245, 265, 100, 30);
        [btnCancel setTitle:[langSetting localizedString:@"Cancel"] forState:UIControlStateNormal];
        [self addSubview:btnCancel];
        btnCancel.tag = 701;
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
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
    self.delegate = nil;
    [super dealloc];
}


- (void)confirm{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if ([tfUser.text length]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Error Table"] message:[langSetting localizedString:@"User could not be empty"] delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:tfUser.text forKey:@"user"];
        

        
        [delegate cancelTableWithOptions:dic];
    }
}

- (void)cancel{
    [delegate cancelTableWithOptions:nil];
}
@end

