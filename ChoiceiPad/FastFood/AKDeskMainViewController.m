//
//  AKDeskMainViewController.m
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import "AKsNetAccessClass.h"
#import "AKDeskMainViewController.h"
#import "AKFilePath.h"
#import "AKOrderRepastViewController.h"
#import "Singleton.h"
#import "BSDataProvider.h"
#import "BSQueryViewController.h"
#import "AKURLString.h"
#import "AKsVipViewController.h"
#import "AKSelectCheck.h"
#import "AKOrderLeft.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "SVProgressHUD.h"
#import "AKsNewVipViewController.h"                 //会员查询
#import "CVLocalizationSetting.h"
#import "AKForecastSalesViewController.h"           //销售排行
#import "AKQueryViewController.h"                   //结账
#import "AKLocalWaitSeat.h"                         //等位
#import "AKFoodOrderViewController.h"
#import "AKWaitSeatViewController.h"



//#import "CVLocalizationSetting.h"
@interface AKDeskMainViewController ()

@end

@implementation AKDeskMainViewController
{
    //    UIControl *control;
    UISegmentedControl      *segment;               //选择器
    NSMutableDictionary     *_tabledict;
    WebChildrenTable        *web;
    AKsOpenSucceed          *_openSucceed;
    UIPanGestureRecognizer  *_pan;
    NSMutableArray          *_freeTableArray;         //空闲台位
    NSMutableArray          *_occupationTableArray;   //占用台位
    NSArray                 *_tableArray;             //全部台位
    AKShouldCheckView       *_shouldCheck;            //需要结账
    UICollectionView        *_tableCV;
    NSDictionary            *_tableStateColor;        //台位状态颜色
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Singleton sharedSingleton].CheckNum=@"";
    [Singleton sharedSingleton].man=@"";
    [Singleton sharedSingleton].woman=@"";
    [Singleton sharedSingleton].tableName=nil;
    [Singleton sharedSingleton].SELEVIP=NO;
    [Singleton sharedSingleton].isYudian=NO;
    [Singleton sharedSingleton].dishArray=nil;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WeChatSettlement"]boolValue])
    {
        _shouldCheck=[AKShouldCheckView shared];
        _shouldCheck.delegate=self;
        [_shouldCheck removeFromSuperview];
        [self.view addSubview:_shouldCheck];
        _shouldCheck.frame=CGRectMake(20, 200, 30, 30);
        [_shouldCheck addGestureRecognizer:_pan];
        [self dismissViews];
        [_shouldCheck startTimer];
    }
    
//    bs_dispatch_sync_on_main_thread(^{
        /**
         *  刷新台位
         */
        [self getTableList:_tabledict];
