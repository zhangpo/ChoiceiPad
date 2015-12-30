//
//  ZCDeskMainViewController.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-5-22.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "ZCDeskMainViewController.h"
#import "BSDataProvider.h"
#import "ZCTableButton.h"
#import "Singleton.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "ZCFoodOrderViewController.h"
#import "AKOrderLeft.h"
#import "ZCQueryViewController.h"
#import "ZCSelectCheckViewController.h"
#import "AKTableCell.h"
#import "ZCEstimatesController.h"

@interface ZCDeskMainViewController ()

@end
typedef enum{
    SELECTORDER=100,
    UPDATETOMAN=101,
    NONETOCLICK=103
}Button_To_Click;
@implementation ZCDeskMainViewController
{
    NSMutableArray      *_DESArray;         //类别显示
    NSMutableDictionary *_tabledict;        //检索标示
    NSArray             *_tableArray;       //台位列表
    NSArray             *_freeArray;        //空闲台位
    NSArray             *_usingArray;       //占用台位
    BSOpenTableView     *_open;             //开台
    BSSwitchTableView   *_switch;           //换台
    NSMutableArray      *deskClassArray;    //类别
    UICollectionView    *_tableCV;
    NSDictionary        *_tableColorDic;    //台位颜色
    ZCResvView          *_resvView;         //预定
    NSArray             *_resvFoodArray;    //预定菜品
    NSArray             *_ordersArray;      //账单
    AKFoodOrderCell     *_foodCell;
    Button_To_Click     _selectTag;
    
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
    [self getTableList:_tabledict];
    [Singleton sharedSingleton].dishArray=nil;
    [Singleton sharedSingleton].CheckNum=nil;
    [Singleton sharedSingleton].Seat=nil;
    [Singleton sharedSingleton].man=nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    //查询状态
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    NSMutableArray *DESArray = [[NSMutableArray alloc]init];
    deskClassArray=[[NSMutableArray alloc] init];
    _tableColorDic=[dp ZCgetTableColor];
    //区域
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Area"]]) {
        NSArray *array=[dp ZCgetArea];
        
        for (NSDictionary *dict in array) {
            NSString *str=[dict objectForKey:@"DES"];
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
    _DESArray=DESArray;
    _tabledict=[NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:DESArray];
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"ArialRoundedMTBold"size:20],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    segment.frame = CGRectMake(0, 0, 768, 40);
    
    [segment setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"title.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    segment.selectedSegmentIndex = 0;
    NSArray *array2=[[NSArray alloc] initWithObjects:[langSetting localizedString:@"Logout"],[langSetting localizedString:@"Change Table"],[langSetting localizedString:@"Select Order"],[langSetting localizedString:@"Change Man"],@"估清",[langSetting localizedString:@"Updata"], nil];
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
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(135, 75);
    flowLayout.minimumInteritemSpacing =5;//列距
    _tableCV=[[UICollectionView alloc] initWithFrame:CGRectMake(25, 100, 718, 850) collectionViewLayout:flowLayout];
    [_tableCV registerClass:[AKTableCell class] forCellWithReuseIdentifier:@"colletionCell"];
    _tableCV.delegate=self;
    _tableCV.backgroundColor=[UIColor whiteColor];
    _tableCV.dataSource=self;
    [self.view addSubview:_tableCV];
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
#pragma mark - UICollectionView代理事件
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
    cell. backgroundColor=[[BSDataProvider sharedInstance] getColorFromString:[_tableColorDic objectForKey:[cell.dataInfo objectForKey:@"status"]]];
    cell.delegate=self;
    return cell;
}
#pragma mark - AKTableCellDelegate
-(void)AKTableCellClick:(NSDictionary *)dataInfo
{
//    NSDictionary *info = [_tableArray objectAtIndex:dSelectedIndex];
    [Singleton sharedSingleton].tableName=[dataInfo objectForKey:@"name"];
    [Singleton sharedSingleton].Seat=[dataInfo objectForKey:@"short"];
    [Singleton sharedSingleton].CheckNum=[dataInfo objectForKey:@"serial"];
    [Singleton sharedSingleton].man=[[[dataInfo objectForKey:@"man"] componentsSeparatedByString:@"/"] objectAtIndex:0];
    int status=[[dataInfo objectForKey:@"status"] intValue];
    if (_selectTag==UPDATETOMAN) {
        if (status==1||status==5||status==4) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改人数" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"],nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *tf2=[alertView textFieldAtIndex:0];
            tf2.placeholder=@"修改人数";
            tf2.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
            tf2.delegate=self;
            alertView.tag = 5;
            [alertView show];
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"选择错误"];
        }
        _selectTag=NONETOCLICK;
        return;
    }else if (_selectTag==SELECTORDER)
    {
        if (status==1||status==5) {
            ZCSelectCheckViewController *zc=[[ZCSelectCheckViewController alloc] init];
            [self.navigationController pushViewController:zc animated:YES];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"该台位没有点餐"];
        }
        _selectTag=NONETOCLICK;
        return;
    }
    UIAlertView *alert;
    switch (status) {
        case 2:
        {
            if (_open){
                [_open removeFromSuperview];
                _open = nil;
            }
            _open = [[BSOpenTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withtag:@"1"];
            _open.delegate = self;
            _open.center = CGPointMake(384, 512);
            _open.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            [self.view addSubview:_open];
            [UIView animateWithDuration:0.5f animations:^(void) {
                _open.transform = CGAffineTransformIdentity;
            }];
        }
            break;
        case 1: {
            bs_dispatch_sync_on_main_thread(^{
                ZCQueryViewController *query=[[ZCQueryViewController alloc] init];
                [self.navigationController pushViewController:query animated:YES];
            });
            
            }
            break;
        case 3:{
            
            UIAlertView *as = [[UIAlertView alloc] initWithTitle:@"此台位已封单" message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil, nil];
            [as show];
        }
            break;
            
        case 0:{
            [SVProgressHUD showProgress:-1 status:@"查询预定信息" maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(ZCpListResv) toTarget:self withObject:nil];
//            UIAlertView *as = [[UIAlertView alloc] initWithTitle:@"预定台位，暂没有此功能" message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil, nil];
//            //            [as showInView:self.view];
//            [as show];
        }
            break;
            
        case 4:
        {
            alert = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点餐",@"清台", nil];
            alert.tag = kCancelTag;
            [alert show];
        }
            break;
        case 5:{
            alert = [[UIAlertView alloc] initWithTitle:@"此台是脏台，是否清台" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.tag = 6;
            
            [alert show];
        }
            break;
            
        default:
            break;
    }
}
-(void)AKTableCellLongClick:(NSDictionary *)dataInfo{
    [Singleton sharedSingleton].tableName=[dataInfo objectForKey:@"name"];
    [Singleton sharedSingleton].Seat=[dataInfo objectForKey:@"short"];
    int status=[[dataInfo objectForKey:@"status"] intValue];
    if (status==1||status==4) {
        if (_open){
            [_open removeFromSuperview];
            _open = nil;
        }
        _open = [[BSOpenTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withtag:@"2"];
        _open.delegate = self;
        _open.center = CGPointMake(384, 512);
        _open.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        [self.view addSubview:_open];
        [UIView animateWithDuration:0.5f animations:^(void) {
            _open.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - 中餐预定
-(void)ZCpListResv
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] ZCpListResv];
    _resvFoodArray=[dict objectForKey:@"food"];
    for (NSDictionary *food in _resvFoodArray) {
        NSMutableArray *additionalAry=[[NSMutableArray alloc] init];
        for (int i=0;i<6;i++) {
            if ([[food objectForKey:[NSString stringWithFormat:@"RE%d",i]] length]>0) {
                [additionalAry addObject:[NSDictionary dictionaryWithObjectsAndKeys:[food objectForKey:[NSString stringWithFormat:@"RE%d",i]],@"DES",[food objectForKey:[NSString stringWithFormat:@"REPRICE%d",i]],@"PRICE1", nil]];
            }
        }
        [food setValue:additionalAry forKey:@"addition"];
    }
    [SVProgressHUD dismiss];
    if (dict) {
        if (!_resvView){
            [self dismissViews];
            _resvView = [[ZCResvView alloc] initWithFrame:CGRectMake(0, 0, 660, 790)];
            _resvView.center = CGPointMake(768/2, (1004-27)/2);
            _resvView.resvDic=dict;
            _resvView.delegate=self;
            [self.view addSubview:_resvView];
        }
        else{
            [_resvView removeFromSuperview];
            _resvView = nil;
        }

    }else
    {
        [SVProgressHUD showErrorWithStatus:@"查询预定错误"];
    }
    
}
#pragma mark ZCResvViewDelegate
-(void)ZCResvViewClick:(int)tag
{
    if (tag==1) {
        [SVProgressHUD showProgress:-1 status:@"转台中" maskType:SVProgressHUDMaskTypeBlack];
        if ([_resvFoodArray count]>0) {
            NSMutableDictionary * packDic=[[NSMutableDictionary alloc] init];
            [packDic setObject:@"1" forKey:@"PACKID"];
            [packDic setObject:@"1" forKey:@"total"];
            [packDic setObject:@"1" forKey:@"ISTC"];
            [packDic setObject:@"1" forKey:@"ITCODE"];
            [packDic setObject:@"临时套餐" forKey:@"DES"];
            [packDic setObject:[[_resvFoodArray lastObject] objectForKey:@"PACKAMT"] forKey:@"PRICE"];
            [packDic setObject:[NSString stringWithFormat:@"%lld",[[self foodPkId] intValue]-2147483648] forKey:@"PKID"];
            int i=1;
            for (NSDictionary *foodDic in _resvFoodArray) {
                [foodDic setValue:[foodDic objectForKey:@"CNT"] forKey:@"total"];
                [foodDic setValue:@"1" forKey:@"Tpcode"];
                //            [foodDic setValue:@"PRICE" forKey:@"priceKey"];
                [foodDic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"num"];
                i++;
            }
            [packDic setObject:_resvFoodArray forKey:@"combo"];
            NSMutableArray *array=[NSMutableArray arrayWithObjects:packDic, nil];
            [[BSDataProvider sharedInstance] cache:array];
        }
        [NSThread detachNewThreadSelector:@selector(ZCpChangeResv) toTarget:self withObject:nil];
        
    }
    _resvFoodArray=nil;
    [_resvView removeFromSuperview];
    _resvView = nil;
}
-(NSString *)foodPkId
{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*60*24*3;
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HmmssSS"];
    //用[NSDate date]可以获取系统当前时间
    NSString *yy = [dateFormatter stringFromDate:localeDate];
    NSString *pkid=[NSString stringWithFormat:@"%@%@",yy,[Singleton sharedSingleton].CheckNum];
    return pkid;
//    [_foodDic setObject:[NSString stringWithFormat:@"%lld",[pkid intValue]-2147483648] forKey:@"PKID"];
}
#pragma mark 预定转单接口
-(void)ZCpChangeResv
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] ZCpChangeResv];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        [self updataTable];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
    }
}


