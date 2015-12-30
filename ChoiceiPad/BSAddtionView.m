//
//  BSAddtionViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSAddtionView.h"
#import "BSAdditionCell.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"

@implementation BSAddtionView
@synthesize dicInfo;
@synthesize delegate;



- (id)initWithFrame:(CGRect)frame info:(NSDictionary *)info{
    self = [super initWithFrame:frame];
    if (self){
        BSDataProvider *dp = [BSDataProvider sharedInstance];
        aryAdditions = [NSMutableArray arrayWithArray:[dp ZCgetAdditions]];
        aryResult = [[NSMutableArray alloc] init];
        
        
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        self.dicInfo = info;
        arySelectedAddtions = [self.dicInfo objectForKey:@"addition"];
        [self additionalArray];
        [self setTitle:[langSetting localizedString:@"AdditionsConfiguration"]];
        
        vAddition = [[UIView alloc] initWithFrame:CGRectMake(15, 55, 320, 50)];
        barAddition = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        barAddition.barStyle = UIBarStyleDefault;
        //       barAddition.showsBookmarkButton = YES;
        //       barAddition.tintColor = [UIColor whiteColor];
        barAddition.delegate = self;
        [vAddition addSubview:barAddition];
        [self addSubview:vAddition];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeContactAdd];
        button.frame=CGRectMake(270, 0, 50, 50);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [vAddition addSubview:button];
//        button.backgroundColor=[UIColor redColor];
        tv = [[UITableView alloc] initWithFrame:CGRectMake(15, 105, 320, 205) style:UITableViewStylePlain];
        tv.backgroundColor = [UIColor whiteColor];
        tv.opaque = NO;
        tv.delegate = self;
        tv.dataSource = self;
        [self addSubview:tv];
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnConfirm.frame = CGRectMake(350, 90, 100, 44);
        [btnConfirm setTitle:[langSetting localizedString:@"OK"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btnCancel.frame = CGRectMake(350, 150, 100, 44);
        [btnCancel setTitle:[langSetting localizedString:@"Cancel"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        
//        tfAddition = [[UITextField alloc] initWithFrame:CGRectMake(350, 210, 100, 44)];
//        tfAddition.borderStyle = UITextBorderStyleRoundedRect;
//        tfAddition.font = [UIFont systemFontOfSize:12];
//        [self addSubview:tfAddition];
        
        [self addSubview:btnConfirm];
        [self addSubview:btnCancel];
    }
    
    return self;
}
#pragma mark - 附加项显示数组
-(void)additionalArray
{
    [aryResult removeAllObjects];
    if (arySelectedAddtions==nil||[arySelectedAddtions count]==0) {
        arySelectedAddtions=[[NSMutableArray alloc] init];
        aryResult =[NSMutableArray arrayWithArray:aryAdditions];
    }else
    {
        aryResult =[NSMutableArray arrayWithArray:aryAdditions];
        for (NSDictionary *dict in arySelectedAddtions) {
            if ([[dict objectForKey:@"ITCODE"] isEqualToString:@""]) {
                [aryResult insertObject:dict atIndex:0];
            }else
            {
                for (NSDictionary *dic in aryResult) {
                    if ([[dic objectForKey:@"DES"] isEqualToString:[dict objectForKey:@"DES"]]) {
                        [dic setValue:@"1" forKey:@"SELECT"];
                    }
                }
            }
        }
    }
}
#pragma mark - 自定义附加项
-(void)buttonClick:(UIButton *)btn{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"自定义附加项" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    UITextField *tf1=[alert textFieldAtIndex:0];
    tf1.placeholder=@"请输入附加项名称";
    tf1=[alert textFieldAtIndex:1];
    tf1.placeholder=@"请输入附加项价格";
    tf1.secureTextEntry=NO;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        NSMutableDictionary *dicCustom = [NSMutableDictionary dictionaryWithObjectsAndKeys:[alertView textFieldAtIndex:0].text,@"DES",[alertView textFieldAtIndex:1].text==nil?@"0":[alertView textFieldAtIndex:1].text,@"PRICE1",@"",@"ITCODE",@"1",@"SELECT",nil];
        [arySelectedAddtions addObject:dicCustom];
        [aryResult insertObject:dicCustom atIndex:0];
        [tv reloadData];
    }
}

#pragma mark - 确定取消按钮事件


- (void)confirm{
    NSMutableArray *aryMut = [NSMutableArray arrayWithArray:arySelectedAddtions];
    [delegate additionSelected:aryMut];
}

- (void)cancel{
    [delegate additionSelected:nil];
}

#pragma mark TableView Delegate & DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    BSAdditionCell *cell = (BSAdditionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BSAdditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
        

    }
    
    [cell setContent:[aryResult objectAtIndex:indexPath.row]];
    BOOL selected = NO;
    if ([[[aryResult objectAtIndex:indexPath.row] objectForKey:@"SELECT"] intValue]==1) {
        selected=YES;
    }else
    {
        selected=NO;
    }
    cell.bSelected = selected;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryResult count];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    BSAdditionCell *cell = (BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([[[aryResult objectAtIndex:indexPath.row] objectForKey:@"SELECT"] intValue]==1) {
        for (NSDictionary *dicAdd in arySelectedAddtions){
            if ([[dicAdd objectForKey:@"DES"] isEqualToString:[[aryResult objectAtIndex:indexPath.row] objectForKey:@"DES"]]&&[[dicAdd objectForKey:@"ITCODE"] isEqualToString:[[aryResult objectAtIndex:indexPath.row] objectForKey:@"ITCODE"]]){
                [[aryResult objectAtIndex:indexPath.row] setObject:@"0" forKey:@"SELECT"];
                [arySelectedAddtions removeObject:dicAdd];
                break;
            }
        }
    }else
    {
        [[aryResult objectAtIndex:indexPath.row] setObject:@"1" forKey:@"SELECT"];
        [arySelectedAddtions addObject:[aryResult objectAtIndex:indexPath.row]];
    }
    [tv reloadData];
}


