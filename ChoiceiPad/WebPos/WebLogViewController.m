

//  BSLogViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "WebLogViewController.h"
#import "CVLocalizationSetting.h"
#import "SVProgressHUD.h"
#import "WebQueryViewController.h"
#import "WebDeskMainViewController.h"
#import "Singleton.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "AKsIsVipShowView.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"

//#import "PaymentSelect.h"

@implementation WebLogViewController
{
    UISearchBar *searchBar;
    NSMutableArray *_dataArray;
    //    AKsAuthorizationView *_AuthorView;
    BSChuckView *vChuck;
    NSMutableDictionary *_dict;
    NSString *_promonum;
    AKsIsVipShowView    *showVip;
    BOOL _SEND;
    NSMutableArray *_searchByName;
    NSMutableDictionary *_searchDict;
    NSMutableArray *_searchByPhone;
    SearchCoreManager *_SearchCoreManager;
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    _dataArray=[[NSMutableArray alloc] init];
    _searchDict=[NSMutableDictionary dictionary];
    _dataArray=[[NSMutableArray alloc] initWithArray:[Singleton sharedSingleton].dishArray];
    _searchByPhone=[NSMutableArray array];
    _searchDict=[NSMutableDictionary dictionary];
    _searchByName=[[NSMutableArray alloc] init];
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        self.navigationController.navigationBar.barTintColor =[UIColor grayColor];
        self.tabBarController.tabBar.barTintColor =[UIColor grayColor];
        self.navigationController.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
    }
    [[SearchCoreManager share] Reset];
    _SearchCoreManager=[[SearchCoreManager alloc] init];
    for (int i=0; i< [[Singleton sharedSingleton].dishArray count]; i++) {
        SearchBage *search=[[SearchBage alloc] init];
        search.localID = [NSNumber numberWithInt:i];
        search.name=[[_dataArray objectAtIndex:i]  objectForKey:@"DES"];
        NSMutableArray *ary=[NSMutableArray array];
        [ary addObject:[[_dataArray objectAtIndex:i]  objectForKey:@"ITCODE"]];
        search.phoneArray=ary;
        [_searchDict setObject:search forKey:search.localID];
        [[SearchCoreManager share] AddContact:search.localID name:search.name phone:search.phoneArray];
    }
    
    _SEND=NO;
    [self performSelector:@selector(updateTitle)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self searchBarInit];
    AKMySegmentAndView *segmen=[[AKMySegmentAndView alloc] init];
    segmen.delegate=self;
    segmen.frame=CGRectMake(0, 0, 768, 114-60);
    [[segmen.subviews objectAtIndex:1]removeFromSuperview];
    [self.view addSubview:segmen];
    UIImageView *imgvCommon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 850, 768, 1004-850)];
    [imgvCommon setImage:[UIImage imageNamed:@"CommonCover"]];
    [self.view addSubview:imgvCommon];
    _dict=[NSMutableDictionary dictionary];
    CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
    NSArray *array=[[NSArray alloc] initWithObjects:[localization localizedString:@"Table"],[localization localizedString:@"Save"],[localization localizedString:@"Remarks"],[localization localizedString:@"All Order"],[localization localizedString:@"Send Hold"],[localization localizedString:@"Send Now"],[localization localizedString:@"Back"], nil];
    for (int i=0; i<7; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/7*i, 1024-70, 130, 50);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 120, 30)];
        lb.text=[array objectAtIndex:i];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        //        [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
        //        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.tintColor=[UIColor whiteColor];
        if (i==0) {
            [btn addTarget:self action:@selector(tableClicked) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1)
        {
            [btn addTarget:self action:@selector(cache) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i==2){
            [btn addTarget:self action:@selector(commonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        else if (i==3){
            [btn addTarget:self action:@selector(queryView) forControlEvents:UIControlEventTouchUpInside];
            
        }else if (i==4||i==5){
            btn.tag=i;
            [btn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==6){
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:btn];
    }
    
    [self headerView];
    tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(0, 275-60, 768, self.view.bounds.size.height-450+60) style:UITableViewStylePlain];
    tvOrder.delegate = self;
    tvOrder.dataSource = self;
    tvOrder.backgroundColor = [UIColor whiteColor];
    [tvOrder setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tvOrder];
    lblCommon = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+30, 768, 80)];
    lblCommon.textColor = [UIColor blackColor];
    lblCommon.font = [UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    lblCommon.backgroundColor=[UIColor clearColor];
    lblCommon.textAlignment=NSTextAlignmentCenter;
    lblCommon.numberOfLines=0;
    lblCommon.lineBreakMode=UILineBreakModeWordWrap;
    [imgvCommon addSubview:lblCommon];
    
}

/**
 *  搜索框
 */
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
#pragma mark -
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:_searchByPhone];
    if ([_searchByName count]>0) {
        for(int j=0;j<=[_searchByName count]-1;j++){
            for (int i=0;i<[_searchByName count]-j-1;i++){
                int k=[[_searchByName objectAtIndex:i] intValue];
                int x=[[_searchByName objectAtIndex:i+1] intValue];
                if (k>x) {
                    [_searchByName exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                }
            }
        }
    }
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    //    NSMutableArray *array=[[NSMutableArray alloc] init];
    [_dataArray removeAllObjects];
    for (int i=0; i<[_searchByName count]; i++) {//搜索到的
        localID = [_searchByName objectAtIndex:i];
        int j=[localID intValue];
        for (int k=0; k<[[Singleton sharedSingleton].dishArray count]; k++) {
            if (j==k) {
                [_searchDict objectForKey:localID];
                [_dataArray addObject:[[Singleton sharedSingleton].dishArray objectAtIndex:k]];
                if ([_searchBar.text length]>0) {
                    
                    [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
                }
            }
        }
    }
    [tvOrder reloadData];
}
//头标题
-(UIView *)headerView
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 175-60, 768, 100)];
    [self.view addSubview:view];
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    //    lblCommon.text = [langSetting localizedString:@"Additions:"];
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 30)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment=UITextAlignmentCenter;
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.font = [UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [view addSubview:lblTitle];
    UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 50,768, 50)];
    [view addSubview:view1];
    CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
    NSArray *array=[[NSArray alloc] initWithObjects:[localization localizedString:@"DeleteAll"],[localization localizedString:@"FoodName"],[localization localizedString:@"Count"],[localization localizedString:@"Price"],[localization localizedString:@"Unit"],[localization localizedString:@"Subtotal"],[localization localizedString:@"Operation"], nil];
    for (int i=0; i<7; i++) {
        if (i==0) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(5, 5, 768/7-1, 40);
            [btn setBackgroundColor:[UIColor whiteColor]];
            
            //            [btn setBackgroundImage:[UIImage imageNamed:@"hd.jpg"] forState:UIControlStateNormal];
            [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [btn addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
            [view1 addSubview:btn];
        }
        else
        {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(768/7*i,5, 768/7-1, 40)];
            lb.backgroundColor=[UIColor clearColor];
            lb.textAlignment=NSTextAlignmentCenter;
            lb.textColor=[UIColor whiteColor];
            lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            lb.text=[array objectAtIndex:i];
            [view1 setBackgroundColor:[UIColor redColor]];
            [view1 addSubview:lb];
        }
    }
    return view;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark TableView Delegate & DataSource

