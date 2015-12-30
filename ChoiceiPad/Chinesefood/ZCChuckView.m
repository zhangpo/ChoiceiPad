//
//  BSChunkView.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ZCChuckView.h"
#import "BSDataProvider.h"


@implementation ZCChuckView
@synthesize delegate;
@synthesize aryReasons;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        [self setTitle:[langSetting localizedString:@"Chuck"]];
        dSelected = 0;
        
        BSDataProvider *dp = [[BSDataProvider alloc] init];
        NSMutableArray *ary = [dp getCodeDesc];
        NSMutableArray *aryList = [NSMutableArray array];
        for (NSDictionary *dic in ary){
            if ([[dic objectForKey:@"CODE"] isEqualToString:@"XT"])
                [aryList addObject:dic];
        }
        self.aryReasons = [NSMutableArray arrayWithArray:aryList];
        
        lblAcct = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 50, 30)];
        lblAcct.textAlignment = UITextAlignmentRight;
        lblAcct.backgroundColor = [UIColor clearColor];
        lblAcct.text = [langSetting localizedString:@"User:"];
        [self addSubview:lblAcct];
        tfAcct = [[UITextField alloc] initWithFrame:CGRectMake(70, 80, 90, 30)];
        tfAcct.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:tfAcct];
        
        lblPwd = [[UILabel alloc] initWithFrame:CGRectMake(170, 80, 50, 30)];
        lblPwd.textAlignment = UITextAlignmentRight;
        lblPwd.backgroundColor = [UIColor clearColor];
        lblPwd.text = [langSetting localizedString:@"Password:"];
        [self addSubview:lblPwd];
        tfPwd = [[UITextField alloc] initWithFrame:CGRectMake(225, 80, 90, 30)];
        tfPwd.borderStyle = UITextBorderStyleRoundedRect;
        tfPwd.secureTextEntry = YES;
        [self addSubview:tfPwd];
        
        lblCount = [[UILabel alloc] initWithFrame:CGRectMake(335, 80, 50, 30)];
        lblCount.textAlignment = UITextAlignmentRight;
        lblCount.backgroundColor = [UIColor clearColor];
        lblCount.text = [langSetting localizedString:@"Count:"];
        [self addSubview:lblCount];
        tfCount = [[UITextField alloc] initWithFrame:CGRectMake(390, 80, 50, 30)];
        tfCount.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:tfCount];
        
        lblReason = [[UILabel alloc] initWithFrame:CGRectMake(15, 135, 50, 30)];
        lblReason.textAlignment = UITextAlignmentRight;
        lblReason.backgroundColor = [UIColor clearColor];
        lblReason.text = [langSetting localizedString:@"Reason:"];
        [self addSubview:lblReason];
        

        
        btnChunk = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnChunk.frame = CGRectMake(105, 295, 100, 30);
        [btnChunk setTitle:[langSetting localizedString:@"Chuck"] forState:UIControlStateNormal];
        [self addSubview:btnChunk];
        btnChunk.tag = 700;
        [btnChunk addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(245, 295, 100, 30);
        [btnCancel setTitle:[langSetting localizedString:@"Cancel"] forState:UIControlStateNormal];
        [self addSubview:btnCancel];
        btnCancel.tag = 701;
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
        pickerReason = [[UIPickerView alloc] initWithFrame:CGRectMake(65, 125, 370, 160)];
        pickerReason.showsSelectionIndicator = YES;
        pickerReason.dataSource= self;
        pickerReason.delegate = self;
        [self addSubview:pickerReason];
        
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

- (void)confirm{
    BOOL bAuth = NO;
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if ([tfAcct.text length]>0 && [tfPwd.text length]>0)
        bAuth = YES;
    
    if (bAuth){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:tfAcct.text,@"user",tfPwd.text,@"pwd",@"send",@"send",nil];
        if ([tfCount.text length]>0){
            [dic setObject:tfCount.text forKey:@"total"];
        }
        [dic setObject:[[self.aryReasons objectAtIndex:dSelected] objectForKey:@"SNO"] forKey:@"rsn"];
        
        [delegate chuckOrderWithOptions:dic];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"User and Password could not be empty"] 
                                                        message:[langSetting localizedString:@"Please type again and retry"]
                                                       delegate:nil 
                                              cancelButtonTitle:[langSetting localizedString:@"OK"]
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}

- (void)cancel{
    [delegate chuckOrderWithOptions:nil];
}

#pragma mark Pickview DataSource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[self.aryReasons objectAtIndex:row] objectForKey:@"DES"];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.aryReasons count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    dSelected = row;
}

@end
