//
//  AKSelectCheck.m
//  BookSystem
//
//  Created by chensen on 13-12-22.
//
//

#import "AKSelectCheck.h"
#import "BSDataProvider.h"
#import "Singleton.h"
#import "AKsCanDanListClass.h"
#import "AKsYouHuiListClass.h"
#import "AKSelectCheckCell.h"
#import "AKsIsVipShowView.h"
#import "SVProgressHUD.h"
#import "CVLocalizationSetting.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"
@interface AKSelectCheck ()
//20111121
@end

@implementation AKSelectCheck
{
    NSMutableDictionary      *_dataDic;
    NSMutableArray      *_orderArray;
    UITableView         *_foodtable;
    UITableView         *_orderTable;
    AKsIsVipShowView    *showVip;
    UISearchBar         *_orderSearch;
    NSMutableDictionary *_searchDic;
    NSMutableArray      *searchByName;
    NSMutableArray      *searchByPhone;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[SearchCoreManager share] Reset];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _dataArray=[[NSMutableArray alloc] init];
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(queryAllOrders) toTarget:self withObject:nil];
//    NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(queryAllOrders) object:nil];
//    [thread start];
    
//    [AKsNetAccessClass sharedNetAccess].showVipMessageDict=nil;
    
}
-(void)queryAllOrders
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict  =[dp queryAllOrders];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"tag"] intValue]==0) {
        searchByName=[NSMutableArray array];
        searchByPhone=[NSMutableArray array];
        
        _searchDic=[[NSMutableDictionary alloc] init];
        _orderArray=[dict objectForKey:@"message"];
        for (int i=0; i<[_orderArray count]; i++) {
            NSDictionary *dict1=[_orderArray objectAtIndex:i];
            [dict1 setValue:[NSNumber numberWithInt:i] forKey:@"ID"];
            [_searchDic setObject:dict1 forKey:[dict1 objectForKey:@"ID"]];
            [[SearchCoreManager share] AddContact:[NSNumber numberWithInt:i] name:[dict1 objectForKey:@"orderid"] phone:[NSArray arrayWithObjects:[dict1 objectForKey:@"Tablename"], nil]];
        }
        [_orderTable reloadData];
        NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
        if ([_orderArray count]>0) {
            [_orderTable selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self queryProduct:[_orderArray objectAtIndex:0]];
        }
        
        
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:searchByName phoneMatch:searchByPhone];
    [_orderTable reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    AKMySegmentAndView *akv=[[AKMySegmentAndView alloc]init];
    akv.delegate=self;
    akv.frame=CGRectMake(0, 0, 768, 114);
    [[akv.subviews objectAtIndex:1]removeFromSuperview];
    [[akv.subviews objectAtIndex:1]removeFromSuperview];
    NSLog(@"%@",akv.subviews);
    [self.view addSubview:akv];
    [self searchBarInit];
    _orderTable=[[UITableView alloc] initWithFrame:CGRectMake(10, 100, 260, 1024-200) style:UITableViewStylePlain];
    //    _orderTable.backgroundColor=[UIColor redColor];
    _orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTable.delegate=self;
    _orderTable.dataSource=self;
    
    _orderTable.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    
    _orderTable.layer.borderWidth = 2;
    _orderTable.layer.borderColor = [[UIColor blackColor] CGColor];
    
    [self.view addSubview:_orderTable];
    _foodtable=[[UITableView alloc] initWithFrame:CGRectMake(270,120-70, 768-280, 1024-210+60) style:UITableViewStylePlain];
    //    _foodtable.backgroundColor=[UIColor blueColor];
    
    _foodtable.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    
    _foodtable.layer.borderWidth = 2;
    _foodtable.layer.borderColor = [[UIColor blackColor] CGColor];
    _foodtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _foodtable.delegate=self;
    _foodtable.dataSource=self;
    [self.view addSubview:_foodtable];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((768-164)/2+60,1004-54, 135, 54);
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 120, 30)];
    lb.text=[[CVLocalizationSetting sharedInstance] localizedString:@"Back"];
    lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:25];
    lb.backgroundColor=[UIColor clearColor];
    lb.textColor=[UIColor whiteColor];
    [btn addSubview:lb];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
}
/**
 *  查询账单
 *
 *  @param orderId 账单号
 */
