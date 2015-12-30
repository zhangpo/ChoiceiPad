//
//  ZCSettlementViewController.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-7-15.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "ZCSettlementViewController.h"
#import "CVLocalizationSetting.h"
#import "BSDataProvider.h"
#import "Singleton.h"
#import "AKMySegmentAndView.h"
#import "AKsNewVipViewController.h"



@interface ZCSettlementViewController ()

@end

@implementation ZCSettlementViewController
{
    UITableView                 *_tvOrder;
    NSArray                     *_dataArray;
    NSMutableArray              *_SettlementArray;
    AKsMoneyVIew                *_moneyView;
    NSArray                     *_paytypArray;
    NSMutableArray              *_queryPaymentsArray;
    UIScrollView                *_viewbank;
    UIScrollView                *_viewPayment;
    UIControl                   *_control;
    NSString                    *moling;
    NSMutableArray              *_paymentsArray;
    NSArray                     *_selectPayments;
    NSMutableDictionary         *_couponDic;
    AKsNewVipSelectView         *_VipView;
    NSMutableDictionary         *_settlementDic;
    ZCPrintQueryView            *vPrint;            //打印view
    ZCTmpacctView               *_tmpacctView;      //活动view
    NSMutableArray              *_foodArray;        //选择的菜品
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
    AKMySegmentAndView *segmen=[AKMySegmentAndView shared];
    [segmen segmentShow:NO];
    [segmen shoildCheckShow:NO];
    [self.view addSubview:segmen];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _paymentsArray=[[NSMutableArray alloc] init];
    _queryPaymentsArray=[[NSMutableArray alloc] init];
    _foodArray         =[[NSMutableArray alloc] init];
    
    //菜品列表
    _tvOrder=[[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 800) style:UITableViewStylePlain];
    _tvOrder.delegate=self;
//    _tvOrder.backgroundColor=[UIColor redColor];
    
    _tvOrder.dataSource=self;
    [self.view addSubview:_tvOrder];
    /**
     *  数据查询
     */
    [self updata];
    AKCouponView *coupon=[[AKCouponView alloc] initWithFrame:CGRectMake(324, 124-54, 430, 830)];
    coupon.delegate=self;
    coupon.tag=9000;
    [self.view addSubview:coupon];
    /**
     *  按钮
     */
    NSArray *array=[NSArray arrayWithObjects:[[CVLocalizationSetting sharedInstance] localizedString:@"Payment"],[[CVLocalizationSetting sharedInstance] localizedString:@"CancelPayment"],@"取消优惠",[[CVLocalizationSetting sharedInstance] localizedString:@"Print"],[[CVLocalizationSetting sharedInstance] localizedString:@"Back"], nil];
    for (int i=0;i<[array count];i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.tag=i;
        btn.frame=CGRectMake(10+(768-50)/[array count]*i, 1024-70,780/[array count] , 50);
//        btn.frame=CGRectMake((768-20)/7*(i+2), 1024-70, 130, 50);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
 
}
/**
 *  查询数据
 */
-(void)updata
{
    bs_dispatch_sync_on_main_thread(^{
        BSDataProvider *bs=[[BSDataProvider alloc] init];
        NSDictionary *dict=[bs ZCpQuery];
        _dataArray=[dict objectForKey:@"data"];
        _SettlementArray=[dict objectForKey:@"settlement"];
        moling=[dict objectForKey:@"moling"];
        NSDictionary *dic=[bs ZCqueryPayments];
        if ([[dic objectForKey:@"Result"]boolValue]) {
            _queryPaymentsArray=[dic objectForKey:@"Message"];
        }
        [Singleton sharedSingleton].dueAmt= [[_SettlementArray lastObject] objectForKey:@"price"];
        [_tvOrder reloadData];
        if ([_queryPaymentsArray count]>0) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[_queryPaymentsArray count]-1 inSection:2];
            [_tvOrder scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        if ([[[_SettlementArray lastObject] objectForKey:@"price"]floatValue]<=0) {
            [bs ZCpaymentFinish];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"结算完成，返回台位" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            alert.tag=100;
            [alert show];
        }
    });
}
#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [_dataArray count];
    }else if (section==1)
    {
        return [_SettlementArray count];
    }else
    {
        return [_queryPaymentsArray count];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.text=@"";
    cell.detailTextLabel.text=@"";
    cell.backgroundColor=[UIColor whiteColor];
    if (indexPath.section==0) {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"SELECT"] boolValue]==YES) {
            cell.backgroundColor=[UIColor redColor];
        }
        cell.textLabel.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PCname"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"talPreice"]floatValue]];
    }else if(indexPath.section==1)
    {
        cell.textLabel.text=[[_SettlementArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f",[[[_SettlementArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
//        cell.backgroundColor=[UIColor greenColor];
    }else
    {
        cell.textLabel.text=[[_queryPaymentsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f",[[[_queryPaymentsArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView* myView = [[UIView alloc] init];
//    myView.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:1];
    if (section==0) {
        titleLabel.text=@"已点菜品";
    }else if(section==1)
    {
        titleLabel.text=@"附加费用";
    }else
    {
        titleLabel.text=@"结算方式";
    }
//    [myView addSubview:titleLabel];
    return titleLabel;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"SELECT"] boolValue]==NO||[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"SELECT"]==nil) {
            [[_dataArray objectAtIndex:indexPath.row] setObject:@"YES" forKey:@"SELECT"];
            [_foodArray addObject:[_dataArray objectAtIndex:indexPath.row]];
        }else
        {
            [[_dataArray objectAtIndex:indexPath.row] setObject:@"NO" forKey:@"SELECT"];
            [_foodArray removeObject:[_dataArray objectAtIndex:indexPath.row]];
        }
        [_tvOrder reloadData];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tvOrder)
    {
        //YOUR_HEIGHT 为最高的那个headerView的高度
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
/**
 *  按钮事件
 *
 *  @param btn
 */
-(void)btnClick:(UIButton *)btn
{
    if (btn.tag==0) {
        /**
         *  支付按钮事件
         */
        if (_viewPayment&&[_viewPayment subviews]) {
            [_viewPayment removeFromSuperview];
            _viewPayment=nil;
        }
        if (_viewbank&&[_viewbank subviews]) {
            [_viewbank removeFromSuperview];
            _viewbank=nil;
        }
        //
        if (!_paytypArray) {
            /**
             *  判断有没有支付方式，如果没有查询
             */
            BSDataProvider *bs=[[BSDataProvider alloc] init];
            _paytypArray=[bs selecePayment];
        }
        [self greatSettlementType];
    }else if (btn.tag==1)
    {
        for (NSDictionary *dict in _queryPaymentsArray) {
            if ([[dict objectForKey:@"typ"] intValue]==6) {
                [self plainPassword:10008];
                return;
            }
        }
        [SVProgressHUD showProgress:-1 status:@"Load···" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(cancelPayment:) toTarget:self withObject:nil];
        /**
         *  取消支付
         */
    }else if (btn.tag==2){
        
        [SVProgressHUD showProgress:-1 status:@"Load···" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(cancelActm:) toTarget:self withObject:nil];
//    }else if (btn.tag==3){
//        AKsNewVipViewController *vipView=[[AKsNewVipViewController alloc] init];
//        [self.navigationController pushViewController:vipView animated:YES];
    }else if (btn.tag==3){
        [self printQuery];
    }
    else{
        /**
         *  返回
         */
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
#pragma mark 取消支付
-(void)cancelPayment:(NSString *)password
{
    BSDataProvider *bs=[BSDataProvider sharedInstance];
    NSDictionary *dict=[bs ZCcancelPayment:password];
    if ([[dict objectForKey:@"Result"] boolValue]) {
        [self updata];
        /**
         *  取消支付成功
         */
        [SVProgressHUD showSuccessWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Succeed"]];
    }else
    {
        /**
         *  取消支付失败
         */
        [SVProgressHUD showSuccessWithStatus:[[CVLocalizationSetting sharedInstance] localizedString:@"Failure"]];
    }

}
#pragma mark - 取消优惠
-(void)cancelActm:(NSString *)password
{
    
    BSDataProvider *bs=[BSDataProvider sharedInstance];
    NSDictionary *dict=[bs ZCcancelActm:password==nil?@"":password];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
        [self updata];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
    }
    
}
#pragma mark - 支付方式类别
/**
 *  支付方式类别
 */
-(void)greatSettlementType
{
    //    [self dismissViews];
    _tvOrder.userInteractionEnabled=NO;
    _viewbank=[[UIScrollView alloc]initWithFrame:CGRectMake(134, 300, 470, 300)];
    _viewbank.backgroundColor=[UIColor colorWithRed:26/255.0 green:76/255.0 blue:109/255.0 alpha:1];
    //    [_viewbank addGestureRecognizer:_pan];
    for (int i=0; i<[_paytypArray count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeView.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeViewSelect.png"] forState:UIControlStateHighlighted];
        button.titleLabel.font=[UIFont systemFontOfSize:20];
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        button.titleLabel.text=[[_paytypArray objectAtIndex:i] objectForKey:@"des"];
        [button setTitle:[[_paytypArray objectAtIndex:i] objectForKey:@"des"] forState:UIControlStateNormal];
//        button.tag=[((AKsSettlementClass *)[array objectAtIndex:i]).SettlementId intValue];
        button.tag=i;
        if ([[[_paytypArray objectAtIndex:i] objectForKey:@"payment"] count]>0) {
            [button addTarget:self action:@selector(settlementTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        button.frame=CGRectMake(i%3*150+10,i/3*75+10, 140, 65);
        [_viewbank addSubview:button];
        _viewbank.contentSize=CGSizeMake(470, i/3*75+75);
        
    }
    [self.view addSubview:_viewbank];
    
}
#pragma mark - 支付方式类别的点击事件
-(void)settlementTypeButtonClick:(UIButton *)btn
{
    if ([[_paytypArray objectAtIndex:btn.tag] objectForKey:@"payment"]>0) {
        for (UIView *view in [_viewbank subviews]) {
            [view removeFromSuperview];
        }
        [_viewbank removeFromSuperview];
        _viewbank=nil;
        _viewPayment=[[UIScrollView alloc]initWithFrame:CGRectMake(134, 300, 470, 300)];
        _viewPayment.backgroundColor=[UIColor colorWithRed:26/255.0 green:76/255.0 blue:109/255.0 alpha:1];
        _selectPayments=[[_paytypArray objectAtIndex:btn.tag] objectForKey:@"payment"];
        /**
         *  生成支付方式按钮
         */
        for (int i=0; i<[_selectPayments count]; i++)
        {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeView.png"] forState:UIControlStateNormal];
                [button setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"PrivilegeViewSelect.png"] forState:UIControlStateHighlighted];
                button.titleLabel.font=[UIFont systemFontOfSize:20];
                button.titleLabel.textAlignment=NSTextAlignmentCenter;
                button.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                button.titleLabel.text=[[_selectPayments objectAtIndex:i] objectForKey:@"des"];
                [button setTitle:[[_selectPayments objectAtIndex:i] objectForKey:@"des"] forState:UIControlStateNormal];
                //        button.tag=[((AKsSettlementClass *)[array objectAtIndex:i]).SettlementId intValue];
                button.tag=i;
                [button addTarget:self action:@selector(settlement:) forControlEvents:UIControlEventTouchUpInside];
                button.frame=CGRectMake(i%3*150+10,i/3*75+10, 140, 65);
                [_viewPayment addSubview:button];
                _viewPayment.contentSize=CGSizeMake(470, i/3*75+75);
        }
        [self.view addSubview:_viewPayment];
    }
}
#pragma mark - 支付方式事件
-(void)settlement:(UIButton *)btn
{
    if(!_moneyView)
    {
        /**
         *
         */
        [_viewPayment removeFromSuperview];
        _viewPayment=nil;
        _settlementDic=[_selectPayments objectAtIndex:btn.tag];
        if([[_settlementDic objectForKey:@"typ"] intValue]==6)
        {
            [self vipSelectView];
            return;
        }
        
        
        _moneyView=[[AKsMoneyVIew alloc] initWithFrame:CGRectMake(0, 0, 493, 354) withPayment:_settlementDic];
        [self.view addSubview:_moneyView];
        _moneyView.delegate=self;
        
    }
    else
    {
        [_moneyView removeFromSuperview];
        _moneyView  =nil;
    }

}
#pragma mark - 手势操作
#pragma mark - 根据手势关闭视图
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    BOOL bDismiss = YES;
    CGPoint pt;
    if (_viewPayment && _viewPayment.superview){
        _tvOrder.userInteractionEnabled=YES;
        pt = [touch locationInView:_viewPayment];
        bDismiss = !(pt.x>=0 && pt.y<_viewPayment.frame.size.width);
    }
    
    if (_viewbank && _viewbank.superview){
        _tvOrder.userInteractionEnabled=YES;
        pt = [touch locationInView:_viewbank];
        bDismiss = !(pt.x>=0 && pt.y<_viewbank.frame.size.width);
    }
    if (_viewPayment) {
        _tvOrder.userInteractionEnabled=YES;
        [_viewPayment removeFromSuperview];
        _viewPayment=nil;
        [self greatSettlementType];
    }else if (_viewbank)
    {
        [_viewbank removeFromSuperview];
        _viewbank=nil;
    }
}
#pragma mark - 使用支付
-(void)AKsMoneyVIewClick:(NSDictionary *)info
{
    /**
     *  移除视图
     */
    [_moneyView removeFromSuperview];
    _moneyView=nil;
    if (!info) {
        return;
    }
    //判断是否挂账
    if([[_settlementDic objectForKey:@"typ"] intValue]==9)
    {
        NSArray *array=[[BSDataProvider sharedInstance] ZCTmpacct];
        if ([array count]>0) {
            [_selectPayments setValue:[info objectForKey:@"paymentMoney"] forKey:@"AMT"];
            _tmpacctView=[[ZCTmpacctView alloc] initWithFrame:CGRectMake(0, 0, 660, 790)];
//            _settlementDic=[NSMutableDictionary dictionaryWithDictionary:info];
            _tmpacctView.delegate=self;
            _tmpacctView.center = CGPointMake(768/2, (1004-27)/2);
            _tmpacctView.tmpacctArray=array;
            [self.view addSubview:_tmpacctView];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"没有找到挂账账号"];
        }
        
        return;
    }
    //判断是否会员
    if ([[_settlementDic objectForKey:@"typ"] intValue]==6) {
        _settlementDic=[NSMutableDictionary dictionaryWithDictionary:info];
        [self plainPassword:10007];
        return;
    }
    
    BSDataProvider *bd=[BSDataProvider sharedInstance];
    float prict=0.2f;
    [info setValue:@"0" forKey:@"moling"];
    prict=[[[_SettlementArray lastObject] objectForKey:@"price"] floatValue];
    NSString *money=[info objectForKey:@"paymentMoney"];
    /**
     *  判断是否支付完成
     */
    if (prict<=[money floatValue]) {
        [info setValue:moling forKey:@"moling"];
        [info setValue:@"Y" forKey:@"flag"];
        NSDictionary *dict=[bd ZCuserPayment:info];
        
        _tvOrder.userInteractionEnabled=YES;
        if ([[dict objectForKey:@"Result"]boolValue]) {
            NSDictionary *dict1=[bd ZCpriPrintOrder:@"2"];
            [SVProgressHUD dismiss];
            if ([[dict1 objectForKey:@"Result"]boolValue]) {
                if (prict<[money floatValue]) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"支付完成，需找零%.2f元",[money floatValue]-prict] message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
                    alert.tag=100;
                    [alert show];
                }else if (prict==[money floatValue])
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"结算完成，返回台位" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
                    alert.tag=100;
                    [alert show];
                    
                }else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:Nil delegate:Nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles: nil];
                    [alert show];
                    
                }
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"结算完成，打印预结单失败,返回台位" message:nil delegate:self cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
                alert.tag=100;
                [alert show];
            }
            
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }

    }else
    {
        [info setValue:@"N" forKey:@"flag"];
        NSDictionary *dict=[bd ZCuserPayment:info];
        if ([[dict objectForKey:@"Result"]boolValue])
        {
            _tvOrder.userInteractionEnabled=YES;
            [self updata];
        }else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
        
    }
    _settlementDic=nil;
    _tvOrder.userInteractionEnabled=YES;
}
-(void)ZCTmpacctClick:(NSDictionary *)tmpacct
{
    if (tmpacct) {
        float prict=[[[_SettlementArray lastObject] objectForKey:@"price"] floatValue];
        [_settlementDic setObject:[tmpacct objectForKey:@"ITCODE"] forKey:@"ITCODE"];
        [_settlementDic setObject:prict>=[[_settlementDic objectForKey:@"AMT"] floatValue]?@"Y":@"N" forKey:@"TAG"];
        [NSThread detachNewThreadSelector:@selector(ZCTmpacctPost) toTarget:self withObject:nil];
    }
    [_tmpacctView removeFromSuperview];
    _tmpacctView=nil;
}
-(void)ZCTmpacctPost
{
    BSDataProvider *dp=[BSDataProvider sharedInstance];
    NSDictionary *dict=[dp ZCTmpacctPost:_settlementDic];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        [self updata];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"msg"]];
    }
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        NSArray *array=[self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    }else if (alertView.tag==10007) {
        UITextField *tf1=[alertView textFieldAtIndex:0];
        [_settlementDic setObject:tf1.text forKey:@"cardPassword"];
        [self cardPayment];
    }else if (alertView.tag==10008) {
        if (buttonIndex==1) {
            UITextField *tf1=[alertView textFieldAtIndex:0];
            [SVProgressHUD showProgress:-1 status:@"Load···" maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(cancelPayment:) toTarget:self withObject:tf1.text];

        }
    }else if (alertView.tag==10004){
        [self ATWILL];
    }
    else{
        if(buttonIndex==1){
            if (alertView.tag==10001)
            {
                UITextField *tf1=[alertView textFieldAtIndex:0];
                if ([tf1.text length]==0) {
                    [SVProgressHUD showErrorWithStatus:@"输入错误"];
                    return;
                }
                [_couponDic setObject:tf1.text forKey:@"phoneamt"];
            }else if (alertView.tag==10002)
            {
                UITextField *tf1=[alertView textFieldAtIndex:0];
                if ([tf1.text length]==0) {
                    [SVProgressHUD showErrorWithStatus:@"输入错误"];
                    return;
                }
                [_couponDic setObject:tf1.text forKey:@"phoneamt"];
            }else if (alertView.tag==10003)
            {
                
                UITextField *tf1=[alertView textFieldAtIndex:0];
                if ([tf1.text floatValue]>[[Singleton sharedSingleton].dueAmt floatValue]) {
                    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"金额输入错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    alert.tag=10004;
                    return;
                }
                [_couponDic setObject:tf1.text forKey:@"phoneamt"];
                if ([tf1.text length]==0) {
                    [SVProgressHUD showErrorWithStatus:@"输入错误"];
                    return;
                }
                tf1=[alertView textFieldAtIndex:1];
                
                [_couponDic setObject:tf1.text forKey:@"phanddes"];
                if ([[_couponDic objectForKey:@"ISMEMBER"] boolValue]==YES){
                    [self plainPassword:10006];
                    return;
                }
            }else if (alertView.tag==10006){
                 UITextField *tf1=[alertView textFieldAtIndex:0];
                [_couponDic setObject:tf1.text forKey:@"cardPassword"];
            }
            [self userActm];
        }
    }
}
#pragma mark - 会员卡储值消费
-(void)cardPayment
{
    BSDataProvider *bp=[BSDataProvider sharedInstance];
    [_settlementDic setObject:[[_SettlementArray objectAtIndex:0] objectForKey:@"price"] forKey:@"Amt"];
    NSDictionary *dict=[bp ZCcardPayment:_settlementDic];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
        [self updata];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
    }
    _settlementDic=nil;
}
#pragma mark - 活动使用
-(void)userActm
{
    BSDataProvider *bp=[BSDataProvider sharedInstance];
    [_couponDic setObject:[Singleton sharedSingleton].dueAmt forKey:@"Amt"];
    NSMutableString *food=[[NSMutableString alloc] init];
    [food appendString:@""];
    for (NSDictionary *foodDic in _foodArray) {
        [food appendString:[foodDic objectForKey:@"num"]];
        if (![foodDic isEqual:[_foodArray lastObject]]) {
            [food appendString:@","];
        }
    }
    [_couponDic setObject:food forKey:@"food"];
    NSDictionary *dict=[bp ZCuserActm:_couponDic];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"state"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
        [self updata];
    }else
    {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"msg"]];
    }
    _couponDic=nil;
}
#pragma mark - 输入会员卡
-(void)vipSelectView
{
    _VipView=[[AKsNewVipSelectView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
    _VipView.delegate=self;
    [self.view addSubview:_VipView];
}
#pragma mark - 选择会员卡
-(void)AKsNewVipSelectView:(NSDictionary *)info
{
    [_VipView removeFromSuperview];
    _VipView = nil;
    if(_settlementDic)
    {
        [_settlementDic setValuesForKeysWithDictionary:info];
        _moneyView=[[AKsMoneyVIew alloc] initWithFrame:CGRectMake(0, 0, 493, 354) withPayment:_settlementDic];
        [self.view addSubview:_moneyView];
        _moneyView.delegate=self;
    }
    if (info) {
//        [_couponDic setObject:[info objectForKey:@"number"] forKey:@"cardNo"];
        [_couponDic setValuesForKeysWithDictionary:info];
        if ([[_couponDic objectForKey:@"VATWILL"] boolValue]==YES) {
            //        BREMIT 减免金额类型 0 金额,1 比例 ,2 自由输入
            [self ATWILL];
        }else
        {
            //优惠券
            if ([[_couponDic objectForKey:@"VVOUCHERDISC"] boolValue]==YES) {
                for (NSDictionary *dict in [_couponDic objectForKey:@"ticketInfoList"]) {
                    if ([[dict objectForKey:@"couponCode"] isEqualToString:[_couponDic objectForKey:@"VVOUCHERCODE"]]) {
                        [_couponDic setObject:[dict objectForKey:@"counpId"] forKey:@"ticketCode"];
                        [_couponDic setObject:[dict objectForKey:@"couponCode"] forKey:@"ticketId"];
                        [_couponDic setObject:[dict objectForKey:@"counpMoney"] forKey:@"ticketPrice"];
                        [_couponDic setObject:[dict objectForKey:@"counpNum"] forKey:@"ticketCount"];
                        
                        [self plainPassword:10006];
                        return;
                    }
                }
                [SVProgressHUD showErrorWithStatus:@"当前会员卡没有该券"];
                return;
            }
            //反积分，反券，固定积分消费
            [self userActm];
        }
    }
}

#pragma mark - 活动使用
-(void)couponSelect:(NSDictionary *)coupon
{
    _couponDic=[NSMutableDictionary dictionaryWithDictionary:coupon];
    //判断是否会员
    if ([[coupon objectForKey:@"ISMEMBER"] boolValue]==YES) {
        [self vipSelectView];
        return;
    }
    //判断是否抹零
    if ([[coupon objectForKey:@"VNAME"] isEqualToString:@"抹零"]) {
        [_couponDic setObject:moling forKey:@"phoneamt"];
        [self userActm];
        return;
    }
    //判断是否服务费
    
    UIAlertView *alert=[[UIAlertView alloc] init];
    alert.delegate=self;
    if ([[coupon objectForKey:@"VNAME"] isEqualToString:@"服务费"]) {
        alert.title=@"服务费";
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        tf.placeholder=@"请输入服务费收取比率";
        alert.tag=10001;
        [alert addButtonWithTitle:@"取消"];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        
        return;
    }
    //判断是否是包间费
    if ([[coupon objectForKey:@"VNAME"] isEqualToString:@"包间费"]) {
        alert.title=@"包间费";
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        UITextField *tf=[alert textFieldAtIndex:0];
        tf.placeholder=@"请输入包间费";
        alert.tag=10002;
        [alert addButtonWithTitle:@"取消"];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }
    
    //任意折扣
    if ([[coupon objectForKey:@"VATWILL"] boolValue]==YES) {
//        BREMIT 减免金额类型 0 金额,1 比例 ,2 自由输入
        [self ATWILL];
        return;
    }
    //是否需要团购验证
    if ([[coupon objectForKey:@"ISVALIDATE"] boolValue]==YES) {
        alert.title=[coupon objectForKey:@"VNAME"];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
        alert.tag=10005;
        UITextField *tf=[alert textFieldAtIndex:0];
        tf.placeholder=@"请输入验证码";
        [alert addButtonWithTitle:@"取消"];
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }
    
    [self userActm];
}
#pragma mark - 任意折扣
-(void)ATWILL
{
    UIAlertView *alert=[[UIAlertView alloc] init];
    alert.title=[_couponDic objectForKey:@"VNAME"];
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    alert.delegate=self;
    alert.tag=10003;
    UITextField *tf=[alert textFieldAtIndex:0];
    if ([[_couponDic objectForKey:@"JMRDO"] intValue]==0) {
        
        tf.placeholder=@"请输入优免金额";
        if ([_couponDic objectForKey:@"integralOverall"]) {
            tf.placeholder=[NSString stringWithFormat:@"积分剩余:%@",[_couponDic objectForKey:@"integralOverall"]];
        }
    }else if ([[_couponDic objectForKey:@"JMRDO"] intValue]==1)
    {
        
        tf.placeholder=@"请输入优免比率";
        
    }
    tf=[alert textFieldAtIndex:1];
    tf.placeholder=@"请输入优免原因";
    tf.secureTextEntry = NO;
    [alert addButtonWithTitle:@"取消"];
    [alert addButtonWithTitle:@"确定"];
    [alert show];
}
#pragma mark - 输入密码
-(void)plainPassword:(int)tag{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
    UITextField *tf=[alert textFieldAtIndex:0];
    tf.placeholder=@"请输入会员卡密码";
    alert.tag=tag;
    [alert show];
}
#pragma mark - 打印
#pragma mark Bottom Buttons Events
- (void)printQuery{
    if (!vPrint){
        vPrint = [[ZCPrintQueryView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
        vPrint.delegate = self;
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
    [vPrint removeFromSuperview];
    vPrint = nil;
}
#pragma mark - 打印请求
-(void)priPrintOrder:(NSDictionary *)info
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp ZCpriPrintOrder:[info objectForKey:@"type"]];
    [SVProgressHUD dismiss];
    if (dict) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
        if ([[dict objectForKey:@"Result"] boolValue]&&[[info objectForKey:@"type"] isEqualToString:@"2"]) {
            bs_dispatch_sync_on_main_thread(^{
                NSArray *array=[self.navigationController viewControllers];
                [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
            });
        }
        
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
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