//        [self updataTable];
//    });
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注销登录通知
    
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    NSMutableArray *DESArray = [[NSMutableArray alloc]init];
    _freeTableArray=[[NSMutableArray alloc] init];
    _occupationTableArray=[[NSMutableArray alloc] init];
    //查询状态
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    deskClassArray=[[NSMutableArray alloc] init];
    _tableStateColor=[dp getStatusColor];
    NSArray *array=[dp getArea];
    if ([array count]>0) {
        [Singleton sharedSingleton].pk_store=[[array lastObject] objectForKey:@"SCODE"];
    }
    //区域
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Area"]]) {
        
        for (NSDictionary *dict in array) {
            NSString *str=[dict objectForKey:@"TBLNAME"];
            [DESArray addObject:str];
        }
        [deskClassArray addObjectsFromArray:array];
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Floor"]]){
        //楼层
        [deskClassArray addObjectsFromArray:[dp getFloor]];
        
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Status"]]){
        //状态
        [DESArray addObjectsFromArray:[dp getStatus]];
    }
    [DESArray insertObject:[[CVLocalizationSetting sharedInstance] localizedString:@"All"] atIndex:0];
    _tabledict=[NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    segment = [[UISegmentedControl alloc] initWithItems:DESArray];
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"ArialRoundedMTBold"size:20],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    segment.frame = CGRectMake(0, 0, 768, 40);
    
    [segment setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"title.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    segment.selectedSegmentIndex = 0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(135, 75);
    flowLayout.minimumInteritemSpacing =5;//列距
    _tableCV=[[UICollectionView alloc] initWithFrame:CGRectMake(25, 100, 718, 850) collectionViewLayout:flowLayout];
    [_tableCV registerClass:[AKTableCell class] forCellWithReuseIdentifier:@"colletionCell"];
    _tableCV.delegate=self;
    _tableCV.backgroundColor=[UIColor whiteColor];
    _tableCV.dataSource=self;
    [self.view addSubview:_tableCV];
    
    
    CVLocalizationSetting *cvlocal=[CVLocalizationSetting sharedInstance];
    
//    NSArray *array2=[[NSArray alloc] initWithObjects:[cvlocal localizedString:@"Logout"],[cvlocal localizedString:@"Wait"],[cvlocal localizedString:@"Combine Table"],[cvlocal localizedString:@"Change Table"],[cvlocal localizedString:@"Select Order"],[cvlocal localizedString:@"SalesForecast"],[cvlocal localizedString:@"Updata"], nil];
    NSArray *array2=[[NSArray alloc] initWithObjects:[cvlocal localizedString:@"Logout"],[cvlocal localizedString:@"Wait"],[cvlocal localizedString:@"Combine Table"],[cvlocal localizedString:@"Change Table"],[cvlocal localizedString:@"Select Order"],[cvlocal localizedString:@"Open Table"],[cvlocal localizedString:@"Updata"], nil];
    for (int i=0; i<[array2 count]; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/[array2 count]*i, 1024-70, 140, 50);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 130, 30)];
        lb.text=[array2 objectAtIndex:i];
        if ([[[NSUserDefaults standardUserDefaults]
              stringForKey:@"language"] isEqualToString:@"en"])
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:14];
        else
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        btn.tintColor=[UIColor whiteColor];
        btn.tag=i+1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    [self searchBarInit];
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;
    
