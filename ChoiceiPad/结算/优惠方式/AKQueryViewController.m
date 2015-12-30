//预结算界面
//  AKQueryViewController.m
//  BookSystem
//
//  Created by sundaoran on 13-11-23.
//
//

#import "AKQueryViewController.h"
#import "Singleton.h"
#import "AKsNewVipViewController.h"
#import "AKsNewVipPayViewController.h"
#import "SVProgressHUD.h"
#import "CVLocalizationSetting.h"
#import "AKuserPaymentButton.h"
#import "AKCouponView.h"
#import "AKQueryTableViewCell.h"


@implementation AKQueryViewController
{
    NSMutableArray                  *_dataArray;          //菜品数据
    NSArray                         *_couponArray;        //支付方式数据
    float                           _totalPrice;          //菜品总价
    float                           _payabill;            //剩余金额
    float                           _clearZero;           //抹零金额
    NSMutableArray                  *_youhuiShowArray;
    NSMutableArray                  *_userPaymentArray;     //关于现金的所有结算方式
    AKQueryAllOrders                *_akao;             //查询菜品view
    AKsMoneyVIew                    *_paymentView;         //现金支付列表view
//    AKDataQueryClass                *queryDataFromSql;  //数据库查询类
    BOOL                            showSettlemenVip;
    NSDictionary                        *_SettlementIdChange;
    AKuserPayment                       *_userPaymentView;
    UIPanGestureRecognizer          *_pan;
//    AKsIsVipShowView                *showVip;
    AKMySegmentAndView              *akv;
    UILabel                         *lbVipCardNum;
    AKAlipayView                    *_alipayView;
    BSPrintQueryView                *printQuery;
    AKPaySelectView                 *_paySelect;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //    初始化标题视图，可能存在会员卡信息改变，每次进该视图都要初始化
    akv=[AKMySegmentAndView shared];
    akv.frame=CGRectMake(0, 0, 768, 44);
    [akv segmentShow:NO];
    [akv shoildCheckShow:NO];
    [self.view addSubview:akv];
    self.view.backgroundColor=[UIColor whiteColor];
//    [self paymentViewQueryProduct];
    if ([AKsNetAccessClass sharedNetAccess].SettlemenVip)
    {
        lbVipCardNum.text=lbVipCardNum.text=[NSString stringWithFormat:@"会员卡号:%@",[[AKsNetAccessClass sharedNetAccess].showVipMessageDict objectForKey:@"cardNum"]];
    }
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"LOGOUT" object:nil];
    //    最上层视图，点击后出发相应时间，用于点击屏幕使上层视图移除
    
    
    //活动界面
    AKCouponView *coupon=[[AKCouponView alloc] initWithFrame:CGRectMake(324, 124-54, 430, 830)];
    coupon.delegate=self;
    coupon.tag=9000;
    [self.view addSubview:coupon];
    
    tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(4,50, 310, 840)];
    tvOrder.allowsSelection=NO;
    tvOrder.delegate = self;
    tvOrder.dataSource = self;
    
    tvOrder.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    tvOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tvOrder];
    UIControl *control=[[UIControl alloc]initWithFrame:self.view.bounds];
    control.tag=9001;
    [control addTarget:self action:@selector(ControlClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [self.view sendSubviewToBack:control];
    //按钮事件
    NSArray *array=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"FreeServiceFee"],[[CVLocalizationSetting sharedInstance] localizedString:@"CancelPayment"],[[CVLocalizationSetting sharedInstance] localizedString:@"Cancelpreferential"],[[CVLocalizationSetting sharedInstance] localizedString:@"Cash"],[[CVLocalizationSetting sharedInstance] localizedString:@"VIP Card"],[[CVLocalizationSetting sharedInstance] localizedString:@"WeChatPlaceOrder"],[[CVLocalizationSetting sharedInstance] localizedString:@"Print"],[[CVLocalizationSetting sharedInstance] localizedString:@"Back"], nil];
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
        [btn addTarget:self action:@selector(ButtonQuery:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=1000+i;
        btn.tintColor=[UIColor whiteColor];
        [self.view addSubview:btn];
    }
//    _youhuiHuChiArray=[[NSMutableArray alloc]init];
    //    最初版本，一个台位可能会返回多个单号，先支持该功能，如果多个出现选择列表
    [self ComputingServicefee:@"1"];
    //    拖动手势事件
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;

    //    会员卡优惠取消，本界面同样将消费信息移除
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
}

