//
//  BSCommonView.m
//  BookSystem
//
//  Created by Dream on 11-5-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSCommonView.h"
#import "BSAdditionCell.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"

@implementation BSCommonView
{
    UITextField *tfAddition;
}
@synthesize arySelectedAdditions,aryAdditions,arySearchMatched,aryCustomAdditions;
@synthesize delegate;



- (id)initWithFrame:(CGRect)frame info:(NSArray *)ary{
    self = [super initWithFrame:frame];
    if (self){
        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        self.aryCustomAdditions = [NSMutableArray array];
        self.arySelectedAdditions = [NSMutableArray array];
        
        [self setTitle:[langSetting localizedString:@"Common Additions"]];
        
        BSDataProvider *dp = [[BSDataProvider alloc] init];
        self.aryAdditions = [NSMutableArray arrayWithArray:[dp specialremark]];//附加项的数据
        
        if ([ary count]>0){
            for (int i=0;i<[ary count];i++){
                if (![[ary objectAtIndex:i] objectForKey:@"ITCODE"])
                    [aryCustomAdditions addObject:[ary objectAtIndex:i]];
                else
                    [arySelectedAdditions addObject:[ary objectAtIndex:i]];
            }
        }
        
        self.arySearchMatched = [NSMutableArray arrayWithArray:[dp specialremark]];
        for (int i=aryCustomAdditions.count-1;i>=0;i--)
            [arySearchMatched insertObject:[aryCustomAdditions objectAtIndex:i] atIndex:0];
        
        
        vAddition = [[UIView alloc] initWithFrame:CGRectMake(15, 55, 320, 50)];
        barAddition = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        barAddition.barStyle = UIBarStyleDefault;
        //       barAddition.showsBookmarkButton = YES;
        //       barAddition.tintColor = [UIColor whiteColor];
        barAddition.delegate = self;
        [vAddition addSubview:barAddition];
        [self addSubview:vAddition];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        //      [btn setTitle:@"+" forState:UIControlStateNormal];
        btn.frame = CGRectMake(270, 0, 50, 50);
        [vAddition addSubview:btn];
        [btn addTarget:self action:@selector(addCustiomAddition) forControlEvents:UIControlEventTouchUpInside];
//        [btn setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        tv = [[UITableView alloc] initWithFrame:CGRectMake(15, 105, 320, 205) style:UITableViewStylePlain];
        tv.backgroundColor = [UIColor whiteColor];
        tv.opaque = NO;
        tv.delegate = self;
        tv.dataSource = self;
        [self addSubview:tv];
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConfirm.frame = CGRectMake(350, 90, 100, 44);
        [btnConfirm setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        btnConfirm.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        btnConfirm.titleLabel.textColor=[UIColor whiteColor];
        [btnConfirm setTitle:[langSetting localizedString:@"OK"] forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(350, 150, 100, 44);
        btnCancel.titleLabel.textColor=[UIColor whiteColor];
        [btnCancel setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [btnCancel setTitle:[langSetting localizedString:@"Cancel"] forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [self addSubview:btnConfirm];
        [self addSubview:btnCancel];
        tfAddition = [[UITextField alloc] initWithFrame:CGRectMake(350, 210, 100, 44)];
        tfAddition.borderStyle = UITextBorderStyleRoundedRect;
        tfAddition.font = [UIFont systemFontOfSize:12];
        [self addSubview:tfAddition];

    }
    
    return self;
}



#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.





- (void)confirm{
    [barAddition resignFirstResponder];
    [tfAddition resignFirstResponder];
    NSMutableArray *aryAll = [NSMutableArray arrayWithArray:arySelectedAdditions];
//    [aryAll addObjectsFromArray:aryCustomAdditions];
    if ([tfAddition.text length]>0){
        NSDictionary *dicCustom = [NSDictionary dictionaryWithObjectsAndKeys:tfAddition.text,@"DES",nil];
        [aryAll addObject:dicCustom];
    }

    NSLog(@"%@",aryAll);
    [delegate setCommon:aryAll];
}

- (void)cancel{
    [delegate setCommon:nil];
}

#pragma mark TableView Delegate
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray *aryCustom = [self.dicInfo objectForKey:@"addition"];
    //    NSMutableArray *aryCustomDics = [NSMutableArray array];
    //    int count = [aryCustomAddition count];
    
    NSArray *ary = arySearchMatched;
    static NSString *identifier = @"AdditionCell";
    
    BSAdditionCell *cell = (BSAdditionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BSAdditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell setHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
    }
    
    NSDictionary *dict;
    //    if (indexPath.row<count)
    //        dict = [aryCustomAddition objectAtIndex:indexPath.row];
    //    else
    //        dict = [ary objectAtIndex:indexPath.row-count];
    dict = [ary objectAtIndex:indexPath.row];
//    NSLog(@"%@",dict);
    
    [cell setContent:dict];
//    BOOL isSelected = NO;
//    for (NSDictionary *dic in arySelectedAdditions){
//        if ([[dict objectForKey:@"Id"] isEqualToString:[dic objectForKey:@"Id"]])
//            isSelected = YES;
//    }
    
//    for (NSDictionary *dic in aryCustomAddition){
//        if ([[dict objectForKey:@"FoodFuJia_Des"] isEqualToString:[dic objectForKey:@"FoodFuJia_Des"]])
//            isSelected = YES;
//    }
//    cell.bSelected = isSelected;
    return cell;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [aryAdditions count]+[aryCustomAddition count];
    return [arySearchMatched count];
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    BSAdditionCell *cell = (BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];
//    NSDictionary *dict=cell.info;
    BSAdditionCell *cell=(BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([[cell.info objectForKey:@"SELECT"]boolValue]==YES) {
        [cell.info setValue:[NSNumber numberWithBool:NO] forKey:@"SELECT"];
        for (NSDictionary *dict in arySelectedAdditions) {
            if ([[dict objectForKey:@"Id"] isEqualToString:[cell.info objectForKey:@"Id"]]) {
                [arySelectedAdditions removeObject:dict];
                break;
            }
        }
        [cell setContent:cell.info];
    }else
    {
        [cell.info setValue:[NSNumber numberWithBool:YES] forKey:@"SELECT"];
        [arySelectedAdditions addObject:cell.info];
        [cell setContent:cell.info];
    }
//    NSDictionary *dictSelected = [arySearchMatched objectAtIndex:indexPath.row];
//    NSLog(@"%@",aryCustomAdditions);
//    if ([aryCustomAdditions containsObject:dictSelected]) {
//        [aryCustomAdditions removeObjectAtIndex:indexPath.row];
//        [arySearchMatched removeObjectAtIndex:indexPath.row];
//    }
//    else{
//        BSAdditionCell *cell = (BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.bSelected = !cell.bSelected;
//        BOOL needAdd = YES;
//        int index = -1;
//        for (NSDictionary *dicAdd in arySelectedAdditions){
//            if ([[dicAdd objectForKey:@"Id"] isEqualToString:[dictSelected objectForKey:@"Id"]]){
//                needAdd = NO;
//                index = [arySelectedAdditions indexOfObject:dicAdd];
//                break;
//            }
//        }
//        
//        if (cell.bSelected && needAdd)
//        {
//            [arySelectedAdditions addObject:[arySearchMatched objectAtIndex:indexPath.row]];
//        }
//        else{
//            [arySelectedAdditions removeObjectAtIndex:index];
//        }
//        
//    }
//    
//    NSMutableArray *aryAll = [NSMutableArray arrayWithArray:arySelectedAdditions];
//    [aryAll addObjectsFromArray:aryCustomAdditions];
//    [tv reloadData];
//    
//    [barAddition resignFirstResponder];
//    NSDictionary *dictSelected = [arySearchMatched objectAtIndex:indexPath.row];
//    NSLog(@"%@",dictSelected);
//    if ([aryCustomAdditions containsObject:dictSelected]) {
//        [aryCustomAdditions removeObjectAtIndex:indexPath.row];
//        [arySearchMatched removeObjectAtIndex:indexPath.row];
//    }
//    else{
//        BSAdditionCell *cell = (BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.bSelected = !cell.bSelected;
//        BOOL needAdd = YES;
//        int index = -1;
//        
//        for (NSDictionary *dicAdd in arySelectedAdditions){
//            if ([[dicAdd objectForKey:@"DES"] isEqualToString:[dictSelected objectForKey:@"DES"]]){
//                needAdd = NO;
//                index = [arySelectedAdditions indexOfObject:dicAdd];
//                break;
//            }
//        }
//        
//        if (cell.bSelected && needAdd)
//            [arySelectedAdditions addObject:[arySearchMatched objectAtIndex:indexPath.row]];
//        else if (!cell.bSelected && !needAdd){
//            [arySelectedAdditions removeObjectAtIndex:index];
//            needAdd = YES;
//        }
//        
//    }
//    
//    NSMutableArray *aryAll = [NSMutableArray arrayWithArray:arySelectedAdditions];
//    [aryAll addObjectsFromArray:aryCustomAdditions];
//    
//    
//    [tv reloadData];
//    
//    [barAddition resignFirstResponder];
}



NSInteger intSort3(id num1,id num2,void *context){
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

        NSArray *ary = [NSArray arrayWithArray:aryAdditions];
        
        // clean buffer after
        [arySearchMatched removeAllObjects];
        
        int count = [ary count];
        for (int i=0;i<count;i++){
            NSDictionary *dic = [ary objectAtIndex:i];
            
//            NSString *strITCODE = [[dic objectForKey:@"ITCODE"] uppercaseString];
            NSString *strINIT = [[dic objectForKey:@"INIT"] uppercaseString];
            NSString *strDES = [dic objectForKey:@"DES"];
            if ([strINIT rangeOfString:searchText].location!=NSNotFound ||
                [strDES rangeOfString:searchText].location!=NSNotFound){
                [arySearchMatched addObject:dic];
            }
        }
         self.arySearchMatched = [NSMutableArray arrayWithArray:[arySearchMatched sortedArrayUsingFunction:intSort3 context:NULL]];
        for (int i=aryCustomAdditions.count-1;i>=0;i--)
            [arySearchMatched insertObject:[aryCustomAdditions objectAtIndex:i] atIndex:0];
//        if (bJump)
//            [tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dJump inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else{
//        [searchBar resignFirstResponder];
//        [tv scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        // clean buffer first
        self.arySearchMatched = [NSMutableArray arrayWithArray:aryAdditions];

        self.arySearchMatched = [NSMutableArray arrayWithArray:[arySearchMatched sortedArrayUsingFunction:intSort3 context:NULL]];
        
        for (int i=aryCustomAdditions.count-1;i>=0;i--)
            [arySearchMatched insertObject:[aryCustomAdditions objectAtIndex:i] atIndex:0];
    }
    [tv reloadData];
//    [barAddition becomeFirstResponder];
}

- (void)addCustiomAddition{
    if ([barAddition.text length]>0){
        for (NSDictionary *dic in aryCustomAdditions){
            if ([[dic objectForKey:@"DES"] isEqualToString:barAddition.text])
                return;
        }
        NSMutableDictionary *dicToAdd = [NSMutableDictionary dictionaryWithObjectsAndKeys:barAddition.text,@"DES",@"0.0",@"PRICE1",[NSNumber numberWithBool:YES],@"SELECT",@"Id",@"Id", nil];
        [aryCustomAdditions addObject:dicToAdd];
        [arySelectedAdditions addObject:dicToAdd];
        [arySearchMatched removeAllObjects];
        [arySearchMatched addObjectsFromArray:aryCustomAdditions];
        [arySearchMatched addObjectsFromArray:aryAdditions];
        for (NSDictionary *dict in arySelectedAdditions) {
            for (NSDictionary *dic in arySearchMatched) {
                if ([[dic objectForKey:@"DES"] isEqualToString:[dict objectForKey:@"DES"]]) {
                    [dic setValue:[NSNumber numberWithBool:YES] forKey:@"SELECT"];
                    break;
                }
            }
        }
//        [arySelectedAdditions insertObject:dicToAdd atIndex:0];
        barAddition.text = nil;
        
        [tv reloadData];
    }
}


@end
