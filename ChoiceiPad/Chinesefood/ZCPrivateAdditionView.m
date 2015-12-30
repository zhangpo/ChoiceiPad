//
//  ZCPrivateAdditionView.m
//  BookSystem-iPhone
//
//  Created by chensen on 15/3/30.
//  Copyright (c) 2015年 Stan Wu. All rights reserved.
//

#import "ZCPrivateAdditionView.h"
#import "BSDataProvider.h"
#import "AppDelegate.h"

@implementation ZCPrivateAdditionView
{
    NSMutableArray *_aryResult;     //全部的数组
    NSMutableArray *_arySelect;     //选择的数组
    NSMutableArray *_arySearchMatched;//显示的数组
    UISearchBar *searchBar;
    NSMutableArray *aryCustomAddition;//自定义附加项
}
@synthesize delegate=_delegate;
#define kPadding 10

- (id)initWithFrame:(CGRect)frame withFcodeArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _aryResult = [NSMutableArray arrayWithArray:[[[BSDataProvider alloc] init] ZCPrivateAddition:array]];
        _arySelect = [[NSMutableArray alloc] init];
        /**
         *  自定义附加项
         */
        aryCustomAddition = [[NSMutableArray alloc] init];
//        for (NSDictionary *dic in additions) {
//            if ([dic objectForKey:@"custom"]) {
//                [aryCustomAddition addObject:dic];
//            }
//        }
        //显示的数据
        _arySearchMatched = [NSMutableArray arrayWithArray:aryCustomAddition];
        [_arySearchMatched addObjectsFromArray:_aryResult];
//        float h = [[UIScreen mainScreen] bounds].size.height;
//        float padding = 10;
//        self.frame = CGRectMake(padding, padding, 320-padding*2, h-padding*8);
        self.backgroundColor = [UIColor clearColor];
        [self.layer setCornerRadius:10.0];
        [self.layer setMasksToBounds:YES];
        self.clipsToBounds = YES;
        
        UIView *skinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        skinView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        skinView.backgroundColor = [UIColor blackColor];
        skinView.alpha = 0.8f;
        [self addSubview:skinView];
        
        UIButton *btncancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btncancel.frame = CGRectMake(self.frame.size.width - (kPadding+40), 0,50, 35);
        [btncancel setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [btncancel setImage:[UIImage imageNamed:@"close_selected.png"] forState:UIControlStateHighlighted];
        [btncancel addTarget:self action:@selector(dismissAdditions) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btncancel];
        
        //    NSDictionary *food = dicInfo;
        //    int index = 0;
        
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(kPadding, kPadding+20, self.frame.size.width-2*kPadding, self.frame.size.height-2*kPadding-20) style:UITableViewStylePlain];
        tv.delegate = self;
        tv.dataSource = self;
        [self addSubview:tv];
        tv.tag = 777;
        
        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        searchBar.delegate = self;
        tv.tableHeaderView = searchBar;
    }
    return self;
}

