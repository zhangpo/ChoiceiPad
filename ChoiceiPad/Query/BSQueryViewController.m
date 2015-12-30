//
//  BSQueryViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSQueryViewController.h"
#import "CVLocalizationSetting.h"
#import "Singleton.h"
#import "AKFoodOrderViewController.h"
#import "BSDataProvider.h"
#import "AKQueryViewController.h"
#import "MMDrawerController.h"
#import "AKOrderLeft.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "SVProgressHUD.h"
#import "AKsIsVipShowView.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"

@implementation BSQueryViewController
{
    UISearchBar *searchBar;
    NSMutableArray *_dataArray;
    NSDictionary *_dataDict;
    NSMutableArray *_selectArray;
    NSMutableArray *_dish;
    int x;
    AKsIsVipShowView    *showVip;
    NSString *str;
    AKMySegmentAndView  *segmen;
    NSMutableArray *_searchByName;
    NSArray *_searchArray;
    UILabel *lblTitle;
    BSPrintQueryView        *printQuery;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchByName=[[NSMutableArray alloc] init];
    _dataDict=[[NSDictionary alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self searchBarInit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"LOGOUT" object:nil];
    //    [Singleton sharedSingleton].Seat=@"33";
    //    [Singleton sharedSingleton].CheckNum=@"P000005";
    _selectArray=[[NSMutableArray alloc] init];
    x=0;
    UIImageView *imgvCommon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 850, 768, 1004-850)];
    [imgvCommon setImage:[UIImage imageNamed:@"CommonCover"]];
    [self.view addSubview:imgvCommon];
//    if ([_dataArray count]>0) {
        tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, 768, self.view.bounds.size.height-350-35) style:UITableViewStylePlain];
        tvOrder.delegate = self;
        tvOrder.dataSource = self;
        tvOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tvOrder];
//    }
    UILabel *lblCommon = [[UILabel alloc] initWithFrame:CGRectMake(35, 15+33, 733, 30)];
    lblCommon.textColor = [UIColor grayColor];
    lblCommon.font = [UIFont systemFontOfSize:20];
    lblCommon.backgroundColor=[UIColor clearColor];
    lblCommon.textAlignment=NSTextAlignmentCenter;
    lblCommon.text=str;
    [imgvCommon addSubview:lblCommon];
