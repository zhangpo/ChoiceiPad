//预结算界面
//  AKQueryViewController.m
//  BookSystem
//
//  Created by sundaoran on 13-11-23.
//
//

#import "WebSettlementViewController.h"
#import "AKDataQueryClass.h"
#import "AKsFenLeiClass.h"
#import "AKsVipViewController.h"
#import "PaymentSelect.h"
#import "AKURLString.h"
#import "WebSettlementCell.h"
#import "AKsYouHuiListClass.h"
#import "AKDataQueryClass.h"
#import "AKsKvoPrice.h"
#import "AKsUserPaymentClass.h"
#import "AKsIsVipShowView.h"
#import "Singleton.h"
#import "AKVipViewController.h"

@implementation WebSettlementViewController
{
    NSMutableArray                  *_youmianLeibieArray; //优免类别
    NSMutableArray                  *_jutiyoumianArray;   //具体优免
    NSMutableArray                  *_dataArray;          //菜品数据
    NSMutableArray                  *_youmianShowArray;   //使用过的优免
    NSMutableArray                  *_youhuiShowArray;
    NSMutableArray                  *_moneyShowArray;     //使用过的现金结算
    NSMutableArray                  *_cardYouhuiArray;    //会员卡的所有结算方式
    NSMutableArray                  *_FenYouhuiArray;      //会员卡积分消费
    NSMutableArray                  *_cardJuanShowArray;    //会员卡的劵
    NSMutableArray                  *_userPaymentArray;     //关于现金的所有结算方式
    NSMutableArray                  *_youhuiHuChiArray;     //判断是否存在优惠互斥
    
    AKQueryAllOrders                *_akao;             //查询菜品view
    AKsCheckAouthView               *_checkView;        //授权view
    AKuserPaymentView               *_userPaymentView;  //现金银行卡使用
    AKDataQueryClass                *queryDataFromSql;  //数据库查询类
    AKShowPrivilegeView             *_showSettlement;
    AKsSettlementClass              *_Settlement;
    AKsSettlementClass              *_Settlementlinshi;
    
    float                           fujiaPrice;    //附加项金额
    float                           tangshiPrice;   //总的金额
    float                           yingfuPrice;    //应付的金额
    float                           zhaolingPrice;  //找零
    float                           fapiaoPrice;
    float                           molingPrice;
    
    BOOL                            shiyongYouHui;
    BOOL                            shiyougMoney;
    BOOL                            fristCounp;
    
    BOOL                            showSettlemenVip;
    
    
    NSString                        *_SettlementIdChange;
    AKSettlement                    *_SettlementView;
    AKsKvoPrice                     *_kvoPrice;
    UIPanGestureRecognizer          *_pan;
    AKsIsVipShowView                *showVip;
    AKMySegmentAndView              *akv;
    UILabel                         *lbVipCardNum;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    初始化标题视图，可能存在会员卡信息改变，每次进该视图都要初始化
    akv=[[AKMySegmentAndView alloc]init];
    akv.frame=CGRectMake(0, 0, 768, 44);
    //    for (int i=2; i<[akv.subviews count]+1; i++)
    //    {
    //        [[akv.subviews lastObject]removeFromSuperview];
    //        i=2;
    //    }
    [[akv.subviews objectAtIndex:1]removeFromSuperview];//移除数字选项
    akv.delegate=self;  //代理时间是数字改变的
    [self.view addSubview:akv];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //查询所有的优惠方式大类，并设为默认值为第一个
    
    if ([AKsNetAccessClass sharedNetAccess].SettlemenVip)
    {
        lbVipCardNum.text=lbVipCardNum.text=[NSString stringWithFormat:[[CVLocalizationSetting sharedInstance] localizedString:@"VIP Number"],[[AKsNetAccessClass sharedNetAccess].showVipMessageDict objectForKey:@"cardNum"]];
    }
    [self updata];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  使用观察者设计模式，观察价格变更
     */
    _kvoPrice=[[AKsKvoPrice alloc]init];
    [_kvoPrice setValue:[NSString stringWithFormat:@"%.2f",yingfuPrice] forKey:@"price"];
    [_kvoPrice addObserver:self forKeyPath:@"price" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    
    //    最上层视图，点击后出发相应时间，用于点击屏幕使上层视图移除
    UIControl *control=[[UIControl alloc]initWithFrame:self.view.bounds];
    [control addTarget:self action:@selector(ControlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view sendSubviewToBack:control];
    
    _cardYouhuiArray=[[NSMutableArray alloc]init];
    _FenYouhuiArray=[[NSMutableArray alloc]init];
    _youhuiHuChiArray=[[NSMutableArray alloc]init];
    //    拖动手势事件
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;
    
    
    //    初始化各种价格，避免为空    fujiaPrice=0;
    tangshiPrice=0;
    yingfuPrice=0;
    zhaolingPrice=0;
    fapiaoPrice=0;
    molingPrice=0;
    
    
    //    会员卡优惠通知，使用会员卡优惠成功后在本界面同样加载使用信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cardJuanYouHui:) name:NSNotificationCardJuanPay object:nil];
    //    会员卡现金
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cardYouHuiXianJin:) name:NSNotificationCardXianJinPay object:nil];
    
    //    会员卡积分
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cardYouHuiFen:) name:NSNotificationCardFenPay object:nil];
    
    //    会员卡优惠取消，本界面同样将消费信息移除
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cardJuanYouHuiCancle) name:NSNotificationCardPayCancle object:nil];
    /**
     *  判断会员
     */
        if([AKsNetAccessClass sharedNetAccess].showVipMessageDict)
        {
            [AKsNetAccessClass sharedNetAccess].VipCardNum=[[AKsNetAccessClass sharedNetAccess].showVipMessageDict objectForKey:@"cardNum"];
            [AKsNetAccessClass sharedNetAccess].IntegralOverall=[[AKsNetAccessClass sharedNetAccess].showVipMessageDict objectForKey:@"IntegralOverall"];
        }
        else
        {
            [AKsNetAccessClass sharedNetAccess].VipCardNum=@"";
            [AKsNetAccessClass sharedNetAccess].IntegralOverall=@"";
        }
    [AKsNetAccessClass sharedNetAccess].bukaiFaPiao=YES;
    [AKsNetAccessClass sharedNetAccess].shiyongVipCard=NO;
    _dataArray=[[NSMutableArray alloc] init];
    _youmianLeibieArray =[[NSMutableArray alloc]initWithArray:[[BSDataProvider sharedInstance] SelectCoupon_kind]];
    _jutiyoumianArray=[[NSMutableArray alloc]initWithArray:[self changeSegmentSelectMessage:0]];
    [self creatshowView];
    
}
/**
 *  更新支付数据
 */
