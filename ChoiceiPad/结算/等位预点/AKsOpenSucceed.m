//
//  AKsOpenSucceed.m
//  BookSystem
//
//  Created by chensen on 14-3-20.
//
//

#import "AKsOpenSucceed.h"
#import "Singleton.h"
#import "CVLocalizationSetting.h"

@implementation AKsOpenSucceed
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setTitle:@"等位预点 "];
        //        Singleton sharedSingleton
        NSString *cheakNum=[NSString stringWithFormat:@"账单号:%@",[Singleton sharedSingleton].CheckNum];
        NSString *waitNum=[NSString stringWithFormat:@"等位号:%@",[Singleton sharedSingleton].WaitNum];
        NSArray *array=[[NSArray alloc] initWithObjects:@"预定成功",cheakNum,waitNum,@"是否进行预点餐?", nil];
        for (int i=0; i<[array count]; i++) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(40, 60+30*i, 200, 40)];
            lb.text=[array objectAtIndex:i];
            lb.backgroundColor=[UIColor clearColor];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            lb.textColor=[UIColor blackColor];
            [self addSubview:lb];
            if (i==[array count]-1) {
                lb.frame=CGRectMake(40, 60+30*i+10,200, 40);
                lb.textColor=[UIColor redColor];
            }
        }
        
        for (int i=0; i<2; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
            btn.frame=CGRectMake(280+90*i, 250,80, 40);
            if (i==0) {
                [btn setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
                btn.tag=101;
            }
            else
            {
                [btn setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
                btn.tag=102;
            }
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    [_delegate OpenSucceed:btn.tag];
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
