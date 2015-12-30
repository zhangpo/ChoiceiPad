//
//  AKSelectCheck.m
//  BookSystem
//
//  Created by chensen on 13-12-22.
//
//

#import "ZCSelectCheckViewController.h"
#import "BSDataProvider.h"
#import "Singleton.h"
#import "AKSelectCheckCell.h"
#import "AKsIsVipShowView.h"
#import "SVProgressHUD.h"
#import "CVLocalizationSetting.h"
@interface ZCSelectCheckViewController ()
//20111121
@end

@implementation ZCSelectCheckViewController
{
    NSMutableArray *_dataArray;
    NSMutableArray *_SettlementArray;
    NSMutableArray *_queryPaymentsArray;
    UITableView *table;
    AKMySegmentAndView *akv;
    AKsIsVipShowView    *showVip;
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
    
    akv=[AKMySegmentAndView shared];
    [akv segmentShow:NO];
    [akv shoildCheckShow:NO];
    [self.view addSubview:akv];
    
    _dataArray=[[NSMutableArray alloc] init];
    [SVProgressHUD showProgress:-1 status:[[CVLocalizationSetting sharedInstance] localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(updata) toTarget:self withObject:nil];
//    NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(updata) object:nil];
//    [thread start];
    
//    [AKsNetAccessClass sharedNetAccess].showVipMessageDict=nil;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(0, 120-60, 164, 1024-114+60)];
    view.image=[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"SelectOrder.jpg"];
    [self.view addSubview:view];
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
    
    //    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame=CGRectMake((768-164)/2+60,940, 120, 60);
    //    [btn setTitle: forState:UIControlStateNormal];
    //    [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"TableButtonRed"] forState:UIControlStateNormal];
    //
    //    [self.view addSubview:btn];
}
-(void)updata
{
        BSDataProvider *bs=[[BSDataProvider alloc] init];
        NSDictionary *dict=[bs ZCpQuery];
        _dataArray=[dict objectForKey:@"data"];
        _SettlementArray=[dict objectForKey:@"settlement"];
//        moling=[dict objectForKey:@"moling"];
        NSDictionary *dic=[bs ZCqueryPayments];
        if ([[dic objectForKey:@"Result"]boolValue]) {
            _queryPaymentsArray=[dic objectForKey:@"Message"];
        }
    [SVProgressHUD dismiss];
    bs_dispatch_sync_on_main_thread(^{
        if ([_dataArray count]==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询结果为空或连接超时，请稍后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }else
        {
            if ([[_dataArray objectAtIndex:0] count]==0) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询结果为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
            else {
                table=[[UITableView alloc] initWithFrame:CGRectMake(164,120-60, 768-164, 1024-220+60) style:UITableViewStylePlain];
                table.separatorStyle = UITableViewCellSeparatorStyleNone;
                table.delegate=self;
                table.dataSource=self;
                [self.view addSubview:table];
            }
        }
    });
    
    
}

//-(void)queryProduct
//{
//    BSDataProvider *dp=[[BSDataProvider alloc] init];
//    _dataArray=[dp queryProduct:[Singleton sharedSingleton].Seat];

    //    [akv removeFromSuperview];
    //    akv=nil;
    //    akv= [[AKMySegmentAndView alloc] init];
    //    akv.delegate=self;
    //    akv.frame=CGRectMake(0, 0, 768, 114);
    //    [[akv.subviews objectAtIndex:1]removeFromSuperview];
    //    [self.view addSubview:akv];
//}
-(void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 60)];
//    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 30)];
//    UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0,30, 768, 30)];
//    [view addSubview:lb1];
//    [view addSubview:lb];
//    if (section==0) {
//        lb.text=@"已点菜品";
//        NSArray *array=[_dataArray objectAtIndex:0];
//        int i=0;
//        int j=0;
//        for (AKsCanDanListClass *caidan in array) {
//            if (![caidan.tpname isEqualToString:caidan.pcname]) {
//
//            }else
//            {
//                i+=[caidan.pcount intValue];
//                j+=[caidan.price intValue];
//            }
//        }
//        lb1.text=[NSString stringWithFormat:@"共点菜品%d道,总计%d元",i,j];
//        return view;
//    }
//    else
//    {
//        view.frame=CGRectMake(0, 0, 768, 30);
//        lb1.text=@"结算方式";
//        return view;
//    }
//}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"已点菜品";
    }else if (section==1){
        return @"全单附加项";
    }
    else
    {
        return @"结算方式";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [_dataArray count];
    }else if (section==1)
    {
        return [_SettlementArray count];
    }else
        return [_queryPaymentsArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 70;
    }else
    {
        return 40;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768-164, 70)];
    view.backgroundColor=[UIColor lightGrayColor];
    if (section==0) {
        float i=0.0;
        float j=0.0;
        float k=0.0;
        for (NSDictionary *caidan in _dataArray) {
            j+=[[caidan objectForKey:@"talPreice"] floatValue];
            i+=[[caidan objectForKey:@"pcount"]floatValue];
        }
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768-164, 30)];
        lb.text=[NSString stringWithFormat:@"共点菜品%.1f道,总计%.2f元",i,j];
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
        UILabel *lb4=[[UILabel alloc] initWithFrame:CGRectMake(100+59*2, 30, 59, 40)];
        lb4.text=@"单位";
        lb4.backgroundColor=[UIColor clearColor];
        
        lb4.textAlignment=NSTextAlignmentRight;
        [view addSubview:lb4];
        UILabel *lb5=[[UILabel alloc] initWithFrame:CGRectMake(100+59*3, 30, 300, 40)];
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
        lb1.text=@"账单";
        lb1.backgroundColor=[UIColor clearColor];
        lb1.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb1];
        
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    AKSelectCheckCell *cell=[table dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[AKSelectCheckCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
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
        
        cell.name.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PCname"];
        cell.count1.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"];
        cell.price.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price" ] floatValue]];
        cell.price.textAlignment=NSTextAlignmentRight;
        cell.unit.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"unit"];
        cell.addition.text=[NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujia"]];
    }
    else if(indexPath.section==1){
        cell.textLabel.text=[[_SettlementArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text=[[_SettlementArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    }else if(indexPath.section==2){
        cell.count1.frame=CGRectMake(0, 0, 0, 0);
        cell.unit.frame=CGRectMake(0, 0, 0, 0);
        cell.addition.frame=CGRectMake(0, 0, 0, 0);
        cell.name.frame=CGRectMake(0, 0, 250, 60);
        cell.price.frame=CGRectMake(250, 0, 100, 60);
        cell.name.text=[[_queryPaymentsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.price.text=[NSString stringWithFormat:@"%@",[[_queryPaymentsArray objectAtIndex:indexPath.row] objectForKey:@"price"]];
        
    }
    return cell;
}

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
