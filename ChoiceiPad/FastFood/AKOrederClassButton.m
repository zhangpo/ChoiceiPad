//
//  AKOrederClassButton.m
//  BookSystem
//
//  Created by chensen on 14-1-13.
//
//

#import "AKOrederClassButton.h"
#import "BSDataProvider.h"

@implementation AKOrederClassButton
@synthesize button=_button,label=_label;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=CGRectMake(0, 0, 90, 59);
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, _button.titleLabel.bounds.size.width-30, 0, 0);
        _button.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self addSubview:_button];
        _label=[[UILabel alloc] initWithFrame:CGRectMake(70,20, 20, 20)];
        _label.font = [UIFont boldSystemFontOfSize:12];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor=[UIColor redColor];
        //        _label.textColor = [UIColor colorWithRed:.95 green:.9 blue:.4 alpha:1];
        [self addSubview:_label];

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
