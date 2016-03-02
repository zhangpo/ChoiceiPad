//
//  BSQueryViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ZCQueryViewController.h"
#import "CVLocalizationSetting.h"
#import "Singleton.h"
#import "ZCFoodOrderViewController.h"
#import "BSDataProvider.h"
#import "ZCSettlementViewController.h"
#import "MMDrawerController.h"
#import "AKOrderLeft.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "SVProgressHUD.h"
#import "AKsIsVipShowView.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"

@implementation ZCQueryViewController
{
    UISearchBar         *searchBar;
    NSMutableArray      *_dataArray;
    NSDictionary        *_dataDict;
    NSMutableArray      *_selectArray;
    NSMutableArray      *_dish;
    int                 x;
    AKsIsVipShowView    *showVip;
    NSString            *str;
    AKMySegmentAndView  *segmen;
    NSMutableArray      *_searchByName;
    NSArray             *_searchArray;
}


#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchByName=[[NSMutableArray alloc] init];
    _dataDict=[[NSDictionary alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    [self viewLoad1];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
    segmen=[AKMySegmentAndView shared];
    [segmen shoildCheckShow:NO];
    [segmen segmentShow:NO];
    [self.view addSubview:segmen];
    
}
-(void)loadData
{
    
    [SVProgressHUD showProgress:-1 status:@"Load..." maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
}
-(void)viewLoad1
{
    
    [self searchBarInit];
    
    //    [Singleton sharedSingleton].Seat=@"33";
    //    [Singleton sharedSingleton].CheckNum=@"P000005";
    _selectArray=[[NSMutableArray alloc] init];
    x=0;
    UIImageView *imgvCommon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 850, 768, 1004-850)];
    [imgvCommon setImage:[UIImage imageNamed:@"CommonCover"]];
    [self.view addSubview:imgvCommon];
        tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, 768, self.view.bounds.size.height-350-35) style:UITableViewStylePlain];
        tvOrder.delegate = self;
        tvOrder.dataSource = self;
        tvOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tvOrder];
    UILabel *lblCommon = [[UILabel alloc] initWithFrame:CGRectMake(35, 15+33, 733, 30)];
    lblCommon.textColor = [UIColor grayColor];
    lblCommon.font = [UIFont systemFontOfSize:20];
    lblCommon.backgroundColor=[UIColor clearColor];
    lblCommon.textAlignment=NSTextAlignmentCenter;
    lblCommon.text=str;
    [imgvCommon addSubview:lblCommon];
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 175-60, 768, 50)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:lblTitle];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 170, 768, 50)];
    view.backgroundColor=[UIColor redColor];
    CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
    NSArray *array=[[NSArray alloc] initWithObjects:[localization localizedString:@"Check All"],[localization localizedString:@"Elide"],[localization localizedString:@"FoodName"],[localization localizedString:@"Count"],[localization localizedString:@"Price"],[localization localizedString:@"Unit"],[localization localizedString:@"Subtotal"],[localization localizedString:@"Gogo"], nil];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(5, 5, 768/7-10,40);
    [btn setBackgroundColor:[UIColor whiteColor]];
    
    //    [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(AllSelect) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:[array objectAtIndex:0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [view addSubview:btn];
    for (int i=1; i<8; i++) {
        UILabel *lb=[[UILabel alloc] init];        lb.textColor=[UIColor whiteColor];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.text=[array objectAtIndex:i];
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb];
        if (i<3) {
            lb.frame=CGRectMake(768/7*i, 0, 768/7, 50);
        }else
        {
            lb.frame=CGRectMake(768/7*3+(768-768/7*3)/5*(i-3), 0, (768-768/7*3)/5, 50);
        }
    }
    [self.view addSubview:view];
    //    tvOrder.tableHeaderView=view;
