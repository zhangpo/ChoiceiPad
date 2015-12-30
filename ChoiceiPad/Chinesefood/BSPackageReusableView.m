//
//  BSPackageReusableView.m
//  BookSystem
//
//  Created by chensen on 15/3/27.
//
//

#import "BSPackageReusableView.h"

@implementation BSPackageReusableView
@synthesize titleLabel=_titleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,5,200, frame.size.height-10)];
        _titleLabel.layer.cornerRadius = frame.size.height/2;
        _titleLabel.layer.backgroundColor=[UIColor lightGrayColor].CGColor;
        _titleLabel.textAlignment=UITextAlignmentCenter;
        _titleLabel.font=[UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor=[UIColor blackColor];
        [self addSubview:_titleLabel];
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
