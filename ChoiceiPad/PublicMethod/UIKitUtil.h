//
//  UIKitUtil.h
//  Nurse
//
//  Created by Wu Stan on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ABProfileButtonTypeFollowees,
    ABProfileButtonTypeStatuses,
    ABProfileButtonTypeFollowers,
    ABProfileButtonTypeMySeeMe,
    ABProfileButtonTypeFollow,
    ABProfileButtonTypeSayHi,
    ABProfileButtonTypeSendPM,
    ABProfileButtonTypeOtherStatuses
}ABProfileButtonType;

@interface BSLabel : UILabel

@end

@interface UILabel(UIKitUtil)

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font;
+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color;

@end


/**
 UITextView subclass that adds placeholder support like UITextField has.
 */
@interface SWTextView : UITextView

/**
 The string that is displayed when there is no other text in the text view.
 
 The default value is `nil`.
 */
@property (nonatomic, retain) NSString *placeholder;

/**
 The color of the placeholder.
 
 The default is `[UIColor lightGrayColor]`.
 */
@property (nonatomic, retain) UIColor *placeholderColor;

@end


@interface UIButton(UIKitUtil)

+ (UIButton *)buttonWithProfileButtonType:(ABProfileButtonType)profileButtonType;

@end

@interface UIImage(UIKitUtil)

- (UIImage *)resizedImage:(CGSize)newSize;
- (UIImage *)resizedPhoto:(CGSize)newSize;
+ (UIImage *)imgWithContentsOfFile:(NSString *)path;


@end

@interface NSString(UIKitUtil)
- (NSString *)MD5;
+ (NSString *)UUIDString;
@end