//    NSLog(@"%@",_dataArray);
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
    NSArray *array2=[[NSArray alloc] initWithObjects:[localization localizedString:@"Table"],[localization localizedString:@"Chuck"],[localization localizedString:@"Gogo"],[localization localizedString:@"Elide"],[localization localizedString:@"Add Food"],[localization localizedString:@"Print"],[localization localizedString:@"Settlement"],[localization localizedString:@"Back"], nil];
    for (int i=0; i<8; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/8*i, 1024-70, 130, 50);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 120, 30)];
        lb.text=[array2 objectAtIndex:i];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        //
        if (i==0) {
            [btn addTarget:self action:@selector(tableClicked) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1){
            [btn addTarget:self action:@selector(chuckOrder) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i==2){
            [btn addTarget:self action:@selector(gogoOrder) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==3){
            [btn addTarget:self action:@selector(over) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i==4){
            [btn addTarget:self action:@selector(AKOrder) forControlEvents:UIControlEventTouchUpInside];
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    segmen=[AKMySegmentAndView shared];
    segmen.frame=CGRectMake(0, 0, 768, 114-60);
    segmen.delegate=self;
    [segmen shoildCheckShow:YES];
    [segmen segmentShow:NO];
    [self.view addSubview:segmen];
    [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
//    [self updata];
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
#pragma mark - 刷新数据
-(void)updata
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] queryCompletely];
    _dataArray=[dict objectForKey:@"data"];
    str=[dict objectForKey:@"Common"];
    _searchArray=[[NSArray alloc] initWithArray:_dataArray];
    [[SearchCoreManager share] Reset];
    for (int i=0; i<[_dataArray count]; i++) {
        SearchBage *search=[[SearchBage alloc] init];
        search.localID = [NSNumber numberWithInt:i];
        search.name=[[_dataArray objectAtIndex:i] objectForKey:@"PCname"];
        [[SearchCoreManager share] AddContact:search.localID name:search.name phone:nil];
    }
    [tvOrder reloadData];
    [self updateTitle];
    [_selectArray removeAllObjects];
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
    //    NSMutableArray *array=[[NSMutableArray alloc] init];
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

-(void)AKOrder
{
    UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
    
    UIViewController * centerViewController = [[AKFoodOrderViewController alloc] init];
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    BSQueryCell *cell = (BSQueryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BSQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegete=self;
    }
    cell.dataDic=[_dataArray objectAtIndex:indexPath.row];
    return cell;
}
/**
 *  手势划菜
 *
 *  @param cell 滑动的cell
 *  @param str1 标示
 */
-(void)cell:(BSQueryCell *)cell hua:(NSString *)str1
{
    if ([Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Wait Can't"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([str1 intValue]==0) {
        [cell.dataDic setValue:[cell.dataDic objectForKey:@"Over"] forKey:@"count"];
    }
    if ([str1 intValue]==1) {
        NSString *string=[NSString stringWithFormat:@"%d",[[cell.dataDic objectForKey:@"pcount"] intValue]-[[cell.dataDic objectForKey:@"Over"] intValue]];
        [cell.dataDic setValue:string forKey:@"count"];
        if ([[cell.dataDic objectForKey:@"Over"] intValue]==[[cell.dataDic objectForKey:@"pcount"] intValue])
        {
            return;
        }
    }
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        NSString *dict=[dp scratch:cell.dataDic andtag:[str1 intValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *ary = [dict componentsSeparatedByString:@"@"];
            if ([[ary objectAtIndex:0] intValue]!=0) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary objectAtIndex:1] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alerView show];
            }
            if (dict==nil) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接断开，请稍后再试" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alerView show];
            }
            int i=0;
            for (NSDictionary *dict in _dataArray) {
                if ([[dict objectForKey:@"Over"] intValue]!=[[dict objectForKey:@"pcount"] intValue]) {
                    i++;
                }
            }
            [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
            [_dish removeAllObjects];
            [SVProgressHUD dismiss];
        });
    });
}
//划菜
-(void)over{
    if ([Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"预点不能划菜" message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
A:
    for (NSDictionary *dict in _selectArray) {
        if ([[dict objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"Pcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]) {
            for (NSDictionary *dict1 in _selectArray) {
                if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]&&![[dict1 objectForKey:@"Pcode"] isEqualToString:[dict1 objectForKey:@"Tpcode"]]&&[[dict1 objectForKey:@"PKID"] isEqualToString:[dict objectForKey:@"PKID"]]){
                    [_selectArray removeObject:dict1];
                    goto A;
                    break;
                }
            }
        }
    }
    
    if ([_selectArray count]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择要划的菜" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        
        [alert show];
    }else
    {
        [self selectcount];
    }
}
-(void)selectcount
{
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        NSString *dict=[dp scratch:[NSArray arrayWithArray:_selectArray]];
        NSArray *ary = [dict componentsSeparatedByString:@"@"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[ary objectAtIndex:0] intValue]!=0) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:dict delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alerView show];
            }
            if (dict==nil) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接断开，请稍后再试" delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alerView show];
            }
            
            //                }