/**
 *  @author ZhangPo, 15-05-14 17:05:47
 *
 *  @brief  查询账单
 *
 *  @since
 */
-(void)paymentViewQueryProduct
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp paymentViewQueryProduct];
    if ([[dict objectForKey:@"Result"]boolValue]==YES) {
        _dataArray=[[dict objectForKey:@"Message"] objectForKey:@"foodList"];
        _couponArray=[[dict objectForKey:@"Message"] objectForKey:@"paymentList"];
        _totalPrice=[[[dict objectForKey:@"Message"] objectForKey:@"foodPrice"] floatValue];
        _payabill=[[[dict objectForKey:@"Message"] objectForKey:@"paymentPrice"] floatValue];
        _clearZero=[[[dict objectForKey:@"Message"] objectForKey:@"CLEARZERO"] floatValue];
        bs_dispatch_sync_on_main_thread(^{
            if (_payabill<=0) {
                NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"paymentID",@"1",@"paymentCnt",@"",@"paymentMoney",@"1",@"payFinish", nil];
                [NSThread detachNewThreadSelector:@selector(userPayment:) toTarget:self withObject:dict];
            }
            if (_payabill==0) {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"结算完成" message:@"返回台位界面" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
                [alert show];
                alert.tag=100007;
                return ;
                
            }else if(_payabill<0){
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"结算完成" message:[NSString stringWithFormat:@"需找零%.2f",-_payabill] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag=100007;
                [alert show];
                return ;
            }
            [tvOrder reloadData];
        });
        
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
    
}
#pragma mark - TableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [_dataArray count];
    }else if(section==1)
    {
        return [_couponArray count];
    }else
    {
        return 0;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellName";
    AKQueryTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[AKQueryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if (indexPath.section==0) {
        NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
        [cell setFoodDic:dict];
    }else
    {
        NSDictionary *dict=[_couponArray objectAtIndex:indexPath.row];
        [cell setCouponDic:dict];
    }
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 50)];
    view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 30)];
    title.textAlignment = UITextAlignmentCenter;
    title.backgroundColor=[UIColor colorWithRed:26/255.0 green:76/255.0 blue:109/255.0 alpha:1];
    title.font = [UIFont boldSystemFontOfSize:17];
    title.text = [[CVLocalizationSetting sharedInstance] localizedString:@"OrderedFood"];
    title.textColor=[UIColor whiteColor];
    [view addSubview:title];
    if (section==0) {
        UILabel *count=[[UILabel alloc]initWithFrame:CGRectMake(0,30, 60, 30)];
        count.textAlignment=NSTextAlignmentCenter;
        count.text=[[CVLocalizationSetting sharedInstance]localizedString:@"Count"];
        count.backgroundColor=[UIColor clearColor];
        count.font=[UIFont systemFontOfSize:17];
        [view addSubview:count];
        
        UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(60,30, 190, 30)];
        name.textAlignment=NSTextAlignmentCenter;
        name.text=[[CVLocalizationSetting sharedInstance]localizedString:@"FoodName"];;
        name.backgroundColor=[UIColor clearColor];
        name.font=[UIFont systemFontOfSize:17];
        [view addSubview:name];
        
        UILabel *Price=[[UILabel alloc] initWithFrame:CGRectMake(250,30, 60, 30)];
        Price.textAlignment=NSTextAlignmentCenter;
        Price.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Price"];
        Price.backgroundColor=[UIColor clearColor];
        Price.font=[UIFont systemFontOfSize:17];
        [view addSubview:Price];
    }else
    {
        title.text=@"结算方式";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 60;
    }
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 100;
    }
    return 0;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 200)];
        view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        NSArray *array=[[NSArray alloc] initWithObjects:[[CVLocalizationSetting sharedInstance]localizedString:@"Original Price"],[[CVLocalizationSetting sharedInstance]localizedString:@"Payment Price"],@"抹零", nil];
        for (int i=0;i<[array count];i++) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(20, 30*i, 135, 30)];
            lb.text=[array objectAtIndex:i];
            lb.textAlignment=NSTextAlignmentLeft;
            lb.backgroundColor=[UIColor clearColor];
            lb.font=[UIFont systemFontOfSize:17];
            [view addSubview:lb];

        }
        for (int i=0;i<[array count];i++) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(147, 30*i, 155, 30)];
            lb.textAlignment=NSTextAlignmentRight;
            lb.backgroundColor=[UIColor clearColor];
            lb.font=[UIFont systemFontOfSize:17];
            [view addSubview:lb];
            if (i==0) {
                lb.text=[NSString stringWithFormat:@"%.2f",_totalPrice];
            }else if(i==1)
            {
                lb.text=[NSString stringWithFormat:@"%.2f",_payabill];
            }else
            {
                lb.text=[NSString stringWithFormat:@"%.2f",0.00];

            }
            
        }

        return view;
    }
    return nil;
}
#pragma mark - 计算服务费

