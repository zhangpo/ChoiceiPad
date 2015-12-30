//
//  AKMySegmentAndView.m
//  BookSystem
//
//  Created by sundaoran on 13-11-21.
//
//

#import "AKMySegmentAndView.h"
#import "Singleton.h"
#import "AKDataQueryClass.h"
#import "CVLocalizationSetting.h"
#import "AKsNetAccessClass.h"
#import "AKsIsVipShowView.h"
#import "AKShouldCheckView.h"

@implementation AKMySegmentAndView
{
    UISegmentedControl *segment;
    AKsIsVipShowView   *_showVip;
    BOOL isvip;
    
}
@synthesize delegate=_delegate;
@synthesize table=_table,CheckNum=_CheckNum,man=_man,woman=_woman,shoildCheck=_shoildCheck;

+(AKMySegmentAndView *)shared
{
    if (!_shared) {
        _shared=[[AKMySegmentAndView alloc] init];
    }
    [_shared peopelNumOrManandWoman];
    [_shared vipMessage];
    return _shared;
}
- (id)init
{
    self = [super init];
//    [AKsNetAccessClass sharedNetAccess].SettlemenVip=NO;
    if (self) {
        [self creatview];
    }
    return self;
}
static AKMySegmentAndView *_shared;
-(void)creatview
{
    UIImageView *titleImageView=[[UIImageView alloc]init];
    titleImageView.frame=CGRectMake(0,0,768,44);
    [titleImageView setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"title.png"]];
    titleImageView.userInteractionEnabled=YES;
    [self addSubview:titleImageView];
    segment=[[UISegmentedControl alloc]init];
    segment.frame=CGRectMake(4, 54, 760, 60);
    //    segment.tintColor=[UIColor blackColor];
    
    
    NSDictionary *dicSelect = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:20],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
    
    NSDictionary *dicnomal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:20],UITextAttributeFont ,nil];
    
    [segment setTitleTextAttributes:dicSelect forState:UIControlStateSelected];
    [segment setTitleTextAttributes:dicnomal forState:UIControlStateNormal];
    
    for (int i=0; i<=8; i++)
    {
        [segment insertSegmentWithTitle:[NSString stringWithFormat:@"%d",i+1] atIndex:i animated:NO];
    }
    [segment insertSegmentWithTitle:@"0" atIndex:10 animated:NO];
    [segment insertSegmentWithTitle:@"X" atIndex:11 animated:NO];
    [segment insertSegmentWithTitle:@"" atIndex:12 animated:NO];
    segment.selectedSegmentIndex=11;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:segment];
    if ([[Singleton sharedSingleton].man isEqualToString:@""]||[[Singleton sharedSingleton].man isEqualToString:NULL]||[[Singleton sharedSingleton].man isEqualToString:nil]||[[Singleton sharedSingleton].man isEqualToString:@"(null)"])
    {
        _man.text=@"0";
    }
    else
    {
        _man.text=[Singleton sharedSingleton].man;
    }
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 700, 40)];
    if([[Singleton sharedSingleton].CheckNum  isEqualToString:@""])
    {
        [Singleton sharedSingleton].CheckNum=@"暂无账单";
    }
    lb.backgroundColor=[UIColor clearColor];
    lb.textColor=[UIColor whiteColor];
    lb.tag=1001;
    [self addSubview:lb];
    UIButton *Vipbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [Vipbutton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"vip.png"] forState:UIControlStateNormal];
    Vipbutton.frame=CGRectMake(768-80, 5, 40, 34);
    Vipbutton.tag=1000;
    [Vipbutton addTarget:self action:@selector(showVipShow) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:Vipbutton];
    _shoildCheck=[AKShouldCheckView shared];
    [_shoildCheck pauseTimer];
    _shoildCheck.delegate=self;
    [titleImageView addSubview:_shoildCheck];
//    [self segmentShow:NO];
    [self peopelNumOrManandWoman];
}
-(void)vipMessage
{
    UIView *view=[self viewWithTag:1000];
    if ([Singleton sharedSingleton].cardMessage) {
        view.hidden=NO;
    }else
    {
        view.hidden=YES;
    }
}
#pragma mark - 是否显示Segment
-(void)segmentShow:(BOOL)SHOW
{
    [segment removeFromSuperview];
    if (SHOW) {
        [self addSubview:segment];
        self.frame=CGRectMake(0, 0, 768, 114);
    }else
    {
        self.frame=CGRectMake(0, 0, 768, 44);
    }
}
#pragma mark - 是否显示我要结账
-(void)shoildCheckShow:(BOOL)SHOW
{
    
    if (SHOW) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WeChatSettlement"]boolValue]) {
            [_shoildCheck removeFromSuperview];
            _shoildCheck.frame=CGRectMake(768-120, 5, 35, 35);
            [self addSubview:_shoildCheck];
            _shoildCheck.hidden=NO;
            [_shoildCheck startTimer];
        }
    }else
    {
        _shoildCheck.hidden=YES;
        [_shoildCheck pauseTimer];
    }
}
-(void)peopelNumOrManandWoman
{
    UILabel *lb=(UILabel *)[self viewWithTag:1001];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"])
    {
        if ([[Singleton sharedSingleton] isYudian]){
                lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@  %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"],[Singleton sharedSingleton].tableName,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"Mister"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"Mistress"],[Singleton sharedSingleton].woman,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
        }
        else
        {
                lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@ %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Table Number"],[Singleton sharedSingleton].tableName,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"Mister"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"Mistress"],[Singleton sharedSingleton].woman,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
        }
    }else
    {
        if ([[Singleton sharedSingleton] isYudian]){
                lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Phone Number"],[Singleton sharedSingleton].tableName,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"People:"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
        }
        else
        {
                lb.text=[NSString stringWithFormat:@"%@%@  %@%@  %@%@ %@%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Table Number"],[Singleton sharedSingleton].tableName,[[CVLocalizationSetting sharedInstance] localizedString:@"Order Number"],[Singleton sharedSingleton].CheckNum,[[CVLocalizationSetting sharedInstance] localizedString:@"People:"],[Singleton sharedSingleton].man,[[CVLocalizationSetting sharedInstance] localizedString:@"User Name"],[Singleton sharedSingleton].userName];
                lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:19];
        }
    }

}
-(void)showVipShow
{
    if (_showVip) {
        [_showVip removeFromSuperview];
        _showVip=nil;
    }else
    {
        NSDictionary *dict=[Singleton sharedSingleton].cardMessage;
        _showVip=[[AKsIsVipShowView alloc] initWithDict:dict];
        [self addSubview:_showVip];
    }
}
-(void)shouldCheckViewClick:(NSDictionary *)checkDic
{
    [_delegate shouldCheckViewClick:checkDic];
}
-(void)segmentClick:(UISegmentedControl *)segment1
{
    
    if(segment1.selectedSegmentIndex!=10)
    {
        if(segment1.selectedSegmentIndex==9)
        {
            [_delegate selectSegmentIndex:[NSString stringWithFormat:@"%d",0] andSegment:segment1];
        }
        else
        {
            [_delegate selectSegmentIndex:[NSString stringWithFormat:@"%d",segment.selectedSegmentIndex+1] andSegment:segment1];
        }
    }
    else
    {
        [_delegate selectSegmentIndex:@"X" andSegment:segment1];
    }
}

-(void)setTitle:(NSString *)title
{
    segment.selectedSegmentIndex=11;
    [segment setTitle:title forSegmentAtIndex:11];
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