-(void)updata
{
    [_dataArray removeAllObjects];
    NSArray *array=[[BSDataProvider sharedInstance] WebgetOrderList];
    for (NSDictionary *dict in array) {
        [_dataArray addObject:dict];
        if ([dict objectForKey:@"addition"]) {
            [_dataArray addObjectsFromArray:[dict objectForKey:@"addition"]];
        }
    }
    tangshiPrice=0;
    yingfuPrice=0;
    for (NSDictionary *dict in _dataArray) {
//        [[info objectForKey:@"nymoney"] floatValue]-[[info objectForKey:@"nzmoney"] floatValue]
        tangshiPrice+=[[dict objectForKey:@"nymoney"] floatValue];
        yingfuPrice=tangshiPrice;
//        yingfuPrice+=([[dict objectForKey:@"nymoney"] floatValue]-[[dict objectForKey:@"nzmoney"] floatValue]);
    }
    [AKsNetAccessClass sharedNetAccess].yingfuMoney=[NSString stringWithFormat:@"%.2f",yingfuPrice];
    _youhuiShowArray=[[BSDataProvider sharedInstance] WebgetFolioPaymentList];
    [tvOrder reloadData];
}
/**
 *  关闭视图
 */
-(void)ControlClick
{
    [self dismissViews];
}

//界面可拖动
-(void)tuodongView:(UIPanGestureRecognizer *)pan
{
    
    UIView *piece = [pan view];
    if ([pan state] == UIGestureRecognizerStateBegan || [pan state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y+ translation.y)];
        [pan setTranslation:CGPointZero inView:self.view];
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    //   取消通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardFenPay object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardJuanPay object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardPayCancle object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NSNotificationCardXianJinPay object:nil];
}

//kvo判断应付金额是否足够，足够后调用支付完成接口
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"price"])
    {
        if([[change valueForKey:@"new"]floatValue]<=0)
        {
            
        }
    }
}


/**
 *  创建view
 */
