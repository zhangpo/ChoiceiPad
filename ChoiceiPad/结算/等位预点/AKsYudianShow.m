//
//  AKsYudianShow.m
//  BookSystem
//
//  Created by sundaoran on 13-12-28.
//
//

#import "AKsYudianShow.h"
#import "AKsCanDanListClass.h"
#import "Singleton.h"
#import "CVLocalizationSetting.h"

@implementation AKsYudianShow
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_zhifuArray;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame andArray:(NSMutableArray *)array andPayArray:(NSMutableArray *)payArray
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _dataArray=[[NSMutableArray alloc]initWithArray:array];
        _zhifuArray=[[NSMutableArray alloc]initWithArray:payArray];
        [self creatView];
        
    }
    return self;
}

-(void)creatView
{
    
    UIView *view=[[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    UIView *title=[[UIView alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width,75)];
    title.backgroundColor=[UIColor colorWithRed:245/255.0 green:202/255.0 blue:0 alpha:1];
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 75)];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.text=@"预点餐详情";
    lbl.textColor=[UIColor whiteColor];
    lbl.userInteractionEnabled=YES;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:25];
    [title addSubview:lbl];
    [view addSubview:title];
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 75, self.bounds.size.width, view.bounds.size.height-155) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight=40;
    _tableView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [view addSubview:_tableView];
    NSArray *array=[[NSArray alloc] initWithObjects:@"转正式台",@"加 菜",@"取消等位",[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"], nil];
    for (int i=1; i<=4; i++) {
        UIButton *sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame=CGRectMake(20+95*(i-1), self.bounds.size.height-60, 90, 40);
        sureButton.titleLabel.textColor=[UIColor whiteColor];
        sureButton.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [sureButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sureButton setTitle:[array objectAtIndex:i-1] forState: UIControlStateNormal];
        sureButton.tag=i;
        [view addSubview:sureButton];
    }
    //    UIButton *sureButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //    sureButton.frame=CGRectMake(20, self.bounds.size.height-60, 120, 40);
    //    sureButton.titleLabel.textColor=[UIColor whiteColor];
    //    sureButton.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    //    [sureButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    //    [sureButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [sureButton setTitle:@"转正式台(即)" forState: UIControlStateNormal];
    //    sureButton.tag=1;
    //    [view addSubview:sureButton];
    //
    //    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //    addButton.frame=CGRectMake(160, self.bounds.size.height-60, 60, 40);
    //    addButton.titleLabel.textColor=[UIColor whiteColor];
    //    addButton.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    //    [addButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    //    [addButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [addButton setTitle:@"加菜" forState: UIControlStateNormal];
    //    addButton.tag=2;
    //    [view addSubview:addButton];
    //
    //    UIButton *cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //    cancleButton.frame=CGRectMake(view.bounds.size.width-80, self.bounds.size.height-60, 60, 40);
    //    cancleButton.tag=3;
    //    cancleButton.titleLabel.textColor=[UIColor whiteColor];
    //    cancleButton.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    //    [cancleButton setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
    //    [cancleButton addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [cancleButton setTitle:@"取消" forState: UIControlStateNormal];
    //    [view addSubview:cancleButton];
    //
    [self addSubview:view];
    
    
}

-(void)ButtonClick:(UIButton *)btn
{
    NSLog(@"%@",btn.titleLabel.text);
    if(1==btn.tag)
    {
        [_delegate AKsYudianShowSure];
    }else if (2==btn.tag)
    {
        [_delegate AKsYudianShowAddDish];
    }else if(3==btn.tag)
    {
        [_delegate AKsYudianDismiss];
    }
    else
    {
        [_delegate AKsYudianShowCancle];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    AKsYuDianListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[AKsYuDianListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.infoDic=[_dataArray objectAtIndex:indexPath.row];
    //    [cell setFoodDic:[_dataArray objectAtIndex:indexPath.row]];
    //    for (UIView *view in cell.contentView.subviews)
    //    {
    //        [view removeFromSuperview];
    //    }
    //    cell.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    //    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //    for (UIView *view in cell.contentView.subviews)
    //    {
    //        [view removeFromSuperview];
    //    }
    //    if(indexPath.section==0)
    //    {
    //        //        菜品显示
    //        [cell setCellForArray:[_dataArray objectAtIndex:indexPath.row]];
    //
    //    }
    //    else if(indexPath.section==1)
    //    {
    //        //        结算方式显示
    //        [cell setCellForAKsYouHuiList:[_zhifuArray objectAtIndex:indexPath.row]];
    //    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"] isEqualToString:@""])
    {
        return 90;
    }else
    {
        return 45;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([_zhifuArray count]!=0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768-370, 50)];
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768-370, 40)];
    lb.backgroundColor=[UIColor clearColor];
    lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    view.backgroundColor=[UIColor lightGrayColor];
    [view addSubview:lb];
    if(section==0)
    {
        
        lb.text=[NSString stringWithFormat:@"等位编号：%@           菜品列表",[Singleton sharedSingleton].WaitNum];
    }
    else
    {
        lb.text=@"结算方式";
    }
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return [_dataArray count];
    }
    else
    {
        return [_zhifuArray count];
    }
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
