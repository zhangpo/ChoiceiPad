//
//  BSSwitchTableView.m
//  BookSystem
//
//  Created by Dream on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSSwitchTableView.h"
#import "CVLocalizationSetting.h"
#import "BSDataProvider.h"

@implementation BSSwitchTableView
{
    UITextField *_tfOldTable;
    UITextField *_tfNewTable;
    int  _tag;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withTag:(int)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        _tag=tag;
        //[[NSUserDefaults standardUserDefaults] setObject:@"switchTable" forKey:@"DeskMainButton"]
        if (tag==1){
            // Initialization code
            [self setTitle:[langSetting localizedString:@"Change Table"]];
        }
        else if (tag==2)
        {
            [self setTitle:[langSetting localizedString:@"Combine Table"]];
        }else
        {
            [self setTitle:@"联台"];
        }
        
        
        UILabel *lblOldTable = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 125, 30)];
        lblOldTable.textAlignment = NSTextAlignmentCenter;
        lblOldTable.backgroundColor = [UIColor clearColor];
        lblOldTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lblOldTable.textColor=[UIColor blackColor];
        lblOldTable.text = [langSetting localizedString:@"From Table:"];//@"当前台位:";
        [self addSubview:lblOldTable];
        UILabel *lblNewTable = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, 125, 30)];
        lblNewTable.textAlignment = NSTextAlignmentCenter;
        lblNewTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lblNewTable.textColor=[UIColor blackColor];
        lblNewTable.backgroundColor = [UIColor clearColor];
        lblNewTable.text = [langSetting localizedString:@"To Table:"];//@"目标台位:";
        [self addSubview:lblNewTable];
        _tfOldTable = [[UITextField alloc] initWithFrame:CGRectMake(140, 80, 290, 40)];
        _tfOldTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];;
        _tfNewTable = [[UITextField alloc] initWithFrame:CGRectMake(140, 150, 290, 40)];
        _tfNewTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        _tfOldTable.borderStyle = UITextBorderStyleRoundedRect;
        _tfOldTable.keyboardType=UIKeyboardTypeNumberPad;
        _tfNewTable.borderStyle = UITextBorderStyleRoundedRect;
        _tfNewTable.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:_tfOldTable];
        [self addSubview:_tfNewTable];
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConfirm.frame = CGRectMake(240, 265, 90, 40);
        btnConfirm.titleLabel.textColor=[UIColor whiteColor];
        btnConfirm.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnConfirm setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];

        [btnConfirm setTitle:[langSetting localizedString:@"OK"] forState:UIControlStateNormal];
        [self addSubview:btnConfirm];
        btnConfirm.tag = 700;
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(345, 265, 90, 40);
        btnCancel.titleLabel.textColor=[UIColor whiteColor];
        [btnCancel setTitle:[langSetting localizedString:@"Cancel"] forState:UIControlStateNormal];
        btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
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


- (void)confirm{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if ([_tfNewTable.text length]<=0 || _tfOldTable.text.length<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Error"] message:[langSetting localizedString:@"User or Password or Table could not be empty"] delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
    else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if ([_tfOldTable.text length]>0){
            [dic setObject:[_tfOldTable.text uppercaseString] forKey:@"oldtable"];
//            BSDataProvider *dp=[[BSDataProvider alloc] init];
//            NSArray *array=[dp getOrdersBytabNum1:tfOldTable.text];
            
        }
        
        if ([_tfNewTable.text length]>0)
            [dic setObject:[_tfNewTable.text uppercaseString] forKey:@"newtable"];
        if (_tag==1){
            [_delegate switchTableWithOptions:dic];
        }
        else
        {
            [_delegate multipleTableWithOptions:dic];
        }
    }
}

- (void)cancel{
    [_delegate switchTableWithOptions:nil];
}

@end