#pragma mark - UISearchBar代理
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:_tabledict];
    [dict setObject:searchBar.text forKey:@"condition"];
    [SVProgressHUD showProgress:-1 status:@"台位查询中..." maskType:SVProgressHUDMaskTypeBlack];
    [self queryTables:dict];
    
}
#pragma mark - 台位搜索请求
-(void)queryTables:(NSDictionary *)dict
{
    BSDataProvider *bs=[[BSDataProvider alloc] init];
    NSDictionary *info=[bs ZCqueryTables:dict];
    [SVProgressHUD dismiss];
    BOOL bSucceed = [[info objectForKey:@"Result"] boolValue];
    [SVProgressHUD dismiss];
    if (bSucceed){
        _tableArray = [info objectForKey:@"Message"];
        [_tableCV reloadData];
    }
    else{
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询台位失败" message:[info objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        });
    }

    
}
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==2)
    {
        if (!_switch){
            [self dismissViews];
            _switch = [[BSSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:1];
            _switch.delegate = self;
//            vSwitch=[[AKSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 660, 790) withTag:1];
            _switch.center = CGPointMake(768/2, (1004-27)/2);
//            _switch.currentArray=_usingArray;
//            _switch.aimsArray=_freeArray;
            //        vSwitch.center = btnSwitch.center;
//            _switch.center = CGPointMake(768/2, 1004-27);
            [self.view addSubview:_switch];
        }
        else{
            [_switch removeFromSuperview];
            _switch = nil;
        }
    }else if (btn.tag==3){
        [SVProgressHUD showSuccessWithStatus:@"请选择查询的台位"];
        _selectTag =SELECTORDER;

    }else if (btn.tag==4){
        [SVProgressHUD showSuccessWithStatus:@"请选择需要修改的台位"];
        _selectTag=UPDATETOMAN;
        
        
    }else if (btn.tag==5){
        ZCEstimatesController *estimates=[[ZCEstimatesController alloc] init];
        [self.navigationController pushViewController:estimates animated:YES];
    }
    else
    {
            [self updataTable];
    }

}
#pragma mark - 刷新台位
-(void)updataTable
{
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    
    [NSThread detachNewThreadSelector:@selector(getTableList:) toTarget:self withObject:_tabledict];
}
#pragma mark - UISegmentedControl事件
- (void)segmentClick:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex==0) {
        [_tabledict setValue:@"" forKey:@"area"];
        [_tabledict setValue:@"" forKey:@"Floor"];
        [_tabledict setValue:@"" forKey:@"status"];
        
    }else
    {
        NSString *DESStr = [[deskClassArray objectAtIndex:sender.selectedSegmentIndex-1] objectForKey:@"DES"];
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];

        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Area"]]) {
            [_tabledict setValue:DESStr forKey:@"area"];
        }else
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Floor"]]){
                [_tabledict setValue:[NSString stringWithFormat:@"%d",sender.selectedSegmentIndex]
                            forKey:@"Floor"];
            }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:[langSetting localizedString:@"Status"]]){
                for(int i=0;i<9;i++)
                {
                    [_tabledict setValue:[NSString stringWithFormat:@"%d",sender.selectedSegmentIndex]
                                  forKey:@"status"];
                }
            }
    }
    [self getTableList:_tabledict];
}
#pragma mark - 台位请求
- (void)getTableList:(NSDictionary *)info{
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp ZCpListTable:info];
    [SVProgressHUD dismiss];
    BOOL bSucceed = [[dict objectForKey:@"Result"] boolValue];

    bs_dispatch_sync_on_main_thread(^{
        if (bSucceed){
            
            _tableArray = [[dict objectForKey:@"Message"] objectForKey:@"allTable"];
            _freeArray = [[dict objectForKey:@"Message"] objectForKey:@"freeTable"];
            _usingArray=[[dict objectForKey:@"Message"] objectForKey:@"usingTable"];
            [_tableCV reloadData];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"查询台位失败" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    });
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kCancelTag){
        if (buttonIndex == 2) {
            BSDataProvider *dp = [BSDataProvider sharedInstance];
            [dp delectCache];
            NSDictionary *info=[[NSDictionary alloc] initWithObjectsAndKeys:[Singleton sharedSingleton].Seat,@"table", nil];
            NSDictionary *dict = [dp ZCpOver:info];
            
            BOOL bSucceed = [[dict objectForKey:@"Result"] boolValue];
            
            NSString *title,*msg;
            CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
            if (bSucceed) {
                title = [langSetting localizedString:@"Cancel Table Succeed"];
                msg = [dict objectForKey:@"Message"];
                
                [self getTableList:_tabledict];
            }
            else{
                title = [langSetting localizedString:@"Cancel Table Failed"];
                msg = [dict objectForKey:@"Message"];
                
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];

        }else if (buttonIndex == 1){
            
//            [Singleton sharedSingleton].Seat=[[[_tableArray objectAtIndex:dSelectedIndex] objectForKey:@"short"] uppercaseString];
//            [Singleton sharedSingleton].tableName=[[_tableArray objectAtIndex:dSelectedIndex] objectForKey:@"name"];
//            NSLog(@"%@",[Singleton sharedSingleton].Seat);
//            [self getFolioNo:[Singleton sharedSingleton].Seat];
            [self AKOrder];
        }
        
    }else if (alertView.tag == 1002){
        [self updataTable];
    }else if (alertView.tag==5){
        if (buttonIndex==1) {
//            NSString *str=[[self getFolioNo:[[alertView textFieldAtIndex:0].text uppercaseString]] objectAtIndex:0];
//            if ([[self getFolioNo:[[alertView textFieldAtIndex:0].text uppercaseString]] isKindOfClass:[NSArray class]])
                [self modifyPax:[alertView textFieldAtIndex:0].text];
//            }
        }
    }else if (alertView.tag==6){
        if (buttonIndex==1) {
            BSDataProvider *dp = [BSDataProvider sharedInstance];
            NSDictionary *info=[[NSDictionary alloc] initWithObjectsAndKeys:[Singleton sharedSingleton].Seat,@"table", nil];
            [dp delectCache];
            NSDictionary *dict = [dp ZCpClearTable:info];
            BOOL bSucceed = [[dict objectForKey:@"state"] boolValue];
            CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
            if (bSucceed) {
                [SVProgressHUD showSuccessWithStatus:[langSetting localizedString:@"Cancel Table Succeed"]];
                [self getTableList:_tabledict];
            }
            else{
                [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Cancel Table Failed"]];
            }
        }
    }
}
#pragma mark - 修改人数
-(void)modifyPax:(NSString *)order
{
    BSDataProvider *bs=[[BSDataProvider alloc] init];
    NSDictionary *dict=[bs modifyPax:order];
    if ([[dict objectForKey:@"Result"] boolValue]) {
        [self updataTable];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}
-(void)tableByFoilioNo:(NSDictionary *)tableDic
{
    [self getFolioNo:tableDic];
    if ([_ordersArray count]==1) {
        [Singleton sharedSingleton].CheckNum=[[_ordersArray lastObject] objectForKey:@"OrderId"];
        [Singleton sharedSingleton].man=[[_ordersArray lastObject] objectForKey:@"pax"];
    }else
    {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        for (NSDictionary *dict in _ordersArray) {
            [actionSheet addButtonWithTitle:[dict objectForKey:@"des"]];
        }
        [actionSheet showInView:self.view];
        
    }
}
#pragma mark - 根据台位号获取账单号
-(void)getFolioNo:(NSDictionary *)tableDic
{
    
    BSDataProvider *bs=[BSDataProvider sharedInstance];
    NSDictionary *dict=[bs getFolioNo:[tableDic objectForKey:@"short"]];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]) {
        NSArray *ary=[dict objectForKey:@"Message"];
        NSMutableArray *orderArray=[[NSMutableArray alloc] init];
        for (NSString *str in ary) {
            NSArray *array=[str componentsSeparatedByString:@"@"];
            NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:[array objectAtIndex:0],@"OrderId",[array objectAtIndex:1],@"pax",[array objectAtIndex:2],@"des", nil];
            [orderArray addObject:dic];
        }
        _ordersArray=orderArray;
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
    
}


