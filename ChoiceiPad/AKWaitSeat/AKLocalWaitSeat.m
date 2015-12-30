//
//  AKWaitSeatViewController.m
//  ChoiceiPad
//
//  Created by chensen on 15/6/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKLocalWaitSeat.h"
#import "AKWaitSeatTableViewCell.h"
#import "SVProgressHUD.h"
#import "BSDataProvider.h"
#import "MMDrawerController.h"
#import "BSQueryViewController.h"
#import "AKFoodOrderViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "AKOrderLeft.h"
#import "Singleton.h"

@interface AKLocalWaitSeat ()
{
    UITableView *_tableView;
    AKWaitSeatTakeNOView *_waitSeat;
    NSMutableArray              *_waitArray;
}

@end

@implementation AKLocalWaitSeat

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor clearColor];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 80)];
    [image setImage:[UIImage imageNamed:@"title.png"]];
    [self.view addSubview:image];
    
    UILabel *view=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 80)];
//    view.backgroundColor=[UIColor colorWithRed:188/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    view.text=@"等位预定";
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
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 80, 768, 880) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 980, 768, 25);
    button.tag=101;
    [button setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _waitSeat=[[AKWaitSeatTakeNOView alloc] initWithFrame:CGRectMake(0, 1024, 768, 400)];
    _waitSeat.delegate=self;
    [self.view addSubview:_waitSeat];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _waitSeat.frame=CGRectMake(0, 1024, 768, 400);
    _tableView.frame=CGRectMake(0, 80, 768, 900);
    [SVProgressHUD showProgress:-1 status:@"Load..." maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(queryReserveTableNum) toTarget:self withObject:nil];
}
#pragma mark - 按钮事件
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _waitSeat.frame=CGRectMake(0, 634, 768, 400);
            _tableView.frame=CGRectMake(0, 80, 768, 800-260);
        } completion:^(BOOL finished) {
        }];
    }
}
#pragma mark - 查找预定列表
-(void)queryReserveTableNum
{
    BSDataProvider *bp=[BSDataProvider sharedInstance];
    NSDictionary *dict=[bp queryReserveTableNum];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        _waitArray=[dict objectForKey:@"Message"];
        [_tableView reloadData];
    }else
    {
        [_waitArray removeAllObjects];
        [_tableView reloadData];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    }
}
#pragma mark - 预定按钮
-(void)AKWaitSeatTakeNOViewClick:(NSDictionary *)info
{
    if (!info) {
        [UIView animateWithDuration:0.5 animations:^{
            _waitSeat.frame=CGRectMake(0, 1024, 768, 400);
            _tableView.frame=CGRectMake(0, 80, 768, 900);
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [SVProgressHUD showProgress:-1 status:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(takeNo:) toTarget:self withObject:info];
    }
}
#pragma mark - 添加预定
-(void)takeNo:(NSDictionary *)info
{
    [Singleton sharedSingleton].tableName=[info objectForKey:@"phone"];
    [Singleton sharedSingleton].man=[info objectForKey:@"people"];
    [Singleton sharedSingleton].woman=[info objectForKey:@"woman"];
    NSDictionary *dict=[[BSDataProvider sharedInstance] reserveTableNum:info];
    [SVProgressHUD dismiss];
    if([[dict objectForKey:@"Result"] boolValue]==NO){
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }else
    {
        
        [Singleton sharedSingleton].WaitNum=[[dict objectForKey:@"Message"] objectForKey:@"waitNum"];
        [Singleton sharedSingleton].CheckNum=[[dict objectForKey:@"Message"] objectForKey:@"CheakNum"];
        AKsOpenSucceed *openSucceed=[[AKsOpenSucceed alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
        openSucceed.delegate=self;
        openSucceed.tag=102;
        [self.view addSubview:openSucceed];
    }
}
#pragma mark - 刷新台位
- (NSArray *)getTableList:(NSDictionary *)info{
    BSDataProvider *dp = [BSDataProvider sharedInstance];
    NSDictionary *dict = [dp pListTable:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==NO) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"], nil];
        [alert show];
        return nil;
    }else
    {
        return [[dict objectForKey:@"Message"] objectForKey:@"freeTableList"];
    }

}
#pragma mark - 开台成功
-(void)OpenSucceed:(int)tag
{
    if (tag==101) {
        [Singleton sharedSingleton].isYudian=YES;
        [self AKOrder];
    }
    else if(tag==102)
    {
        [self queryReserveTableNum];
    }
    UIView *view=[self.view viewWithTag:102];
    [view removeFromSuperview];
    view=nil;
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_waitArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    AKWaitSeatTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=(AKWaitSeatTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"AKWaitSeatTableViewCell" owner:self options:nil]  lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];       cell.delegate=self;
    }
    [cell setDataInfo:[_waitArray objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark - cellDelegate
-(void)AKWaitSeatTableViewCell:(NSDictionary *)info
{
    [Singleton sharedSingleton].isYudian=YES;
    [Singleton sharedSingleton].CheckNum=[info objectForKey:@"CheakNum"];
    [Singleton sharedSingleton].Seat=[info objectForKey:@"phoneNum"];
    [Singleton sharedSingleton].tableName=[info objectForKey:@"phoneNum"];
    [Singleton sharedSingleton].man=[info objectForKey:@"manNum"];
    [Singleton sharedSingleton].woman=[info objectForKey:@"womanNum"];
    if ([[info objectForKey:@"TAG"] intValue]==1) {
        [self quertView];
    }else if ([[info objectForKey:@"TAG"] intValue]==2)
    {
        //转正式台
        AKSwitchTableView *vSwitch=[[AKSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 660, 790) withTag:1];
        vSwitch.center = CGPointMake(768/2, (1004-27)/2);
        vSwitch.currentArray=[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:[info objectForKey:@"phoneNum"],@"num",[info objectForKey:@"phoneNum"],@"name", nil], nil];
        vSwitch.tag=103;
        vSwitch.aimsArray=[self getTableList:nil];
        vSwitch.delegate=self;
        [self.view addSubview:vSwitch];
    }else
    {
//        cancelReserveTableNum
        //取消预定
        [SVProgressHUD showProgress:-1 status:@"Load..." maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(cancelReserveTableNum:) toTarget:self withObject:info];
    }
}
#pragma mark - 取消等位
-(void)cancelReserveTableNum:(NSDictionary *)info
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] cancelReserveTableNum:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        [SVProgressHUD showSuccessWithStatus:[dict objectForKey:@"Message"]];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
    [self queryReserveTableNum];
}
#pragma mark - 转正式台
-(void)switchTableWithOptions:(NSDictionary *)info
{
    if (info) {
        NSDictionary *dict=[[BSDataProvider sharedInstance] changeTableNum:info];
        if ([[dict objectForKey:@"Result"] boolValue]==YES) {
            [SVProgressHUD showProgress:-1 status:@"Load..." maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(queryReserveTableNum) toTarget:self withObject:nil];
        }
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dict objectForKey:@"Message"] message:nil delegate:nil cancelButtonTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        });
    }
    UIView *view=[self.view viewWithTag:103];
    [view removeFromSuperview];
    view=nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
