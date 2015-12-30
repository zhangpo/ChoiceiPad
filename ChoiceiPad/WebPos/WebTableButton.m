//
//  BSTableButtion.m
//  BookSystem
//
//  Createdby Dream on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WebTableButton.h"


@implementation WebTableButton
@synthesize manTitle=_manTitle,tableInfo=_tableInfo;


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _manTitle=[[UILabel alloc] initWithFrame:CGRectMake(102,1.5, 30, 20)];
        //        _manTitle.backgroundColor=[UIColor blackColor];
        _manTitle.textAlignment=UITextAlignmentRight;
        _manTitle.textColor=[UIColor whiteColor];
        _manTitle.backgroundColor=[UIColor clearColor];
        _manTitle.font=[UIFont systemFontOfSize:14];
        [self addSubview:_manTitle];
        self.titleLabel.font=[UIFont systemFontOfSize:30];
    }
    return self;
}


- (NSString *)tableTitle{
    return tableTitle;
}

- (void)setTableTitle:(NSString *)tableTitle_{
    if (tableTitle_!=tableTitle){
        tableTitle = [tableTitle_ copy];
        self.titleLabel.numberOfLines=2;
        self.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        [self setTitle:tableTitle forState:UIControlStateNormal];
    }
}

@end