-(void)AKOrder
{
    bs_dispatch_sync_on_main_thread(^{
        UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
        
        UIViewController * centerViewController = [[ZCFoodOrderViewController alloc] init];
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
    });
    
    
}
#pragma mark - 开台代理
- (void)openTableWithOptions:(NSDictionary *)info{
   
    if (info){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
        [Singleton sharedSingleton].man=[info objectForKey:@"man"];
//        [Singleton sharedSingleton].Seat=[[_tableArray objectAtIndex:dSelectedIndex] objectForKey:@"short"];
        
        [dic setObject:[Singleton sharedSingleton].Seat forKey:@"table"];
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(openTable:) toTarget:self withObject:dic];
    }
    [self dismissViews];
}
#pragma mark - 开台的请求
- (void)openTable:(NSDictionary *)info{
    
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp ZCStart:info];
    [SVProgressHUD dismiss];
    BOOL bSucceed = [[dict objectForKey:@"Result"] boolValue];
    
    NSString *title;
    
    if (bSucceed) {
//        title = [NSString stringWithFormat:@"开台成功，账单流水号为:%@", [dict objectForKey:@"Message"]];
        
        [Singleton sharedSingleton].CheckNum=[dict objectForKey:@"Message"];
        [self AKOrder];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
}
#pragma mark - 换台代理
- (void)switchTableWithOptions:(NSDictionary *)info{
    if (info){
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(switchTable:) toTarget:self withObject:info];
    }
    
    [self dismissViews];
}
#pragma mark - 换台请求
- (void)switchTable:(NSDictionary *)info{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp ZCChangeTable:info];
    NSString *msg,*title;
    if ([[dict objectForKey:@"Result"] boolValue]) {
        title = [langSetting localizedString:@"Change Table Succeed"];
        msg = [dict objectForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:msg];
        [self getTableList:_tabledict];
    }
    else{
//        title = [langSetting localizedString:@"Change Table Failed"];
        msg = [dict objectForKey:@"Message"];
        [SVProgressHUD showErrorWithStatus:msg];
    }
    
}
- (void)dismissViews{
    if (_open && _open.superview){
        [_open removeFromSuperview];
        _open = nil;
    }
    if (_switch && _switch.superview){
        [_switch removeFromSuperview];
        _switch = nil;
    }
    if (_resvView && _resvView.superview){
        [_resvView removeFromSuperview];
        _resvView = nil;
    }
}



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


@end
