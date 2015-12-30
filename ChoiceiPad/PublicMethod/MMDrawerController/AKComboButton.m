//
//  AKComboButton.m
//  BookSystem
//
//  Created by chensen on 14-2-28.
//
//

#import "AKComboButton.h"

@implementation AKComboButton
@synthesize btnTag=_btnTag,titleLabel1=_titleLabel1,lblCount=_lblCount,PCODE=_PCODE,dataInfo=_dataInfo;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _lblCount=[[UILabel alloc] initWithFrame:CGRectMake(70, 50, 50, 30)];
        _lblCount.backgroundColor=[UIColor clearColor];
        _lblCount.textAlignment=NSTextAlignmentRight;
        _lblCount.textColor=[UIColor whiteColor];
        _lblCount.font=[UIFont systemFontOfSize:13];
        //        _titleLabel1.backgroundColor=[UIColor blackColor];
        [self addSubview:_lblCount];
        
        _titleLabel1=[[UILabel alloc] initWithFrame:CGRectMake(90, 50, 30, 30)];
        _titleLabel1.backgroundColor=[UIColor clearColor];
        _titleLabel1.textAlignment=NSTextAlignmentRight;
        _titleLabel1.textColor=[UIColor redColor];
        _titleLabel1.font=[UIFont systemFontOfSize:13];
        //        _titleLabel1.backgroundColor=[UIColor blackColor];
        [self addSubview:_titleLabel1];
        
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

@end
