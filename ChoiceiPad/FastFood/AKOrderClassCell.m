//
//  AKOrderClassCell.m
//  ChoiceiPad
//
//  Created by chensen on 15/7/15.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKOrderClassCell.h"

@implementation AKOrderClassCell
{
    UIImageView *_imageBG;
    UILabel     *_lblName;
    UILabel     *_lblCount;
}
@synthesize dataDic=_dataDic;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _imageBG=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame)-10, CGRectGetHeight(frame))];
        [self addSubview:_imageBG];
        _lblName=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 70, CGRectGetHeight(frame))];
        _lblName.textAlignment=NSTextAlignmentLeft;
        _lblName.textColor=[UIColor whiteColor];
        _lblName.backgroundColor=[UIColor clearColor];
        [self addSubview:_lblName];
        _lblCount=[[UILabel alloc] initWithFrame:CGRectMake(70,20, 20, 20)];
        _lblCount.font = [UIFont boldSystemFontOfSize:12];
        _lblCount.backgroundColor=[UIColor clearColor];
        _lblCount.textColor=[UIColor redColor];
        [self addSubview:_lblCount];
    }
    return self;
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic=dataDic;
    _lblName.text=@"";
    if ([[dataDic objectForKey:@"SELECT"] boolValue]==YES) {
        _lblName.textColor=[UIColor blueColor];
    }else
    {
        _lblName.textColor=[UIColor whiteColor];
    }
    if([[dataDic objectForKey:@"count"] floatValue]>0)
    {
        _lblCount.text=[dataDic objectForKey:@"count"];
        [_imageBG setImage:[UIImage imageNamed:@"ClassLong.png"]];
        _imageBG.frame=CGRectMake(0,0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
    else
    {
        _lblCount.text=@"";
        [_imageBG setImage:[UIImage imageNamed:@"ClassShort.png"]];
        _imageBG.frame=CGRectMake(0,0, CGRectGetWidth(self.frame)-5, CGRectGetHeight(self.frame));
    }
    _lblName.text=[dataDic objectForKey:@"DES"];
    
}

@end
