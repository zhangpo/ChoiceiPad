
//  BSLogViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ZCLogViewController.h"
#import "CVLocalizationSetting.h"
#import "SVProgressHUD.h"
#import "ZCQueryViewController.h"
#import "Singleton.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"
#import "BSDataProvider.h"


//#import "PaymentSelect.h"

@implementation ZCLogViewController
{
    UISearchBar *searchBar;
    NSMutableArray *_dataArray;
    NSMutableDictionary *_dict;
    NSString *_promonum;
    BOOL _SEND;
    NSMutableArray *_searchByName;
    NSMutableDictionary *_searchDict;
    NSMutableArray *_searchByPhone;
    SearchCoreManager *_SearchCoreManager;
    UITableView *tvOrder;
    UILabel *lblCommon;
    ZCAdditionalView *vCommon;
    UILabel *lblTitle;
    NSMutableArray *_selectArray;
}

@synthesize aryCommon;

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    aryCommon=Nil;
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
    _selectArray=[[NSMutableArray alloc] init];

    [[SearchCoreManager share] Reset];
    _SearchCoreManager=[[SearchCoreManager alloc] init];
    for (int i=0; i< [[Singleton sharedSingleton].dishArray count]; i++) {
        SearchBage *search=[[SearchBage alloc] init];
        search.localID = [NSNumber numberWithInt:i];
        search.name=[[[Singleton sharedSingleton].dishArray objectAtIndex:i]  objectForKey:@"DES"];
        NSMutableArray *ary=[NSMutableArray array];
        [ary addObject:[[[Singleton sharedSingleton].dishArray objectAtIndex:i]  objectForKey:@"ITCODE"]];
        search.phoneArray=ary;
        [_searchDict setObject:search forKey:search.localID];
        [[SearchCoreManager share] AddContact:search.localID name:search.name phone:search.phoneArray];
    }
    AKMySegmentAndView *segmen=[AKMySegmentAndView shared];
    [segmen segmentShow:NO];
    [segmen shoildCheckShow:NO];
    [self.view addSubview:segmen];
    _SEND=NO;
    [self performSelector:@selector(updateTitle)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self viewLoad1];
    
}
-(void)viewLoad1
{
    [self searchBarInit];
    
    UIImageView *imgvCommon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 850, 768, 1004-850)];
    [imgvCommon setImage:[UIImage imageNamed:@"CommonCover"]];
    [self.view addSubview:imgvCommon];
    _dict=[NSMutableDictionary dictionary];
    CVLocalizationSetting *localization=[CVLocalizationSetting sharedInstance];
    NSArray *array=[[NSArray alloc] initWithObjects:[localization localizedString:@"Table"],[localization localizedString:@"Save"],[localization localizedString:@"Remarks"],[localization localizedString:@"All Order"],@"发送",[localization localizedString:@"Back"], nil];
    for (int i=0; i<6; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/6*i, 1024-70, 140, 50);
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
            
        }else if (i==4){
            btn.tag=i;
            [btn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==5){
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:btn];
    }
    
    [self headerView];
    tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(0, 275-60, 768, self.view.bounds.size.height-450+60) style:UITableViewStylePlain];
    tvOrder.delegate = self;
    tvOrder.dataSource = self;
    tvOrder.backgroundColor = [UIColor whiteColor];
    [tvOrder setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:tvOrder];
    [self setExtraCellLineHidden:tvOrder];
    lblCommon = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+30, 768, 80)];
    lblCommon.textColor = [UIColor blackColor];
    lblCommon.font = [UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    lblCommon.backgroundColor=[UIColor clearColor];
    lblCommon.textAlignment=NSTextAlignmentCenter;
    lblCommon.numberOfLines=0;
    lblCommon.lineBreakMode=UILineBreakModeWordWrap;
    [imgvCommon addSubview:lblCommon];
}
#pragma mark - 隐藏tableview多余的分割条
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
//搜索
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

