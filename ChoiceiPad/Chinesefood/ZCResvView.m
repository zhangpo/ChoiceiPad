//
//  ZCResvView.m
//  ChoiceiPad
//
//  Created by chensen on 15/8/6.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCResvView.h"
#import "AKSelectCheckCell.h"

@implementation ZCResvView
{
    UITableView *_tableView;
}
@synthesize resvDic=_resvDic,delegate=_delegate;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:frame];
        [imageView setImage:[UIImage imageNamed:@"huantai_bg.png"]];
        [self addSubview:imageView];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        label.font=[UIFont systemFontOfSize:20];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=@"预定信息查询";
        [self addSubview:label];
        _tableView =[[UITableView alloc] initWithFrame:CGRectMake(10, 60, CGRectGetWidth(self.frame)-10, 600) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        _tableView.layer.borderColor = [[UIColor grayColor] CGColor];
//        _tableView.layer.borderWidth = 2;
//        _tableView.layer.cornerRadius = 10;
        [self addSubview:_tableView];
        for (int i=0; i<2; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(110+265*i, 686, 190, 60);
            button.titleLabel.textColor=[UIColor whiteColor];
            button.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [button setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
            
            if (i==0) {
                button.tag=1;
                [button setTitle:@"转台" forState:UIControlStateNormal];
            }else
            {
                button.tag=2;
                [button setTitle:@"取消" forState:UIControlStateNormal];
            }
            
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }

    }
    return self;
}
-(void)setResvDic:(NSDictionary *)resvDic
{
    _resvDic=resvDic;
    bs_dispatch_sync_on_main_thread(^{
        [_tableView reloadData];
    });
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 10;
    }
//    return 0;
    else
    {
        return [[_resvDic objectForKey:@"food"] count];
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"预定信息";
    }else
    {
        return @"预定菜品";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 44;
    }else
    {
        return 60;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        static NSString *cellName=@"cellName";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        }
        NSString *titleName,*titleValue;
        switch (indexPath.row) {
            case 0:{
                    titleName=@"客人类型:";
                    NSString *typ=[_resvDic objectForKey:@"TYP"];
                    if ([typ isEqualToString:@"O"]) {
                    titleValue=@"老客户";
                    }else if ([typ isEqualToString:@"G"])
                    {
                        titleValue=@"普通客户";
                    }else
                    {
                        titleValue=@"新客户";
                    }
                }
                break;
            case 1:
                titleName=@"客人姓名:";
                titleValue=[_resvDic objectForKey:@"NAM"];
                break;
            case 2:
                titleName=@"预定人姓名:";
                titleValue=[_resvDic objectForKey:@"SUBJECT"];
                break;
            case 3:
                titleName=@"业务员:";
                titleValue=[_resvDic objectForKey:@"SPCLIENT"];
                break;
            case 4:
                titleName=@"预到时间:";
                titleValue=[_resvDic objectForKey:@"TIMEFROM"];
                break;
                
            case 5:
                titleName=@"单位:";
                titleValue=[_resvDic objectForKey:@"FIRM"];
                break;
            case 6:
                titleName=@"电话:";
                titleValue=[_resvDic objectForKey:@"CONTACT"];
                break;
            case 7:
                titleName=@"备注:";
                titleValue=[_resvDic objectForKey:@"MEMO"];
                break;
            case 8:
                titleName=@"人数:";
                titleValue=[_resvDic objectForKey:@"PAX"];
                break;
            case 9:
                titleName=@"桌数:";
                titleValue=[_resvDic objectForKey:@"TABLES"];
                break;
            default:
                break;
        }
        cell.textLabel.text=titleName;
        cell.detailTextLabel.text=titleValue;
        return cell;
    }
    else{
        static NSString *cellName=@"cellName1";
        AKSelectCheckCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell=[[AKSelectCheckCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        }
        NSDictionary *food=[[_resvDic objectForKey:@"food"] objectAtIndex:indexPath.row];
        cell.name.frame=CGRectMake(0, 0, 200, 60);
        cell.count1.frame=CGRectMake(200,0, 60, 60);
        cell.price.frame=CGRectMake(260,0, 60, 60);
        cell.unit.frame=CGRectMake(320,0, 60, 60);
        cell.addition.frame=CGRectMake(380,0, 280, 60);
        cell.name.text=[food objectForKey:@"DES"];
        
        cell.count1.text=[food objectForKey:@"CNT"];
        cell.price.text=[food objectForKey:@"PRICE"];
        cell.unit.text=[food objectForKey:@"UNIT"];
        return cell;
    }
    
}
-(void)btnClick:(UIButton *)btn
{
    [_delegate ZCResvViewClick:btn.tag];
}
@end
