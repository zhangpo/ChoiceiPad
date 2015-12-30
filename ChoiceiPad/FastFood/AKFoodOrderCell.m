//
//  AKFoodOrderCell.m
//  ChoiceiPad
//
//  Created by chensen on 15/7/17.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKFoodOrderCell.h"

@implementation AKFoodOrderCell
{
    UIImageView *_imageBG;
    UILabel     *_lblName;
    UILabel     *_lblCount;
    UILabel     *_lblSoldoutCnt;
}
@synthesize dataDict=_dataDict,comboDict=_comboDict;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        _imageBG=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_imageBG];
        _lblName=[[UILabel alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _lblName.textAlignment=NSTextAlignmentCenter;
        _lblName.textColor=[UIColor whiteColor];
        _lblName.numberOfLines=0;
        _lblName.lineBreakMode=NSLineBreakByWordWrapping;
        _lblName.font=[UIFont boldSystemFontOfSize:23];
        _lblName.backgroundColor=[UIColor clearColor];
        [self addSubview:_lblName];
        _lblCount=[[UILabel alloc] initWithFrame:CGRectMake(70,50, 50, 30)];
        _lblCount.font = [UIFont boldSystemFontOfSize:12];
//        _lblCount.backgroundColor=[UIColor blackColor];
        _lblCount.backgroundColor=[UIColor clearColor];
        _lblCount.textColor=[UIColor redColor];
        _lblCount.textAlignment=NSTextAlignmentRight;
        [self addSubview:_lblCount];
        _lblSoldoutCnt=[[UILabel alloc] initWithFrame:CGRectMake(0,50, 50, 30)];
        _lblSoldoutCnt.font = [UIFont boldSystemFontOfSize:15];
        //        _lblCount.backgroundColor=[UIColor blackColor];
        _lblSoldoutCnt.backgroundColor=[UIColor clearColor];
        _lblSoldoutCnt.textColor=[UIColor blackColor];
        _lblSoldoutCnt.textAlignment=NSTextAlignmentLeft;
        [self addSubview:_lblSoldoutCnt];
    }
    return self;
}
-(void)setDataDict:(NSMutableDictionary *)dataDict
{
    _dataDict=dataDict;
    _lblName.text=[dataDict objectForKey:@"DES"];
    _lblCount.text=@"";
    _lblSoldoutCnt.text=@"";
    if ([[dataDict objectForKey:@"SOLDOUT"] boolValue]) {
        [_imageBG setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"assess.png"]];
        return;
    }
    if ([[dataDict objectForKey:@"SOLDOUTCNT"] floatValue]>0) {
        _lblSoldoutCnt.text=[dataDict objectForKey:@"SOLDOUTCNT"];
    }
    if ([[dataDict objectForKey:@"total"]floatValue]>0) {
        _lblCount.text=[dataDict objectForKey:@"total"];
        [_imageBG setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"]];
        
    }else
    {
        [_imageBG setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"]];
    }
}
-(void)setComboDict:(NSMutableDictionary *)comboDict
{
    _comboDict=comboDict;
    _lblName.text=[comboDict objectForKey:@"PNAME"];
    _lblCount.text=@"";
    if ([[comboDict objectForKey:@"SOLDOUT"] boolValue]) {
        [_imageBG setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"assess.png"]];
        return;
    }
    
    if ([[comboDict objectForKey:@"total"]intValue]>0) {
        _lblCount.text=[comboDict objectForKey:@"total"];
        [_imageBG setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"OrderBG.png"]];
        
        
    }else
    {
        [_imageBG setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"product.png"]];
    }

}
@end