- (void)dismissAdditions{
    [_delegate additionsSelected:_arySelect];
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addCustiomAddition{
    if ([searchBar.text length]>0){
        for (NSDictionary *dic in aryCustomAddition){
            if ([[dic objectForKey:@"DES"] isEqualToString:searchBar.text])
                return;
        }
        NSDictionary *dicToAdd = [NSDictionary dictionaryWithObjectsAndKeys:searchBar.text,@"DES",@"0.0",@"PRICE1",@"1",@"custom", nil];
        [aryCustomAddition addObject:dicToAdd];
        
        [_arySearchMatched removeAllObjects];
        [_arySearchMatched addObjectsFromArray:aryCustomAddition];
        [_arySearchMatched addObjectsFromArray:_aryResult];
        searchBar.text = nil;
        
        UITableView *tv = (UITableView *)[self viewWithTag:777];
        [tv reloadData];
        
        [_arySelect addObject:dicToAdd];
        [searchBar resignFirstResponder];
    }
}

#pragma mark TableView Delegate & DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [[_arySearchMatched objectAtIndex:indexPath.row] objectForKey:@"DES"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",[[[_arySearchMatched objectAtIndex:indexPath.row] objectForKey:@"PRICE1"] floatValue]];
    
//    NSArray *ary = arySearchMatched;
    
    
    BOOL selected = NO;
    for (NSDictionary *dic in _arySelect){
        if ([[[_arySearchMatched objectAtIndex:indexPath.row] objectForKey:@"DES"] isEqualToString:[dic objectForKey:@"DES"]]){
            selected = YES;
            break;
        }
    }
    cell.selected = selected;
    
    cell.accessoryType = cell.selected?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arySearchMatched count];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dictSelected = [_arySearchMatched objectAtIndex:indexPath.row];
    if ([aryCustomAddition containsObject:dictSelected]) {
        [aryCustomAddition removeObjectAtIndex:indexPath.row];
        [_arySearchMatched removeObjectAtIndex:indexPath.row];
        [_arySelect removeObject:dictSelected];
    }
    
    NSString *str = nil;
    BOOL needAdd = YES;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = !cell.selected;
    int index = -1;
    for (NSDictionary *dicAdd in _arySelect){
        if ([[dicAdd objectForKey:@"DES"] isEqualToString:[[_arySearchMatched objectAtIndex:indexPath.row] objectForKey:@"DES"]]){
            needAdd = NO;
            str = [dicAdd objectForKey:@"DES"];
            index = indexPath.row;
            break;
        }
    }
    
    if (cell.selected && needAdd)
        [_arySelect addObject:[_arySearchMatched objectAtIndex:indexPath.row]];
    else if (!needAdd){
        int i = 0;
        for (NSDictionary *dicAdd in _arySelect){
            if ([[dicAdd objectForKey:@"DES"] isEqualToString:str]){
                [_arySelect removeObjectAtIndex:i];
                break;
            }
            i++;
        }
    }
    
    
    [tableView reloadData];
    
//    if ([(NSObject *)delegate respondsToSelector:@selector(additionsSelected:)]){
//        [delegate additionsSelected:arySelectedAdditions];
//    }
}


NSInteger intSort11(id num1,id num2,void *context){
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
    NSMutableArray *ary = [NSMutableArray arrayWithArray:_aryResult];
    [ary addObjectsFromArray:aryCustomAddition];
//    NSMutableArray *ary=[[NSMutableArray alloc] initWithArray:_arySearchMatched];
    UITableView *tv = (UITableView *)[self viewWithTag:777];
    if ([searchText length]>0){
        searchText = [searchText uppercaseString];
        int count = [ary count];
        [_arySearchMatched removeAllObjects];
        for (int i=0;i<count;i++){
            NSDictionary *dic = [ary objectAtIndex:i];
            
          NSString *strINIT = [[dic objectForKey:@"INIT"] uppercaseString];
            NSString *strITCODE = [[dic objectForKey:@"ITCODE"] uppercaseString];
            NSString *strDES = [[dic objectForKey:@"DES"] uppercaseString];
            if ([strDES rangeOfString:searchText].location!=NSNotFound||[strITCODE rangeOfString:searchText].location!=NSNotFound||[strINIT rangeOfString:searchText].location!=NSNotFound){
                [_arySearchMatched addObject:dic];
            }
        }
        
        _arySearchMatched = [NSMutableArray arrayWithArray:[_arySearchMatched sortedArrayUsingFunction:intSort11 context:NULL]];
    }
    else{
        //        [searchBar resignFirstResponder];
        _arySearchMatched = [NSMutableArray arrayWithArray:ary];
        _arySearchMatched = [NSMutableArray arrayWithArray:[_arySearchMatched sortedArrayUsingFunction:intSort11 context:NULL]];
    }
    [tv reloadData];
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:text];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}


@end