//加入数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    AKLogCell *cell = (AKLogCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[AKLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    cell.supTableView=tvOrder;
    //    cell.lblName.textColor=[UIColor whiteColor];
    cell.lblTotalPrice.text=@"";
    cell.lblAddition.text=@"";
    cell.lb.text=@"";
    cell.tfCount.backgroundColor=[UIColor lightGrayColor];
    NSDictionary *info=[_dataArray objectAtIndex:indexPath.row];
    cell.dicInfo=info;
    /**
     *  判断是套餐明细
     */
    if (![info  objectForKey:@"SUBID"]) {
        cell.tfPrice.text=[NSString stringWithFormat:@"%.2f",[[info  objectForKey:[info objectForKey:@"PriceKey"]] floatValue]];
        cell.lblUnit.text=[info  objectForKey:[info objectForKey:@"UnitKey"]];
        cell.lblName.text=[NSString stringWithFormat:@"%@",[info  objectForKey:@"DES"]];
        /**
         *  判断是否是赠送
         */
        if ([[info  objectForKey:@"promonum"] intValue]>0) {
            cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",[[info  objectForKey:@"total"] floatValue]*[[info  objectForKey:[info objectForKey:@"PriceKey"]] floatValue]-[[info  objectForKey:@"promonum"] floatValue]*[[info  objectForKey:[info objectForKey:@"PriceKey"]] floatValue]];
            cell.lblName.text=[NSString stringWithFormat:@"%@-赠%@",[info  objectForKey:@"DES"],[info  objectForKey:@"promonum"] ];
            cell.tfCount.text=[info objectForKey:@"total"];
        }
        else
        {
            /**
             *  判断是否是第二单位
             */
            if ([[info objectForKey:@"UNITCUR"] intValue]==2) {
                cell.jia.hidden=YES;
                cell.jian.hidden=YES;
                cell.tfCount.text=[info objectForKey:@"Weight"];
                float TotalPrice=[[info objectForKey:@"Weight"] floatValue]*[[info objectForKey:@"PRICE"] floatValue];
                cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",TotalPrice];
            }
            else
            {
                cell.lblName.text=[NSString stringWithFormat:@"%@",[info  objectForKey:@"DES"]];
                
                cell.tfCount.text=[info objectForKey:@"total"];
                float TotalPrice=[[info objectForKey:@"total"] floatValue]*[[info objectForKey:[info objectForKey:@"PriceKey"]] floatValue];
                cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",TotalPrice];
            }
            
        }
        /**
         *  判断是否是套餐
         */
        if ([[info  objectForKey:@"ISTC"] intValue]==1) {
            cell.jia.hidden=YES;
            cell.jian.hidden=YES;
            cell.tfCount.textColor=[UIColor lightGrayColor];
            cell.tfCount.backgroundColor=[UIColor clearColor];
        }
        cell.lblAddition.textColor=[UIColor blackColor];
        //cell.lblTotalPrice.text=cell.tfPrice.text;
    }
    else
    {
        cell.jia.hidden=YES;
        cell.jian.hidden=YES;
        cell.btnAdd.hidden=YES;
        cell.btnReduce.hidden=YES;
        cell.tfCount.backgroundColor=[UIColor clearColor];
        cell.lblName.text=[NSString stringWithFormat:@"---%@",[info  objectForKey:@"PNAME"]];
        cell.tfPrice.text=[NSString stringWithFormat:@"%.2f",[[info  objectForKey:@"PRICE"] floatValue]];
        cell.lblUnit.text=[info  objectForKey:@"UNIT"];
        if ([[info objectForKey:@"UNITCUR"] intValue]==2)
            cell.tfCount.text=[info  objectForKey:@"Weight"];
        else
            cell.tfCount.text=[info  objectForKey:@"total"];
        cell.tfCount.textColor=[UIColor lightGrayColor];
    }
    /**
     *  附加项
     */
    NSArray *additions=[info  objectForKey:@"addition"];
    /**
     *  判断是否有附加项
     */
    if ([info  objectForKey:@"addition"]!=nil) {
        NSMutableString *str=[[NSMutableString alloc] init];
        /**
         *  根据附加项来改变cell的宽度
         */
        for (int i=0; i<[additions count]; i++){
            [str appendFormat:@"%@(%@),",[[additions objectAtIndex:i] objectForKey:@"FoodFuJia_Des"],[[additions objectAtIndex:i] objectForKey:@"total"]];
        }
        CGSize size = CGSizeMake(440,10000);  //设置宽高，其中高为允许的最大高度
        CGSize labelsize = [str sizeWithFont:cell.lblAddition.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
        [cell.lblAddition setFrame:CGRectMake(cell.lblAddition.frame.origin.x,cell.lblAddition.frame.origin.y,labelsize.width,labelsize.height)];  //最后根据这个大小设置label的frame即可
        cell.lblAddition.text=str;
    }
    if ([[info  objectForKey:@"addition"] count]!=0) {
        cell.lb.text=@"附加项:";
        cell.lblLine.frame=CGRectMake(0, cell.lblAddition.frame.origin.y+cell.lblAddition.frame.size.height, 768, 2);
    }else
        cell.lblLine.frame=CGRectMake(0, 49, 768, 2);
    cell.indexPath = indexPath;
    return cell;
}
/**
 *  cell选择事件
 *
 *  @param tableView
 *  @param indexPath
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info=[_dataArray objectAtIndex:indexPath.row];
    if ([[[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] objectForKey:@"ISTC"] intValue]==1) {
        if ([[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] objectForKey:@"isShow"]==nil||[[[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] objectForKey:@"isShow"] boolValue]==NO) {
            NSRange range = NSMakeRange(indexPath.row+1,[[info  objectForKey:@"combo"] count]);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [[Singleton sharedSingleton].dishArray insertObjects:[info  objectForKey:@"combo"] atIndexes:indexSet];
            [[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"isShow"];
            _dataArray=[NSMutableArray arrayWithArray:[Singleton sharedSingleton].dishArray];
            [tvOrder reloadData];
        }else
        {
            NSRange range = NSMakeRange(indexPath.row+1,[[info  objectForKey:@"combo"] count]);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [[Singleton sharedSingleton].dishArray removeObjectsAtIndexes:indexSet];
            [[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isShow"];
            _dataArray=[NSMutableArray arrayWithArray:[Singleton sharedSingleton].dishArray];
            [tvOrder reloadData];
        }
    }
}

//设置组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//设置行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
//设置标题的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *additions=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"addition"];
    if ([additions count]==0) {
        return 50;
    }else
    {
        NSMutableString *str=[NSMutableString string];
        for (int i=0; i<[additions count]; i++) {
            [str appendFormat:@"%@,",[[additions objectAtIndex:i] objectForKey:@"FoodFuJia_Des"]];
        }
        CGSize size = CGSizeMake(440,10000);  //设置宽高，其中高为允许的最大高度
        CGSize labelsize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        return 50+labelsize.height;
    }
}
#pragma mark -
#pragma mark LogCellDelegate

//附加项
- (void)cell:(AKLogCell *)cell additionChanged:(NSMutableArray *)additions{
    tvOrder.userInteractionEnabled=YES;
    NSMutableDictionary *dic=[_dataArray objectAtIndex:cell.indexPath.row];
    if (!additions)
        [dic removeObjectForKey:@"addition"];
    else
        [dic setObject:additions forKey:@"addition"];
    [Singleton sharedSingleton].dishArray=[NSMutableArray arrayWithArray:_dataArray];
    [self performSelector:@selector(updateTitle)];
    [tvOrder reloadData];
}
//赠菜
-(void)cell:(AKLogCell *)cell present:(BOOL)ZS{
    tvOrder.userInteractionEnabled=NO;
    _dict=[NSMutableDictionary dictionary];
    _dict=[_dataArray objectAtIndex:cell.indexPath.row];
    if (ZS==NO) {
        if ([[_dict objectForKey:@"total"] intValue]==1) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否取消赠送" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag=1;
            [alert show];
        }else
        {
            vChuck = [[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:3];
            vChuck.delegate = self;
            //            vChuck.center = btnChuck.center;
            [self.view addSubview:vChuck];
            [vChuck firstAnimation];
            vChuck.lblcount.hidden=NO;
            vChuck.tfcount.hidden=NO;
            
        }
        
        //        cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",[cell.tfPrice.text floatValue]*[cell.tfCount.text floatValue]];
    }
    else
    {
        float zeng;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Zeng"]) {
            zeng=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Zeng"] floatValue];
        }else
        {
            zeng=49;
        }
        if([cell.tfPrice.text floatValue]<zeng)
        {
            vChuck = [[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:3];
            vChuck.delegate = self;
            //            vChuck.center = btnChuck.center;
            [self.view addSubview:vChuck];
            [vChuck firstAnimation];
            if ([[_dict objectForKey:@"total"] intValue]>1) {
                vChuck.lblcount.hidden=NO;
                vChuck.tfcount.hidden=NO;
                vChuck.tffan.hidden=NO;
                vChuck.lblfan.hidden=NO;
            }else
            {
                vChuck.lblcount.hidden=NO;
                vChuck.tfcount.hidden=NO;
                vChuck.tffan.hidden=NO;
                vChuck.lblfan.hidden=NO;
                _promonum=@"1";
            }
            
        }
        else
        {
            
            //            cell.lblTotalPrice.text=@"0";
            tvOrder.userInteractionEnabled=NO;
            vChuck = [[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:2];
            vChuck.delegate = self;
            //            vChuck.center = btnChuck.center;
            [self.view addSubview:vChuck];
            [vChuck.tfcount becomeFirstResponder];
            [vChuck firstAnimation];
            
            if ([[_dict objectForKey:@"total"] intValue]>1) {
                vChuck.lblcount.hidden=NO;
                vChuck.tfcount.hidden=NO;
                vChuck.tffan.hidden=NO;
                vChuck.lblfan.hidden=NO;
            }
            else
            {
                vChuck.lblcount.hidden=NO;
                vChuck.tfcount.hidden=NO;
                vChuck.tffan.hidden=NO;
                vChuck.lblfan.hidden=NO;
                _promonum=@"1";
            }
        }
    }
    [tvOrder reloadData];
    [self updateTitle];
    
}
#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            [_dict setValue:[NSString stringWithFormat:@"%d",0] forKey:@"promonum"];
            if ([[_dict objectForKey:@"ISTC"] intValue]==1) {
                for (int i=0; i<[_dataArray count]; i++) {
                    if ([[_dict objectForKey:@"DES"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNANE"]]&&[[_dict objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]]) {
                        [[_dataArray objectAtIndex:i] setValue:@"0" forKey:@"promonum"];
                    }
                }
                
            }
        }
        tvOrder.userInteractionEnabled=YES;
        [tvOrder reloadData];
    }else if (alertView.tag==2)
    {
        if (buttonIndex==1) {
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            [dp cache:_dataArray];
            NSArray *array=[self.navigationController viewControllers];
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
        }
        else if (buttonIndex==2)
        {
            NSArray *array=[self.navigationController viewControllers];
            [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
        }
    }
    
}
/**
 *  赠菜
 *
 *  @param info
 */
