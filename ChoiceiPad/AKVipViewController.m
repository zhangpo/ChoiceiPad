//
//  AKsVipViewController.m
//  BookSystem
//
//  Created by sundaoran on 13-12-4.
//
//

#import "AKVipViewController.h"
#import "AKVipPayViewController.h"
#import "AKsIsVipShowView.h"
#import "AKMySegmentAndView.h"
#import "Singleton.h"
#import "CVLocalizationSetting.h"


@interface AKVipViewController ()

@end

@implementation AKVipViewController
{
    UITextField  *_cardTf;
    AKsIsVipShowView *showVip;
    AKMySegmentAndView *akv;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    akv=[[AKMySegmentAndView alloc]init];
    akv.frame=CGRectMake(0, 0, 768, 44);
    //    for (int i=1; i<[akv.subviews count]+1; i++)
    //    {
    //        [[akv.subviews lastObject]removeFromSuperview];
    //        i=1;
    //    }
    [[akv.subviews objectAtIndex:1]removeFromSuperview];
    [self.view addSubview:akv];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.backgroundColor=[UIColor colorWithRed:193/255.0f green:193/255.0f blue:193/255.0f alpha:1];
    AKVipSelectView *akcard=[[AKVipSelectView alloc]init];
    akcard.frame=CGRectMake(0, 0, 768, 1024);
    akcard.delegate=self;
    [self.view addSubview:akcard];
    [self.view sendSubviewToBack:akcard];
    
    
    UIControl *control=[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(ControlClick) forControlEvents:UIControlEventTouchUpInside];
    [akcard addSubview:control];
    [akcard sendSubviewToBack:control];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refushVipMessage) name:@"refushVipMessage" object:nil];
    
}

-(void)ControlClick
{
    [_cardTf resignFirstResponder];
}

-(void)controlClick:(UITextField *)cardTf
{
    _cardTf=cardTf;
}
-(void)AKVipSelectViewButtonClick:(int)tag
{
    if (tag==1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        AKVipPayViewController *vippay=[[AKVipPayViewController alloc] init];
        [self.navigationController pushViewController:vippay animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  AKMySegmentAndViewDelegate
-(void)showVipMessageView:(NSArray *)array andisShowVipMessage:(BOOL)isShowVipMessage
{
    if(isShowVipMessage)
    {
        [showVip removeFromSuperview];
        showVip=nil;
    }
    else
    {
        showVip=[[AKsIsVipShowView alloc]initWithArray:array];
        [self.view addSubview:showVip];
    }
}

@end
