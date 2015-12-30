//
//  AKSwitchTableView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/1/19.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKSwitchTableView.h"
#import "AKSwitchTableViewCell.h"

@implementation AKSwitchTableView
{
    int _TAG;
    NSDictionary *_aimsDic;
    NSDictionary *_currentDic;
}
@synthesize aimsArray=_aimsArray,currentArray=_currentArray,delegate=_delegate;
/**
 *  初始化
 *
 *  @param frame
 *  @param tag   1  换台    2并台
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame withTag:(int)tag
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code、
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:[UIImage imageNamed:@"huantai_bg.png"]];
        [self addSubview:imageView];
        
        _TAG=tag;
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        label.font=[UIFont systemFontOfSize:20];
        label.textAlignment=UITextAlignmentCenter;
        [self addSubview:label];
        
        if (_TAG==1) {
            label.text=@"换台";
        }else
        {
            label.text=@"并台";
        }
        NSArray *array=[[NSArray alloc] initWithObjects:@"当前台位",@"目标台位", nil];
        for (int i=0; i<2; i++) {
            UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(100+265*i, 70, 195, 40)];
            lb.text=[array objectAtIndex:i];
            lb.textAlignment=UITextAlignmentCenter;
            lb.backgroundColor=[UIColor clearColor];
            [self addSubview:lb];
            UITableView *table=[[UITableView alloc] initWithFrame:CGRectMake(100+265*i, 110, 195, 440) style:UITableViewStylePlain];
            table.tag=100+i;
            table.delegate=self;
            table.dataSource=self;
            table.layer.borderColor = [[UIColor grayColor] CGColor];
            table.layer.borderWidth = 2;
            table.layer.cornerRadius = 10;
            [self addSubview:table];
            lb=[[UILabel alloc] initWithFrame:CGRectMake(100+265*i, 580, 195, 40)];
            lb.text=[NSString stringWithFormat:@"%@:",[array objectAtIndex:i]];
            lb.textAlignment=UITextAlignmentLeft;
            lb.backgroundColor=[UIColor clearColor];
            [self addSubview:lb];
            lb=[[UILabel alloc] initWithFrame:CGRectMake(100+265*i, 620, 195, 40)];
            lb.textAlignment=UITextAlignmentLeft;
            lb.backgroundColor=[UIColor clearColor];
            lb.layer.borderColor = [[UIColor grayColor] CGColor];
            lb.layer.borderWidth = 2;
            lb.tag=200+i;
            [self addSubview:lb];
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(110+265*i, 686, 190, 60);
            button.titleLabel.textColor=[UIColor whiteColor];
            button.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [button setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];

            if (i==0) {
                if (_TAG==1) {
                    [button setTitle:@"换台" forState:UIControlStateNormal];
                    button.tag=300;
                }else
                {
                    [button setTitle:@"并台" forState:UIControlStateNormal];
                    button.tag=301;
                }
            }else
            {
                [button setTitle:@"取消" forState:UIControlStateNormal];
                button.tag=302;

            }
            
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
       
       
        
    }
    return self;
}
/**
 *  目标台位
 *
 *  @param aimsArray
 */
-(void)setAimsArray:(NSArray *)aimsArray
{
    _aimsArray=aimsArray;
    if ([aimsArray count]>0) {
        UITableView *table=(UITableView *)[self viewWithTag:101];
        [table reloadData];
        NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
        UILabel *label=(UILabel *)[self viewWithTag:201];
        if ([Mode isEqualToString:@"zc"])
            label.text=[[_aimsArray objectAtIndex:0] objectForKey:@"name"];
        else
            label.text=[[_aimsArray objectAtIndex:0] objectForKey:@"num"];
        [table selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
        _aimsDic=[aimsArray objectAtIndex:0];
    }
    
}
/**
 *  原台位
 *
 *  @param currentArray
 */
-(void)setCurrentArray:(NSArray *)currentArray
{
    _currentArray=currentArray;
    UITableView *table=(UITableView *)[self viewWithTag:100];
    [table reloadData];
    if ([currentArray count]>0) {
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    [table selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
    UILabel *label=(UILabel *)[self viewWithTag:200];
        if ([Mode isEqualToString:@"zc"])
            label.text=[[currentArray objectAtIndex:0] objectForKey:@"name"];
        else
            label.text=[[currentArray objectAtIndex:0] objectForKey:@"num"];
    _currentDic=[currentArray objectAtIndex:0];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==100) {
        return [_currentArray count];
    }else
    {
        return [_aimsArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName=@"cellName";
    AKSwitchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[AKSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text=@"";
    if (tableView.tag==100) {
        if ([Mode isEqualToString:@"zc"]) {
            cell.textLabel.text=[[_currentArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        }else
        {
            cell.textLabel.text=[[_currentArray objectAtIndex:indexPath.row] objectForKey:@"num"];
        }
        
    }else
    {
        if ([Mode isEqualToString:@"zc"]) {
            cell.textLabel.text=[[_aimsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        }else
        {
            cell.textLabel.text=[[_aimsArray objectAtIndex:indexPath.row] objectForKey:@"num"];
        }
        
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100) {
        UILabel *label=(UILabel *)[self viewWithTag:200];
        if ([Mode isEqualToString:@"zc"]) {
            label.text=[[_currentArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        }else
        {
            label.text=[[_currentArray objectAtIndex:indexPath.row] objectForKey:@"num"];
        }
        
        
        _currentDic=[_currentArray objectAtIndex:indexPath.row];
    }else
    {
        UILabel *label=(UILabel *)[self viewWithTag:201];
        if ([Mode isEqualToString:@"zc"]) {
            label.text=[[_aimsArray objectAtIndex:indexPath.row] objectForKey:@"name"];
        }else
        {
            label.text=[[_aimsArray objectAtIndex:indexPath.row] objectForKey:@"num"];
        }
        _aimsDic=[_aimsArray objectAtIndex:indexPath.row];
    }
}
-(void)btnClick:(UIButton *)btn
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    if (btn.tag==300) {
        if ([Mode isEqualToString:@"zc"]) {
            [dic setObject:[_currentDic objectForKey:@"short"] forKey:@"oldtable"];
            [dic setObject:[_aimsDic objectForKey:@"short"] forKey:@"newtable"];
        }else
        {
        [dic setObject:[_currentDic objectForKey:@"name"] forKey:@"oldtable"];
        [dic setObject:[_aimsDic objectForKey:@"name"] forKey:@"newtable"];
        }
        [_delegate switchTableWithOptions:dic];
    }else if (btn.tag==301)
    {
        [dic setObject:[_currentDic objectForKey:@"name"] forKey:@"oldtable"];
        [dic setObject:[_aimsDic objectForKey:@"name"] forKey:@"newtable"];
        [_delegate multipleTableWithOptions:dic];
    }else if(btn.tag==302)
    {
        if (_TAG==1) {
            [_delegate switchTableWithOptions:nil];
        }else
        {
            [_delegate multipleTableWithOptions:nil];
        }
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
