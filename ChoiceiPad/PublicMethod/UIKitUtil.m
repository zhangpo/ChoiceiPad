//
//  UIKitUtil.m
//  Nurse
//
//  Created by Wu Stan on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIKitUtil.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>

@implementation BSLabel

- (void)setText:(NSString *)text{
    
    
    NSString *linestext = [text stringByReplacingOccurrencesOfString:@"^" withString:@"\n"];
    int count = 1;
    for (int i=0;i<text.length;i++){
        NSString *str = [text substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@"\n"])
            count++;
    }
    [super setText:linestext];
    
    UIFont *oldfont = self.font;
    UIFont *newfont = [UIFont fontWithName:oldfont.fontName size:self.frame.size.height/count-3];
    self.font = newfont;
    
}

@end

@implementation UILabel(UIKitUtil)

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font{
    BSLabel *lbl = [[BSLabel alloc] initWithFrame:frame];
    lbl.font = font;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.numberOfLines = 0;
    lbl.lineBreakMode = UILineBreakModeCharacterWrap;
    
    return [lbl autorelease];
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color{
    BSLabel *lbl = (BSLabel *)[self createLabelWithFrame:frame font:font];
    lbl.textColor = color;
    lbl.numberOfLines = 3 ;
    lbl.lineBreakMode = UILineBreakModeCharacterWrap;
    
    return lbl;
}



@end

@interface SWTextView ()
- (void)_initialize;
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;
@end


@implementation SWTextView {
    BOOL _shouldDrawPlaceholder;
}


#pragma mark - Accessors

@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

- (void)setText:(NSString *)string {
    [super setText:string];
    [self _updateShouldDrawPlaceholder];
}


- (void)setPlaceholder:(NSString *)string {
    if ([string isEqual:_placeholder]) {
        return;
    }
    
    [_placeholder release];
    _placeholder = [string retain];
    
    [self _updateShouldDrawPlaceholder];
}


#pragma mark - NSObject

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    
    [_placeholder release];
    [_placeholderColor release];
    [super dealloc];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (_shouldDrawPlaceholder) {
        [_placeholderColor set];
        [_placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withFont:self.font];
    }
}


#pragma mark - Private

- (void)_initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    _shouldDrawPlaceholder = NO;
}


- (void)_updateShouldDrawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderColor && self.text.length == 0;
    
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
}


- (void)_textChanged:(NSNotification *)notificaiton {
    [self _updateShouldDrawPlaceholder];    
}

@end


@implementation UIButton(UIKitUtil)

+ (UIButton *)buttonWithProfileButtonType:(ABProfileButtonType)profileButtonType{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ABProfileButtonPanel%d.gif",profileButtonType>3?profileButtonType:0]] forState:UIControlStateNormal];
    [btn sizeToFit];
    
    if (profileButtonType<=ABProfileButtonTypeMySeeMe){
        NSArray *titles = [NSArray arrayWithObjects:@"关注",@"动态",@"粉丝",@"谁看过我",nil];
        
        UILabel *lbltitle = [UILabel createLabelWithFrame:CGRectMake(0,8,btn.frame.size.width,13) font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithWhite:.2 alpha:1]];
        lbltitle.tag = 100;
        lbltitle.text = [titles objectAtIndex:profileButtonType];
        lbltitle.textAlignment = UITextAlignmentCenter;
        [btn addSubview:lbltitle];

        
        lbltitle = [UILabel createLabelWithFrame:CGRectMake(0,31,btn.frame.size.width,12) font:[UIFont systemFontOfSize:12] textColor:[UIColor colorWithRed:.05 green:.22 blue:.65 alpha:1.0]];
        lbltitle.tag = 101;
        lbltitle.textAlignment = UITextAlignmentCenter;
        [btn addSubview:lbltitle];

    }

    return btn;
}

@end


@implementation UIImage(UIKitUtil)

- (UIImage *)resizedImage:(CGSize)newSize{
    CGSize mysize = self.size;
    
    float w = newSize.width;
    float h = newSize.height;
    float W = mysize.width;
    float H = mysize.height;
    
    float fw = w/W;
    float fh = h/H;
    
    if (w>=W && h>=H){
        return self;
    }else{
        if (fw>fh){
            w = h/H*W;
        }else{
            h = w/W*H;
        }
    }
    
    UIImageView *imgv = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,w,h)] autorelease];
    [imgv setImage:self];
    
    UIGraphicsBeginImageContextWithOptions(imgv.bounds.size,YES,0.0);
    [imgv.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *imgC = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imgC;
}

- (UIImage *)resizedPhoto:(CGSize)newSize{
    return [self resizedImage:newSize];
}

+ (UIImage *)imgWithContentsOfFile:(NSString *)path{

    return [UIImage imageWithContentsOfFile:path];

}

@end

@implementation NSString(UIKitUtil)

-(NSString *)MD5
{
	unsigned char hashBytes[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self UTF8String], [self length], hashBytes);
	
    //	for (int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    //		printf("%x",hashBytes[i]);
    
	NSMutableString *mutStr = [[NSMutableString alloc] init];
	for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
	{
		NSString *a = [NSString stringWithFormat:@"%x",hashBytes[i]];
		[mutStr appendString:a];
	}
	
	return [mutStr autorelease];
}

+ (NSString *)UUIDString{
    NSString *uuid = nil;
    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0){
        uuid = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
    }else{
        uuid = [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
    }
    return uuid;
}

@end