#pragma mark -
#pragma mark ChuckViewDelegate
- (void)chuckOrderWithOptions:(NSDictionary *)info{
    tvOrder.userInteractionEnabled=YES;
    if (info) {
        if ([info objectForKey:@"count"]!=nil||[info objectForKey:@"recount"]!=nil) {
            if ([[info objectForKey:@"count"] intValue]>[[_dict objectForKey:@"total"] intValue]-[[_dict objectForKey:@"promonum"] intValue]||[[info objectForKey:@"recount"] intValue]>[[_dict objectForKey:@"promonum"] intValue]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The input number is wrong"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
        if ([vChuck.tfcount.text intValue]>0&&[vChuck.tffan.text intValue]>0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The input number is wrong"] message:nil  delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if ([info count]==8) {
            NSString *str=[NSString stringWithFormat:@"%d",[[_dict objectForKey:@"promonum"] intValue]+[[info objectForKey:@"count"] intValue]-[[info objectForKey:@"recount"] intValue] ];
            [_dict setValuesForKeysWithDictionary:info];
            [_dict setValue:str  forKey:@"promonum"];
//            [_dict setValue:[info objectForKey:@"INIT"] forKey:@"promoReason"];
            [self dismissViews];
        }else
        {
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            NSDictionary *dict=[dp checkAuth:info];
            if (dict) {
                NSString *result = [[[dict objectForKey:@"ns:checkAuthResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
                NSArray *ary1 = [result componentsSeparatedByString:@"@"];
                if ([ary1 count]==1) {
                    UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                    [alwet show];
                }
                
                else
                {
                    
                    if ([[ary1 objectAtIndex:0] isEqualToString:@"0"]) {
                        UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                        [alwet show];
                        if ([vChuck.tfcount.text intValue]>0) {
                            NSString *str=[NSString stringWithFormat:@"%d",[[_dict objectForKey:@"promonum"] intValue]+[[info objectForKey:@"count"] intValue]-[[info objectForKey:@"recount"] intValue] ];
                            [_dict setValue:str  forKey:@"promonum"];
                            [_dict setValue:[info objectForKey:@"INIT"] forKey:@"promoReason"];
                            [self dismissViews];
                        }else
                        {
                            [_dict setValue:_promonum forKey:@"promonum"];
                            if ([[_dict objectForKey:@"ISTC"] intValue]==1) {
                                for (int i=0; i<[_dataArray count]; i++) {
                                    if ([[_dict objectForKey:@"DES"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNANE"]]&&[[_dict objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]]) {
                                        [[_dataArray objectAtIndex:i] setValue:@"0" forKey:@"promonum"];
                                    }
                                }
                                
                            }
                        }
                        [_dict setValue:[info objectForKey:@"INIT"] forKey:@"promoReason"];
                        [self dismissViews];
                    }
                    else
                    {
                        UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                        [alwet show];
                    }
                }
            }
        }
    }
    else
    {
        [self dismissViews];
    }
    [tvOrder reloadData];
    [self updateTitle];
}

#pragma mark -
#pragma mark AKLogCellDelegate
//退菜
- (void)cell:(AKLogCell *)cell countChanged:(float)count{
    int row = cell.tag%100;
    //    NSMutableArray *ary = [Singleton sharedSingleton].dishArray;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:row]];
    int index = cell.indexPath.row;
    if (count>0){
        [dic setObject:[NSString stringWithFormat:@"%.2f",count] forKey:@"total"];
        [_dataArray replaceObjectAtIndex:index withObject:dic];
    }
    else{
        NSMutableArray *array=[[NSMutableArray alloc] init];
        int k=0;
        NSString *tpcode;
        if ([[[_dataArray objectAtIndex:index] objectForKey:@"ISTC"] intValue]==1) {
            [[[BSDataProvider alloc] init] delectcombo:[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"] andNUM:[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"]];
            k=[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] intValue];
            int j=[_dataArray count];
            tpcode=[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"];
            for (int i=0;i<j;i++) {
                if (([[[_dataArray objectAtIndex:index] objectForKey:@"DES"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"DES"]]&&[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]])||([[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"Tpcode"]]&&[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]])) {
                    [array addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }
            for (int i=0; i<[array count]; i++) {
                [_dataArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]-i];
            }
            for (NSMutableDictionary *food in _dataArray) {
                if ([[food objectForKey:@"ITCODE"] isEqualToString:tpcode]||[[food objectForKey:@"Tpcode"] isEqualToString:tpcode]) {
                    if ([[food objectForKey:@"TPNUM"] intValue]>k) {
                        int x=[[food objectForKey:@"TPNUM"] intValue];
                        [food setValue:[NSString stringWithFormat:@"%d",x-1] forKey:@"TPNUM"];
                    }
                }
            }
            
        }
        else
        {
            [[[BSDataProvider alloc] init] delectdish:[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"]];
            [_dataArray removeObjectAtIndex:index];
            
        }
    }
    [Singleton sharedSingleton].dishArray=[NSMutableArray arrayWithArray:_dataArray];
    [self performSelector:@selector(updateTitle)];
    [tvOrder reloadData];
}
-(void)cell:(AKLogCell *)cell count:(int)count
{
    NSMutableDictionary *dic=[_dataArray objectAtIndex:cell.indexPath.row];
    int i=[[dic objectForKey:@"total"] intValue];
    [dic setValue:[NSString stringWithFormat:@"%d", i+count] forKey:@"total"];
    if (i+count==0) {
        [_dataArray removeObject:dic];
    }
    [self performSelector:@selector(updateTitle)];
    [tvOrder reloadData];
}
-(void)unitOfCellChanged:(AKLogCell *)cell
{
    NSMutableDictionary *dicInfo=[_dataArray objectAtIndex:cell.indexPath.row];
    _dict=dicInfo;
    NSMutableArray *mutmut = [NSMutableArray array];
    for (int i=0;i<5;i++){
        NSString *unit = [dicInfo objectForKey:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
        NSString *price = [dicInfo objectForKey:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1]];
        if (unit && [unit length]>0)
            [mutmut addObject:[NSDictionary dictionaryWithObjectsAndKeys:price,@"price",unit,@"unit", nil]];
    }
    
    if ([mutmut count]>1){
        int count = [mutmut count];
        NSMutableArray *mut = [NSMutableArray array];
        for (int j=0;j<[mutmut count];j++){
            NSString *title = [NSString stringWithFormat:@"%d/%@",[[[mutmut objectAtIndex:j] objectForKey:@"price"] intValue],[[mutmut objectAtIndex:j] objectForKey:@"unit"]];
            [mut addObject:title];
        }
        UIActionSheet *as = nil;
        if (2==count)
            as = [[UIActionSheet alloc] initWithTitle:@"请选择单位和价格" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:[mut objectAtIndex:0],[mut objectAtIndex:1],nil];
        else if (3==count)
            as = [[UIActionSheet alloc] initWithTitle:@"请选择单位和价格" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:[mut objectAtIndex:0],[mut objectAtIndex:1],[mut objectAtIndex:2],nil];
        else if (4==count)
            as = [[UIActionSheet alloc] initWithTitle:@"请选择单位和价格" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:[mut objectAtIndex:0],[mut objectAtIndex:1],[mut objectAtIndex:2],[mut objectAtIndex:3],nil];
        else if (5==count)
            as = [[UIActionSheet alloc] initWithTitle:@"请选择单位和价格" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:[mut objectAtIndex:0],[mut objectAtIndex:1],[mut objectAtIndex:2],[mut objectAtIndex:3],[mut objectAtIndex:4],nil];
        
        [as showFromRect:cell.lblUnit.frame inView:cell.lblUnit.superview animated:YES];
    }
}
#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (0<buttonIndex){
        int j = 0;
        int mutIndex = buttonIndex-1;
        for (int i=0;i<5;i++){
            NSString *unit = [_dict objectForKey:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1]];
            if (unit && [unit length]>0){
                if (j==mutIndex){
                    [_dict setValue:0==i?@"UNIT":[NSString stringWithFormat:@"UNIT%d",i+1] forKey:@"UnitKey"];
                    [_dict setValue:0==i?@"PRICE":[NSString stringWithFormat:@"PRICE%d",i+1] forKey:@"PriceKey"];
                    break;
                }
                j++;
            }
        }
        [Singleton sharedSingleton].dishArray=[NSMutableArray arrayWithArray:_dataArray];
        [tvOrder reloadData];
    }
    
}

#pragma mark Bottom Buttons Events

//返回按钮的事件
- (void)back{
    /**
     *  重置搜索
     */
    [[SearchCoreManager share] Reset];
    [Singleton sharedSingleton].dishArray=_dataArray;
    [self.navigationController popViewControllerAnimated:YES];
}
//缓存事件
-(void)cache{
    if([Singleton sharedSingleton].isYudian)
    {
        NSString *immediateOrWait;
        immediateOrWait=@"";
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:immediateOrWait,@"immediateOrWait",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"username"],@"user",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"password"],@"pwd",[Singleton sharedSingleton].Seat,@"table",@"1",@"pn",@"N",@"type", nil];
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(checkFood:) toTarget:self withObject:info];
    }else
    {
        if ([_dataArray count]!=0) {
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            [dp cache:_dataArray];
            [SVProgressHUD showSuccessWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Save Success"]];
        }
    }
}
/**
 *  跳转全单界面
 */
-(void)queryView
{
    [self quertView];
}

//公共附加项
- (void)commonClicked{
    [self dismissViews];
    if (!vCommon){
        vCommon = [[BSCommonView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) info:aryCommon];
        vCommon.delegate = self;
    }
    if (!vCommon.superview){
        vCommon.center = CGPointMake(self.view.center.x,924+self.view.center.y);
        [self.view addSubview:vCommon];
        [vCommon firstAnimation];
    }
    else{
        [vCommon removeFromSuperview];
        vCommon = nil;
    }
}
//全单附加项的解析
#pragma mark -
#pragma mark CommonView Delegate
- (void)setCommon:(NSArray *)ary{
    aryCommon=ary;
        [self dismissViews];
}

/**
 *  发送按钮事件
 *
 *  @param btn
 */
- (void)sendClicked:(UIButton *)btn{
    
    if([Singleton sharedSingleton].isYudian)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[[CVLocalizationSetting sharedInstance] localizedString:@"Wait Can't"] delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
        [alert show];
    }else
    {
        
        //        _dataArray=[Singleton sharedSingleton].dishArray;
        if ([_dataArray count]==0) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:[[CVLocalizationSetting sharedInstance] localizedString:@"NoFoodOrderedAlert"] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alertView show];
        }
        else
        {
            NSString *immediateOrWait;
            
            if (btn.tag==4) {
                immediateOrWait=@"1";
                if (_SEND==YES) {
                    return;
                }
                _SEND=YES;
            }else
            {
                
                immediateOrWait=@"0";
                if (_SEND==YES) {
                    return;
                }
                _SEND=YES;
                
            }
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(checkFood:) toTarget:self withObject:immediateOrWait];
        }
    }
}
/**
 *  发送请求
 *
 *  @param info
 */