-(void)ComputingServicefee:(NSString *)type
{
    BSDataProvider * dataprovider=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dataprovider ComputingServicefee:type];
    [SVProgressHUD dismiss];
    if (dict) {
        NSString *result = [[dict objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        if ([[ary1 objectAtIndex:0] intValue]==0) {
            [self paymentViewQueryProduct];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[ary1 objectAtIndex:1]];
        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"network connection timeout"]];
    }
    
}
#pragma mark - 活动使用
/**
 *  @author ZhangPo, 15-05-14 16:05:57
 *
 *  @brief  优惠使用
 *
 *  @return
 *
 *  @since
 */
-(void)couponSelect:(NSDictionary *)coupon
{
    _SettlementIdChange=coupon;
    if ([[coupon objectForKey:@"VATWILL"] intValue]==1) {
        _paySelect =[[AKPaySelectView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withInfoDic:coupon];
        _paySelect.delegate=self;
        [self.view addSubview:_paySelect];
//        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"任意折扣" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
//        UITextField *tf1=[alert textFieldAtIndex:1];
//        tf1.placeholder=@"请输入折扣比例";
//        tf1.secureTextEntry=NO;
//        tf1=[alert textFieldAtIndex:0];
//        tf1.placeholder=@"请输入折扣金额";
//        alert.tag=10008;
//        [alert show];
        return;
    }
    //判断是否需要验证
    if ([[coupon objectForKey:@"ISVALIDATE"] intValue]==1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入验证号" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:@"使用",nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertView.tag=100020;
            [alertView show];
            return;
        });
    }else
    {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(userCoump:) toTarget:self withObject:coupon];
        
    }
}
#pragma mark - 活动使用接口
-(void)userCoump:(NSDictionary *)SettlementId
{
    BSDataProvider *bp=[BSDataProvider sharedInstance];
    [SettlementId setValue:[NSString stringWithFormat:@"%f",_payabill] forKey:@"PRICE"];
    NSDictionary *dict=[bp activityUserCounp:SettlementId];
    [SVProgressHUD dismiss];
    if (dict) {
        if ([[dict objectForKey:@"Result"]boolValue]==YES) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
            [self paymentViewQueryProduct];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
}
-(void)AKPaySelectViewClick:(NSDictionary *)info
{
    if (info) {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(userCoump:) toTarget:self withObject:info];
    }
    [_paySelect removeFromSuperview];
    _paySelect=nil;
}
#pragma mark - 取消支付
-(void)memberConsumptionRecord
{
    BSDataProvider *bp=[[BSDataProvider alloc] init];
    //验证是否需要输入密码
    NSDictionary *dic=[bp memberConsumptionRecord];
    if ([[dic objectForKey:@"return"] intValue]==0) {
        
        if ([[[[dic objectForKey:@"data"] lastObject] objectForKey:@"count(*)"] intValue]==0) {
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(cancleUserPayment:) toTarget:self withObject:nil];
        }else
        {
            [SVProgressHUD dismiss];
            bs_dispatch_sync_on_main_thread(^{
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入会员卡密码" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
                alert.alertViewStyle=UIAlertViewStylePlainTextInput;
                alert.tag=111;
                [alert show];
            });
        }
    }else
    {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"error"]];
    }
}
-(void)cancleUserPayment:(NSString *)password
{
    BSDataProvider *bp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[bp cancleUserPayment:password];
    [SVProgressHUD dismiss];
    if (dict) {
        if ([[dict objectForKey:@"Result"]boolValue]==YES) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
            [self paymentViewQueryProduct];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
}
#pragma mark - 取消优惠
-(void)cancleUserCounp
{
    BSDataProvider *bp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[bp cancleUserCounp];
    [SVProgressHUD dismiss];
    if (dict) {
        if ([[dict objectForKey:@"Result"]boolValue]==YES) {
            [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
            [self paymentViewQueryProduct];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
}
#pragma mark - 打印
#pragma mark - 打印按钮事件
- (void)printQuery{
    bs_dispatch_sync_on_main_thread(^{
        if (!printQuery){
            printQuery = [[BSPrintQueryView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
            printQuery.delegate = self;
            printQuery.center = self.view.center;
            [self.view addSubview:printQuery];
            [printQuery firstAnimation];
        }
        else{
            [printQuery removeFromSuperview];
            printQuery = nil;
        }
    });
}
#pragma mark - 打印代理事件
-(void)printQueryWithOptions:(NSDictionary *)info
{
    if (info) {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."]];
        NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(priPrintOrder:) object:info];
        [thread start];
    }
    [printQuery removeFromSuperview];
    printQuery = nil;
}

#pragma mark - 打印请求
-(void)priPrintOrder:(NSDictionary *)info
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp priPrintOrder:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==YES)
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
    else
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
}
#pragma mark - 视图点击事件
-(void)ControlClick
{
    if (_paymentView) {
        [_paymentView removeFromSuperview];
        _paymentView =nil;
    }
    if (_userPaymentView) {
        [_userPaymentView removeFromSuperview];
        _userPaymentView =nil;
    }
    [self.view sendSubviewToBack:[self.view viewWithTag:9001]];
}
#pragma mark - 界面可拖动
//界面可拖动
-(void)tuodongView:(UIPanGestureRecognizer *)pan
{
    
    UIView *piece = [pan view];
    NSLog(@"%@",piece);
    if ([pan state] == UIGestureRecognizerStateBegan || [pan state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y+ translation.y)];
        [pan setTranslation:CGPointZero inView:self.view];
    }
}

#pragma mark - 按钮事件
/**
 *  下面的按钮的事件
 *
 *  @param btn
 */
-(void)ButtonQuery:(UIButton *)btn
{
//    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
//    netAccess.delegate=self;
    /**
     *  取消支付
     */
    if (1000==btn.tag) {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [self ComputingServicefee:@"0"];
    }else if(1001==btn.tag)
    {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        //        一个取消支付接口，取消所有可取消的支付方式
        [NSThread detachNewThreadSelector:@selector(memberConsumptionRecord) toTarget:self withObject:nil];
     }
    else if(1002==btn.tag)
    {
        /**
         *  取消优惠
         */
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(cancleUserCounp) toTarget:self withObject:nil];
    }
    else if(1003==btn.tag)
    {
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"支付" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"现金",@"银行卡",@"网络支付", nil];
        [sheet showFromRect:btn.frame inView:self.view animated:YES];
    }

    else if(1004==btn.tag)
    {
        [AKsNetAccessClass sharedNetAccess].isVipShow=NO;
        [AKsNetAccessClass sharedNetAccess].userPaymentArray=_userPaymentArray;
        if([AKsNetAccessClass sharedNetAccess].showVipMessageDict)
        {
            NSDictionary *dict=[[NSDictionary alloc]initWithDictionary:[AKsNetAccessClass sharedNetAccess].showVipMessageDict];
            
            
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否更换员卡消费"
                                                                message:[NSString stringWithFormat:@"当前手机号码：%@\n当前会员卡号:%@", [dict objectForKey:@"phoneNum"],[dict objectForKey:@"cardNum"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是",nil];
                alert.tag=100013;
                [alert show];
                
            });
            
        }
        else
        {
            AKsNewVipViewController *vipView=[[AKsNewVipViewController alloc]init];
            [self.navigationController pushViewController:vipView animated:YES];
        }
    }else if (1005==btn.tag){
        //上传微信
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(wechat) toTarget:self withObject:nil];
    }
    else if(1006==btn.tag)
    {
        /**
         *  打印
         */
        [self printQuery];
    }
    else if (1007==btn.tag)
    {
        /**
         *  返回
         */
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
}
-(void)wechat
{
    BSDataProvider * bs=[[BSDataProvider alloc] init];
    NSDictionary *dict=[bs pushWeChatCheckOut:[NSDictionary dictionaryWithObjectsAndKeys:[Singleton sharedSingleton].CheckNum,@"orderid",[NSString stringWithFormat:@"%.2f",_payabill],@"paymoney", nil]];
    [SVProgressHUD dismiss];
    if (dict) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"error"]];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    BSDataProvider *bp=[[BSDataProvider alloc] init];
    
    if (buttonIndex>=0) {
        NSArray *array=nil;
        if (buttonIndex==0) {
            array=[bp selectCashArray];
        }else if (buttonIndex==1){
            array=[bp selectBankArray];
        }else if (buttonIndex==2){
            array=[bp selectOnlinePaymentArray];
        }
        [self userPaymentView:array];
    }
}
#pragma mark - 支付方式
/**
 *  使用现金支付
 */
