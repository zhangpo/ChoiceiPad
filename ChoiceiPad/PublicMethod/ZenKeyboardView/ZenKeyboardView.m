//
//  ZenKeyboardView.m
//  ZenKeyboard
//
//  Created by Kevin Nick on 2012-11-9.
//  Copyright (c) 2012年 com.zen. All rights reserved.
//

#import "ZenKeyboardView.h"
#import "CVLocalizationSetting.h"

@implementation ZenKeyboardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:[self addNumericKeyWithTitle:@"1" frame:CGRectMake(0, 1, KeyboardNumericKeyWidth - 3, KeyboardNumericKeyHeight)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"2" frame:CGRectMake(KeyboardNumericKeyWidth - 2, 1, KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"3" frame:CGRectMake(KeyboardNumericKeyWidth * 2 - 1, 1, KeyboardNumericKeyWidth - 2, KeyboardNumericKeyHeight)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"4" frame:CGRectMake(0, KeyboardNumericKeyHeight + 2, KeyboardNumericKeyWidth - 3, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"5" frame:CGRectMake(KeyboardNumericKeyWidth - 2, KeyboardNumericKeyHeight + 2, KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"6" frame:CGRectMake(KeyboardNumericKeyWidth * 2 - 1, KeyboardNumericKeyHeight + 2, KeyboardNumericKeyWidth - 2, KeyboardNumericKeyHeight)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"7" frame:CGRectMake(0, KeyboardNumericKeyHeight * 2 + 3, KeyboardNumericKeyWidth - 3, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"8" frame:CGRectMake(KeyboardNumericKeyWidth - 2, KeyboardNumericKeyHeight * 2 + 3, KeyboardNumericKeyWidth , KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"9" frame:CGRectMake(KeyboardNumericKeyWidth * 2 - 1, KeyboardNumericKeyHeight * 2 + 3, KeyboardNumericKeyWidth-2, KeyboardNumericKeyHeight)]];
        
        [self addSubview:[self addNumericKeyWithTitle:@"0" frame:CGRectMake(KeyboardNumericKeyWidth - 2, KeyboardNumericKeyHeight * 3 + 4, KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        CVLocalizationSetting *cvlocal=[CVLocalizationSetting sharedInstance];
        [self addSubview:[self addNumericKeyWithTitle:[cvlocal localizedString:@"Delect"] frame:CGRectMake(0, KeyboardNumericKeyHeight * 3 + 4, KeyboardNumericKeyWidth - 3, KeyboardNumericKeyHeight)]];
        
        [self addSubview:[self addNumericKeyWithTitle:[cvlocal localizedString:@"Finish"] frame:CGRectMake(KeyboardNumericKeyWidth * 2 - 1, KeyboardNumericKeyHeight * 3 + 4, KeyboardNumericKeyWidth - 2, KeyboardNumericKeyHeight)]];
        
        
        UIButton *dengluButton=[UIButton buttonWithType:UIButtonTypeCustom];
        dengluButton.frame=CGRectMake(20, KeyboardNumericKeyHeight * 3 + 4+20+KeyboardNumericKeyHeight, KeyboardNumericKeyWidth - 3+20, KeyboardNumericKeyHeight);
        [dengluButton setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [dengluButton setTitle:[cvlocal localizedString:@"Login"] forState:UIControlStateNormal];
        [dengluButton addTarget:self action:@selector(dengluButton) forControlEvents:UIControlEventTouchUpInside];
        [dengluButton.titleLabel setFont:[UIFont boldSystemFontOfSize:28.0]];
        [self addSubview:dengluButton];
        
        UIButton *chongzhiButton=[UIButton buttonWithType:UIButtonTypeCustom];
        chongzhiButton.frame=CGRectMake(self.bounds.size.width-20-(KeyboardNumericKeyWidth - 3+20), KeyboardNumericKeyHeight * 3 + 4+20+KeyboardNumericKeyHeight, KeyboardNumericKeyWidth - 3+20, KeyboardNumericKeyHeight);
        [chongzhiButton setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [chongzhiButton setTitle:[cvlocal localizedString:@"Reset"] forState:UIControlStateNormal];
        [chongzhiButton addTarget:self action:@selector(chongzhiButton) forControlEvents:UIControlEventTouchUpInside];
        [chongzhiButton.titleLabel setFont:[UIFont boldSystemFontOfSize:28.0]];
        [self addSubview:chongzhiButton];
        
        
    }
    
    return self;
}

-(void)dengluButton
{
    [_delegate zenKeydengluDelegate];
}
-(void)chongzhiButton
{
    [_delegate zenKeychongzhiDelegate];
}

- (UIButton *)addNumericKeyWithTitle:(NSString *)title frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:35]];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [button.titleLabel setShadowOffset:CGSizeMake(0, -0.5)];
    
    [button setBackgroundImage:[UIImage imageNamed:@"NumberButton.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressNumericKey:) forControlEvents:UIControlEventTouchUpInside];
    //    button.titleLabel.textColor=[UIColor blackColor];
    return button;
}


- (void)pressNumericKey:(UIButton *)button {
    [self.delegate didNumericKeyPressed:button];
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