-(void)creatshowView
{
    tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(4,154-54, 310, 765+54)];
    tvOrder.allowsSelection=NO;
    tvOrder.delegate = self;
    tvOrder.dataSource = self;
    //    [self.view insertSubview:tvOrder belowSubview:btnQuery];
    tvOrder.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    tvOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tvOrder];
    
    UIView *titleImageView=[[UIView alloc]initWithFrame:CGRectMake(4, 124-54, 310, 30)];
    //    [titleImageView setImage:[UIImage imageNamed:@"CommonBG.png"]];
    titleImageView.backgroundColor=[UIColor colorWithRed:26/255.0 green:76/255.0 blue:109/255.0 alpha:1];
    
    //    [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
    //    [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_highlight_button.png"] forState:
    
    
    NSArray *array=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"CancelPayment"],[[CVLocalizationSetting sharedInstance] localizedString:@"Cancelpreferential"],[[CVLocalizationSetting sharedInstance] localizedString:@"Cash"],[[CVLocalizationSetting sharedInstance] localizedString:@"Bank Card"],[[CVLocalizationSetting sharedInstance] localizedString:@"Print"],@"会员卡",[[CVLocalizationSetting sharedInstance] localizedString:@"Back"], nil];
    for (int i=0; i<[array count]; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/[array count]*i, 1024-70, 140, 50);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 130, 30)];
        lb.text=[array objectAtIndex:i];
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"language"] isEqualToString:@"en"])
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:15];
        else
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        //        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonRed"] forState:UIControlStateNormal];
        //        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(ButtonQuery:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=1000+i;
        btn.tintColor=[UIColor whiteColor];
        [self.view addSubview:btn];
        
    }
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 30)];
    title.textAlignment = UITextAlignmentCenter;
    title.backgroundColor=[UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:17];
    title.text = [[CVLocalizationSetting sharedInstance] localizedString:@"OrderedFood"];
    title.textColor=[UIColor whiteColor];
    [titleImageView addSubview:title];
    [self.view addSubview:titleImageView];
    
    
    
    _showSettlement=[[AKShowPrivilegeView alloc]initWithArray:_youmianLeibieArray andSegmentArray:_jutiyoumianArray];
    _showSettlement.frame=CGRectMake(324, 124-54, 430, 690+54);
    _showSettlement.delegate=self;
    [self.view addSubview:_showSettlement];
    
    lbVipCardNum=[[UILabel alloc] initWithFrame:CGRectMake(400,850, 350, 40)];
    if ([AKsNetAccessClass sharedNetAccess].SettlemenVip) {
        lbVipCardNum.text=[NSString stringWithFormat:[[CVLocalizationSetting sharedInstance] localizedString:@"VIP Number"],[[AKsNetAccessClass sharedNetAccess].showVipMessageDict objectForKey:@"cardNum"]];
    }else
    {
        lbVipCardNum.text=@"";
    }
    lbVipCardNum.textColor=[UIColor blackColor];
    lbVipCardNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    lbVipCardNum.backgroundColor=[UIColor clearColor];
    [self.view bringSubviewToFront:lbVipCardNum];
    [self.view addSubview:lbVipCardNum];
    
    _youmianShowArray=[[NSMutableArray alloc]init];
    _youhuiShowArray=[[NSMutableArray alloc]init];
    _moneyShowArray=[[NSMutableArray alloc]init];
    _cardJuanShowArray=[[NSMutableArray alloc]init];
    _userPaymentArray=[[NSMutableArray alloc]init];
    
    _Settlementlinshi=[[AKsSettlementClass alloc]init];
    
}
/**
 *  按钮事件
 *
 *  @param btn
 */