-(void)userPaymentView:(NSArray *)array
{
        if(!_userPaymentView)
        {
//            [self dismissViews];
            [self.view bringSubviewToFront:[self.view viewWithTag:9001]];
//            [self.view sendSubviewToBack:[self.view viewWithTag:9001]];
            _userPaymentView =[[AKuserPayment alloc] initWithFrame:CGRectMake(0, 0, 470, 300) withPaymentArray:array];
            _userPaymentView.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            _userPaymentView.delegate=self;
            [self.view addSubview:_userPaymentView];
        }
        else
        {
            [_userPaymentView removeFromSuperview];
            _userPaymentView=nil;
        }
}
#pragma mark -
#pragma mark - 支付方式按钮事件---现金，银行卡，微信，支付宝
-(void)userPaymentClick:(NSDictionary *)userPaymentDic
{
   
    [userPaymentDic setValue:[NSString stringWithFormat:@"%.2f",_payabill] forKey:@"PAYABILL"];//应付金额
    if ([[userPaymentDic objectForKey:@"OPERATEGROUPID"] isEqualToString:@"50"]||[[userPaymentDic objectForKey:@"OPERATEGROUPID"] isEqualToString:@"48"]) {
        //微信，支付宝
        if (!_alipayView) {
            [self.view bringSubviewToFront:[self.view viewWithTag:9001]];
            _alipayView=[[AKAlipayView alloc] initWithFrame:CGRectMake(0, 0, 493, 354)withAlipayDict:userPaymentDic];
            [_alipayView addGestureRecognizer:_pan];
            _alipayView.delegate=self;
            [self.view addSubview:_alipayView];
        }else
        {
            [_alipayView removeFromSuperview];
            _alipayView=nil;
        }
        
    }else
    {
        //现金，银行卡
        
        if ([[userPaymentDic objectForKey:@"OPERATEVALUE"]floatValue]==0||[[userPaymentDic objectForKey:@"EXCHANGERATE"]floatValue]!=0) {
            if(!_paymentView)
            {
                _paymentView=[[AKsMoneyVIew alloc] initWithFrame:CGRectMake(0, 0, 493, 354) withPayment:userPaymentDic];
                [_paymentView addGestureRecognizer:_pan];
                [self.view addSubview:_paymentView];
                _paymentView.delegate=self;
            }
            else
            {
                [_paymentView removeFromSuperview];
                _paymentView=nil;
            }
        }else
        {
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:[userPaymentDic objectForKey:@"OPERATE"],@"paymentID",@"1",@"paymentCnt",[userPaymentDic objectForKey:@"OPERATEVALUE"],@"paymentMoney",[[userPaymentDic objectForKey:@"OPERATEVALUE"] floatValue]<_payabill?@"0":@"1",@"payFinish", nil];
            [self userPayment:dict];
        }
    }
    [_userPaymentView removeFromSuperview];
    _userPaymentView=nil;

}
#pragma mark - 输入金额的事件
-(void)AKsMoneyVIewClick:(NSDictionary *)info
{
    if (info) {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
//        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:[info objectForKey:@"OPERATE"],@"paymentID",@"1",@"paymentCnt",[info objectForKey:@"paymentMoney"],@"paymentMoney",[[info objectForKey:@"paymentMoney"] floatValue]<_payabill?@"0":@"1",@"payFinish", nil];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:[info objectForKey:@"OPERATE"],@"paymentID",@"1",@"paymentCnt",[info objectForKey:@"paymentMoney"],@"paymentMoney",@"0",@"payFinish", nil];
        [NSThread detachNewThreadSelector:@selector(userPayment:) toTarget:self withObject:dict];
    }
    [_paymentView removeFromSuperview];
    _paymentView=nil;
}

