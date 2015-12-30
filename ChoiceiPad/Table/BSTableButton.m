//
//  BSTableButtion.m
//  BookSystem
//
//  Createdby Dream on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSTableButton.h"


@implementation BSTableButton
@synthesize manTitle=_manTitle,tableDic=_tableDic;


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




- (BSTableType)tableType{
    return tableType;
}

- (void)setTableType:(BSTableType)tableType_{
    if (tableType_!=tableType || (tableType==tableType_ && tableType==BSTableTypeOrdered)){
        tableType = tableType_;
        NSString *strImage;
        switch (tableType) {
            case BSTableTypeEmpty:
                strImage = @"Empty";
                break;
            case BSTableTypeOpen:
                strImage = @"Open";
                break;
            case BSTableTypeOrdered:
                strImage = @"Ordered";
                break;
            case BSTableTypeCheck:
                strImage = @"Check";
                break;
            case BSTableTypeSeal:
                strImage = @"Seal";
                break;
            case BSTableTypeChange:
                strImage = @"Change";
                break;
            case BSTableTypeChildren:
                strImage = @"";
                break;
            case BSTableTypeStay:
                strImage = @"Stay";
                break;
            case BSTableTypeNeat:
                strImage = @"Neat";
                break;
            default:
                break;
        }
        strImage = [NSString stringWithFormat:@"TableButton%@.png",strImage];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:strImage ofType:nil]];
        [self setBackgroundImage:img forState:UIControlStateNormal];
        //        [self setBackgroundColor:color];
        
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