//    if (SCAN) {
//        AKScanTableView *scan=[[AKScanTableView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
//        scan.delegate=self;
//        [self.view addSubview:scan];
//    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_shouldCheck pauseTimer];
}
#pragma mark - 台位显示
#pragma mark - collectionViewDelegate&&UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_tableArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell";
    AKTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    cell.dataInfo=[_tableArray objectAtIndex:indexPath.row];
    NSString *colorStr=[_tableStateColor objectForKey:[cell.dataInfo objectForKey:@"status"]];
    NSArray *colorAry=[colorStr componentsSeparatedByString:@","];
    cell.backgroundColor=[UIColor colorWithRed:[[colorAry objectAtIndex:0] floatValue]/255 green:[[colorAry objectAtIndex:1] floatValue]/255 blue:[[colorAry objectAtIndex:2] floatValue]/255 alpha:1];
    cell.delegate=self;
    return cell;
}
#pragma mark - 点击事件
-(void)AKTableCellClick:(NSDictionary *)dataInfo
{
    //    AKTableCell *tableCell=(AKTableCell *)[_tableCV cellForItemAtIndexPath:indexPath];
    [self dismissViews];
    _tabledict=dataInfo;
    [Singleton sharedSingleton].isYudian=NO;
    [Singleton sharedSingleton].tableName=[_tabledict objectForKey:@"num"];
    [Singleton sharedSingleton].Seat  =[_tabledict objectForKey:@"name"];
    int type = [[_tabledict objectForKey:@"status"] intValue];
    UIAlertView *alert;
    segment.selectedSegmentIndex=[Singleton sharedSingleton].segment;
    /**
     *  当为空闲台位
     */
    if (type==1) {
        [self openTableView:_tabledict];
    }
    /**
     *  结账
     *
     */
    else if (type==4){
        alert = [[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"This table is already the checkout, to clear the table?"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        alert.tag = kCancelTag;
        [alert show];
    }
    /**
     *  封单
     *
     */
    else if (type==6){
        alert = [[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The table has a account, please go to the cashier's desk"] message:nil
                                          delegate:self cancelButtonTitle:nil otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        [alert show];
    }else
    {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(getOrdersBytale:) toTarget:self withObject:_tabledict];
    }
}
#pragma mark - 长按事件
-(void)AKTableCellLongClick:(NSDictionary *)dataInfo
{
    _tabledict=dataInfo;
    
    NSDictionary *dic=[[BSDataProvider sharedInstance] selectRolemodule:@"9904001"];
    if (![[dic objectForKey:@"ROLE"] boolValue]) {
        [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Have no legal power"]];
        return;
    }
    
    [AKsNetAccessClass sharedNetAccess].TableNum=[dataInfo objectForKey:@"name"];
    if (vOpen){
        [vOpen removeFromSuperview];
        vOpen = nil;
    }
    vOpen = [[BSOpenTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withtag:@"6"];
    vOpen.delegate = self;
    vOpen.tableDic=dataInfo;
    vOpen.center = CGPointMake(384, 512);
    vOpen.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [vOpen addGestureRecognizer:_pan];
    [self.view addSubview:vOpen];
    //        scvTables.userInteractionEnabled=NO;
    [UIView animateWithDuration:0.5f animations:^(void) {
        vOpen.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark - 要结账单
-(void)shouldCheckViewClick:(NSDictionary *)checkDic
{
    //    TABLENUM,a.ORDERID,b.TBLNAME,a.PEOLENUMMAN,a.PEOLENUMWOMEN
    [Singleton sharedSingleton].man=[checkDic objectForKey:@"PEOLENUMMAN"];
    [Singleton sharedSingleton].woman=[checkDic objectForKey:@"PEOLENUMWOMEN"];
    [Singleton sharedSingleton].CheckNum=[checkDic objectForKey:@"ORDERID"];
    [Singleton sharedSingleton].Seat=[checkDic objectForKey:@"TABLENUM"];
    [Singleton sharedSingleton].tableName=[checkDic objectForKey:@"TBLNAME"];
    bs_dispatch_sync_on_main_thread(^{
        AKQueryViewController *query=[[AKQueryViewController alloc] init];
        [self.navigationController pushViewController:query animated:YES];
    });
}

/**
 *  按钮事件
 *
 *  @param btn
 */
-(void)btnClick:(UIButton *)btn
{
    BSDataProvider *db=[BSDataProvider sharedInstance];
    /**
     *  注销
     */
    if (btn.tag==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Logout?"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        alert.tag=2;
        [alert show];
    }
    else if (btn.tag==2){
        /**
         *  等位预定
         */
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WaitTyp"] boolValue]==YES) {
            
            AKWaitSeatViewController *waitSeat=[[AKWaitSeatViewController alloc] init];
            [self.navigationController pushViewController:waitSeat animated:YES];

        }else
        {
            AKLocalWaitSeat *local=[[AKLocalWaitSeat alloc] init];
            [self.navigationController pushViewController:local animated:YES];
        }
    }else if(btn.tag==3)
    {
        NSDictionary *dic=[db selectRolemodule:@"9904004"];
        if (![[dic objectForKey:@"ROLE"] boolValue]) {
            [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Have no legal power"]];
            return;
        }
        /**
         *  并台
         */
        if (!vSwitch) {
            [self dismissViews];
            vSwitch=[[AKSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 660, 790) withTag:2];
            vSwitch.center = CGPointMake(768/2, (1004-27)/2);
            vSwitch.currentArray=_occupationTableArray;
            vSwitch.aimsArray=_occupationTableArray;
            vSwitch.delegate=self;
            [self.view addSubview:vSwitch];
        }else
        {
            [vSwitch removeFromSuperview];
            vSwitch = nil;
        }
    }else if (btn.tag==4)
    {
        //权限判断
        NSDictionary *dic=[db selectRolemodule:@"9904003"];
        if (![[dic objectForKey:@"ROLE"] boolValue]) {
            [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Have no legal power"]];
            return;
        }
        /**
         *  换台
         */
        if (!vSwitch) {
            [self dismissViews];
            vSwitch=[[AKSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 660, 790) withTag:1];
            vSwitch.center = CGPointMake(768/2, (1004-27)/2);
            vSwitch.currentArray=_occupationTableArray;
            vSwitch.aimsArray=_freeTableArray;
            vSwitch.delegate=self;
            [self.view addSubview:vSwitch];
        }else
        {
            [vSwitch removeFromSuperview];
            vSwitch = nil;
        }
    }else if (btn.tag==5){
        /**
         *  查询台位信息
         */
        bs_dispatch_sync_on_main_thread(^{
            AKSelectCheck *select=[[AKSelectCheck alloc] init];
            [self.navigationController pushViewController:select animated:YES];
        });
    }else if (btn.tag==6)
    {
        if (vOpen){
            [vOpen removeFromSuperview];
            vOpen = nil;
        }
        vOpen = [[BSOpenTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withtag:@"1" withTableShow:YES];
        vOpen.delegate = self;
        vOpen.tableDic=nil;
//        vOpen.tableDic=dataInfo;
        vOpen.center = CGPointMake(384, 512);
        vOpen.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        [vOpen addGestureRecognizer:_pan];
        [self.view addSubview:vOpen];
        //        scvTables.userInteractionEnabled=NO;
        [UIView animateWithDuration:0.5f animations:^(void) {
            vOpen.transform = CGAffineTransformIdentity;
        }];

    }
//    else if (btn.tag==6)
//    {
//        AKForecastSalesViewController *ForecastSales=[[AKForecastSalesViewController alloc] init];
//        [self.navigationController pushViewController:ForecastSales animated:YES];
//    }
    else
    {
        [self updataTable];
    }
}

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

/**
 *  台位搜索框
 */
- (void)searchBarInit {
    UISearchBar *searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 45, 768, 50)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.backgroundColor=[UIColor clearColor];
    searchBar.translucent=YES;
    searchBar.placeholder=@"搜索";
    searchBar.delegate = self;
    searchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:searchBar];
}
#pragma mark - 搜索框事件
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSDictionary *info=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"area",@"",@"floor",@"",@"state",_searchBar.text,@"tableNum", nil];
    _tabledict=info;
    [self updataTable];
    
    //    area=%@&floor=%@&state=
}

#pragma mark - 刷新台位
-(void)updataTable
{
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getTableList:) toTarget:self withObject:_tabledict];
}
-(void)logout
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BSDataProvider *dp=[BSDataProvider sharedInstance];
        NSArray *array=[dp logout];
        [Singleton sharedSingleton].userInfo=nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [Singleton sharedSingleton].userInfo=nil;
            NSArray *array=[self.navigationController viewControllers];
            if ([array count]>0) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        });
    });
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==2) {
        if (buttonIndex==1) {
            [self logout];
        }
    }
    else if (alertView.tag==4) {
        if (buttonIndex==1) {
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            [Singleton sharedSingleton].Seat=tf1.text;
            AKSelectCheck *select=[[AKSelectCheck alloc] init];
            [self.navigationController pushViewController:select animated:YES];
        }
    }
    else if(alertView.tag==3){
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (alertView.tag==1003){
        [self updataTable];
//        [self getTableList:_tabledict];
    }
    else if(alertView.tag==1005){
        [Singleton sharedSingleton].isYudian=YES;
        [self AKOrder];
    }
    else if(kdish==alertView.tag){
        if (2==buttonIndex) {
            /**
             *  清台
             */
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(changTableState) toTarget:self withObject:nil];
        }
        else if (1==buttonIndex){
            /**
             *  查询账单号
             */
            bs_dispatch_sync_on_main_thread(^{
                [self AKOrder];

            });
            
        }
    }
    else if(alertView.tag==kCancelTag){
        if (1==buttonIndex) {
            /**
             *  清台
             */
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
//            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self
//                                                          selector:@selector(changTableState)
//                                                            object:nil];
//            [myThread1 start];
            [NSThread detachNewThreadSelector:@selector(changTableState) toTarget:self withObject:nil];
        }
    }
    
}
#pragma mark - 换台代理事件
- (void)switchTableWithOptions:(NSDictionary *)info{
    //    scvTables.userInteractionEnabled=YES;
    
    if (info){
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        //        [SVProgressHUD showProgress:-1 status:@"换台中..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
            BSDataProvider *dp = [BSDataProvider sharedInstance];
            NSDictionary *dict= [dp pChangeTable:info];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
                [self updataTable];
//                [self getTableList:_tabledict];
                
            });
        });
    }
    
    [self dismissViews];
}
//并台代理事件
-(void)multipleTableWithOptions:(NSDictionary *)info{
    if (info){
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(multiple:) toTarget:self withObject:info];
    }
    [self dismissViews];
}