-(void)queryProduct:(NSDictionary *)orderId
{
    BSDataProvider *dp=[BSDataProvider sharedInstance];
    [Singleton sharedSingleton].CheckNum=[orderId objectForKey:@"orderid"];
    [Singleton sharedSingleton].Seat=@"";
    NSDictionary *dict=[dp paymentViewQueryProduct];
//    _dataArray=[dp paymentViewQueryProduct];
    [SVProgressHUD dismiss];
    _dataDic=nil;
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        _dataDic=[dict objectForKey:@"Message"];
//        [_dataArray addObject:[[dict objectForKey:@"Message"] objectForKey:@"foodList"]];
//        [_dataArray addObject:[NSArray arrayWithObject:[[dict objectForKey:@"Message"] objectForKey:@"whole"]]];
//        [_dataArray addObject:[[dict objectForKey:@"Message"] objectForKey:@"paymentList"]];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
//    bs_dispatch_sync_o n_main_thread(^{
        [_foodtable reloadData];
//    });
    
}
-(void)btnClick
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_orderTable]) {
        if ([_orderSearch.text length]<=0) {
            return [_orderArray count];
        }else
        {
            return [searchByName count] + [searchByPhone count];
        }
        
    }else
    {
        if (section==0) {
            return [[_dataDic objectForKey:@"foodList"] count];
        }else if(section==1)
        {
            return 1;
        }else
        {
            return [[_dataDic objectForKey:@"paymentList"] count];
        }
//        return [[_dataArray objectAtIndex:section] count];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_orderTable]) {
        return 1;
    }else
    {
        return 3;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:_orderTable])
    {
        return 40;
    }else
    {
        
        if (section==0) {
            return 70;
        }else
        {
            return 40;
        }
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768-164, 70)];
    view.backgroundColor=[UIColor lightGrayColor];
    if ([tableView isEqual:_orderTable]) {
        view.frame=CGRectMake(0, 0, 768-164, 40);
        UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(30,0,100, 40)];
        lb1.text=@"账单号";
        lb1.backgroundColor=[UIColor clearColor];
        lb1.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb1];
        UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(170, 0,59, 40)];
        lb2.text=@"台位号";
        lb2.backgroundColor=[UIColor clearColor];
        [view addSubview:lb2];
    }else
    {
        if (section==0) {
            float i=0.0;
            float j=0.0;
            float k=0.0;
//            NSArray *array=[_dataArray objectAtIndex:0];
            for (NSDictionary *caidan in [_dataDic objectForKey:@"foodList"]) {
//                if (![caidan.tpname isEqualToString:caidan.pcname]&&[caidan.istc intValue]==1) {
//                    
//                }else
//                {
//                    i+=[caidan.pcount floatValue];
//                    j+=[caidan.price floatValue];
//                }
//                k+=[caidan.fujiaprice floatValue];
                i+=[[caidan objectForKey:@"pcount"] intValue];
            }
            
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768-164, 30)];
            lb.text=[NSString stringWithFormat:@"共点菜品%.1f道,总计%.2f元",i,[[[[_dataDic objectForKey:@"paymentList"] objectAtIndex:0] objectForKey:@"paymentShowPrice"] floatValue]];
            lb.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lb];
            UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 30,100, 40)];
            lb1.text=@"菜品名";
            lb1.backgroundColor=[UIColor clearColor];
            lb1.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lb1];
            UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(100, 30,59, 40)];
            lb2.text=@"数量";
            lb2.backgroundColor=[UIColor clearColor];
            
            lb2.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lb2];
            UILabel *lb3=[[UILabel alloc] initWithFrame:CGRectMake(159, 30, 59, 40)];
            lb3.text=@"价格";
            lb3.backgroundColor=[UIColor clearColor];
            
            lb3.textAlignment=NSTextAlignmentRight;
            [view addSubview:lb3];
            UILabel *lb5=[[UILabel alloc] initWithFrame:CGRectMake(100+59*2, 30, 268, 40)];
            lb5.backgroundColor=[UIColor clearColor];
            
            lb5.textAlignment=NSTextAlignmentCenter;
            lb5.text=@"附加项";
            [view addSubview:lb5];
        }
        else if(section==2)
        {
            view.frame=CGRectMake(0, 0, 768-164, 40);
            UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
            lb1.text=@"结算方式";
            lb1.backgroundColor=[UIColor clearColor];
            lb1.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lb1];
            UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(250, 0, 100, 40)];
            lb2.text=@"结算金额";
            lb2.backgroundColor=[UIColor clearColor];
            lb2.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lb2];
        }
        else
        {
            view.frame=CGRectMake(0, 0, 768-164, 40);
            UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
            lb1.text=@"全单附加项";
            lb1.backgroundColor=[UIColor clearColor];
            lb1.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lb1];
            
        }
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_orderTable])
    {
        static NSString *cellName1=@"ordercell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName1];
        if (!cell) {
            cell=[[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName1];
        }
        cell.textLabel.text=@"";
        cell.detailTextLabel.text=@"";
        if ([_orderSearch.text length]<=0) {
            cell.textLabel.text=[[_orderArray objectAtIndex:indexPath.row] objectForKey:@"orderid"];
            cell.detailTextLabel.text=[[_orderArray objectAtIndex:indexPath.row] objectForKey:@"Tablename"];
            cell.detailTextLabel.textColor=[UIColor blackColor];
            return cell;
        }
        NSNumber *localID = nil;
        NSMutableString *matchString = [NSMutableString string];
        NSMutableArray *matchPos = [NSMutableArray array];
        if (indexPath.row < [searchByName count]) {
            localID = [searchByName objectAtIndex:indexPath.row];
            
            //姓名匹配 获取对应匹配的拼音串 及高亮位置
            if ([_orderSearch.text length]) {
                [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
            }
        } else {
            localID = [searchByPhone objectAtIndex:indexPath.row-[searchByName count]];
            NSMutableArray *matchPhones = [NSMutableArray array];
            
            //号码匹配 获取对应匹配的号码串 及高亮位置
            if ([_orderSearch.text length]) {
                [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                [matchString appendString:[matchPhones objectAtIndex:0]];
            }
        }
        //        ContactPeople *contact = [self.contactDic objectForKey:localID];
        NSDictionary   *dict=[_searchDic objectForKey:localID];
        cell.textLabel.text = [dict objectForKey:@"orderid"];
        cell.detailTextLabel.text = [dict objectForKey:@"Tablename"];
        return cell;
        
    }else{
        static NSString *cellName=@"cell";
        AKSelectCheckCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[AKSelectCheckCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        cell.name.text=@"";
        cell.count1.text=@"";
        cell.price.text=@"";
        cell.unit.text=@"";
        cell.textLabel.text=@"";
        cell.addition.text=@"";
        if (indexPath.section==0) {
            cell.name.frame=CGRectMake(0, 0,100, 60);
            cell.count1.frame=CGRectMake(100, 0,59, 60);
            cell.price.frame=CGRectMake(159, 0, 59, 60);
            cell.unit.frame=CGRectMake(100+59*2, 0, 59, 60);
            NSDictionary *dict=[[_dataDic objectForKey:@"foodList"] objectAtIndex:indexPath.row];
            cell.name.text=[dict objectForKey:@"PCname"];
            cell.count1.text=[dict objectForKey:@"pcount"];
            cell.price.text=[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"price"] floatValue]];
            cell.price.textAlignment=NSTextAlignmentRight;
            //        cell.unit.text=((AKsCanDanListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).unit;
            cell.addition.text=[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"fujianame"],[dict objectForKey:@"fujiaprice"]];
        }
        else if(indexPath.section==1){
            cell.textLabel.text=[_dataDic objectForKey:@"whole"];
        }else if(indexPath.section==2){
            NSDictionary *dict=[[_dataDic objectForKey:@"paymentList"] objectAtIndex:indexPath.row];
            cell.count1.frame=CGRectMake(0, 0, 0, 0);
            cell.addition.frame=CGRectMake(0, 0, 0, 0);
            cell.name.frame=CGRectMake(0, 0, 250, 60);
            cell.price.frame=CGRectMake(250, 0, 100, 60);
            cell.name.text=[dict objectForKey:@"paymentName"];
            cell.price.text=[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"paymentShowPrice"] floatValue]];
            
        }
        return cell;
    }
}
- (void)searchBarInit {
    _orderSearch= [[UISearchBar alloc] initWithFrame:CGRectMake(10, 45, 260, 50)];
    _orderSearch.autocorrectionType = UITextAutocorrectionTypeNo;
	_orderSearch.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_orderSearch.keyboardType = UIKeyboardTypeDefault;
	_orderSearch.backgroundColor=[UIColor clearColor];
	_orderSearch.translucent=YES;
	_orderSearch.placeholder=@"搜索";
	_orderSearch.delegate = self;
	_orderSearch.barStyle=UIBarStyleDefault;
    [self.view addSubview:_orderSearch];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_orderTable])
    {
        [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [self queryProduct:[_orderArray objectAtIndex:indexPath.row]];
    }
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