/**
 
 画图形渐进色方法，此方法只支持双色值渐变
 @param context     图形上下文的CGContextRef
 @param clipRect    需要画颜色的rect
 @param startPoint  画颜色的起始点坐标
 @param endPoint    画颜色的结束点坐标
 @param options     CGGradientDrawingOptions
 @param startColor  开始的颜色值
 @param endColor    结束的颜色值
 */
- (void)DrawGradientColor:(CGContextRef)context
                     rect:(CGRect)clipRect
                    point:(CGPoint) startPoint
                    point:(CGPoint) endPoint
                  options:(CGGradientDrawingOptions) options
               startColor:(UIColor*)startColor
                 endColor:(UIColor*)endColor
{
    UIColor* colors [2] = {startColor,endColor};
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colorComponents[8];
    
    for (int i = 0; i < 2; i++) {
        UIColor *color = colors[i];
        CGColorRef temcolorRef = color.CGColor;
        
        const CGFloat *components = CGColorGetComponents(temcolorRef);
        for (int j = 0; j < 4; j++) {
            colorComponents[i * 4 + j] = components[j];
        }
    }
    
    CGGradientRef gradient =  CGGradientCreateWithColorComponents(rgb, colorComponents, NULL, 2);
    
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
    CGGradientRelease(gradient);
}
#pragma mark - 点菜
-(void)AKOrder
{
    UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
    
    UIViewController * centerViewController = [[AKFoodOrderViewController alloc] init];
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

#pragma mark - 跳转全单
-(void)quertView
{
    BSQueryViewController *bsq=[[BSQueryViewController alloc] init];
    [self.navigationController pushViewController:bsq animated:YES];
}
@end
