//
//  ZCDeskMainViewController.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-5-22.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "WebDeskMainViewController.h"
#import "BSDataProvider.h"
#import "WebTableButton.h"
#import "Singleton.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "WebOrderRepastViewController.h"
#import "AKOrderLeft.h"
#import "WebChildrenTable.h"
#import "WebQueryViewController.h"
#import "ZCSelectCheckViewController.h"

@interface WebDeskMainViewController ()

@end

@implementation WebDeskMainViewController
{
    NSMutableArray *_DESArray;
    UIScrollView *_scvTables;
    NSMutableDictionary *_tabledict;
    NSArray *_tableArray;
    int dSelectedIndex;
    BSOpenTableView *_open;
    WebChildrenTable *web;
    BSSwitchTableView *_switch;
    NSMutableDictionary *stateInfo;
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
     [SVProgressHUD showProgress:-1 status:@"台位查询中..." maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getTableList:) toTarget:self withObject:_tabledict];
//    [self getTableList:_tabledict];
    [Singleton sharedSingleton].dishArray=nil;
    [Singleton sharedSingleton].CheckNum=nil;
    [Singleton sharedSingleton].Seat=nil;
    [Singleton sharedSingleton].man=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    //查询状态
    NSArray *arr=[dp WebgetState];
    stateInfo=[NSMutableDictionary dictionary];
    for (NSDictionary *dict in arr) {
        [stateInfo setValue:[dict objectForKey:@"vuseColor"] forKey:[dict objectForKey:@"vcode"]];
    }
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    _DESArray=[NSMutableArray array];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Area"]]) {
        NSArray *array=[dp WebgetArea];
        for (NSDictionary *dict in array) {
            NSString *str=[dict objectForKey:@"TBLNAME"];
            [array1 addObject:str];
            
        }
        [_DESArray addObjectsFromArray:array];
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Floor"]]){
        //        deskClassArray = [[NSMutableArray alloc]initWithArray:[dp getFloor]];
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Status"]]){
        for (NSDictionary *dict in arr) {
            NSString *str=[dict objectForKey:@"vname"];
            [array1 addObject:str];
        }
        [_DESArray addObjectsFromArray:arr];
    }
    [array1 insertObject:[[CVLocalizationSetting sharedInstance] localizedString:@"All"] atIndex:0];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array1];
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"ArialRoundedMTBold"size:20],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    segment.frame = CGRectMake(0, 0, 768, 40);
    _tabledict=[NSMutableDictionary dictionary];
    [segment setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"title.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    segment.selectedSegmentIndex = 0;
    _scvTables = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 100, 718, 850)];
    [self.view addSubview:_scvTables];
    CVLocalizationSetting *cvlocal=[CVLocalizationSetting sharedInstance];
    //    NSArray *array2=[[NSArray alloc] initWithObjects:[cvlocal localizedString:@"Logout"],[cvlocal localizedString:@"Wait"],[cvlocal localizedString:@"Combine Table"],[cvlocal localizedString:@"Change Table"],[cvlocal localizedString:@"Select VIP"],[cvlocal localizedString:@"Select Order"],[cvlocal localizedString:@"Update"], nil];
    NSArray *array2=[[NSArray alloc] initWithObjects:[cvlocal localizedString:@"Logout"],[cvlocal localizedString:@"Change Table"],@"联台",[cvlocal localizedString:@"Updata"], nil];
    for (int i=0; i<[array2 count]; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(150+(500)/[array2 count]*i, 1024-70, 140, 50);
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
        //        [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
        //        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.tintColor=[UIColor whiteColor];
        btn.tag=i+1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    [self searchBarInit];
}
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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_tabledict setObject:searchBar.text forKey:@"condition"];
    [SVProgressHUD showProgress:-1 status:@"台位查询中..." maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(updataTable) toTarget:self withObject:nil];