NSInteger intSort(id num1,id num2,void *context){
    int v1 = [[(NSDictionary *)num1 objectForKey:@"ITCODE"] intValue];
    int v2 = [[(NSDictionary *)num2 objectForKey:@"ITCODE"] intValue];
    
    if (v1 < v2)
    return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


#pragma mark SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length]>0){
        searchText = [searchText uppercaseString];
        [self additionalArray];
        NSArray *ary = [NSArray arrayWithArray:aryResult];
        int count = [ary count];
        [aryResult removeAllObjects];
        for (int i=0;i<count;i++){
            NSDictionary *dic = [ary objectAtIndex:i];
            NSString *strITCODE = [[dic objectForKey:@"ITCODE"] uppercaseString];
            NSString *strINIT = [[dic objectForKey:@"INIT"] uppercaseString];
            NSString *strDES = [dic objectForKey:@"DES"];
            if ([strITCODE rangeOfString:searchText].location!=NSNotFound ||
                [strINIT rangeOfString:searchText].location!=NSNotFound ||
                [strDES rangeOfString:searchText].location!=NSNotFound){
                [aryResult addObject:dic];
            }
        }
        
        aryResult = [NSMutableArray arrayWithArray:[aryResult sortedArrayUsingFunction:intSort context:NULL]];
        [tv reloadData];
    }
    else{
//        [searchBar resignFirstResponder];
//        aryResult = [NSMutableArray arrayWithArray:aryAdditions];
//        aryResult = [NSMutableArray arrayWithArray:[aryResult sortedArrayUsingFunction:intSort context:NULL]];
        [self additionalArray];
        [tv reloadData];
    }
}

- (void)sortArray:(NSDictionary *)dict{
    
}

@end