//            [self updata];
            int i=0;
            for (NSDictionary *dict in _dataArray) {
                if ([[dict objectForKey:@"Over"] intValue]!=[[dict objectForKey:@"pcount"] intValue]) {
                    i++;
                }
            }
            [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
            [_dish removeAllObjects];
            [SVProgressHUD dismiss];
        });
    });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2) {
        if (buttonIndex==1) {
            NSDictionary *dict=[_selectArray objectAtIndex:x];
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            UITextField *tf2=[alertView textFieldAtIndex:1];
            if ([tf1.text length]>0&&[tf2.text length]>0) {
                [_dish removeAllObjects];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"不明确你需要划菜还是反划菜，请核对后再输入" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alert show];
                return;
            }
            if ([tf1.text length]==0&&[tf2.text length]==0) {
                [dict setValue:@"0" forKey:@"count"];
                [_dish addObject:dict];
                [self selectcount];
            }else{
                if ([tf2.text intValue]>[[dict objectForKey:@"Over"] intValue]||[tf1.text intValue]>[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"输入有误" delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                
                if ([tf1.text length]>0) {
                    [dict setValue:tf1.text forKey:@"count"];
                    [_dish addObject:dict];
                    [self selectcount];
                }
                else
                {
                    [dict setValue:tf2.text forKey:@"recount"];
                    [_dish addObject:dict];
                    [self selectcount];
                }
            }
            
        }
        else
        {
            
            NSDictionary *dict=[_selectArray objectAtIndex:x];
            [dict setValue:@"0" forKey:@"count"];
            [_dish addObject:dict];
            [self selectcount];
        }
        
    }
    else if(alertView.tag==3){
        NSDictionary *dict=[_selectArray objectAtIndex:x];
        if (buttonIndex==1) {
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            if ([tf1.text length]>0) {
                    [dict setValue:tf1.text forKey:@"count"];
            }
            if ([tf1.text intValue]>[[dict objectForKey:@"pcount"] intValue]) {
                
                [SVProgressHUD showErrorWithStatus:@"输入有误请重新输入"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
                    [self tuicai];
                });
                
                return;
            }
            
            if (x==[_selectArray count]-1) {
                x=0;
                [self chuckOrder];
                return;
            }
            else
            {
                x++;
                [self tuicai];
            }
        }else
        {
            if ([dict isEqual:[_selectArray lastObject]]) {
                [_selectArray removeObjectAtIndex:x];
                x=0;
                [self chuckOrder];
            }else
            {
                [_selectArray removeObjectAtIndex:x];
                [self tuicai];
            }
            
            
        }
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
    /**
     *  根据附加项来判断cell的高度
     */
    if ([[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"]==NULL||[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"]==nil||[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"] isEqualToString:@""]) {
        return 50;
    }else
    {
        return 80;
    }
    
}

#pragma mark Bottom Buttons Events
/**
 *  返回台位界面
 */
-(void)tableClicked{
    NSArray *array=[self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}
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
/**
 *  进入预结算
 */
-(void)QueryView
{
    if(![Singleton sharedSingleton].isYudian)
    {
        NSDictionary *dic=[[BSDataProvider sharedInstance]selectRolemodule:@"9905005"];
        if (![[dic objectForKey:@"ROLE"] boolValue]) {
            [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Have no legal power"]];
            return;
        }
        AKQueryViewController *ak=[[AKQueryViewController alloc] init];
        [self.navigationController pushViewController:ak animated:YES];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Wait Can't"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
            
        });
    }
}

/**
 *  催菜
 */
- (void)gogoOrder{
    NSDictionary *dic=[[BSDataProvider sharedInstance]selectRolemodule:@"9902005"];
    if (![[dic objectForKey:@"ROLE"] boolValue]) {
        [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Have no legal power"]];
        return;
    }
    if ([Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Wait Can't"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_selectArray count]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"GogoAlert"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        return;
    }
A:
    for (NSDictionary *dict in _selectArray) {
        /**
         *  判断是否划完菜品
         */
        if ([[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]==0) {
            NSString *str1=[NSString stringWithFormat:[[CVLocalizationSetting sharedInstance] localizedString:@"don't Gogo"],[dict objectForKey:@"PCname"]];
            UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:str1 message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alerView show];
            return;
        }
        /**
         *  如果选择了套餐头，删除套餐明细
         */
        if ([[dict objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"Pcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]) {
            for (NSDictionary *dict1 in _selectArray) {
                if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]&&![[dict1 objectForKey:@"Pcode"] isEqualToString:[dict1 objectForKey:@"Tpcode"]]&&[[dict1 objectForKey:@"PKID"] isEqualToString:[dict objectForKey:@"PKID"]]){
                    [_selectArray removeObject:dict1];
                    goto A;
                    break;
                }
            }
        }
    }
    
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."]];
    NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(pGogo:) object:_selectArray];
    [thread start];
}
/**
 *  催菜
 *
 *  @param array 菜品
 */
-(void)pGogo:(NSArray *)array
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp pGogo:_selectArray];
    [SVProgressHUD dismiss];
    NSString *result = [[[dict objectForKey:@"ns:callPubitemResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary = [result componentsSeparatedByString:@"@"];
    if ([ary count]==1) {
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:[ary objectAtIndex:0] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alerView show];
    }
    else{
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:[ary objectAtIndex:1] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alerView show];
    }
    [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
}
- (void)chuckOrder{
    if ([_selectArray count]==0) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"NoFoodToChuckAlert"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
        return;
    }
    tvOrder.userInteractionEnabled=NO;
    CVLocalizationSetting *langSetting  = [CVLocalizationSetting sharedInstance];
    if (!vChuck){
        [self dismissViews];
        NSMutableArray *aryOrderToChuck = [NSMutableArray array];
        [aryOrderToChuck addObject:_dataDict];
        bs_dispatch_sync_on_main_thread(^{
            if ([aryOrderToChuck count]==0){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Error"] message:[langSetting localizedString:@"NoFoodToChuckAlert"] delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
                [alert show];
            }
            else{
                vChuck = [[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:1];
                vChuck.delegate = self;
                vChuck.center = self.view.center;
                [self.view addSubview:vChuck];
                [vChuck firstAnimation];
            }
        });
        
    }
    else{
        bs_dispatch_sync_on_main_thread(^{
            [vChuck removeFromSuperview];
            
            vChuck = nil;
        });
        
    }
    [tvOrder reloadData];
    
}
/**
 *  退菜按钮事件
 */
-(void)tuicai
{
    if ([_selectArray count]>0) {
        NSMutableDictionary *dict=[_selectArray objectAtIndex:x];
        if ([[dict objectForKey:@"pcount"] intValue]>1) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"退菜数量" message:[dict objectForKey:@"PCname"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            UITextField *tf1 = [alert textFieldAtIndex:0];
            tf1.keyboardType=UIKeyboardTypeNumberPad;
            tf1.clearButtonMode=UITextFieldViewModeAlways;
            tf1.placeholder=[NSString stringWithFormat:@"菜品数量:%@",[dict objectForKey:@"pcount"]];
            tf1.delegate=self;
            alert.tag=3;
            [alert show];
            
        }else
        {
            if (x==[_selectArray count]-1) {
                x=0;
                return;
                [tvOrder reloadData];
            }
            else
            {
                x++;
                [self tuicai];
            }
        }

    }
}
/**
 *  返回
 */
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ChuckView Delegate
//退菜
- (void)chuckOrderWithOptions:(NSDictionary *)info{
    tvOrder.userInteractionEnabled=YES;
    if (info) {
//        [self chuckByCount:0];
//        NSLog(@"%@",_selectArray);
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        NSArray *array=[[NSArray alloc] initWithArray:_selectArray];
        [dict setValue:array forKey:@"dataArray"];
        [dict setValue:info forKey:@"info"];
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."]];
        NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(chuckOrder:) object:dict];
        [thread start];
    }
    else
    {
//        [
        [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
    }
    [self dismissViews];
}

/**
 *  退菜
 *
 *  @param info
 */
-(void)chuckOrder:(NSDictionary *)info
{
    if ([[info objectForKey:@"ISTC"] intValue]==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"套餐里的菜不能退菜" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp checkAuth:[info objectForKey:@"info"]];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:checkAuthResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        if ([ary1 count]==1) {
            [SVProgressHUD showErrorWithStatus:[ary1 lastObject]];
        }
        else
        {
            if ([[ary1 objectAtIndex:0] isEqualToString:@"0"]) {
                BSDataProvider *dp=[[BSDataProvider alloc] init];
                NSDictionary *dic=[dp cancleProducts:info];
                if (dic) {
                    
                    [SVProgressHUD dismiss];
                    if ([[dic objectForKey:@"return"] intValue]==0) {
                        [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"success"]];
                        
                    }else{
                        [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"error"]];
                    }
                }
                
                [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
//                [self updata];
               
            }
            else
            {
                [SVProgressHUD dismiss];
                UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:[ary1 lastObject] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alwet show];
            }
        }
    }
}

