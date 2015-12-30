
//  BSLogViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSLogViewController.h"
#import "SVProgressHUD.h"
#import "BSQueryViewController.h"
#import "Singleton.h"
#import "BSAllCheakRight.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"
#import "CVLocalizationSetting.h"

@implementation BSLogViewController
{
    UISearchBar *searchBar;
    NSMutableArray *_dataArray;
    BSChuckView *vChuck;
    NSMutableDictionary *_dict;
    NSString *_promonum;
    BOOL _SEND;
    NSMutableArray *_searchByName;
    NSMutableDictionary *_searchDict;
    NSMutableArray *_searchByPhone;
    SearchCoreManager *_SearchCoreManager;
    NSArray           *aryCommon;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:@"LOGOUT" object:nil];
    _dataArray=[[NSMutableArray alloc] init];
    _searchDict=[NSMutableDictionary dictionary];
    _dataArray=[[NSMutableArray alloc] initWithArray:[Singleton sharedSingleton].dishArray];
    _searchByPhone=[NSMutableArray array];
    _searchDict=[NSMutableDictionary dictionary];
    _searchByName=[[NSMutableArray alloc] init];
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
    _SEND=NO;
    AKMySegmentAndView *segmen=[AKMySegmentAndView shared];
    segmen.delegate=self;
    [segmen segmentShow:NO];
    [segmen shoildCheckShow:NO];
    [self.view addSubview:segmen];
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
    
//    NSString *str;
//    if([Singleton sharedSingleton].isYudian)
//    {
//        str=@"发送";
//    }
//    else
//    {
//        str=@"即起发送";
//    }
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
            [btn addTarget:self action:@selector(quertView) forControlEvents:UIControlEventTouchUpInside];
            
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
    [tvOrder setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:tvOrder];
    lblCommon = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+30, 768, 80)];
    lblCommon.textColor = [UIColor blackColor];
    lblCommon.font = [UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    lblCommon.backgroundColor=[UIColor clearColor];
    lblCommon.textAlignment=NSTextAlignmentCenter;
    lblCommon.numberOfLines=0;
    lblCommon.lineBreakMode=UILineBreakModeWordWrap;
    [imgvCommon addSubview:lblCommon];
    [self setExtraCellLineHidden:tvOrder];
}
#pragma mark - 隐藏tableview多余的分割条
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
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
/**
 *  搜索事件
 *
 */
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
/**
 *  头标题
 *
 *  @return 
 */