//    NSArray *array2=[[NSArray alloc] initWithObjects:[localization localizedString:@"Table"],[localization localizedString:@"Gogo"],[localization localizedString:@"Elide"],[localization localizedString:@"Add Food"],[localization localizedString:@"Chuck"],[localization localizedString:@"Print"],[localization localizedString:@"Settlement"],@"外送地址",[localization localizedString:@"Back"], nil];
    NSArray *array2=[[NSArray alloc] initWithObjects:[localization localizedString:@"Table"],[localization localizedString:@"Gogo"],[localization localizedString:@"Elide"],[localization localizedString:@"Add Food"],[localization localizedString:@"Chuck"],[localization localizedString:@"Print"],[localization localizedString:@"Settlement"],[localization localizedString:@"Back"], nil];
    for (int i=0; i<[array2 count]; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/[array2 count]*i, 1024-70, 130, 50);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 120, 30)];
        lb.text=[array2 objectAtIndex:i];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        if (i==0) {
            [btn addTarget:self action:@selector(tableClicked) forControlEvents:UIControlEventTouchUpInside];
            //        }else if (i==1){
            //            [btn addTarget:self action:@selector(chuckOrder) forControlEvents:UIControlEventTouchUpInside];
        }else if(i==1){
            [btn addTarget:self action:@selector(gogoOrder) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==2){
            [btn addTarget:self action:@selector(over) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i==3){
            [btn addTarget:self action:@selector(addDush) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==4){
            [btn addTarget:self action:@selector(chuckOrder) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==5){
            [btn addTarget:self action:@selector(printQuery) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==6){
            [btn addTarget:self action:@selector(QueryView) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==7){
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    _dish=[[NSMutableArray alloc] init];
}

#pragma mark - 刷新数据
-(void)updata
{
    BSDataProvider *bs=[[BSDataProvider alloc] init];
    _dataArray=[[bs ZCpQuery] objectForKey:@"data"];
    //    [Singleton sharedSingleton].dishArray=_dataArray;
    _searchArray=[[NSArray alloc] initWithArray:_dataArray];
    [[SearchCoreManager share] Reset];
    for (int i=0; i<[_dataArray count]; i++) {
        SearchBage *search=[[SearchBage alloc] init];
        search.localID = [NSNumber numberWithInt:i];
        search.name=[[_dataArray objectAtIndex:i] objectForKey:@"PCname"];
        [[SearchCoreManager share] AddContact:search.localID name:search.name phone:nil];
    }
    
    [_dish removeAllObjects];
    [_selectArray removeAllObjects];
    [SVProgressHUD dismiss];
    bs_dispatch_sync_on_main_thread(^{
        [segmen peopelNumOrManandWoman];
        [self updateTitle];
        [tvOrder reloadData];
    });
}
#pragma mark - 外送地址
-(void)deliveryAddress
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"外送地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.tag=101;
    [alert show];
    
}
-(void)deliveryAddressToNet:(NSString *)addr
{
    BSDataProvider *bs=[BSDataProvider sharedInstance];
    NSDictionary *dict=[bs deliveryAddress:addr];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
    }else{
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
    }

}
#pragma mark - 打印
#pragma mark Bottom Buttons Events
- (void)printQuery{
    if (!vPrint){
        [self dismissViews];
        vPrint = [[ZCPrintQueryView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
        vPrint.delegate = self;
        vPrint.center = btnPrint.center;
        [self.view addSubview:vPrint];
        [vPrint firstAnimation];
    }
    else{
        [vPrint removeFromSuperview];
        vPrint = nil;
    }
}
#pragma mark - 打印delegate
- (void)printQueryWithOptions:(NSDictionary *)info
{
    if (info) {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."]];
        NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(priPrintOrder:) object:info];
        [thread start];
    }
    [self dismissViews];
}
#pragma mark - 打印请求
-(void)priPrintOrder:(NSDictionary *)info
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp ZCpriPrintOrder:[info objectForKey:@"type"]];
    [SVProgressHUD dismiss];
    if (dict) {
        if ([[dict objectForKey:@"Result"] boolValue]) {
            if ([[dict objectForKey:@"Result"] boolValue]&&[[info objectForKey:@"type"] isEqualToString:@"2"]) {
                bs_dispatch_sync_on_main_thread(^{
                    NSArray *array=[self.navigationController viewControllers];
                    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
                });
            }
        }
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
}

#pragma mark - 全选
-(void)AllSelect
{
    x=0;
    if ([_selectArray count]==0) {
        [_selectArray removeAllObjects];
        for (NSDictionary *dict in _dataArray) {
            [dict setValue:@"1" forKey:@"select"];
            [_selectArray addObject:dict];
        }
    }
    else
    {
        for (NSDictionary *dict in _dataArray) {
            [dict setValue:@"0" forKey:@"select"];
            [_selectArray addObject:dict];
        }
        [_selectArray removeAllObjects];
    }
    [tvOrder reloadData];
}
#pragma mark - 搜索
- (void)searchBarInit {
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 120-60, 768, 50)];
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
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:nil];
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    if ([_searchByName count]>0) {
        for(int j=0;j<=[_searchByName count]-1;j++){
            for (int i=0;i<[_searchByName count]-j-1;i++){
                int k=[[_searchByName objectAtIndex:i] intValue];
                int y=[[_searchByName objectAtIndex:i+1] intValue];
                if (k>y) {
                    [_searchByName exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                }
            }
        }
    }
    [_dataArray removeAllObjects];
    for (int i=0; i<[_searchByName count]; i++) {//搜索到的
        localID = [_searchByName objectAtIndex:i];
        int j=[localID intValue];
        [_dataArray addObject:[_searchArray objectAtIndex:j]];
        if ([_searchBar.text length]>0) {
            
            [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
        }
    }
    [tvOrder reloadData];
}

#pragma mark - 加菜
-(void)addDush{
    [self AKOrder];
}
-(void)AKOrder
{
    UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
    
    UIViewController * centerViewController = [[ZCFoodOrderViewController alloc] init];
    
    //    UIViewController * rightSideDrawerViewController = [[RightViewController alloc] init];
    
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



#pragma mark -
#pragma mark TableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujia"] length]==0) {
        return 50;
    }else
    {
        return 80;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    x=0;
    _dataDict=[NSDictionary dictionary];
    NSInteger i=indexPath.row;
    _dataDict=[_dataArray objectAtIndex:i];
    if ([[_dataDict objectForKey:@"select"] intValue]==1) {
        [_dataDict setValue:@"0" forKey:@"select"];
        [_selectArray removeObject:_dataDict];
    }
    else
    {
        [_dataDict setValue:@"1" forKey:@"select"];
        [_selectArray addObject:_dataDict];
    }
    [tvOrder reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    BSQueryCell *cell = (BSQueryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell=[[BSQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegete=self;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.ZCdataDic=[_dataArray objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - 手势划菜
-(void)cell:(BSQueryCell *)cell hua:(NSString *)str1
{
    if ([str1 intValue]==0) {
        [cell.ZCdataDic setValue:[cell.ZCdataDic objectForKey:@"Over"] forKey:@"count"];
    }
    if ([str1 intValue]==1) {
        NSString *string=[NSString stringWithFormat:@"%d",[[cell.ZCdataDic objectForKey:@"pcount"] intValue]-[[cell.ZCdataDic objectForKey:@"Over"] intValue]];
        [cell.ZCdataDic setValue:string forKey:@"count"];
        if ([[cell.ZCdataDic objectForKey:@"Over"] intValue]==[[cell.ZCdataDic objectForKey:@"pcount"] intValue])
        {
            return;
        }
    }
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        NSString *dict=[dp ZCscratch:cell.ZCdataDic andtag:[str1 intValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *ary = [dict componentsSeparatedByString:@"@"];
            if ([[ary objectAtIndex:0] intValue]!=0) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary objectAtIndex:1] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alerView show];
            }
            int i=0;
            for (NSDictionary *dict in _dataArray) {
                if ([[dict objectForKey:@"Over"] intValue]!=[[dict objectForKey:@"pcount"] intValue]) {
                    i++;
                }
            }
            [self loadData];
            [SVProgressHUD dismiss];
        });
    });
}
#pragma mark - 修改数量
-(void)changeCountCell:(BSQueryCell *)cell
{
    _dataDict=cell.ZCdataDic;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"修改数量" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *tf=[alert textFieldAtIndex:0];
    tf.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
    alert.tag=100;
    [alert show];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            UITextField *tf=[alertView textFieldAtIndex:0];
            tf.enabled=YES;
            [_dataDict setValue:tf.text forKey:@"oCnt"];
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(ZCpModiOrdrCnt) toTarget:self withObject:nil];
        }
    }else if(alertView.tag==101){
        UITextField *tf=[alertView textFieldAtIndex:0];
        tf.enabled=YES;
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."]];
        [NSThread detachNewThreadSelector:@selector(deliveryAddressToNet:) toTarget:self withObject:tf.text];
    }
}
#pragma mark - 修改数量调用接口
-(void)ZCpModiOrdrCnt
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] ZCpModiOrdrCnt:_dataDict];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        [self updata];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
}
#pragma mark - 划菜
-(void)over{
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(selectcount) toTarget:self withObject:nil];
}
-(void)selectcount
{
    //    if ([_dish count]==[_selectArray count]) {
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp ZCscratch:[NSArray arrayWithArray:_selectArray]];
    
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
        [self loadData];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }

}

