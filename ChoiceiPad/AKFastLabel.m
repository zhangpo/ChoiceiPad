//
//  AKFastLabel.m
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import "AKFastLabel.h"

@implementation AKFastLabel
+(UILabel*)labelWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont
{
    UILabel *Label = [[UILabel alloc]initWithFrame:aFrame];
    [Label setBackgroundColor:[UIColor clearColor]];
    Label.text = aText;
    Label.textColor = [UIColor blackColor];
    Label.textAlignment = aTextAlignment;
    [Label setFont:[UIFont systemFontOfSize:aFont]];
    return Label;
    
}
+(UILabel*)labelWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont andTextColor:(UIColor*)aColor andBackgroundColor:(UIColor*)aBackgroundColor
{
    UILabel *Label = [[UILabel alloc]initWithFrame:aFrame];
    [Label setBackgroundColor:aBackgroundColor];
    Label.text = aText;
    Label.textColor = aColor;
    Label.textAlignment = aTextAlignment;
    [Label setFont:[UIFont systemFontOfSize:aFont]];
    return Label;
}
+(UILabel*)cellLabelWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont andLines:(NSInteger)aLines
{
    UILabel *Label = [[UILabel alloc]initWithFrame:aFrame];
    [Label setBackgroundColor:[UIColor clearColor]];
    Label.text = aText;
    Label.textColor = [UIColor blackColor];
    Label.textAlignment = aTextAlignment;
    [Label setFont:[UIFont systemFontOfSize:aFont]];
    Label.numberOfLines = aLines;
    [Label sizeToFit];
    return Label;
}
//+(UILabel*)cellLabelNameWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont
//{
//    UILabel *Label = [[UILabel alloc]initWithFrame:aFrame];
//    [Label setBackgroundColor:[UIColor clearColor]];
//    Label.text = aText;
//    Label.textColor = [UIColor blackColor];
//    Label.textAlignment = aTextAlignment;
//    [Label setFont:[UIFont systemFontOfSize:aFont]];
//    
//    return [Label autorelease];
//}
@end