#pragma mark -
#pragma mark TableView Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    AKLogTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[AKLogTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate=self;
    }
    cell.backgroundColor=[UIColor whiteColor];
    cell.foodInfo=[_dataArray objectAtIndex:indexPath.row];
    cell.indexPath=indexPath;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AKLogTableViewCell *cell=(AKLogTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.foodCount endEditing:YES];
    if ([[[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] objectForKey:@"ISTC"] intValue]==1) {
        if ([[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] objectForKey:@"isShow"]==nil||[[[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] objectForKey:@"isShow"] boolValue]==NO) {
            NSRange range = NSMakeRange(indexPath.row+1,[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"combo"] count]);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [[Singleton sharedSingleton].dishArray insertObjects:[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"combo"] atIndexes:indexSet];
            [[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"isShow"];
            _dataArray=[NSMutableArray arrayWithArray:[Singleton sharedSingleton].dishArray];
            [tvOrder reloadData];
        }else
        {
            NSRange range = NSMakeRange(indexPath.row+1,[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"combo"] count]);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [[Singleton sharedSingleton].dishArray removeObjectsAtIndexes:indexSet];
            [[[Singleton sharedSingleton].dishArray objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"isShow"];
            _dataArray=[NSMutableArray arrayWithArray:[Singleton sharedSingleton].dishArray];
            [tvOrder reloadData];
        }
    }else
    {
        BOOL changeColor=NO;
        for (AKLogTableViewCell *logCell in _selectArray) {
            if ([cell isEqual:logCell]) {
                changeColor=YES;
                [_selectArray removeObject:cell];
                cell.backgroundColor=[UIColor whiteColor];
                break;
            }
        }
        if (changeColor==NO) {
            cell.backgroundColor=[UIColor lightGrayColor];
            [_selectArray addObject:cell];
        }
    }
}
#pragma mark - AKLogTableViewCellDelegate
-(void)AKLogTableViewCellClick:(AKLogTableViewCell *)cell
{
    if (cell.foodInfo) {
        [_dataArray replaceObjectAtIndex:cell.indexPath.row withObject:cell.foodInfo];
        
    }else
    {
        if ([[[_dataArray objectAtIndex:cell.indexPath.row] objectForKey:@"ISTC"] intValue]==1) {
            if ([[[_dataArray objectAtIndex:cell.indexPath.row] objectForKey:@"isShow"] isEqualToString:@"YES"]) {
                [_dataArray removeObjectsInArray:[[_dataArray objectAtIndex:cell.indexPath.row] objectForKey:@"combo"]];
            }
            [[BSDataProvider sharedInstance] delectcombo:[[_dataArray objectAtIndex:cell.indexPath.row] objectForKey:@"ITCODE"] andNUM:[[_dataArray objectAtIndex:cell.indexPath.row] objectForKey:@"TPNUM"]];
            [_dataArray removeObjectAtIndex:cell.indexPath.row];
        }else
        {
            [[BSDataProvider sharedInstance] delectdish:[[_dataArray objectAtIndex:cell.indexPath.row] objectForKey:@"ITCODE"]];
            [_dataArray removeObjectAtIndex:cell.indexPath.row];
        }
    }
    
    [tvOrder reloadData];
    [self updateTitle];
}

