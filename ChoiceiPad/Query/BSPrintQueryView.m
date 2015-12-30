//
//  BSPrintQueryView.m
//  BookSystem
//
//  Created by Dream on 11-7-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSPrintQueryView.h"
#import "CVLocalizationSetting.h"

@implementation BSPrintQueryView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        
        [self setTitle:[langSetting localizedString:@"PrintQuery"]];
        
        lblType = [[UILabel alloc] initWithFrame:CGRectMake(15, 130, 50, 30)];
        lblType.textAlignment = UITextAlignmentRight;
        lblType.backgroundColor = [UIColor clearColor];
        lblType.text = [langSetting localizedString:@"Type:"];
        [self addSubview:lblType];
        segType = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[langSetting localizedString:@"QUERY"],[langSetting localizedString:@"TAB"], nil]];//NIL@"查询单",@"结账单",@"自动打印查询单",
        segType.frame = CGRectMake(70, 130, 380, 30);

//        [segType addTarget:self action:@selector(chooseType) forControlEvents:UIControlEventTouchUpInside];
        [segType setSelectedSegmentIndex:0];
        [self addSubview:segType];

        
        UIButton * btnPrint = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnPrint.frame = CGRectMake(105, 265, 100, 30);
        [btnPrint setTitle:[langSetting localizedString:@"Print"] forState:UIControlStateNormal];
        [self addSubview:btnPrint];
        btnPrint.tag = 700;
        [btnPrint addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(245, 265, 100, 30);
        [btnCancel setTitle:[langSetting localizedString:@"Cancel"] forState:UIControlStateNormal];
        [self addSubview:btnCancel];
        btnCancel.tag = 701;
        [btnCancel addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        
        
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

- (void)confirm:(UIButton *)btn{
    if (btn.tag==700) {
        NSDictionary *dict;
        int index = [segType selectedSegmentIndex];
        NSString *strType;
        if (0==index)
            strType = @"1";
        else strType = @"0";
        dict = [NSDictionary dictionaryWithObjectsAndKeys:strType,@"printTyp", nil];
        [delegate printQueryWithOptions:dict];
    }else
    {
        [delegate printQueryWithOptions:nil];
    }
    
    
}

- (void)cancel{
    [delegate printQueryWithOptions:nil];
}

@end
