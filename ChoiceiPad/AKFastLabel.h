//
//  AKFastLabel.h
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKFastLabel : NSObject
+(UILabel*)labelWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont;
+(UILabel*)labelWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont andTextColor:(UIColor*)aColor andBackgroundColor:(UIColor*)aBackgroundColor;
+(UILabel*)cellLabelWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont andLines:(NSInteger)aLines;
//+(UILabel*)cellLabelNameWithFrame:(CGRect)aFrame andText:(NSString*)aText andtextAlignment:(UITextAlignment)aTextAlignment andFont:(NSInteger)aFont;
@end