-(UIView *)headerView
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 175-60, 768, 100)];
    [self.view addSubview:view];
    //    lblCommon.text = [langSetting localizedString:@"Additions:"];
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 30)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
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
    cell.foodInfo=[_dataArray objectAtIndex:indexPath.row];
    cell.indexPath=indexPath;
    return cell;
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
    NSArray *additions=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"];
    if ([additions count]==0) {
        return 55;
    }else
    {
        NSMutableString *str=[NSMutableString string];
        for (int i=0; i<[additions count]; i++) {
            [str appendFormat:@"%@X%@,",[[additions objectAtIndex:i] objectForKey:@"FNAME"],[[additions objectAtIndex:i] objectForKey:@"count"]];
        }
        CGSize size = CGSizeMake(660,10000);  //设置宽高，其中高为允许的最大高度
        CGSize labelsize = [str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        return 60+labelsize.height;
        //        return 80;
    }
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
}
////加入数据
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"CellIdentifier";
//    BSLogCell *cell = (BSLogCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell){
//        cell = [[BSLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.delegate = self;
//    }
//    cell.supTableView=tvOrder;
////    cell.lblName.textColor=[UIColor whiteColor];
//    cell.lblTotalPrice.text=@"";
//    cell.lblAddition.text=@"";
//    cell.lb.text=@"";
//    cell.tfCount.backgroundColor=[UIColor lightGrayColor];
//    cell.dicInfo=[_dataArray objectAtIndex:indexPath.row];
//    /**
//     *  判断是套餐明细
//     */
//    if (![[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"CNT"]) {
//        cell.tfPrice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"PRICE"] floatValue]];
//        cell.lblUnit.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"UNIT"];
//        cell.lblName.text=[NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"DES"]];
//        /**
//         *  判断是否是赠送
//         */
//        if ([[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"promonum"] intValue]>0) {
//            cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"total"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"PRICE"] floatValue]-[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"promonum"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"PRICE"] floatValue]];
//            cell.lblName.text=[NSString stringWithFormat:@"%@-赠%@",[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"DES"],[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"promonum"] ];
//            cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"total"];
//        }
//        else
//        {
//            /**
//             *  判断是否是第二单位
//             */
//            if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"UNITCUR"] intValue]==2) {
//                cell.jia.hidden=YES;
//                cell.jian.hidden=YES;
//                cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weight"];
//                float TotalPrice=[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weight"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PRICE"] floatValue];
//                cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",TotalPrice];
//            }
//            else
//            {
//                cell.lblName.text=[NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"DES"]];
//                
//                cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"total"];
//                float TotalPrice=[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"total"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PRICE"] floatValue];
//                cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",TotalPrice];
//            }
//            
//        }
//        /**
//         *  判断是否是套餐
//         */
//        if ([[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"ISTC"] intValue]==1) {
//            cell.jia.hidden=YES;
//            cell.jian.hidden=YES;
//            cell.btnEdit.userInteractionEnabled=NO;
//            cell.tfCount.textColor=[UIColor lightGrayColor];
//            cell.tfCount.backgroundColor=[UIColor clearColor];
//        }
//        cell.lblAddition.textColor=[UIColor blackColor];
//        //cell.lblTotalPrice.text=cell.tfPrice.text;
//    }
//    else
//    {
//        cell.jia.hidden=YES;
//        cell.jian.hidden=YES;
//        cell.btnAdd.hidden=YES;
//        cell.btnReduce.hidden=YES;
//        cell.tfCount.backgroundColor=[UIColor clearColor];
//        cell.lblName.text=[NSString stringWithFormat:@"---%@",[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"PNAME"]];
//        cell.tfPrice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"PRICE"] floatValue]];
//        cell.lblUnit.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"UNIT"];
//        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"UNITCUR"] intValue]==2)
//            cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"Weight"];
//        else
//            cell.tfCount.text=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"total"];
//        cell.tfCount.textColor=[UIColor lightGrayColor];
//    }
//    /**
//     *  附加项
//     */
//    NSArray *additions=[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"];
//    /**
//     *  判断是否有附加项
//     */
//    if ([[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"]!=nil) {
//        NSMutableString *str=[[NSMutableString alloc] init];
//        /**
//         *  根据附加项来改变cell的宽度
//         */
//        for (int i=0; i<[additions count]; i++){
//            [str appendFormat:@"%@,",[[additions objectAtIndex:i] objectForKey:@"FNAME"]];
//        }
//        CGSize size = CGSizeMake(440,10000);  //设置宽高，其中高为允许的最大高度
//        CGSize labelsize = [str sizeWithFont:cell.lblAddition.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];    //通过文本_lblContent.text的字数，字体的大小，限制的高度大小以及模式来获取label的大小
//        [cell.lblAddition setFrame:CGRectMake(cell.lblAddition.frame.origin.x,cell.lblAddition.frame.origin.y,labelsize.width,labelsize.height)];  //最后根据这个大小设置label的frame即可
//        cell.lblAddition.text=str;
//    }
//    if ([[[_dataArray objectAtIndex:indexPath.row]  objectForKey:@"addition"] count]!=0) {
//        cell.lb.text=@"附加项:";
//        cell.lblLine.frame=CGRectMake(0, cell.lblAddition.frame.origin.y+cell.lblAddition.frame.size.height, 768, 2);
//    }else
//        cell.lblLine.frame=CGRectMake(0, 49, 768, 2);
//    cell.indexPath = indexPath;
//    return cell;
//}
//
//#pragma mark -
//#pragma mark LogCellDelegate
////赠菜
//-(void)cell:(BSLogCell *)cell present:(BOOL)ZS{
//    tvOrder.userInteractionEnabled=NO;
//    _dict=[NSMutableDictionary dictionary];
//    _dict=[_dataArray objectAtIndex:cell.indexPath.row];
//    if (ZS==NO) {
//        if ([[_dict objectForKey:@"total"] intValue]==1) {
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否取消赠送" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//            tvOrder.userInteractionEnabled=YES;
//            alert.tag=1;
//            [alert show];
//        }else
//        {
//            vChuck = [[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:3];
//            vChuck.delegate = self;
//            //            vChuck.center = btnChuck.center;
//            [self.view addSubview:vChuck];
//            [vChuck firstAnimation];
//            vChuck.lblcount.hidden=NO;
//            vChuck.tfcount.hidden=NO;
//            
//        }
//        
//        //        cell.lblTotalPrice.text=[NSString stringWithFormat:@"%.2f",[cell.tfPrice.text floatValue]*[cell.tfCount.text floatValue]];
//    }
//    else
//    {
//        float zeng;
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Zeng"]) {
//            zeng=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Zeng"] floatValue];
//        }else
//        {
//            zeng=49;
//        }
//        if([cell.tfPrice.text floatValue]<zeng)
//        {
//            vChuck = [[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:3];
//            vChuck.delegate = self;
//            //            vChuck.center = btnChuck.center;
//            [self.view addSubview:vChuck];
//            [vChuck firstAnimation];
//            if ([[_dict objectForKey:@"total"] intValue]>1) {
//                vChuck.lblcount.hidden=NO;
//                vChuck.tfcount.hidden=NO;
//                vChuck.tffan.hidden=NO;
//                vChuck.lblfan.hidden=NO;
//            }else
//            {
//                vChuck.lblcount.hidden=NO;
//                vChuck.tfcount.hidden=NO;
//                vChuck.tffan.hidden=NO;
//                vChuck.lblfan.hidden=NO;
//                _promonum=@"1";
//            }
//            
//        }
//        else
//        {
//            
//            //            cell.lblTotalPrice.text=@"0";
//            tvOrder.userInteractionEnabled=NO;
//            vChuck = [[BSChuckView alloc] initWithFrame:CGRectMake(0, 0, 492, 354) withTag:2];
//            vChuck.delegate = self;
//            //            vChuck.center = btnChuck.center;
//            [self.view addSubview:vChuck];
//            [vChuck firstAnimation];
//            
//            if ([[_dict objectForKey:@"total"] intValue]>1) {
//                vChuck.lblcount.hidden=NO;
//                vChuck.tfcount.hidden=NO;
//                vChuck.tffan.hidden=NO;
//                vChuck.lblfan.hidden=NO;
//            }
//            else
//            {
//                vChuck.lblcount.hidden=YES;
//                vChuck.tfcount.hidden=YES;
//                vChuck.tffan.hidden=YES;
//                vChuck.lblfan.hidden=YES;
//                _promonum=@"1";
//            }
//        }
//    }
//    [tvOrder reloadData];
//    [self updateTitle];
//    
//}

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
        [tvOrder reloadData];
        [self updateTitle];
    }else if (alertView.tag==2)
    {
        if (buttonIndex==1) {
            BSDataProvider *dp=[BSDataProvider sharedInstance];
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
//- (void)chuckOrderWithOptions:(NSDictionary *)info{
//    tvOrder.userInteractionEnabled=YES;
//    if (info) {
//        if ([info objectForKey:@"count"]!=nil||[info objectForKey:@"recount"]!=nil) {
//            if ([[info objectForKey:@"count"] intValue]>[[_dict objectForKey:@"total"] intValue]-[[_dict objectForKey:@"promonum"] intValue]||[[info objectForKey:@"recount"] intValue]>[[_dict objectForKey:@"promonum"] intValue]) {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The input number is wrong"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//                [alert show];
//                return;
//            }
//        }
//        if ([vChuck.tfcount.text intValue]>0&&[vChuck.tffan.text intValue]>0) {
//            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"The input number is wrong"] message:nil  delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//            [alert show];
//            return;
//        }
//        
//        if ([info count]==3) {
//            NSString *str=[NSString stringWithFormat:@"%d",[[_dict objectForKey:@"promonum"] intValue]+[[info objectForKey:@"count"] intValue]-[[info objectForKey:@"recount"] intValue] ];
//            [_dict setValue:str  forKey:@"promonum"];
//            [_dict setValue:[info objectForKey:@"INIT"] forKey:@"promoReason"];
//            [self dismissViews];
//        }else
//        {
//            BSDataProvider *dp=[BSDataProvider sharedInstance];
//            NSDictionary *dict=[dp checkAuth:info];
//            NSLog(@"%@",dict);
//            if (dict) {
//                NSString *result = [[[dict objectForKey:@"ns:checkAuthResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
//                NSArray *ary1 = [result componentsSeparatedByString:@"@"];
//                NSLog(@"%@",ary1);
//                if ([ary1 count]==1) {
//                    UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//                    [alwet show];
//                }
//                
//                else
//                {
//                    
//                    if ([[ary1 objectAtIndex:0] isEqualToString:@"0"]) {
//                        UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//                        [alwet show];
//                        if ([vChuck.tfcount.text intValue]>0) {
//                            NSString *str=[NSString stringWithFormat:@"%d",[[_dict objectForKey:@"promonum"] intValue]+[[info objectForKey:@"count"] intValue]-[[info objectForKey:@"recount"] intValue] ];
//                            [_dict setValue:str  forKey:@"promonum"];
//                            [_dict setValue:[info objectForKey:@"INIT"] forKey:@"promoReason"];
//                            [self dismissViews];
//                        }else
//                        {
//                            [_dict setValue:_promonum forKey:@"promonum"];
//                            if ([[_dict objectForKey:@"ISTC"] intValue]==1) {
//                                for (int i=0; i<[_dataArray count]; i++) {
//                                    if ([[_dict objectForKey:@"DES"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNANE"]]&&[[_dict objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]]) {
//                                        [[_dataArray objectAtIndex:i] setValue:@"0" forKey:@"promonum"];
//                                    }
//                                }
//                                
//                            }
//                        }
//                        [_dict setValue:[info objectForKey:@"INIT"] forKey:@"promoReason"];
//                        [self dismissViews];
//                    }
//                    else
//                    {
//                        UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
//                        [alwet show];
//                    }
//                }
//            }
//        }
//    }
//    else
//    {
//        [self dismissViews];
//    }
//    [tvOrder reloadData];
//    [self updateTitle];
//}


////退菜
//- (void)cell:(BSLogCell *)cell countChanged:(float)count{
//    int index = cell.indexPath.row;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:index]];
//    
//    if (count>0){
//        [dic setObject:[NSString stringWithFormat:@"%.2f",count] forKey:@"total"];
//        [_dataArray replaceObjectAtIndex:index withObject:dic];
//    }
//    else{
//        NSMutableArray *array=[[NSMutableArray alloc] init];
//        int k=0;
//        NSString *tpcode;
//        if ([[[_dataArray objectAtIndex:index] objectForKey:@"ISTC"] intValue]==1) {
//            [[BSDataProvider sharedInstance] delectcombo:[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"] andNUM:[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"]];
//            k=[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] intValue];
//            int j=[_dataArray count];
//            tpcode=[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"];
//            for (int i=0;i<j;i++) {
//                if (([[[_dataArray objectAtIndex:index] objectForKey:@"DES"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"DES"]]&&[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]])||([[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"PCODE"]]&&[[[_dataArray objectAtIndex:index] objectForKey:@"TPNUM"] isEqualToString:[[_dataArray objectAtIndex:i] objectForKey:@"TPNUM"]])) {
//                    [array addObject:[NSString stringWithFormat:@"%d",i]];
//                }
//            }
//            for (int i=0; i<[array count]; i++) {
//                [_dataArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]-i];
//            }
//            for (NSMutableDictionary *food in _dataArray) {
//                if ([[food objectForKey:@"ITCODE"] isEqualToString:tpcode]||[[food objectForKey:@"PCODE"] isEqualToString:tpcode]) {
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
//            [[BSDataProvider sharedInstance] delectdish:[[_dataArray objectAtIndex:index] objectForKey:@"ITCODE"]];
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
//    int i=[[dic objectForKey:@"total"] intValue];
//    [dic setValue:[NSString stringWithFormat:@"%d", i+count] forKey:@"total"];
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
//    [self performSelector:@selector(updateTitle)];
//    [tvOrder reloadData];
//}
#pragma mark Bottom Buttons Events
//返回按钮的事件
- (void)back{
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
            BSDataProvider *dp=[BSDataProvider sharedInstance];
            [dp cache:_dataArray];
            [SVProgressHUD showSuccessWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Save Success"]];
        }
    }
}

//发送按钮事件
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
                immediateOrWait=@"2";
                if (_SEND==YES) {
                    return;
                }
                _SEND=YES;
            }else
            {
                
                immediateOrWait=@"1";
                if (_SEND==YES) {
                    return;
                }
                _SEND=YES;
                
            }
            [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:immediateOrWait,@"immediateOrWait",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"username"],@"user",[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"] objectForKey:@"password"],@"pwd",[Singleton sharedSingleton].Seat,@"table",@"1",@"pn",@"N",@"type", nil];
            [NSThread detachNewThreadSelector:@selector(checkFood:) toTarget:self withObject:info];
        }
    }
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
#pragma mark CommonView Delegate
- (void)setCommon:(NSArray *)ary{
    if (ary) {
        if ([ary count]==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择后再发送" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            return;
        }
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."]];
        NSArray *array=[[NSArray alloc] initWithArray:ary];
        NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(specialRemark:) object:array];
        [thread start];
    }
    else
    {
        [self dismissViews];
    }
}
/**
 *  特别备注
 *
 *  @param ary 选择的特别备注
 */