/**
 *  并台请求
 *
 *  @param info 并台信息
 */
-(void)multiple:(NSDictionary *)info
{
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp combineTable:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        segment.selectedSegmentIndex=[Singleton sharedSingleton].segment;
        [self segmentClick:segment];
    }
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    });
    
    
}
#pragma mark - 查询台位
- (void)getTableList:(NSDictionary *)info{
    _tabledict=[[NSMutableDictionary alloc] initWithDictionary:info];
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp pListTable:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==NO) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        [alert show];
        return;
    }else
    {
        _tableArray= [[dict objectForKey:@"Message"] objectForKey:@"tableList"];
        _freeTableArray=[[dict objectForKey:@"Message"] objectForKey:@"freeTableList"];
        _occupationTableArray=[[dict objectForKey:@"Message"] objectForKey:@"occupationTableList"];
    }
//    bs_dispatch_sync_on_main_thread(^{
        [_tableCV reloadData];
//    });
    
}
- (void)segmentClick:(UISegmentedControl*)sender
{
    //    for (UIView *v in scvTables.subviews){
    //        if ([v isKindOfClass:[BSTableButton class]])
    //            [v removeFromSuperview];
    //    }
    
    //    NSString *DESStr = [DESArray objectAtIndex:segment.selectedSegmentIndex];
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if (segment.selectedSegmentIndex==0) {
        [_tabledict removeAllObjects];
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Area"]]) {
            BSDataProvider *dp=[BSDataProvider sharedInstance];
            NSArray *array=[dp getArea];
            
            [_tabledict setValue:[[array objectAtIndex:segment.selectedSegmentIndex-1] objectForKey:@"AREARID"] forKey:@"area"];
        }else
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Floor"]]){
                //                [_tabledict setObject:DESStr forKey:@"Floor"];
            }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Status"]]){
                //NSArray *array=[[NSArray alloc] initWithObjects:@"空闲",@"开台",@"点菜",@"结账",@"封台",@"换台",@"子台位",@"挂单",@"菜齐", nil];
                for(int i=0;i<9;i++)
                {
                    if (i<5) {
                        if (i==segment.selectedSegmentIndex) {
                            [_tabledict setObject:[NSString stringWithFormat:@"%d",i] forKey:@"state"];
                        }
                    }
                    else
                    {
                        if (i==segment.selectedSegmentIndex) {
                            [_tabledict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"state"];
                        }
                    }
                    
                }
            }
    }
    [Singleton sharedSingleton].segment=segment.selectedSegmentIndex;
    [self getTableList:_tabledict];
}

