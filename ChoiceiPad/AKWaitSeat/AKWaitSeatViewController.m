//
//  AKWaitSeatViewController.m
//  ChoiceiPad
//
//  Created by chensen on 15/6/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKWaitSeatViewController.h"
#import "AKWaitSeatTableViewCell.h"
#import "SVProgressHUD.h"
#import "BSDataProvider.h"

@interface AKWaitSeatViewController ()
{
    UITableView *_tableView;
    AKWaitSeatTakeNOView *_waitSeat;
    NSMutableArray              *_waitArray;
}

@end

@implementation AKWaitSeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor clearColor];
    UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    [image setImage:[UIImage imageNamed:@"dengwei_gai.png"]];
    [self.view addSubview:image];
    
    UILabel *view=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 80)];
    view.backgroundColor=[UIColor colorWithRed:28/255.0 green:26/255.0 blue:84/255.0 alpha:1];
    view.text=@"等位取号服务";
    view.textAlignment=NSTextAlignmentCenter;
    view.font=[UIFont boldSystemFontOfSize:30];
    view.textColor=[UIColor whiteColor];
    [self.view addSubview:view];
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:[UIImage imageNamed:@"tuichu.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame=CGRectMake(20, 20, 40, 40);
    button1.tag=100;
    [self.view addSubview:button1];
    AKWaitSeatTypView *seatTyp=[[AKWaitSeatTypView alloc] initWithFrame:CGRectMake(20, 100, 728, 80)];
    seatTyp.delegate=self;
    [self.view addSubview:seatTyp];
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 180, 768, 800) style:UITableViewStylePlain];
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
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==100) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _waitSeat.frame=CGRectMake(0, 634, 768, 400);
            _tableView.frame=CGRectMake(0, 180, 768, 800-360);
        } completion:^(BOOL finished) {
        
        }];
    }
    
}
-(void)AKWaitSeatTypViewClick:(NSDictionary *)info
{
    
    [info setValue:@"" forKey:@"lineno"];
//    if (![info objectForKey:@"history"]) {
        [info setValue:@"" forKey:@"history"];
//    }
    [SVProgressHUD showProgress:-1 status:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(queryNO:) toTarget:self withObject:info];
}
-(void)queryNO:(NSDictionary *)info
{
    [_waitArray removeAllObjects];
    _waitArray=[[NSMutableArray alloc] init];
    NSArray *array=[[BSDataProvider sharedInstance] queryNO:info];
    [SVProgressHUD dismiss];
    
    NSMutableArray *ary=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        if ([[dict objectForKey:@"vcode"] isEqualToString:[info objectForKey:@"vcode"]]) {
            [_waitArray addObjectsFromArray:[dict objectForKey:@"waits"]];
            break;
        }
        if ([[dict objectForKey:@"vname"] isEqualToString:@"LS"]||[[dict objectForKey:@"vname"] isEqualToString:[info objectForKey:@"vcode"]]) {
            [_waitArray addObjectsFromArray:[dict objectForKey:@"waits"]];
        }
        if ([[info objectForKey:@"vcode"] isEqualToString:@""]&&![[dict objectForKey:@"vname"] isEqualToString:@"LS"]) {
            [ary addObjectsFromArray:[dict objectForKey:@"waits"]];
            _waitArray=ary;
        }
        
    }
    [_tableView reloadData];
}
-(void)AKWaitSeatTakeNOViewClick:(NSDictionary *)info
{
    if (!info) {
        [UIView animateWithDuration:0.5 animations:^{
            _waitSeat.frame=CGRectMake(0, 1024, 768, 400);
            _tableView.frame=CGRectMake(0, 180, 768, 800);
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [SVProgressHUD showProgress:-1 status:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(takeNo:) toTarget:self withObject:info];
    }
}
-(void)takeNo:(NSDictionary *)info
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] takeNO:info];
    [SVProgressHUD dismiss];
    if([[dict objectForKey:@"Result"] boolValue]==NO){
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"取号成功" message:[dict objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate=self;
    }
    [cell setDataInfo:[_waitArray objectAtIndex:indexPath.row]];
    return cell;
}
-(void)AKWaitSeatTableViewCell:(NSDictionary *)info
{
    if ([[info objectForKey:@"TAG"] intValue]==1) {
        [SVProgressHUD showProgress:-1 status:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(callNumber:) toTarget:self withObject:info];
    }else
    {
        if ([[info objectForKey:@"TAG"] intValue]==1) {
            [info setValue:@"D" forKey:@"sta"];
        }else
        {
            [info setValue:@"C" forKey:@"sta"];
        }
        [SVProgressHUD showProgress:-1 status:@"数据加载中" maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(cancelSeat:) toTarget:self withObject:info];
    }
}
-(void)callNumber:(NSDictionary *)info
{
//    "{\"vcode\":\"" + wait.getType().getVcode() + "\",\"call\":\"" + wait.getRec() + "\"}"
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[info objectForKey:@"vcode"],@"vcode",[info objectForKey:@"rec"],@"call", nil];
    NSDictionary *dict=[[BSDataProvider sharedInstance] cancelSeat:dic];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
}
-(void)cancelSeat:(NSDictionary *)info
{
    NSDictionary *dict=[[BSDataProvider sharedInstance] cancelSeat:info];
    [SVProgressHUD dismiss];
    if ([[dict objectForKey:@"Result"] boolValue]==YES) {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }else
    {
        [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
    }
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

@end