-(void)ButtonQuery:(UIButton *)btn
{
    if(1000==btn.tag)
    {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [self WebcancelFolioPayment];
    }
    else if(1001==btn.tag)
    {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [self WebcancelMarketing_Cut];
        
    }
    else if(1002==btn.tag)
    {
        if(shiyougMoney)
        {
            [self userMoneyFirst:1];
        }
        else
        {
            if(_SettlementView)
            {
                [_SettlementView removeFromSuperview];
                _SettlementView=nil;
                [_showSettlement setCanuse:YES];
            }
            else
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Whether to use cash directly after operation cash will not perform preferential operations"]]
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NO"]
                                                          otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],nil];
                    alert.tag=100010;
                    [alert show];
                });
            }
        }
    }
    else if(1003==btn.tag)
    {
        if(shiyougMoney)
        {
            [self userMoneyFirst:2];
        }
        else
        {
            if(_SettlementView)
            {
                [_SettlementView removeFromSuperview];
                _SettlementView=nil;
                [_showSettlement setCanuse:YES];
            }
            else
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Whether or not the direct use of bank CARDS operation  bank card will be unenforceable preferential operation after payment"]
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NO"]
                                                          otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],nil];
                    alert.tag=100011;
                    [alert show];
                });
            }
        }
        
    }
    else if(1004==btn.tag)
    {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [self WebprintFirstBillFolio];
        
    }else if (1005==btn.tag){
        AKVipViewController *vip=[[AKVipViewController alloc] init];
        [self.navigationController pushViewController:vip animated:YES];
    }
    else if (1006==btn.tag)
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该账单正在结算，是否返回"
                                                            message:@"\n"
                                                           delegate:self
                                                  cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NO"]
                                                  otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],nil];
            alert.tag=100006;
            [alert show];
            
        });
    }
    else
    {
        NSLog(@"无此操作");
    }
    
}
-(void)WebprintFirstBillFolio
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebprintFirstBillFolio];
    if ([[dict objectForKey:@"success"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"message"]];
        [self updata];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
        [SVProgressHUD dismiss];
    }
    
}
/**
 *  取消支付
 */
-(void)WebcancelFolioPayment
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebcancelFolioPayment];
    if ([[dict objectForKey:@"success"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"message"]];
        [self updata];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
         [SVProgressHUD dismiss];
    }
   
}
/**
 *  取消优惠
 */
-(void)WebcancelMarketing_Cut
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebcancelMarketing_Cut];
    if ([[dict objectForKey:@"success"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"message"]];
        [self updata];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
    [SVProgressHUD dismiss];
}
#pragma mark - 现金银行卡使用
/**
 *  使用现金及银行卡
 */
-(void)userMoneyFirst:(int)tag
{
    NSArray *array=[[NSArray alloc] init];
    if (tag==1) {
        array=[[BSDataProvider sharedInstance] SelectSettlement:@"5"];
    }else
    {
        array=[[BSDataProvider sharedInstance] SelectSettlement:@"31"];
    }
        if(!_SettlementView)
        {
            [self dismissViews];
            _SettlementView=[[AKSettlement alloc] initWithFrame:CGRectMake(0, 0, 470, 300) withArray:array];
            _SettlementView.center=self.view.center;
            _SettlementView.delegate=self;
            [self.view addSubview:_SettlementView];
            [_SettlementView addGestureRecognizer:_pan];
            self.view.backgroundColor=[UIColor whiteColor];
            [_showSettlement setCanuse:NO];
        }
        else
        {
            [_SettlementView removeFromSuperview];
            [_showSettlement setCanuse:YES];
            _SettlementView  =nil;
        }
}
#pragma mark - AKSettlementDelegate 现金选择视图
-(void)AKSettlementButtonClick:(NSDictionary *)info
{
    if (info) {
        [self dismissViews];
        if ([[info objectForKey:@"OPERATEVALUE"] intValue]!=0&&[[info objectForKey:@"OPERATEVALUE"] intValue]!=1) {
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [self WebuserPayment:info];
            [self dismissViews];
        }else
        {
            _userPaymentView=[[AKuserPaymentView alloc] initWithFrame:CGRectMake(0, 0, 470, 350) withInfo:info];
            _userPaymentView.center=self.view.center;
            _userPaymentView.delegate=self;
            [self.view addSubview:_userPaymentView];
        }
    }
    
}
-(void)WebuserPayment:(NSDictionary *)info
{
    [self dismissViews];
    if (info) {
        NSDictionary *dict=[[BSDataProvider sharedInstance] WebcommitFolioPayment:info];
        
        if (dict) {
            if ([[dict objectForKey:@"success"] intValue]==1) {
                [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"message"]];
                [self updata];
            }else
            {
                [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"message"]];
            }
            
        }
        
    }
    

}
#pragma mark - AKuserPaymentViewDelegate 输入现金视图
-(void)AKuserPaymentViewButtonClick:(NSDictionary *)info
{
    if (info) {
        [info setValue:[info objectForKey:@"voperate"] forKey:@"OPERATEVALUE"];
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [self WebuserPayment:info];
    }
    [_userPaymentView removeFromSuperview];
    _userPaymentView=nil;
    
    
//    -(NSDictionary *)WebcommitFolioPayment:(NSDictionary *)info
}
/**
 *  刷新视图
 */