#pragma mark Bottom Buttons Events
#pragma mark - 台位
-(void)tableClicked{
    NSArray *array=[self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}


#pragma mark - 预结算界面
-(void)QueryView
{
    ZCSettlementViewController *ak=[[ZCSettlementViewController alloc] init];
    [self.navigationController pushViewController:ak animated:YES];
}

#pragma mark  - 催菜
- (void)gogoOrder{
    if ([_selectArray count]) {
        for (NSDictionary *dict in _selectArray) {
            if ([dict objectForKey:@"Over"]) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@已上菜",[dict objectForKey:@"PCname"]]];
                [_selectArray removeAllObjects];
                return;
            }
        }
        [SVProgressHUD showProgress:-1 status:@"Load...." maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(gogoOrder:) toTarget:self withObject:_selectArray];
    }
}
#pragma mark -
- (void)gogoOrder:(NSMutableArray *)info{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp ZCpGogo:info];
    
    BOOL bSuceed = [[dict objectForKey:@"Result"] boolValue];
    NSString *title,*msg;
    title = nil;
    msg = nil;
    if (bSuceed){
        [SVProgressHUD showSuccessWithStatus:[langSetting localizedString:@"GogoSucceed"]];
        [self loadData];
    } else {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"GogoFailed"]];
        [self loadData];
    }
}
#pragma mark -返回
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 退菜按钮事件
- (void)chuckOrder{
    CVLocalizationSetting *langSetting  = [CVLocalizationSetting sharedInstance];
    if (!vChuck){
        [self dismissViews];
        if ([_selectArray count]==0){
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"NoFoodToChuckAlert"]];
        }
        else{
            vChuck = [[ZCChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
            vChuck.delegate = self;
            vChuck.center = btnChuck.center;
            [self.view addSubview:vChuck];
            [vChuck firstAnimation];
        }
    }
    else{
        [self dismissViews];
    }
}