#pragma mark - 开台
-(void)openTableView:(NSDictionary *)info
{
    NSDictionary *dic=[[BSDataProvider sharedInstance] selectRolemodule:@"9904001"];
    if (![[dic objectForKey:@"ROLE"] boolValue]) {
        [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Have no legal power"]];
        return;
    }
    if (vOpen){
        [vOpen removeFromSuperview];
        vOpen = nil;
    }
    vOpen = [[BSOpenTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withtag:@"1"];
    vOpen.delegate = self;
    vOpen.tableDic=info;
    vOpen.center = CGPointMake(384, 512);
    vOpen.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    [vOpen addGestureRecognizer:_pan];
    [self.view addSubview:vOpen];
    //    scvTables.userInteractionEnabled=NO;
    [UIView animateWithDuration:0.5f animations:^(void) {
        vOpen.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - 根据台位号查询账单号
-(void)getOrdersBytale:(NSDictionary *)info
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp getOrdersBytabNum1:[_tabledict objectForKey:@"name"]];
    [SVProgressHUD dismiss];
    [Singleton sharedSingleton].tableName=[_tabledict objectForKey:@"num"];
    if ([[dict objectForKey:@"Result"] intValue]==0) {
        NSArray *array=[dict objectForKey:@"message"];
        [Singleton sharedSingleton].Seat=[_tabledict objectForKey:@"name"];
        if ([array count]==1) {
            
            [AKsNetAccessClass sharedNetAccess].TableNum=[_tabledict objectForKey:@"name"];
            [Singleton sharedSingleton].Seat=[_tabledict objectForKey:@"name"];
            [Singleton sharedSingleton].CheckNum=[[array lastObject] objectForKey:@"CheckNum"];
            [Singleton sharedSingleton].tableName=[_tabledict objectForKey:@"num"];
            [Singleton sharedSingleton].man=[[array lastObject] objectForKey:@"man"];
            [Singleton sharedSingleton].woman=[[array lastObject] objectForKey:@"woman"];
            //开台状态
            bs_dispatch_sync_on_main_thread(^{
                if ([[info objectForKey:@"status"] intValue]==2) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Please select operation"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"Order"],[[CVLocalizationSetting sharedInstance] localizedString:@"Clear the table"], nil];
                    alert.tag=kdish;
                    [alert show];
                }
                else
                {
                    
                    [self quertView];
                    
                }
            });
        }
        else
        {
            web=[[WebChildrenTable alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withArray:array];
            web.center = CGPointMake(384, 512);
            web.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            web.delegete=self;
            [self.view addSubview:web];
            //            scvTables.userInteractionEnabled=NO;
            [UIView animateWithDuration:0.5f animations:^(void) {
                web.transform = CGAffineTransformIdentity;
            }];
            return;
        }
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
    }
}
- (void)dismissViews{
    if (vOpen && vOpen.superview){
        [vOpen removeFromSuperview];
        vOpen = nil;
    }
    if (vSwitch && vSwitch.superview){
        [vSwitch removeFromSuperview];
        vSwitch = nil;
    }
}
#pragma mark - 开台事件
- (void)openTableWithOptions:(NSDictionary *)info{
    if (info){
        
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(openTable:) toTarget:self withObject:info];
    }
    [self dismissViews];
}
#pragma mark - 开台请求
/**
 *  开台请求
 *
 *  @param info 开台信息
 */
- (void)openTable:(NSDictionary *)info{
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    NSDictionary *dict =nil;
    if ([info objectForKey:@"auth_code"])
        NSLog(@"fd");
    else
        dict=[dp pStart:info];
    [SVProgressHUD dismiss];
    if([[dict objectForKey:@"Result"] boolValue]==YES)
    {
        [Singleton sharedSingleton].tableName=[info objectForKey:@"num"];
        [Singleton sharedSingleton].Seat=[info objectForKey:@"name"];
        [Singleton sharedSingleton].CheckNum=[dict objectForKey:@"Message"];
        [self AKOrder];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
        
    }
}
-(void)scanClick:(BSOPENHandler)open
{
    static QRCodeReaderViewController *reader = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        reader= [QRCodeReaderViewController new];
        reader.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    reader.delegate = self;
    
    [reader setCompletionWithBlock:^(NSString *resultAsString) {
        open(resultAsString);
        [self dismissViewControllerAnimated:YES completion:NULL];
        NSLog(@"Completion with result: %@", resultAsString);
    }];
    [self presentViewController:reader animated:YES completion:NULL];

}
#pragma mark - QRCodeReader Delegate Methods
//
//- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
//}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - 搭台
-(void)ChiledrenTableButton:(NSDictionary *)info
{
    //    scvTables.userInteractionEnabled=YES;
    if (info) {
        if ([[info objectForKey:@"state"] intValue]==1) {
            
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"TheTableIsUsing"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
            [web removeFromSuperview];
            web=nil;
            return;
        }
        if ([[info objectForKey:@"ISFENGTAI"] intValue] ==1) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Locked"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
            [web removeFromSuperview];
            web=nil;
            return;
        }
        [AKsNetAccessClass sharedNetAccess].TableNum=[info objectForKey:@"tableName"];
        //        [Singleton sharedSingleton].Seat=[info objectForKey:@"tableName"];
        [Singleton sharedSingleton].tableName=[NSString stringWithFormat:@"%@(%@)",[Singleton sharedSingleton].tableName,[info objectForKey:@"tableName"]];
        [Singleton sharedSingleton].CheckNum=[info objectForKey:@"CheckNum"];
        [Singleton sharedSingleton].man=[info objectForKey:@"man"];
        [Singleton sharedSingleton].woman=[info objectForKey:@"woman"];
        [self quertView];
        [web removeFromSuperview];
        web=nil;
    }else
    {
        [web removeFromSuperview];
        web=nil;
    }
    
}

#pragma mark - 清台
-(void)changTableState
{
    [SVProgressHUD dismiss];
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [Singleton sharedSingleton].Seat=[_tabledict objectForKey:@"name"];
    [dict setObject:[_tabledict objectForKey:@"name"] forKey:@"tableNum"];
    [dict setObject:@"6" forKey:@"currentState"];
    [dict setObject:@"1" forKey:@"nextState"];
    /**
     *  调用改变台位状态接口
     */
    NSDictionary *dict1=[dp changTableState:dict];
    if (dict1){
        NSString *result = [[[dict1 objectForKey:@"ns:changTableStateResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        NSLog(@"%@",ary);
        if ([[ary objectAtIndex:0] intValue]==0) {
            /**
             *  刷新台位
             *
             *  @param getTableList: 调用查询台位接口
             *
             *  @return
             */
            [dp delectCache];
            NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                         selector:@selector(getTableList:)
                                                           object:_tabledict];
            [myThread start];
            [AKsNetAccessClass sharedNetAccess].VipCardNum=@"";
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[ary lastObject] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
        }
    }
    
}
#pragma mark - 点菜
-(void)AKOrder
{
//    AKFoodOrderViewController *food=[[AKFoodOrderViewController alloc] init];
//    [self.navigationController pushViewController:food animated:YES];
    UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
    
    UIViewController * centerViewController = [[AKFoodOrderViewController alloc] init];
    MMDrawerController *drawerController=[[MMDrawerController alloc] initWithCenterViewController:centerViewController rightDrawerViewController:leftSideDrawerViewController];
    [drawerController setMaximumRightDrawerWidth:280.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    [self.navigationController pushViewController:drawerController animated:YES];
}

#pragma mark - 跳转全单
-(void)quertView
{
    BSQueryViewController *bsq=[[BSQueryViewController alloc] init];
    [self.navigationController pushViewController:bsq animated:YES];
}
#pragma mark - 扫描下单
//-(void)AKScanTableViewClick:(NSString *)string
//{
//    BSDataProvider *bs=[[BSDataProvider alloc] init];
//    NSDictionary *dict=[bs scandToOrder:string];
//    NSArray *array=[dict objectForKey:@"data"];
//    if ([array count]>0) {
//        NSDictionary *dic=[array lastObject];
//        //        a.usestate,b.orderid,b.PEOLENUM,b.PEOLENUMMAN,b.PEOLENUMWOMEN
//        [Singleton sharedSingleton].tableName=[dic objectForKey:@"TBLNAME"];
//        [Singleton sharedSingleton].Seat=string;
//        
//        [Singleton sharedSingleton].CheckNum=[dic objectForKey:@"orderid"];
//        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"])
//        {
//            [Singleton sharedSingleton].man=[dic objectForKey:@"PEOLENUMMAN"];
//            [Singleton sharedSingleton].woman=[dic objectForKey:@"PEOLENUMWOMEN"];
//        }else
//        {
//            [Singleton sharedSingleton].man=[dic objectForKey:@"PEOLENUM"];
//        }
//        if ([[dic objectForKey:@"usestate"] intValue]==1) {
//            NSMutableDictionary *dic1=[NSMutableDictionary dictionaryWithObjectsAndKeys:[dic objectForKey:@"TBLNAME"],@"num",string,@"name", nil];
//            [self openTableView:dic1];
//        }else if ([[dic objectForKey:@"usestate"] intValue]==2){
//            
//            [self AKOrder];
//        }else if ([[dic objectForKey:@"usestate"] intValue]==4){
//            [SVProgressHUD showErrorWithStatus:@"该台位已结账"];
//        }else if ([[dic objectForKey:@"usestate"] intValue]==6){
//            [SVProgressHUD showErrorWithStatus:@"该台位已封单"];
//        }else
//        {
//            [self quertView];
//        }
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"台位号不存在"];
//    }
//}
@end