-(void)specialRemark:(NSArray *)ary
{
    BSDataProvider *dp=[BSDataProvider sharedInstance];
    NSDictionary *dict=[dp specialRemark:ary];
    [SVProgressHUD dismiss];
    NSString *result = [[[dict objectForKey:@"ns:specialRemarkResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    if ([[ary1 objectAtIndex:0] intValue]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[ary1 lastObject] delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        NSMutableString *str2=[NSMutableString string];
        for (NSDictionary *value in ary)
        {
            [str2 appendFormat:@"%@ ",[NSString stringWithFormat:@" %@",[value objectForKey:@"DES"]]];
        }
        lblCommon.text=str2;
        [alert show];
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[ary1 lastObject] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
    [self dismissViews];
}
/**
 *  发送
 *
 *  @param info 菜品信息
 */
- (void)checkFood:(NSDictionary *)info{
    NSMutableArray *array=[[NSMutableArray alloc] initWithArray:[Singleton sharedSingleton].dishArray];
    int i=0,j=0;
    for (NSDictionary *dict in _dataArray) {
        if ([[dict objectForKey:@"isShow"] boolValue]==NO&&[[dict objectForKey:@"ISTC"] intValue]==1) {
            NSRange range = NSMakeRange(i+1+j,[[dict  objectForKey:@"combo"] count]);
            j=[[dict objectForKey:@"combo"] count];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [array insertObjects:[dict objectForKey:@"combo"] atIndexes:indexSet];
        }
        i++;
    }
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    NSDictionary *dict = [dp checkFoodAvailable:array info:info tag:1];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if ([ary count]==1) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[ary lastObject]
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSString *content=[ary objectAtIndex:1];
            NSString *str=[ary objectAtIndex:0];
            if ([str isEqualToString:@"0"]) {
                [_dataArray removeAllObjects];
                [tvOrder reloadData];
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:[ary lastObject]];
                [self updateTitle];
                [Singleton sharedSingleton].dishArray=_dataArray;
                if (![[Singleton sharedSingleton] isYudian]) {
                    [self quertView];
                }                }
            else
            {
                NSLog(@"%@",content);
                _SEND=NO;
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[ary lastObject]
                                                               message:nil
                                                              delegate:nil
                                                     cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]
                                                     otherButtonTitles:nil];
                [alert show];
                [SVProgressHUD dismiss];
            }
        }
    }
    else
    {
        _SEND=NO;
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Send Failed" ]];
    }
    
}