#pragma mark Show Latest Price & Number
/**
 *  计算数量价格
 */
- (void)updateTitle{
    bs_dispatch_sync_on_main_thread(^{
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        float count = 0.0f;
        float fPrice = 0.0f;
        float fAdditionPrice = 0.0f;
        int i=0;
        for (NSDictionary *dic in _dataArray){
            
            if ([[dic objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dic objectForKey:@"Tpcode"] isEqualToString:[dic objectForKey:@"Pcode"]]||[[dic objectForKey:@"Tpcode"] isEqualToString:@""])
            {
                if ([[dic objectForKey:@"pcount"] intValue]>0)
                {
                    count+=[[dic objectForKey:@"pcount"] intValue];
                }
                
                float price =[[dic objectForKey:@"talPreice"] floatValue];
                fPrice += price;
                i++;
            }
            NSArray *ary4=[[dic objectForKey:@"fujiaPrice"] componentsSeparatedByString:@"!"];
            if ([ary4 count]>0) {
                for (NSString *addition in ary4) {
                    fAdditionPrice+=[addition floatValue];
                }
            }
            
        }
        lblTitle.text = [NSString stringWithFormat:[langSetting localizedString:@"QueryTitle"],count,fPrice,fAdditionPrice];
    });
    
}

- (void)dismissViews{
    bs_dispatch_sync_on_main_thread(^{
        if (vChuck && vChuck.superview){
            [vChuck removeFromSuperview];
            vChuck = nil;
        }
    });
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]{1,2}$";
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
}
#pragma mark - 注销登录
-(void)logout
{
    [Singleton sharedSingleton].userInfo=nil;
    NSArray *array=[self.navigationController viewControllers];
    if ([array count]>0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