//    [self updataTable];
    
    
}
#pragma mark - button事件
/**
 *  下面的按钮事件
 *
 *  @param btn
 */
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
        //        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Logout?"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        //        alert.tag=2;
        //        [alert show];
    }else if (btn.tag==2)
    {
        _scvTables.userInteractionEnabled=NO;
        if (!_switch){
            [self dismissViews];
            _switch = [[BSSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:1];
            _switch.delegate = self;
            //        vSwitch.center = btnSwitch.center;
            _switch.center = CGPointMake(384, 1004-27);
            [self.view addSubview:_switch];
            [_switch firstAnimation];
        }
        else{
            [_switch removeFromSuperview];
            _switch = nil;
        }
    }else if (btn.tag==3){
        _scvTables.userInteractionEnabled=NO;
        if (!_switch){
            [self dismissViews];
            _switch = [[BSSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:3];
            _switch.delegate = self;
            _switch.center = CGPointMake(384, 1004-27);
            [self.view addSubview:_switch];
            [_switch firstAnimation];
        }
        else{
            [_switch removeFromSuperview];
            _switch = nil;
        }
//    }else if (btn.tag==4){
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改人数" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"],nil];
//        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//        UITextField *tf1=[alertView textFieldAtIndex:0];
//        tf1.placeholder=@"台位号";
//        UITextField *tf2=[alertView textFieldAtIndex:1];
//        tf2.placeholder=@"修改人数";
//        tf2.secureTextEntry=NO;
//        tf2.delegate=self;
//        alertView.tag = 5;
//        [alertView show];
    }else
    {
        //        if (_waitView)
        //            [_waitView addshowTableView];
        //        else
        [self updataTable];
    }
    
}
#pragma mark - SwitchTableViewDelegate
/**
 *  连台
 *
 *  @param info
 */
-(void)multipleTableWithOptions:(NSDictionary *)info{
    _scvTables.userInteractionEnabled=YES;
    if (info){
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(multiple:) toTarget:self withObject:info];
    }
    [self dismissViews];
    [SVProgressHUD dismiss];
}
/**
 *  联台请求
 *
 *  @param info
 */
-(void)multiple:(NSDictionary *)info
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] WebjoinOpenSitedefinehand:info];
    if (dict) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"message"] message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
    }
    
}
#pragma mark - switchTableDelegate
/**
 *  换台的代理事件
 *
 *  @param info
 */
- (void)switchTableWithOptions:(NSDictionary *)info{
    if (info){
        [NSThread detachNewThreadSelector:@selector(switchTable:) toTarget:self withObject:info];
    }
    
    [self dismissViews];
}
/**
 *  换台请求
 *
 *  @param info
 */
- (void)switchTable:(NSDictionary *)info{
    
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    /**
     *  调用换台接口
     */
    NSDictionary *dict = [[BSDataProvider sharedInstance] WebChangeTable:info];
    _scvTables.userInteractionEnabled=YES;
    NSString *msg,*title;
    if ([[dict objectForKey:@"success"] boolValue]) {
        title = [langSetting localizedString:@"Change Table Succeed"];
        msg = [dict objectForKey:@"message"];
        [self getTableList:_tabledict];
    }
    else{
        title = [langSetting localizedString:@"Change Table Failed"];
        msg = [dict objectForKey:@"message"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
    [alert show];
}
#pragma mark - 刷新台位
/**
 *  刷新台位
 */
-(void)updataTable
{
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getTableList:) toTarget:self withObject:_tabledict];
}
#pragma mark - segmentClick
/**
 *  segmentClick点击事件
 *
 *  @param sender
 */
- (void)segmentClick:(UISegmentedControl*)sender
{
    //    for (UIView *v in _scvTables.subviews){
    //        if ([v isKindOfClass:[ZCTableButton class]])
    //            [v removeFromSuperview];
    //    }
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    if (sender.selectedSegmentIndex==0) {
        [_tabledict removeAllObjects];
    }else
    {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Area"]]) {
            [_tabledict setValue:[[_DESArray objectAtIndex:sender.selectedSegmentIndex-1] objectForKey:@"AREARID"] forKey:@"area"];
        }else
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Floor"]]){
                [_tabledict setValue:[NSString stringWithFormat:@"%d",sender.selectedSegmentIndex]
                              forKey:@"Floor"];
            }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Status"]]){
                [_tabledict setValue:[[_DESArray objectAtIndex:sender.selectedSegmentIndex-1] objectForKey:@"vcode"] forKey:@"state"];
            }
    }
    [self getTableList:_tabledict];
}
#pragma mark - 台位请求
/**
 *  台位请求
 *
 *  @param info
 */