-(void)reloadDataMyself
{
    //    tvOrder.contentOffset=CGPointMake(0, ([_moneyShowArray count]+[_youhuiShowArray count]+75)*50);
    [tvOrder reloadData];
}


#pragma mark --AKsVipPayViewControllerNSNotification
/**
 *  会员卡优惠
 *
 *  @param sender <#sender description#>
 */
-(void)cardJuanYouHui:(id)sender
{
    //    AKDataQueryClass *dataQuery=[AKDataQueryClass sharedAKDataQueryClass];
    //    NSArray *name=[dataQuery selectDataFromSqlite:[NSString stringWithFormat:@"SELECT *FROM settlementoperate WHERE OPERATE='%@'",[array objectAtIndex:2]] andApi:@"优惠显示"];
    AKsYouHuiListClass *youhui=((AKsYouHuiListClass *)[sender object]);
    [_youhuiShowArray addObject:youhui];
    [_cardYouhuiArray addObject:youhui];
    [_cardJuanShowArray addObject:youhui];
    if(yingfuPrice>0)
    {
        yingfuPrice-=[youhui.youMoney floatValue];
        //        [_kvoPrice setValue:[NSString stringWithFormat:@"%.2f",yingfuPrice] forKey:@"price"];
    }
    [self reloadDataMyself];
    
}
/**
 *  现金
 *
 *  @param sender
 */
-(void)cardYouHuiXianJin:(id)sender
{
    AKsYouHuiListClass *youhui=((AKsYouHuiListClass *)[sender object]);
    yingfuPrice-=[youhui.youMoney floatValue];
    fapiaoPrice+=[youhui.youMoney floatValue];
    [_youhuiShowArray addObject:youhui];
    [_cardYouhuiArray addObject:youhui];
    //    if(yingfuPrice<0)
    //    {
    //        zhaolingPrice=0-yingfuPrice;
    //        yingfuPrice=0;
    //
    //    }
    [self reloadDataMyself];
    
}
/**
 *  会员卡积分
 *
 *  @param sender
 */
-(void)cardYouHuiFen:(id)sender
{
    AKsYouHuiListClass *youhui=((AKsYouHuiListClass *)[sender object]);
    [_youhuiShowArray addObject:youhui];
    [_cardYouhuiArray addObject:youhui];
    
    yingfuPrice-=[youhui.youMoney floatValue];
    //    [_kvoPrice setValue:[NSString stringWithFormat:@"%.2f",yingfuPrice] forKey:@"price"];
    [self reloadDataMyself];
}

/**
 *  取消优惠券使用
 */
-(void)cardJuanYouHuiCancle
{
    
    for (int j=0; j<[_cardYouhuiArray count]; j++)
    {
        for(int i=0;i<[_youhuiShowArray count];i++)
        {
            
            if([_youhuiShowArray objectAtIndex:i]==[_cardYouhuiArray objectAtIndex:j])
            {
                
                yingfuPrice+=[((AKsYouHuiListClass *)[_youhuiShowArray objectAtIndex:i]).youMoney floatValue];
                [_youhuiShowArray removeObjectAtIndex:i];
                //               }
            }
        }
    }
    [self reloadDataMyself];
}


#pragma mark - AKsNetAccessClassDelegate

-(void)fapiaoAlterBack:(NSString *)string
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                              otherButtonTitles:nil];
        [alert show];
    });
    
    
}


-(void)cancleZhiFu
{
    if((!shiyongYouHui) && (!shiyougMoney) && (![AKsNetAccessClass sharedNetAccess].shiyongVipCard))
    {
        //        [self showAlterDelegate:@"支付取消成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//提示框显示
-(void)showAlter:(NSString *)string
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                              otherButtonTitles:nil];
        [alert show];
        
    });
    
}
//提示框显示并且添加代理事件
-(void)showAlterDelegate:(NSString *)string
{
    
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                              otherButtonTitles:nil];
        alert.tag=100012;
        [alert show];
        
    });
}



#pragma mark - AKShowPrivilegeViewDelegate
//显示所有的优惠方式
-(void)changeSegmentSelect:(NSInteger)selectIndex
{
    [_showSettlement removeFromSuperview];
    _showSettlement=nil;
    
    _jutiyoumianArray=[[NSMutableArray alloc]initWithArray:[self changeSegmentSelectMessage:selectIndex]];
    [self dismissViews];
    if(!_showSettlement)
    {
        _showSettlement=[[AKShowPrivilegeView alloc]initWithArray:_youmianLeibieArray andSegmentArray:_jutiyoumianArray];
        _showSettlement.frame=CGRectMake(324, 124-54, 430, 690+54);
        _showSettlement.delegate=self;
        [self.view addSubview:_showSettlement];
    }
    
}