- (void)checkFood:(NSString *)info{
    //        [Singleton sharedSingleton].quandan=NO;
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[Singleton sharedSingleton].dishArray];
A:
    for (int i=0;i<[array count];i++) {
        NSDictionary *dict=[array objectAtIndex:i];
        if (([[dict objectForKey:@"isShow"] boolValue]==YES)&&[[dict objectForKey:@"ISTC"] intValue]==1) {
            NSRange range = NSMakeRange(i+1,[[dict objectForKey:@"combo"] count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [array removeObjectsAtIndexes:indexSet];
            [dict setValue:@"NO" forKey:@"isShow"];
            goto A;
            break;
        }
    }
    NSDictionary *dict = [[BSDataProvider sharedInstance] WebSendFood:array withTag:info withComment:aryCommon];
    if (dict) {
            if ([[dict objectForKey:@"success"] boolValue]==YES) {
                [_dataArray removeAllObjects];
                [tvOrder reloadData];
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:[[dict objectForKey:@"root"] objectForKey:@"message"]];
                [self updateTitle];
                [Singleton sharedSingleton].dishArray=_dataArray;
                if (![[Singleton sharedSingleton] isYudian]) {
                    [self quertView];
                }                }
            else
            {
                _SEND=NO;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[dict objectForKey:@"message"]
                                                               message:nil
                                                              delegate:nil
                                                     cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                     otherButtonTitles:nil];
                [alert show];
                [SVProgressHUD dismiss];
        }
    }
    else
    {
        _SEND=NO;
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Send Failed" ]];
    }
    
}