#pragma mark - 现金银行卡支付
-(void)userPayment:(NSDictionary *)info
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp userPayment:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"]boolValue]==YES) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
        [self paymentViewQueryProduct];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }

}
#pragma mark - 微信支付宝支付
-(void)AKAlipayViewButtonClick:(NSDictionary *)alipay
{
    if (alipay) {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(scanCode:) toTarget:self withObject:alipay];
    }
    [_alipayView removeFromSuperview];
    _alipayView = nil;
}
#pragma mark - 扫码支付
-(void)scanCode:(NSDictionary *)info{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp scanCode:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"return"] intValue]==0) {
    
//        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [self paymentViewQueryProduct];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"error"]];
    }
}
#pragma mark alterViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    bs_dispatch_sync_on_main_thread(^{
        if(alertView.tag==100006)
        {
            if(buttonIndex==1)
            {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }else if(alertView.tag==100007)
        {
            if(buttonIndex==1)
            {
                
                NSArray *array=[self.navigationController viewControllers];
                [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
            }
        }else if(alertView.tag==10008)
        {
            if(buttonIndex==1)
            {
               
            }
        }
        else if(alertView.tag==100013)
        {
            if(buttonIndex==0)
            {
                
                AKsNewVipPayViewController *vipPay=[[AKsNewVipPayViewController alloc] init];
                [self.navigationController pushViewController:vipPay animated:YES];
                [AKsNetAccessClass sharedNetAccess].changeVipCard=NO;
            }
            else
            {
                AKsNewVipViewController *vipView=[[AKsNewVipViewController alloc]init];
                [self.navigationController pushViewController:vipView animated:YES];
                [AKsNetAccessClass sharedNetAccess].changeVipCard=YES;
            }
            
        }else if(alertView.tag==100020)
        {
            //团购验证
            if (buttonIndex==1) {
                UITextField *tf1 = [alertView textFieldAtIndex:0];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:_SettlementIdChange];
                [dict setObject:tf1.text forKey:@"num"];
                _SettlementIdChange=dict;
                [self userCoump:dict];
            }
        }else if (alertView.tag==111){
            if (buttonIndex==1) {
                UITextField *tf1 = [alertView textFieldAtIndex:0];
                if ([tf1.text length]>0) {
                    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance]localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
                    [NSThread detachNewThreadSelector:@selector(cancleUserPayment:) toTarget:self withObject:tf1.text];
                }
            }
            [SVProgressHUD dismiss];
        }
    });
}


#pragma mark - 注销登录
-(void)logout
{
    [Singleton sharedSingleton].userInfo=nil;
    NSArray *array=[self.navigationController viewControllers];
    if ([array count]>1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
