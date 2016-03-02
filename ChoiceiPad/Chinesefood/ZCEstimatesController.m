//
//  ZCEstimatesController.m
//  ChoiceiPad
//
//  Created by chensen on 15/8/14.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCEstimatesController.h"
#import "ZCEstimatesCell.h"

@interface ZCEstimatesController ()

@end

@implementation ZCEstimatesController
{
    NSMutableArray *_dataArray;
    NSMutableArray *_classArray;
    UITableView    *_tableView;
    int            _total;
    UISearchBar    *searchBar;
    NSMutableArray *_allFoodArray;
    NSMutableArray *_searchArray;
    NSDictionary   *_foodDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 80)];
    [image setImage:[UIImage imageNamed:@"title.png"]];
    [self.view addSubview:image];
    
    UILabel *view=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 80)];
    //    view.backgroundColor=[UIColor colorWithRed:188/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    view.text=@"沽清设置";
    view.textAlignment=NSTextAlignmentCenter;
    view.font=[UIFont boldSystemFontOfSize:30];
    view.backgroundColor=[UIColor clearColor];
    view.textColor=[UIColor whiteColor];
    [self.view addSubview:view];
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"tuichu.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame=CGRectMake(20, 20, 40, 40);
    button1.tag=100;
    [self.view addSubview:button1];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 130, 768, 880) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    [self searchBarInit];
    
    _allFoodArray=[[NSMutableArray alloc] init];
    _searchArray=[[NSMutableArray alloc] init];
    _total=-1;
    [NSThread detachNewThreadSelector:@selector(returnArray) toTarget:self withObject:nil];
}
-(void)buttonClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 搜索
- (void)searchBarInit {
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0,80, 768, 50)];
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
    [_searchArray removeAllObjects];
    for (NSDictionary *dict in _allFoodArray) {
        if ([[dict objectForKey:@"ITCODE"] rangeOfString:searchBar.text].location !=NSNotFound||[[dict objectForKey:@"DES"] rangeOfString:searchBar.text].location !=NSNotFound||[[[dict objectForKey:@"INIT"] uppercaseString] rangeOfString:[searchBar.text uppercaseString]].location !=NSNotFound) {
            [_searchArray addObject:dict];
        }
    }
    [_tableView reloadData];
}
-(void)returnArray
{
    [_allFoodArray removeAllObjects];
    BSDataProvider *bp=[BSDataProvider sharedInstance];
    _classArray=[NSMutableArray arrayWithArray:[bp getClassById]];//查询菜品类别
    [_classArray insertObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"套餐",@"DES",[NSString stringWithFormat:@"%d",[[[_classArray objectAtIndex:0] objectForKey:@"GRP"] intValue]-1],@"GRP", nil] atIndex:0];
    _dataArray = [BSDataProvider ZCgetAllFoodList:_classArray];
    [_classArray removeObjectAtIndex:0];
    [_dataArray removeObjectAtIndex:0];
    
    NSArray * _soldOutArray=[bp ZCEstimatesFoodList];             //估清的菜品
    for (NSArray *foodArray in _dataArray) {
        for (NSDictionary *foodDic in foodArray) {
            for (NSDictionary *code in _soldOutArray) {
                if ([[code objectForKey:@"ITCODE"] isEqualToString:[foodDic objectForKey:@"ITCODE"]]) {
                    [foodDic setValue:[NSNumber numberWithBool:YES] forKey:@"SOLDOUT"];
                    [foodDic setValue:[code objectForKey:@"CNT"] forKey:@"SOLDOUTCNT"];
                    break;
                }
            }
        }
        [_allFoodArray addObjectsFromArray:foodArray];
    }
    for (NSDictionary *foodDic in _searchArray) {
        for (NSDictionary *code in _soldOutArray) {
            if ([[code objectForKey:@"ITCODE"] isEqualToString:[foodDic objectForKey:@"ITCODE"]]) {
                [foodDic setValue:[NSNumber numberWithBool:YES] forKey:@"SOLDOUT"];
                [foodDic setValue:[code objectForKey:@"CNT"] forKey:@"SOLDOUTCNT"];
                break;
            }
        }
    }
    
    bs_dispatch_sync_on_main_thread(^{
        [_tableView reloadData];
    });
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if (searchBar.text.length>0) {
        return 1;
    }
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (searchBar.text.length>0) {
        return [_searchArray count];
    }
    if (section==_total) {
        return [[_dataArray objectAtIndex:_total] count];
    }else
    {
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (searchBar.text.length>0) {
        return nil;
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 40)];
    view.backgroundColor=[UIColor whiteColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 768, 39);
    
    button.tag=section;
    button.backgroundColor=[UIColor lightGrayColor];
    
    [button setTitle:[[_classArray objectAtIndex:section] objectForKey:@"DES"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}
-(void)headerClick:(UIButton *)button
{
    if (button.tag==_total)
        _total=-1;
    else
        _total=button.tag;
    bs_dispatch_sync_on_main_thread(^{
        
        [_tableView reloadData];
        if (_total>=0) {
            if ([[_dataArray objectAtIndex:_total] count]>0&&_total>=0) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:_total];
                [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
        }
        
    });
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName=@"cellName";
    ZCEstimatesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[ZCEstimatesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
//
//    cell.userInteractionEnabled = NO;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    cell.delegate=self;
    NSDictionary *foodDic=nil;
    if (searchBar.text.length>0)
        foodDic=[_searchArray objectAtIndex:indexPath.row];
    else
        foodDic=[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.estimatesDic=foodDic;
    return cell;
}
-(void)ZCEstimatesCellClick:(NSDictionary *)info
{
    [searchBar endEditing:YES];
    if ([[info objectForKey:@"TAG"] intValue]==100) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入沽清数量" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *tf1=[alert textFieldAtIndex:0];
        tf1.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNHexNumberpad" owner:self options:nil] objectAtIndex:0];
        [alert show];
        _foodDic=info;
    }else
    {
        [SVProgressHUD showProgress:-1 status:@"设置沽清中" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(ZCEstimates:) toTarget:self withObject:info];
    }
}
-(void)ZCEstimates:(NSDictionary *)info{
    NSDictionary *dict=[[BSDataProvider sharedInstance] ZCSetEstimatesFoodList:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        [self returnArray];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        UITextField *tf=[alertView textFieldAtIndex:0];
        [_foodDic setValue:tf.text forKey:@"cnt"];
        [SVProgressHUD showProgress:-1 status:@"设置沽清中" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(ZCEstimates:) toTarget:self withObject:_foodDic];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
