//
//  AKPrivateAdditionView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-8-29.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "AKPrivateAdditionView.h"
#import "BSDataProvider.h"
#import "AKComboButton.h"


@implementation AKPrivateAdditionView
{
    NSMutableArray *_dataArray;
    NSMutableArray *_selectArray;
    NSString       *_itcode;
    int            _total;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withFoodDict:(NSDictionary *)food
{
    self =[super initWithFrame:frame];
    if (self) {
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.frame];
        [imageView setImage:[UIImage imageNamed:@"huantai_bg.png"]];
        [self addSubview:imageView];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        label.font=[UIFont boldSystemFontOfSize:20];
        label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label];
        label.text=@"附加项";
        _selectArray = [NSMutableArray arrayWithArray:[food objectForKey:@"addition"]];
        _itcode=[food objectForKey:@"ITCODE"]==nil?[food objectForKey:@"PCODE1"]:[food objectForKey:@"ITCODE"];
        _dataArray = [self returnAryResult:_itcode];
        UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 40,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-200)];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(headerView.frame)-7, 50)];
        searchBar.delegate = self;
        [headerView addSubview:searchBar];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        //      [btn setTitle:@"+" forState:UIControlStateNormal];
        btn.frame = CGRectMake(CGRectGetWidth(self.frame)-60, 0, 50, 50);
        btn.backgroundColor=[UIColor clearColor];
        [headerView addSubview:btn];
        [btn addTarget:self action:@selector(addCustiomAddition) forControlEvents:UIControlEventTouchUpInside];
        headerView.frame=CGRectMake(0, 45,CGRectGetWidth(self.frame), 50);
        [self addSubview:headerView];
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(5, 100,CGRectGetWidth(self.frame)-7, CGRectGetHeight(self.frame)-200) style:UITableViewStylePlain];
        tv.delegate = self;
        tv.backgroundColor=[UIColor whiteColor];
        tv.dataSource = self;
        [self addSubview:tv];
        tv.tag = 777;
        for (int i=0; i<2; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(200+90*i, CGRectGetHeight(self.frame)-70, 80, 40);
            button.titleLabel.textColor=[UIColor whiteColor];
            button.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [button setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
            button.tag=i;
            [button setTitle:i==0?@"确定":@"取消" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}
-(void)addCustiomAddition{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"自定义附加项" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    //    WTReTextField *tf=(WTReTextField *)[alert textFieldAtIndex:0];
    UITextField *tf1=[alert textFieldAtIndex:0];
    
    //    tf.pattern = @"^[a-zA-Z0-9\u4E00-\u9FA5]";
    tf1.delegate=self;
    tf1.placeholder=@"附加项内容";
    tf1.tag=100;
    tf1=[alert textFieldAtIndex:1];
    tf1.placeholder=@"附加项金额";
    tf1.tag=101;
    tf1.delegate=self;
    tf1.keyboardType = UIKeyboardTypeNumberPad;
    tf1.secureTextEntry=NO;
    [alert show];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==_total) {
        return [[_dataArray  objectAtIndex:section] count];
    }else
    {
        return 0;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray  count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)-7, 40)];
    view.backgroundColor=[UIColor whiteColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame)-7, 39);
    [button setTitle:[NSString stringWithFormat:@"%@  %@-%@",[[[_dataArray objectAtIndex:section] lastObject] objectForKey:@"name"],[[[_dataArray objectAtIndex:section] lastObject] objectForKey:@"FMINCNT"],[[[_dataArray objectAtIndex:section] lastObject] objectForKey:@"FMAXCNT"]] forState:UIControlStateNormal];
    button.tag=section;
    button.backgroundColor=[UIColor lightGrayColor];
    [button addTarget:self action:@selector(headerClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
#pragma mark - 组标题点击事件
-(void)headerClick:(UIButton *)button
{
    if (button.tag==_total)
        _total=-1;
    else
        _total=button.tag;
    bs_dispatch_sync_on_main_thread(^{
        UITableView *tableView=(UITableView *)[self viewWithTag:777];
        [tableView reloadData];
        if (_total>=0) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:_total];
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    });
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cellName";
    AKPrivateAdditionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[AKPrivateAdditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.delegate=self;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.dataDic=[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.indexPath=indexPath;
    return cell;
}

#pragma mark - 获取数据数组
-(NSMutableArray *)returnAryResult:(NSString *)itcode
{
    NSMutableArray *ary = [[BSDataProvider sharedInstance] SelectPrivateAddition:itcode];
    NSMutableArray *myAddition=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in _selectArray) {
        BOOL RUN=NO;
        for (int i=0;i<[ary count];i++) {
            NSMutableArray *array=[ary objectAtIndex:i];
            for (int j=0;j<[array count];j++) {
                NSDictionary *dict=[array objectAtIndex:j];
                if ([[dic objectForKey:@"FCODE"] isEqualToString:[dict objectForKey:@"FCODE"]]) {
                    [array replaceObjectAtIndex:j withObject:dic];
                    RUN=YES;
                    break;
                }
            }
            if (RUN) {
                break;
            }
        }
        if (!RUN) {
            [myAddition addObject:dic];
        }
    }
    if ([myAddition count]>0) {
        [ary insertObject:myAddition atIndex:0];
    }

    return ary;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"自定义",@"name",[alertView textFieldAtIndex:0].text,@"FNAME",[NSString stringWithFormat:@"%.2f",[[alertView textFieldAtIndex:1].text floatValue]],@"FPRICE",@"1",@"count",@"PRODUCTTC_ORDER",@"PRODUCTTC_ORDER",@"",@"FCODE",nil];
        [_selectArray addObject:dict];
        [_dataArray insertObject:[NSArray arrayWithObjects:dict, nil] atIndex:0];
        UITableView *tableView=(UITableView *)[self viewWithTag:777];
        [tableView reloadData];
    }
}
#pragma mark - AKPrivateAdditionCellDelegate
-(void)AKPrivateAdditionBtnClick:(AKPrivateAdditionCell *)cell
{
    NSMutableDictionary *dict=[[_dataArray objectAtIndex:cell.indexPath.section] objectAtIndex:cell.indexPath.row];
    //TYPE加减按钮的表示
    if ([[dict objectForKey:@"TYPE"] intValue]==200) {
        int i=0;
        for (NSDictionary *dic in [_dataArray objectAtIndex:cell.indexPath.section]) {
            i+=[dic objectForKey:@"count"]==nil?0:[[dic objectForKey:@"count"] intValue];
        }
        BOOL ISYES=YES;
        //判断是否满足组条件
        if ([[dict objectForKey:@"FMAXCNT"] intValue]==i) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"已是该组最大份数" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            ISYES=NO;
        }
        //判断是否满足单个附加项条件
        if ([[dict objectForKey:@"MAXCNT"] intValue]==[[dict objectForKey:@"count"] intValue]&&ISYES) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"已是该附加项最大份数" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            ISYES=NO;
        }
        // 如果都没有添加
        if (ISYES) {
            [dict setObject:[dict objectForKey:@"count"]!=nil?[NSString stringWithFormat:@"%d",[[dict objectForKey:@"count"] intValue]+1]:@"1" forKey:@"count"];
            for (NSDictionary *dic in _selectArray) {
                if ([[dic objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[dict objectForKey:@"PRODUCTTC_ORDER"]]&&[[dic objectForKey:@"FCODE"] isEqualToString:[dict objectForKey:@"FCODE"]]) {
                    [_selectArray removeObject:dic];
                    break;
                }
            }
            [_selectArray addObject:dict];
        }
        
    }else
    {
        //        [dict setObject:[[dict objectForKey:@"count"] intValue]-1];
        [dict setObject:[dict objectForKey:@"count"]!=0?[NSString stringWithFormat:@"%d",[[dict objectForKey:@"count"] intValue]-1]:@"0" forKey:@"count"];
        for (NSDictionary *dic in _selectArray) {
            if ([[dic objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[dict objectForKey:@"PRODUCTTC_ORDER"]]&&[[dic objectForKey:@"FCODE"] isEqualToString:[dict objectForKey:@"FCODE"]]) {
                [_selectArray removeObject:dic];
                break;
            }
        }
        if ([[dict objectForKey:@"count"] intValue]>0) {
            [_selectArray addObject:dict];
        }
    }
    UITableView *tableView=(UITableView *)[self viewWithTag:777];
    cell.dataDic=[[_dataArray objectAtIndex:cell.indexPath.section] objectAtIndex:cell.indexPath.row];
    [tableView reloadData];
    
}
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==0) {
        for (NSArray *addition in _dataArray) {
            int i=0;
            for (NSDictionary *dict in addition) {
                i+=[dict objectForKey:@"count"]==nil?0:[[dict objectForKey:@"count"] intValue];
            }
            if (i<[[[addition lastObject] objectForKey:@"FMINCNT"] intValue]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@不满足条件",[[addition lastObject] objectForKey:@"name"]] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
        }
        [_delegate privateAdditionSelected:_selectArray];
    }else if (btn.tag==1){
        [_delegate privateAdditionSelected:nil];
    }
}
#pragma mark SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSArray *ary=[self returnAryResult:_itcode];
    if ([searchText length]>0){
        searchText = [searchText uppercaseString];
        [_dataArray removeAllObjects];
        for (NSArray *array in ary) {
            NSMutableArray *addition=[[NSMutableArray alloc] init];
            
            for (NSDictionary *dic in array) {
                NSString *strITCODE = [[dic objectForKey:@"FCODE"] uppercaseString];
                //            NSString *strINIT = [[dic objectForKey:@"INIT"] uppercaseString];
                NSString *strDES = [dic objectForKey:@"FNAME"];
                if ([strITCODE rangeOfString:searchText].location!=NSNotFound ||
                    [strDES rangeOfString:searchText].location!=NSNotFound){
                    [addition addObject:dic];
                }
            }
            if ([addition count]>0) {
                [_dataArray addObject:addition];
            }
        }
    }
    else{
        _dataArray = [NSMutableArray arrayWithArray:ary];
    }
    UITableView *tv = (UITableView *)[self viewWithTag:777];
    [tv reloadData];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"."])
    {
        return YES;
    }
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        //        ^\d{m,n}$
        NSString *validRegEx=nil;
        if (textField.tag==100) {
            validRegEx =@"^[a-zA-Z0-9\u4E00-\u9FA5]";
            
        }else
        {
            validRegEx =@"^[0-9]";
        }
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        return [regExPredicate evaluateWithObject:string];
    }
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([text isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        //        ^\d{m,n}$
        
        NSString *validRegEx =@"^[a-zA-Z0-9\u4E00-\u9FA5]";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        return [regExPredicate evaluateWithObject:text];
    }
    
}



@end