-(NSArray *)changeSegmentSelectMessage:(NSInteger)index
{
    //    优惠方式是从本地的数据库中获取
    NSString *string=[[_youmianLeibieArray objectAtIndex:index] objectForKey:@"KINDID"];
    NSArray *array=[[BSDataProvider sharedInstance] SelectCoupon_main:string];
    return array;
}
#pragma mark - AKShowPrivilegeViewDelegate
-(void)changeButtonSelect:(NSDictionary *)selectButton
{
    if(shiyougMoney)
    {
        [self showAlter:[NSString stringWithFormat:@"%@",[[CVLocalizationSetting sharedInstance] localizedString:@"Has been to use cash or bank card payment, please cancel the payment do this in the future"]]];
    }
    else
    {
        if(yingfuPrice >0)
        {
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(changbuttonThread:) toTarget:self withObject:selectButton];
            
        }
        else
        {
            [self showAlter:[[CVLocalizationSetting sharedInstance] localizedString:@"Bill had closed, do not use the corresponding preferential way"]];
        }
    }
    //    }
}


/**
 *  优惠使用
 *
 *  @param SettlementId 优惠信息
 */
-(void)changbuttonThread:(NSDictionary *)SettlementId
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebexecuteMarketing:SettlementId];
    [SVProgressHUD dismiss];
    if (dict) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        
        [self updata];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"使用失败" message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
    }
}


#pragma mark - 互斥授权

-(void)sureAKsCheckAouthView:(AKsSettlementClass *)Settlement andUserName:(NSString *)name andUserPass:(NSString *)pass
{
    _Settlement=[[AKsSettlementClass alloc]init];
    _Settlement=Settlement;
    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    netAccess.delegate=self;
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",name,@"userCode",pass,@"userPass", nil];
    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"checkAuth"]] andPost:dict andTag:checkAuth];
}

/**
 *  取消授权
 */