- (void)getTableList:(NSDictionary *)info{
    NSDictionary *dict = [[BSDataProvider sharedInstance] WebpListTable];
    if (dict){
        _tableArray = [dict objectForKey:@"root"];
        [self performSelectorOnMainThread:@selector(showTables:) withObject:_tableArray waitUntilDone:YES];
    }
    else{
        [SVProgressHUD dismiss];
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询台位失败" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        });
    }
    
}
#pragma mark - 生成台位按钮
/**
 *  显示按钮
 *
 *  @param ary
 */
- (void)showTables:(NSArray *)ary{
    /**
     *  移除按钮
     */
    for (UIView *v in _scvTables.subviews){
        if ([v isKindOfClass:[WebTableButton class]])
            [v removeFromSuperview];
    }
    NSMutableArray *array=[NSMutableArray array];
    /**
     *  台位过滤
     */
    for (NSDictionary *dict in ary) {
        if ([[_tabledict objectForKey:@"area"] isEqualToString:[dict objectForKey:@"pk_storearearid"]]) {
            [array addObject:dict];
        }else if ([[_tabledict objectForKey:@"state"] isEqualToString:[dict objectForKey:@"iusestatus"]]) {
            [array addObject:dict];
        }else if ([_tabledict objectForKey:@"condition"]&&![[_tabledict objectForKey:@"condition"]isEqualToString:@""]) {
            NSString *strINIT = [[dict objectForKey:@"vinit"] uppercaseString];
            NSString *strITCODE=[dict objectForKey:@"vcode"];
            [_tabledict setObject:[[_tabledict objectForKey:@"condition"] uppercaseString] forKey:@"condition"];
            NSString *strDES = [[dict objectForKey:@"vname"] uppercaseString];
            if ([strINIT rangeOfString:[_tabledict objectForKey:@"condition"]].location!=NSNotFound ||
                [strDES rangeOfString:[_tabledict objectForKey:@"condition"]].location!=NSNotFound||[strITCODE rangeOfString:[_tabledict objectForKey:@"condition"]].location!=NSNotFound){
                [array addObject:dict];
            }
        }
    }
    if ([array count]==0) {
        [array addObjectsFromArray:ary];
    }
    
    for (int i=0;i<[array count];i++){
        int row = i/5;
        int column = i%5;
        NSDictionary *dic = [array objectAtIndex:i];
        WebTableButton *btnTable = [WebTableButton buttonWithType:UIButtonTypeCustom];
        btnTable.tag = i;
        btnTable.frame = CGRectMake(15+141*column, 5+83*row, 126, 71);
        [btnTable addTarget:self action:@selector(tableClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnTable.tableTitle = [dic objectForKey:@"vname"];
        btnTable.manTitle.text=[dic objectForKey:@"man"];
        btnTable.tableInfo=dic;
        btnTable.backgroundColor=[self hexStringToColor:[stateInfo objectForKey:[dic objectForKey:@"iusestatus"]]];
        [_scvTables addSubview:btnTable];
        [_scvTables setContentSize:CGSizeMake(141*column+15*(column-1), 83*row+70)];
    }
    [SVProgressHUD dismiss];
}
#pragma mark - UIColor转换
//16进制颜色(html颜色值)字符串转为UIColor
-(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
#pragma mark - 台位按钮事件
/**
 *  台位按钮事件
 *
 *  @param btn
 */
- (void)tableClicked:(WebTableButton *)btn{
    //    [self dismissViews];
    dSelectedIndex = btn.tag;
    NSDictionary *info = btn.tableInfo;
    int tableTyp=[[info objectForKey:@"iusestatus"] intValue];
    NSArray *array=[info objectForKey:@"subfoliolist"];
    /**
     *  判断是否有子台位
     */
    if ([array count]==1) {
        [Singleton sharedSingleton].vbcode=[[array lastObject] objectForKey:@"vbcode"];
        [Singleton sharedSingleton].CheckNum=[[array lastObject] objectForKey:@"vorderid"];
        [Singleton sharedSingleton].Seat=[[array lastObject] objectForKey:@"vtablenum"];
        [Singleton sharedSingleton].woman=[[array lastObject] objectForKey:@"ipeolenumwoment"];
        [Singleton sharedSingleton].man=[[array lastObject] objectForKey:@"ipeolenumman"];
    }else if ([array count]>1)
    {
        web=[[WebChildrenTable alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withArray:array];
        web.center = CGPointMake(384, 512);
        web.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        web.delegete=self;
        [self.view addSubview:web];
        _scvTables.userInteractionEnabled=NO;
        [UIView animateWithDuration:0.5f animations:^(void) {
            web.transform = CGAffineTransformIdentity;
        }];
        return;
    }
    switch (tableTyp) {
        case 1:// 空闲
        {
            if (_open){
                [_open removeFromSuperview];
                _open = nil;
            }
            _open = [[BSOpenTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
            _open.delegate = self;
            [btn.tableInfo setValue:@"0" forKey:@"iopenstate"];
            _open.tableDic=btn.tableInfo;
            _open.center = CGPointMake(384, 512);
            _open.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            [self.view addSubview:_open];
            _scvTables.userInteractionEnabled=NO;
            [UIView animateWithDuration:0.5f animations:^(void) {
                _open.transform = CGAffineTransformIdentity;
            }];
        }
            break;
        case 2://开台
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点餐",@"清台", nil];
            alert.tag = kCancelTag;
            [alert show];
            break;
            
        }
            break;
            
        case 3://点菜
        case 10://菜齐
        {
            WebQueryViewController *webquery=[[WebQueryViewController alloc] init];
            [self.navigationController pushViewController:webquery animated:YES];
        }
            break;
        case 7://换台
        case 4://结账
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"This table is already the checkout, to clear the table?"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
            alert.tag = 33;
            [alert show];
        }
            break;
        case 6://封单
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The table has a account, please go to the cashier's desk"] message:nil
                                                           delegate:self cancelButtonTitle:nil otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
            [alert show];
        }
            //            break;
            //        case 8:
            //        {
            //
            //        }
            //            break;
            //        case 9:
            //        {
            //
            //        }
            break;
        default:
            break;
    }
}
#pragma mark - ChiledrenTableDelegate
/**
 *  子台位代理事件
 *
 *  @param info 台位信息
 */
-(void)ChiledrenTableButton:(NSDictionary *)info
{
    [web removeFromSuperview];
    web=nil;
    if (info) {
        _scvTables.userInteractionEnabled=YES;
        [Singleton sharedSingleton].vbcode=[info objectForKey:@"vbcode"];
        [Singleton sharedSingleton].CheckNum=[info objectForKey:@"vorderid"];
        [Singleton sharedSingleton].Seat=[info objectForKey:@"vtablenum"];
        [Singleton sharedSingleton].woman=[info objectForKey:@"ipeolenumwoment"];
        [Singleton sharedSingleton].man=[info objectForKey:@"ipeolenumman"];
        WebQueryViewController *webq=[[WebQueryViewController alloc] init];
        [self.navigationController pushViewController:webq animated:YES];
    }
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    /**
     *  判断是否清台
     */
    if(alertView.tag == kCancelTag){
        if (buttonIndex == 2) {
            /**
             *  调用取消账单接口
             */
            NSDictionary *dict = [[BSDataProvider sharedInstance] WebcancelDelFolioFromVbcode];
            
            BOOL bSucceed = [[dict objectForKey:@"success"] boolValue];
            
            NSString *title,*msg;
            CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
            if (bSucceed) {
                title = [langSetting localizedString:@"Cancel Table Succeed"];
                msg = [dict objectForKey:@"message"];
                
                [self getTableList:_tabledict];
            }
            else{
                title = [langSetting localizedString:@"Cancel Table Failed"];
                msg = [dict objectForKey:@"message"];
                
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        }else if (buttonIndex == 1){
            /**
             *  点菜
             */
            [self AKOrder];
        }
        
    }else if (alertView.tag == 1002){
        /**
         *  刷新台位信息
         */
        [self updataTable];
    }else if (alertView.tag==4){
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [Singleton sharedSingleton].Seat=[tf1.text uppercaseString];
        ZCSelectCheckViewController *zc=[[ZCSelectCheckViewController alloc] init];
        [self.navigationController pushViewController:zc animated:YES];
    }else if (alertView.tag==5){
//        if (buttonIndex==1) {
//            NSString *str=[self getFolioNo:[[alertView textFieldAtIndex:0].text uppercaseString]];
//            if ([str intValue]>0) {
//                [self modifyPax:[alertView textFieldAtIndex:1].text];
//            }
//        }
    }else if (alertView.tag==33){
        if (buttonIndex==1) {
            /**
             *  调用清台接口
             */
            NSDictionary *info=[_tableArray objectAtIndex:dSelectedIndex];
            NSDictionary *dict = [[BSDataProvider sharedInstance] WebclearSitedefine:info];
            
            BOOL bSucceed = [[dict objectForKey:@"success"] boolValue];
            
            NSString *title,*msg;
            CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
            if (bSucceed) {
                title = [langSetting localizedString:@"Cancel Table Succeed"];
                msg = [dict objectForKey:@"message"];
                
                [self getTableList:_tabledict];
            }
            else{
                title = [langSetting localizedString:@"Cancel Table Failed"];
                msg = [dict objectForKey:@"message"];
                
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        }
    }
}

/**
 *  跳转点菜界面
 */

-(void)AKOrder
{
    UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
    UIViewController * centerViewController = [[WebOrderRepastViewController alloc] init];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - openTableDelegate
//开台的代理事件
- (void)openTableWithOptions:(NSDictionary *)info{
    
    _scvTables.userInteractionEnabled=YES;
    if (info){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
        [Singleton sharedSingleton].man=[info objectForKey:@"man"];
        [Singleton sharedSingleton].woman=[info objectForKey:@"woman"];
        
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(openTable:) toTarget:self withObject:dic];
    }
    [self dismissViews];
}
/**
 *  开台请求
 *
 *  @param info
 */
- (void)openTable:(NSDictionary *)info{
    
    NSDictionary *dict = [[BSDataProvider sharedInstance] WebOpenTable:info];
    [SVProgressHUD dismiss];
    BOOL bSucceed = [[dict objectForKey:@"success"] boolValue];
    NSString *title;
    if (bSucceed) {
        NSDictionary *dic=[[BSDataProvider sharedInstance] WebgetFolioNo:info];
        
        if (dic&&![[dic objectForKey:@"root"] isEqual:@"null"]) {
//            if ([[dic objectForKey:@"root"] isEqualToString:@"null"]) {
//                title = [dict objectForKey:@"查询失败"];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alert show];
//                return;
//            }
//            NSLog(@"%@",[dic objectForKey:@"root"]);
                [Singleton sharedSingleton].Seat=[[[dic objectForKey:@"root"] lastObject] objectForKey:@"vtablenum"];
                [Singleton sharedSingleton].CheckNum=[[[dic objectForKey:@"root"] lastObject] objectForKey:@"vorderid"];
                [Singleton sharedSingleton].vbcode=[[[dic objectForKey:@"root"] lastObject] objectForKey:@"vbcode"];
                [self AKOrder];
            
        }else
        {
            title = @"开台失败";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    else
    {
        title = [dict objectForKey:@"message"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
/**
 *  移除界面
 */
- (void)dismissViews{
    if (_open && _open.superview){
        [_open removeFromSuperview];
        _open = nil;
    }
    if (_switch && _switch.superview){
        [_switch removeFromSuperview];
        _switch = nil;
    }
}


#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if ([textField.text length]>=2) {
            return NO;
        }
        //        ^\d{m,n}$
        
        NSString *validRegEx =@"^[0-9]$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
