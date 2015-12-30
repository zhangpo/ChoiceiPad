//
//  AKShouldCheckView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/21.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKShouldCheckView.h"
#import "BSDataProvider.h"

@implementation AKShouldCheckView
{
    NSArray *_dataArray;
    UIPopoverController *pop;
    UITableView *_tableView;
}
@synthesize timer=_timer,delegate=_delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:button];
        button.tag=100;
        [button setBackgroundImage:[UIImage imageNamed:@"ShouldCheak.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shouldCheckData) userInfo:nil repeats:YES];
    }
    return self;
}
static AKShouldCheckView *_shared;
+(AKShouldCheckView *)shared
{
    if (!_shared) {
        _shared=[[AKShouldCheckView alloc] initWithFrame:CGRectZero];
    }
    return _shared;
}
static AKShouldCheckView *_sharedDest;
+(AKShouldCheckView *)sharedDest
{
    if (!_sharedDest) {
        _sharedDest=[[AKShouldCheckView alloc] initWithFrame:CGRectZero];
    }
    return _sharedDest;
}
#pragma mark - 开始计时
-(void)startTimer
{
    [_timer setFireDate:[NSDate date]];
}
#pragma mark - 暂停
-(void)pauseTimer
{
     [_timer setFireDate:[NSDate distantFuture]];
}
#pragma mark - 刷新数据
-(void)shouldCheck
{
    [NSThread detachNewThreadSelector:@selector(shouldCheckData) toTarget:self withObject:nil];
}
-(void)shouldCheckData
{
    [_timer invalidate];
    BSDataProvider *bp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[bp shouldCheckData];
    _dataArray=[dict objectForKey:@"data"];
    if ([_dataArray count]>0) {
//        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shouldCheckData) userInfo:nil repeats:YES];
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, 60, 60);
        UIView *view=[self viewWithTag:100];
        view.frame=CGRectMake(0, 0, 60, 60);
        
    }else
    {
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        UIView *view=[self viewWithTag:100];
        view.frame=CGRectZero;
    }
    [_tableView reloadData];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shouldCheckData) userInfo:nil repeats:YES];
}
#pragma mark - 按钮事件
-(void)buttonClick:(UIButton *)btn
{
    [self pauseTimer];
    UIViewController *vc = [[UIViewController alloc] init];
    pop = [[UIPopoverController alloc] initWithContentViewController:vc];
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 354) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [vc.view addSubview:_tableView];
    
    [pop setPopoverContentSize:CGSizeMake(200, 354)];
    pop.delegate = self;
    
    [pop presentPopoverFromRect:btn.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    popoverController=nil;
    [self startTimer];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellName";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.textLabel.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"ORDERID"];
    cell.detailTextLabel.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"TBLNAME"];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   账单号                    台位";
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    [self pauseTimer];
    [_delegate shouldCheckViewClick:dict];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
