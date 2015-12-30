//
//  WebChildrenTable.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-8-27.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "WebChildrenTable.h"
#import "WebTableButton.h"
#import "Singleton.h"

@implementation WebChildrenTable
@synthesize delegete=_delegete;

- (id)initWithFrame:(CGRect)frame withArray:(NSArray *)aryInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.transform = CGAffineTransformIdentity;
        CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
        [self setTitle:[localization localizedString:@"子台位"]];
        int i=0;
        /**
         *  生成子台位按钮
         */
        for (NSDictionary *dict in aryInfo) {
//            (0, 0, 492, 354)
            WebTableButton *button=[WebTableButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor=[UIColor greenColor];
            button.tableInfo=dict;
            [button setTitle:[dict objectForKey:@"vtablenum"] forState:UIControlStateNormal];
//            button.titleLabel.text=[dict objectForKey:@"vtablenum"];
            button.frame=CGRectMake(20+(490-20)/3*(i%3), 50+55*(i/3),(490-20)/3-5, 50);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [self addSubview:button];
            i++;
        }
        /**
         *  取消按钮
         */
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(380, 280, 70, 40);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor redColor]];
        [self addSubview:btn];
        

    }
    return self;
}
#pragma mark - 自台位按钮事件
-(void)buttonClick:(WebTableButton *)btn
{
    [_delegete ChiledrenTableButton:btn.tableInfo];
}
#pragma mark - 取消按钮事件
-(void)btnClick
{
    [_delegete ChiledrenTableButton:nil];
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