////加入数据
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"CellIdentifier";
//    BSLogCell *cell = (BSLogCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell){
//        cell = [[BSLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.delegate = self;
//    }
//    //    cell.arySelectedAdditions=nil;
//    cell.supTableView=tvOrder;
//    //    cell.arySelectedAdditions=nil;
//    cell.lblAddition.textColor=[UIColor blackColor];
//    cell.lblName.textColor=[UIColor whiteColor];
//    cell.tag = indexPath.section*100+indexPath.row;
//    cell.lblTotalPrice.text=@"";
//    cell.lblAddition.text=@"";
//    cell.lb.text=@"";
//    cell.jia.frame=CGRectMake(109*2-20,5, 40, 40);
//    cell.jian.frame=CGRectMake(109*3-20, 5, 40, 40);
//    cell.tfCount.backgroundColor=[UIColor lightGrayColor];
//    cell.dicInfo=[_dataArray objectAtIndex:indexPath.row];
//    if ([[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Tpcode"]==nil||[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"Tpcode"] isEqualToString:[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"ITCODE"]]||[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"Tpcode"] isEqualToString:@""]) {
//        cell.btnAdd.frame=CGRectMake(109*5.7, 10, 40, 40);
//        cell.btnReduce.frame=CGRectMake(109*5.7+110, 10, 40, 40);
//        cell.lblName.textColor=[UIColor blackColor];
//        cell.tfPrice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"priceKey"]] floatValue]];
//        cell.tfPrice.textColor=[UIColor blackColor];
//        NSLog(@"%@",_dataArray);
//        cell.lblUnit.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"unitKey"]];
//        cell.lblUnit.textColor=[UIColor blackColor];
//        cell.tfCount.textColor=[UIColor blackColor];
//        cell.lblName.text=[NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"DES"]];
//        cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"total"];
//        float TotalPrice=[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"total"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row] objectForKey:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"priceKey"]] floatValue];
//        cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",TotalPrice];
//            
//        
//        NSArray *additions=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"];
//        if ([[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"]!=nil) {
//            NSMutableString *str=[NSMutableString string];
//            for (int i=0; i<[additions count]; i++) {
//                [str appendFormat:@"%@,",[[additions objectAtIndex:i] objectForKey:@"DES"]];
//            }
//            CGSize size = CGSizeMake(440,10000);  //设置宽高，其中高为允许的最大高度
//            CGSize labelsize = [str sizeWithFont:cell.lblAddition.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
//            [cell.lblAddition setFrame:CGRectMake(cell.lblAddition.frame.origin.x,cell.lblAddition.frame.origin.y,labelsize.width,labelsize.height)];  //最后根据这个大小设置label的frame即可
//            
//            cell.lblAddition.text=str;
//        }
//        cell.lblAddition.textColor=[UIColor lightGrayColor];
//        
//        if ([[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"ISTC"] intValue]==1) {
//            cell.jia.frame=CGRectMake(0, 0, 0, 0);
//            cell.jian.frame=CGRectMake(0, 0, 0, 0);
//            cell.tfCount.backgroundColor=[UIColor clearColor];
//            cell.tfCount.enabled=NO;
//        }
//        cell.lblAddition.textColor=[UIColor blackColor];
//        //cell.lblTotalPrice.text=cell.tfPrice.text;
//    }
//    else
//    {
//        cell.jia.frame=CGRectMake(0, 0, 0, 0);
//        cell.jian.frame=CGRectMake(0, 0, 0, 0);
//        cell.tfCount.backgroundColor=[UIColor clearColor];
//        cell.btnAdd.frame=CGRectMake(0, 0, 0, 0);
//        cell.btnReduce.frame=CGRectMake(0, 0, 0, 0);
//        cell.tfCount.enabled=NO;
//        cell.lblName.text=[NSString stringWithFormat:@"---%@",[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"DES"]];
//        cell.lblName.textColor=[UIColor lightGrayColor];
//        cell.tfPrice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"PRICE"] floatValue]];
//        //        cell.tfPrice.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"PRICE"];
//        cell.tfPrice.textColor=[UIColor lightGrayColor];
//        cell.lblUnit.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"UNIT"];
//        cell.lblUnit.textColor=[UIColor lightGrayColor];
//        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weightflg"] intValue]==2) {
//            cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"Weight"];
//        }
//        else
//        {
//            cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"total"];
//        }
//        
//        
//        cell.tfCount.textColor=[UIColor lightGrayColor];
//        NSArray *additions=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"];
//        if ([[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"]!=nil) {
//            NSMutableString *str=[NSMutableString string];
//            for (int i=0; i<[additions count]; i++) {
//                [str appendFormat:@"%@,",[[additions objectAtIndex:i] objectForKey:@"DES"]];
//            }
//            CGSize size = CGSizeMake(440,10000);  //设置宽高，其中高为允许的最大高度
//            CGSize labelsize = [str sizeWithFont:cell.lblAddition.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
//            [cell.lblAddition setFrame:CGRectMake(cell.lblAddition.frame.origin.x,cell.lblAddition.frame.origin.y,labelsize.width,labelsize.height)];  //最后根据这个大小设置label的frame即可
//            
//            cell.lblAddition.text=str;
//            
//        }
//        cell.lblAddition.textColor=[UIColor lightGrayColor];
//    }
//    if ([[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"] count]!=0) {
//        cell.lb.text=@"附加项:";
//        cell.lblLine.frame=CGRectMake(0, cell.lblAddition.frame.origin.y+cell.lblAddition.frame.size.height, 768, 2);
//    }else
//    {
//        
//        cell.lblLine.frame=CGRectMake(0, 49, 768, 2);
//    }
//    cell.indexPath = indexPath;
//    return cell;
//}

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
    NSArray *additions=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"];
    if ([additions count]==0) {
        return 50;
    }else
    {
        NSMutableString *str=[NSMutableString string];
        for (int i=0; i<[additions count]; i++) {
            [str appendFormat:@"%@,",[[additions objectAtIndex:i] objectForKey:@"DES"]];
        }
        CGSize size = CGSizeMake(440,10000);  //设置宽高，其中高为允许的最大高度
        CGSize labelsize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        return 50+labelsize.height;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    if ([[_dict objectForKey:@"ISTC"] intValue]==1) {
    //        for (int i=0; i<[_dataArray count]; i++) {
    //            if ([[_dict objectForKey:@"DES"] isEqualToString:[[[_dataArray objectAtIndex:i] objectForKey:@"food"] objectForKey:@"TPNANE"]]&&[[_dict objectForKey:@"TPNUM"] isEqualToString:[[[_dataArray objectAtIndex:i] objectForKey:@"food"] objectForKey:@"TPNUM"]]) {
    //                [[[_dataArray objectAtIndex:i] objectForKey:@"food"] setValue:[[[_dataArray objectAtIndex:i] objectForKey:@"food"] objectForKey:@"CNT"] forKey:@"promonum"];
    //            }
    //        }
    //
    //    }
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

//-(void)cancleAKsAuthorizationView
//{
//    [self dismissViews];
//}
//
////退菜
//- (void)cell:(BSLogCell *)cell countChanged:(float)count{
//    int row = cell.tag%100;
//    //    NSMutableArray *ary = [Singleton sharedSingleton].dishArray;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:row]];
//    BSDataProvider *dp=[[BSDataProvider alloc] init];
//    int index = cell.indexPath.row;
//    if (count>0){
//        [dic setObject:[NSString stringWithFormat:@"%.2f",count] forKey:@"total"];
//        [_dataArray replaceObjectAtIndex:index withObject:dic];
//    }
//    else{
//        NSMutableArray *array=[NSMutableArray array];
//        int k=0;
//        NSString *tpcode;
//        if ([[[_dataArray objectAtIndex:index] objectForKey:@"ISTC"] intValue]==1) {
//            [dp delectcombo:[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"] andNUM:[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"]];
//            k=[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] intValue];
//            int j=[_dataArray count];
//            tpcode=[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"];
//            for (int i=0;i<j;i++) {
//                if (([[[_dataArray objectAtIndex:index] objectForKey:@"DES"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"DES"]]&&[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]])||([[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"Tpcode"]]&&[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]])) {
//                    [array addObject:[NSString stringWithFormat:@"%d",i]];
//                }
//            }
//            for (int i=0; i<[array count]; i++) {
//                [_dataArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]-i];
//            }
//            
//            for (NSMutableDictionary *food in _dataArray) {
//                if ([[food objectForKey:@"ITCODE"] isEqualToString:tpcode]||[[food objectForKey:@"Tpcode"] isEqualToString:tpcode]) {
//                    if ([[food objectForKey:@"TPNUM"] intValue]>k) {
//                        int x=[[food objectForKey:@"TPNUM"] intValue];
//                        [food setValue:[NSString stringWithFormat:@"%d",x-1] forKey:@"TPNUM"];
//                    }
//                }
//            }
//            
//        }
//        else
//        {
//            [dp delectdish:[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"]];
//            [_dataArray removeObjectAtIndex:index];
//            
//        }
//    }
//    [Singleton sharedSingleton].dishArray=[NSMutableArray arrayWithArray:_dataArray];
//    [self performSelector:@selector(updateTitle)];
//    [tvOrder reloadData];
//}
//-(void)cell:(BSLogCell *)cell count:(int)count
//{
//    NSMutableDictionary *dic=[_dataArray objectAtIndex:cell.indexPath.row];
//    float i=[[dic objectForKey:@"total"] floatValue];
//    [dic setValue:[NSString stringWithFormat:@"%.2f", i+count] forKey:@"total"];
//    if (i+count==0) {
//        [_dataArray removeObject:dic];
//    }
//    [self performSelector:@selector(updateTitle)];
//    [tvOrder reloadData];
//}
////附加项
//- (void)cell:(BSLogCell *)cell additionChanged:(NSMutableArray *)additions{
//    NSMutableDictionary *dic=[_dataArray objectAtIndex:cell.indexPath.row];
//    if (!additions)
//        [dic removeObjectForKey:@"addition"];
//    else
//        [dic setObject:additions forKey:@"addition"];
//    //[ary replaceObjectAtIndex:index withObject:dic];
//    //    NSMutableString *str=[[NSMutableString alloc] init];
//    //    float count=0;
//    //    for (int i=0; i<[additions count]; i++) {
//    //        [str appendFormat:@"%@,",[[additions objectAtIndex:i] objectForKey:@"FoodFuJia_Des"]];
//    //
//    //        count=count+[[[additions objectAtIndex:i] objectForKey:@"FoodFujia_Checked"]intValue];
//    //    }
//    [self performSelector:@selector(updateTitle)];
//    [tvOrder reloadData];
//}
#pragma mark Bottom Buttons Events
//返回按钮的事件
- (void)back{
    bs_dispatch_sync_on_main_thread(^{
        [[SearchCoreManager share] Reset];
        [Singleton sharedSingleton].dishArray=_dataArray;
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
//缓存事件
-(void)cache{
    if ([_dataArray count]!=0) {
        BSDataProvider *dp=[BSDataProvider sharedInstance];
        [dp cache:_dataArray];
        [SVProgressHUD showSuccessWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Save Success"]];
    }
}
//预结算
//-(void)queryView
//{
//    [self quertView];
//}
//发送按钮事件
- (void)sendClicked:(UIButton *)btn{
    
    
    
    //        _dataArray=[Singleton sharedSingleton].dishArray;
    if ([_dataArray count]==0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:[[CVLocalizationSetting sharedInstance] localizedString:@"NoFoodOrderedAlert"] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        if (_SEND==YES) {
            return;
        }
        _SEND=YES;
        NSMutableArray *array=[[NSMutableArray alloc] init];
        int TPNUM=0;
        for (NSDictionary *dic in [Singleton sharedSingleton].dishArray) {
            if (![dic objectForKey:@"CNT"]) {
                if ([[dic objectForKey:@"ISTC"] intValue]==1) {
                    int i=0;
                    for (NSDictionary *combo in [dic objectForKey:@"combo"]) {
                        [combo setValue:[NSString stringWithFormat:@"%d",TPNUM] forKey:@"TPNUM"];
                        [combo setValue:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"PKID"] intValue]+i*60*100] forKey:@"PKID"];
                        i++;
                    }
                    [array addObjectsFromArray:[dic objectForKey:@"combo"]];
                    TPNUM++;
                }else
                {
                    [array addObject:dic];
                }
            }
        }
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(sendFoodToTab:) toTarget:self withObject:array];
        
    }
}
#pragma mark - 发送菜品
-(void)sendFoodToTab:(NSArray *)food
{
    BSDataProvider *dp=[BSDataProvider sharedInstance];
    NSDictionary *dict1=[dp checkFoodAvailable:food];
    if (dict1) {
        BOOL bResult = [[dict1 objectForKey:@"Result"] boolValue];
        if (bResult){
            NSDictionary *dict2=[[NSDictionary alloc] initWithObjectsAndKeys:@"N",@"type",aryCommon,@"common", nil];
            
            NSDictionary *STR=[dp pSendTab:food options:dict2];
            if ([[STR objectForKey:@"Result"] boolValue]==YES) {
                [_dataArray removeAllObjects];
                [dp delectCache];
                [Singleton sharedSingleton].dishArray=_dataArray;
                [SVProgressHUD showSuccessWithStatus:@"传菜成功"];
                bs_dispatch_sync_on_main_thread(^{
                    [tvOrder reloadData];
                    ZCQueryViewController *query=[[ZCQueryViewController alloc] init];
                    [self.navigationController pushViewController:query animated:YES];
                });
            }else
            {
                [Singleton sharedSingleton].dishArray=_dataArray;
                _SEND=NO;
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:[STR objectForKey:@"Message"]];
            }
        }else{
            [SVProgressHUD dismiss];
            [Singleton sharedSingleton].dishArray=_dataArray;
            [SVProgressHUD showErrorWithStatus:[dict1 objectForKey:@"Message"]];
            _SEND=NO;
            
        }
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
        [SVProgressHUD dismiss];
    }
}
//公共附加项
- (void)commonClicked{
    [self dismissViews];
    if (!vCommon){
        vCommon=[[ZCAdditionalView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withSelectAddtions:self.aryCommon];
        vCommon.delegate = self;
        vCommon.center = CGPointMake(self.view.center.x,self.view.center.y);
        [self.view addSubview:vCommon];
    }
}
- (void)additionSelected:(NSArray *)ary{
    [self dismissViews];
    if (ary) {
        if ([_selectArray count]==0) {
            self.aryCommon=ary;
            [self specialRemark:ary];
        }else
        {
            for (AKLogTableViewCell *cell in _selectArray) {
//                NSIndexPath *index=cell.indexPath;
                NSDictionary *dict=[_dataArray objectAtIndex:cell.indexPath.row];
                if ([dict objectForKey:@"addition"]) {
                    NSMutableArray *addition=[dict objectForKey:@"addition"];
                    [addition addObjectsFromArray:ary];
                }else
                {
                    [dict setValue:ary forKey:@"addition"];
                }
                 [_dataArray replaceObjectAtIndex:cell.indexPath.row withObject:dict];
            }
            [_selectArray removeAllObjects];
            [tvOrder reloadData];
        }
        
    }
}
//全单附加项的解析
//#pragma mark CommonView Delegate
//- (void)setCommon:(NSArray *)ary{
//    if (ary) {
//        self.aryCommon=ary;
//        [self specialRemark:ary];
//    }
//    else
//    {
//        [self dismissViews];
//    }
//}
-(void)specialRemark:(NSArray *)ary
{
        NSMutableString *str2=[NSMutableString string];
    aryCommon=ary;
        for (NSDictionary *value in ary)
        {
            //            [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
            [str2 appendFormat:@"%@ ",[NSString stringWithFormat:@" %@",[value objectForKey:@"DES"]]];
            //            str1=[str1 stringByAppendingString:[NSString stringWithFormat:@" %@",[value objectForKey:@"FoodFuJia_Des"]]];
        }
        lblCommon.text=str2;
        [self dismissViews];
}

//
//-(BOOL) shouldOverwriteFileWithRequest:(WRRequest *)request {
//    
//    //if the file (ftp://xxx.xxx.xxx.xxx/space.jpg) is already on the FTP server,the delegate is asked if the file should be overwritten
//    //'request' is the request that intended to create the file
//    return YES;
//    
//}
//- (void)uploadFood:(NSString *)str{
//    bs_dispatch_sync_on_main_thread(^{
//        NSString *settingPath = [@"setting.plist" documentPath];
//        NSDictionary *didict= [NSDictionary dictionaryWithContentsOfFile:settingPath];
//        NSString *ftpurl = nil;
//        if (didict!=nil)
//            ftpurl = [didict objectForKey:@"url"];
//        
//        if (!ftpurl)
//            ftpurl = kPathHeader;
//        WRRequestUpload *uploader = [[WRRequestUpload alloc] init];
//        uploader.delegate = self;
//        uploader.hostname = [ftpurl hostName];
//        uploader.username = [[ftpurl account] objectForKey:@"username"];
//        uploader.password = [[ftpurl account] objectForKey:@"password"];
//        
//        uploader.sentData = [str dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSString *filename = [NSString stringWithFormat:@"%@%lf",[NSString UUIDString],[[NSDate date] timeIntervalSince1970]];
//        
//        uploader.path = [NSString stringWithFormat:@"/orders/%@.order",[filename MD5]];
//        
//        
//        [uploader start];
//    });
//}



#pragma mark Show Latest Price & Number
//更新标题
- (void)updateTitle{
    
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    float count = 0.0f;
    float fPrice = 0.0f;
    float fAdditionPrice = 0.0f;
    int i=0;
    for (NSDictionary *dic in _dataArray){
        if ([dic objectForKey:@"CNT"]==nil||[[dic objectForKey:@"CNT"] isEqualToString:@"(null)"])
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
            for (NSDictionary *dicCommonAdd in self.aryCommon){
                if ([[dicAdd objectForKey:@"DES"] isEqualToString:[dicCommonAdd objectForKey:@"DES"]])
                    bAdd = NO;
            }
            
            if (bAdd)
                fAdditionPrice += [[dicAdd objectForKey:@"PRICE1"] floatValue];
        }
        
        for (NSDictionary *dicCommonAdd in self.aryCommon){
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
//    if (vChuck && vChuck.superview) {
//        [vChuck removeFromSuperview];
//        vChuck = nil;
//    }
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
-(void)queryView
{

    ZCQueryViewController *bsq=[[ZCQueryViewController alloc] init];
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
//
//#pragma mark  AKMySegmentAndViewDelegate
//-(void)showVipMessageView:(NSArray *)array andisShowVipMessage:(BOOL)isShowVipMessage
//{
//    if(isShowVipMessage)
//    {
//        [showVip removeFromSuperview];
//        showVip=nil;
//    }
//    else
//    {
//        showVip=[[AKsIsVipShowView alloc]initWithArray:array];
//        [self.view addSubview:showVip];
//    }
//}


@end