#pragma mark -
#pragma mark Show Latest Price & Number
//更新标题
- (void)updateTitle{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    float count = 0.0f;
    float fPrice = 0.0f;
    float fAdditionPrice = 0.0f;
    int i=0;
    for (NSDictionary *dic in _dataArray){
        if (![dic objectForKey:@"SUBID"])
        {
            if ([[dic objectForKey:@"total"] floatValue]>0)
            {
                if ([[dic objectForKey:@"promonum"] isEqualToString:@"1"]) {
                    float fCount = [[dic objectForKey:@"total"] floatValue];
                    float price = [[dic objectForKey:@"PRICE"] floatValue];
                    float fTotal = price*fCount-price*[[dic objectForKey:@"promonum"] intValue];
                    count +=fCount;
                    fPrice += fTotal;
                }
                else
                {
                    float fCount = [[dic objectForKey:@"total"] floatValue];
                    float price = [[dic objectForKey:@"PRICE"] floatValue];
                    float fTotal = price*fCount;
                    count +=fCount;
                    fPrice += fTotal;
                }
            }
        }
        i++;
        NSArray *aryAdd = [dic objectForKey:@"addition"];
        for (NSDictionary *dicAdd in aryAdd){
            BOOL bAdd = YES;
            for (NSDictionary *dicCommonAdd in aryCommon){
                if ([[dicAdd objectForKey:@"DES"] isEqualToString:[dicCommonAdd objectForKey:@"DES"]])
                    bAdd = NO;
            }
            
            if (bAdd)
                fAdditionPrice += [[dicAdd objectForKey:@"Fprice"] floatValue];
        }
        
        for (NSDictionary *dicCommonAdd in aryCommon){
            fAdditionPrice += [[dicCommonAdd objectForKey:@"PRICE1"] floatValue];
        }
        
    }
    lblTitle.text = [NSString stringWithFormat:[langSetting localizedString:@"QueryTitle"],count,fPrice,fAdditionPrice];
}
//关闭界面

- (void)dismissViews{
    if (vCommon && vCommon.superview){
        [vCommon removeFromSuperview];
        vCommon = nil;
    }
    if (vChuck && vChuck.superview) {
        [vChuck removeFromSuperview];
        vChuck = nil;
    }
}

//台位按钮的事件
- (void)tableClicked{
    if ([_dataArray count]!=0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Save the dishes"] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"YES"],[[CVLocalizationSetting sharedInstance] localizedString:@"NO"], nil];
        alert.tag=2;
        [alert show];
    }else
    {
        NSArray *array=[self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    }
    
    
    
}
//抽屉
-(void)quertView
{
    
    WebQueryViewController *bsq=[[WebQueryViewController alloc] init];
    [self.navigationController pushViewController:bsq animated:YES];
    
}
//删除全部的按钮事件
- (void)deleteAll{
    
    [_dataArray removeAllObjects];
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    [dp delectCache];
    [Singleton sharedSingleton].dishArray=_dataArray;
    [tvOrder reloadData];
    [self performSelector:@selector(updateTitle)];
}
#pragma mark -
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