-(void)cancleAKsCheckAouthView
{
    [_checkView removeFromSuperview];
    _checkView=nil;
}
#pragma mark - UItableViewDelegate

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return [_dataArray count];
    }
    else if(section==1)
    {
        return [_youhuiShowArray count];
    }
    else if(section==2)
    {
        return [_moneyShowArray count];
    }
    else
        return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 45;
    }
    else
    {
        return 50;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section==0)
    {
        return 37;
    }
    else  if(section==1)
    {
        return 50;
    }
    else if(section==3)
    {
        return 75;
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    WebSettlementCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[WebSettlementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if(indexPath.section==0)
    {
        //        菜品显示
        NSDictionary *info=[_dataArray objectAtIndex:indexPath.row];
        NSString *count=[[info objectForKey:@"ncount"] stringValue];
        if ([[info objectForKey:@"ntcount"] intValue]>0) {
            count=[NSString stringWithFormat:@"%@-%@",count,[[info objectForKey:@"ntcount"] stringValue]];
        }
        if ([[info objectForKey:@"nzcount"] intValue]>0) {
            count=[NSString stringWithFormat:@"%@赠(%@)",count,[[info objectForKey:@"nzcount"] stringValue]];
        }
        cell.lblCount.text=count;
            //    iflag   :菜品标志(0-普通单点菜品 1-套餐 2-套餐明细 24-带附加项套餐明细 3-带附加项菜品 4-附加项)
        if ([[info objectForKey:@"iflag"] intValue]==2) 
            cell.lblName.text=[NSString stringWithFormat:@"(套)%@",[info objectForKey:@"vpname"]];
        else if ([[info objectForKey:@"iflag"] intValue]==4)
            cell.lblName.text=[NSString stringWithFormat:@"(附)%@",[info objectForKey:@"vpname"]];
        else
            cell.lblName.text=[info objectForKey:@"vpname"];
        cell.lblPrice.text=[NSString stringWithFormat:@"%.2f",[[info objectForKey:@"nymoney"] floatValue]-[[info objectForKey:@"nzmoney"] floatValue]];
        
    }
    else if(indexPath.section==1)
    {
        cell.lblName.text=[[_youhuiShowArray objectAtIndex:indexPath.row] objectForKey:@"vcashname"];
        cell.lblPrice.text=[NSString stringWithFormat:@"%.2f",[[[_youhuiShowArray objectAtIndex:indexPath.row] objectForKey:@"nmoney"] floatValue]];
        yingfuPrice-=[[[_youhuiShowArray objectAtIndex:indexPath.row] objectForKey:@"nmoney"] floatValue];
        //        结算方式显示
//        cell.lblCount.text
//        [cell setCellForAKsYouHuiList:[_youhuiShowArray objectAtIndex:indexPath.row]];
    }
    else if (indexPath.section==2)
    {
//        [cell setCellForAKsYouHuiList:[_moneyShowArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 75)];
    if(section==0)
    {
        //        view.backgroundColor=[UIColor redColor];
        UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake(0,37-37, 60, 37)];
        count.textAlignment=NSTextAlignmentCenter;
        count.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Count"];
        count.backgroundColor=[UIColor clearColor];
        count.font=[UIFont systemFontOfSize:17];
        [view addSubview:count];
        
        UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(60,37-37, 190, 37)];
        name.textAlignment=NSTextAlignmentCenter;
        name.text=[[CVLocalizationSetting sharedInstance] localizedString:@"FoodName"];
        name.backgroundColor=[UIColor clearColor];
        name.font=[UIFont systemFontOfSize:17];
        [view addSubview:name];
        
        UILabel *Price=[[UILabel alloc]initWithFrame:CGRectMake(250,37-37, 60, 37)];
        Price.textAlignment=NSTextAlignmentCenter;
        Price.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Price"];
        Price.backgroundColor=[UIColor clearColor];
        Price.font=[UIFont systemFontOfSize:17];
        [view addSubview:Price];
    }
    else if(section==1)
    {
        //         view.backgroundColor=[UIColor yellowColor];
        //        if([_jutiyoumianArray count]!=0)
        //        {
        
        UILabel *YouName=[[UILabel alloc]initWithFrame:CGRectMake(0+20,0, 155-20, 24)];
        YouName.textAlignment=NSTextAlignmentLeft;
        YouName.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Order Price"];
        YouName.backgroundColor=[UIColor clearColor];
        YouName.font=[UIFont systemFontOfSize:17];
        [view addSubview:YouName];
        
        
        UILabel *YouMoney=[[UILabel alloc]initWithFrame:CGRectMake(155-8,0, 155, 24)];
        YouMoney.textAlignment=NSTextAlignmentRight;
        YouMoney.text=[NSString stringWithFormat:@"%.2f",tangshiPrice];
        YouMoney.backgroundColor=[UIColor clearColor];
        YouMoney.font=[UIFont systemFontOfSize:17];
        [view addSubview:YouMoney];
        
        //        }
    }
    else if(section==2)
    {
        view.frame=CGRectMake(0, 0, 310, 0);
    }
    else if(section==3)
    {
        //         view.backgroundColor=[UIColor blueColor];
        UILabel *hejiName=[[UILabel alloc]initWithFrame:CGRectMake(0+20,0, 155-20, 24)];
        hejiName.textAlignment=NSTextAlignmentLeft;
        hejiName.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Original Price"];
        hejiName.backgroundColor=[UIColor clearColor];
        hejiName.font=[UIFont systemFontOfSize:17];
        [view addSubview:hejiName];
        
        
        UILabel *hejiMoney=[[UILabel alloc]initWithFrame:CGRectMake(155-8,0, 155, 24)];
        hejiMoney.textAlignment=NSTextAlignmentRight;
        hejiMoney.text=[NSString stringWithFormat:@"%.2f",yingfuPrice];
        hejiMoney.backgroundColor=[UIColor clearColor];
        hejiMoney.font=[UIFont systemFontOfSize:17];
        [view addSubview:hejiMoney];
        
        
        
        UILabel *PayName=[[UILabel alloc]initWithFrame:CGRectMake(0+20,24, 155-20, 24)];
        PayName.textAlignment=NSTextAlignmentLeft;
        PayName.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Payment Price"];
        PayName.backgroundColor=[UIColor clearColor];
        PayName.font=[UIFont systemFontOfSize:17];
        [view addSubview:PayName];
        
        
//        UILabel *PayMoney=[[UILabel alloc]initWithFrame:CGRectMake(155-8,24, 155, 24)];
//        PayMoney.textAlignment=NSTextAlignmentRight;
//        if(yingfuPrice>0)
//        {
//            PayMoney.text=[NSString stringWithFormat:@"%.2f",yingfuPrice];
//        }
//        else
//        {
//            PayMoney.text=@"0.00";
//        }
//        PayMoney.backgroundColor=[UIColor clearColor];
//        PayMoney.font=[UIFont systemFontOfSize:17];
//        [view addSubview:PayMoney];
//        
//        
//        UILabel *BackName=[[UILabel alloc]initWithFrame:CGRectMake(0+20,24+24, 155-20, 24)];
//        BackName.textAlignment=NSTextAlignmentLeft;
//        BackName.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Refund"];
//        BackName.backgroundColor=[UIColor clearColor];
//        BackName.font=[UIFont systemFontOfSize:17];
//        [view addSubview:BackName];
//        
//        UILabel *BackMoney=[[UILabel alloc]initWithFrame:CGRectMake(155-8,24+24, 155, 24)];
//        BackMoney.textAlignment=NSTextAlignmentRight;
//        BackMoney.text=[NSString stringWithFormat:@"%.2f",zhaolingPrice];
//        BackMoney.backgroundColor=[UIColor clearColor];
//        BackMoney.font=[UIFont systemFontOfSize:17];
//        [view addSubview:BackMoney];
        
    }
    
    view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    return view;
}
/**
 *  关闭视图
 */
