//
//  BSTableButtion.m
//  BookSystem
//
//  Created by Dream on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ZCTableButton.h"


@implementation ZCTableButton
@synthesize manTitle=_manTitle;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (ZCTableType)tableType{
    return tableType;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _manTitle=[[UILabel alloc] initWithFrame:CGRectMake(85,1.5, 40, 20)];
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

- (void)setTableType:(ZCTableType)tableType_{
    if (tableType_!=tableType || (tableType==tableType_ && tableType==ZCTableTypeOrdered)){
        tableType = tableType_;
        NSString *strImage;
        switch (tableType) {
            case ZCTableTypeKongXian:
                strImage = @"TableButtonEmpty.png";
                break;
            case ZCTableTypeKaiTai:
               strImage = @"TableButtonOpen.png";
                break;
            case ZCTableTypeDianCai:
                strImage = @"TableButtonOrdered.png";
                break;
            case ZCTableTypeYuDing:
                strImage = @"TableButtonCheck.png";
                break;

            default:
                strImage = @"TableButtonSeal.png";
                break;
        }
        [self setBackgroundImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
//        [imageView setImage:[UIImage imageNamed:strImage]];
    }
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