#pragma mark - 计算价格
- (void)updateTitle{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    float count = 0.0f;
    float fPrice = 0.0f;
    float fAdditionPrice = 0.0f;
    int i=0;
    for (NSDictionary *dic in _dataArray){
        if ([dic objectForKey:@"ITCODE"])
        {
            if ([[dic objectForKey:@"total"] floatValue]>0)
            {
                float fCount = [[dic objectForKey:@"total"] floatValue];
                float price = [[dic objectForKey:@"PRICE"] floatValue];
                float fTotal=0.0f;
                if ([[dic objectForKey:@"promonum"] isEqualToString:@"1"]) {
                    fTotal = price*fCount-price*[[dic objectForKey:@"promonum"] intValue];
                }
                else
                {
                    fTotal = price*fCount;
                }
                count +=fCount;
                fPrice += fTotal;
            }
        }
        i++;
        fAdditionPrice+=([self additionPrice:[dic objectForKey:@"addition"]])*[[dic objectForKey:@"total"] floatValue];
        if ([[dic objectForKey:@"ISTC"] intValue]==1&&![dic objectForKey:@"isShow"]) {
            for (NSDictionary *comboDic in [dic objectForKey:@"combo"]) {
                fAdditionPrice+=[self additionPrice:[comboDic objectForKey:@"addition"]];
            }
        }
    }
    lblTitle.text = [NSString stringWithFormat:[langSetting localizedString:@"QueryTitle"],count,fPrice,fAdditionPrice];
}
#pragma mark - 计算附加项价格
-(float)additionPrice:(NSArray *)array
{
    float fAdditionPrice=0.00;
    for (NSDictionary *dicAdd in array){
        BOOL bAdd = YES;
        for (NSDictionary *dicCommonAdd in aryCommon){
            if ([[dicAdd objectForKey:@"DES"] isEqualToString:[dicCommonAdd objectForKey:@"DES"]])
                bAdd = NO;
        }
        if (bAdd)
            fAdditionPrice += [[dicAdd objectForKey:@"FPRICE"] floatValue]*[[dicAdd objectForKey:@"count"] floatValue];
    }
    
    for (NSDictionary *dicCommonAdd in aryCommon){
        fAdditionPrice += [[dicCommonAdd objectForKey:@"PRICE1"] floatValue];
    }
    return fAdditionPrice;
    
}
/**
 *  关闭全单备注或授权
 */
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

#pragma mark - 跳转台位
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
#pragma mark - 跳转全单
-(void)quertView
{
        BSQueryViewController *bsq=[[BSQueryViewController alloc] init];
        [self.navigationController pushViewController:bsq animated:YES];
}
#pragma mark - 删除全部
//删除全部的按钮事件
- (void)deleteAll{
    [_dataArray removeAllObjects];
    BSDataProvider *dp=[BSDataProvider sharedInstance];
    [dp delectCache];
    [Singleton sharedSingleton].dishArray=_dataArray;
    [tvOrder reloadData];
    [self performSelector:@selector(updateTitle)];
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