- (void)dismissViews{
    [_showSettlement setCanuse:YES];
    if (_SettlementView && _SettlementView.superview){
        [_SettlementView removeFromSuperview];
        _SettlementView = nil;
    }
    if (_userPaymentView && _userPaymentView.superview){
        [_userPaymentView removeFromSuperview];
        _userPaymentView = nil;
    }
    if(_checkView && _checkView.superview)
    {
        [_checkView removeFromSuperview];
        _checkView = nil;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (UIInterfaceOrientationIsPortrait(interfaceOrientation));
}


#pragma mark - alterViewDelegate
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==100002)
    {
        [self.navigationController popViewControllerAnimated:YES];
        //        [_kvoPrice setValue:[NSString stringWithFormat:@"%.2f",yingfuPrice] forKey:@"price"];
    }
    else if(alertView.tag==100003)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==100004)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==100005)
    {
        [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
    }
    else if(alertView.tag==100006)
    {
        if(buttonIndex==1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag==100007)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==100008)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==100009)
    {
        if(buttonIndex==1)
        {
//            [self userCoump:_SettlementIdChange];
        }
    }
    else if(alertView.tag==100010)
    {
        if(buttonIndex==1)
        {
            [self userMoneyFirst:1];
        }
    }
    else if(alertView.tag==100011)
    {
        if(buttonIndex==1)
        {
            [self userMoneyFirst:2];
        }
    }
    else if(alertView.tag==100012)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(alertView.tag==100013)
    {
        if(buttonIndex==0)
        {
            
//            AKsVipPayViewController *vipPay=[[AKsVipPayViewController alloc] initWithArray:[AKsNetAccessClass sharedNetAccess].CardJuanArray];
//            [self.navigationController pushViewController:vipPay animated:YES];
//            [AKsNetAccessClass sharedNetAccess].changeVipCard=NO;
        }
        else
        {
            AKsVipViewController *vipView=[[AKsVipViewController alloc]init];
            [self.navigationController pushViewController:vipView animated:YES];
            [AKsNetAccessClass sharedNetAccess].changeVipCard=YES;
        }
    }
    else//是否开发票
    {
        //        if(buttonIndex==1)
        //        {
        //
        //            AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
        //            netAccess.delegate=self;
        //            [self.view addSubview:_HUD];
        //            NSLog(@"%@",[NSString stringWithFormat:@"%.2f",fapiaoPrice-zhaolingPrice]);
        //            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.zhangdanId,@"orderId",[NSString stringWithFormat:@"%.2f",fapiaoPrice-zhaolingPrice],@"invoiceMoney", nil];
        //            [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"invoiceFace"]] andPost:dict andTag:invoiceFace];
        //        }
        //        else
        //        {
        [self.navigationController popToViewController:[self.navigationController.childViewControllers objectAtIndex:1] animated:YES];
        //        }
    }
}
#pragma mark - mysegmentDelegate
-(void)selectSegmentIndex:(NSString *)segmentIndex andSegment:(UISegmentedControl *)segment
{
    
}
#pragma mark  - AKMySegmentAndViewDelegate
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