#pragma mark ChuckView Delegate
#pragma mark - 退菜代理
- (void)chuckOrderWithOptions:(NSDictionary *)info{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    [vChuck removeFromSuperview];
    vChuck = nil;
    
    if (!info)
        return;
    if ([_selectArray count]==0){
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"NoFoodToChuckAlert"]];
    }
    else{
        NSMutableDictionary *dicToChuck = [NSMutableDictionary dictionaryWithDictionary:info];
        [dicToChuck setObject:_selectArray forKey:@"account"];
        [NSThread detachNewThreadSelector:@selector(chuckFood:) toTarget:self withObject:dicToChuck];
    }
}
#pragma mark - 退菜
- (void)chuckFood:(NSDictionary *)info{
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp pChuck:info];
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    
    BOOL bSucceed = [[dict objectForKey:@"Result"] boolValue];
    if (bSucceed){
        [self loadData];
        [SVProgressHUD showSuccessWithStatus:[langSetting localizedString:@"ChuckSucceed"]];
    }
    else{
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"ChuckFailed"]];
        //@"退菜失败";
    }
}

#pragma mark Show Latest Price & Number、
#pragma mark - 计算数量价格
- (void)updateTitle{
    bs_dispatch_sync_on_main_thread(^{
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        float count = 0;
        float fPrice = 0.0f;
        float fAdditionPrice = 0.0f;
        int i=0;
        for (NSDictionary *dic in _dataArray){
            
            
                    if ([[dic objectForKey:@"pcount"] intValue]>0)
                    {
                        count+=[[dic objectForKey:@"pcount"] floatValue];
                    }
                    
                    NSArray *ary4=[[dic objectForKey:@"fujiaPrice"] componentsSeparatedByString:@"!"];
                    if ([ary4 count]>0) {
                        for (NSString *addition in ary4) {
                            fAdditionPrice+=[addition floatValue];
                        }
                    }
                    float price =[[dic objectForKey:@"talPreice"] floatValue];
                    fPrice += price;
                i++;
        }
        lblTitle.text = [NSString stringWithFormat:[langSetting localizedString:@"QueryTitle"],count,fPrice,fAdditionPrice];
    });
    
}
#pragma mark - 关闭视图
- (void)dismissViews{
    bs_dispatch_sync_on_main_thread(^{
        
        if (vPrint && vPrint.superview){
            [vPrint removeFromSuperview];
            vPrint = nil;
        }
        if (vChuck && vChuck.superview){
            [vChuck removeFromSuperview];
            vChuck = nil;
        }
    });
}

@end
