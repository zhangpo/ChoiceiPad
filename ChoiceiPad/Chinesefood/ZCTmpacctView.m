//
//  ZCTmpacctView.m
//  ChoiceiPad
//
//  Created by chensen on 15/9/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCTmpacctView.h"
#import "ZCTmpacctCell.h"

@implementation ZCTmpacctView
{
    UITableView *tmpacctTableView;
    UISearchBar *_searchBar;
    NSMutableArray *_tmpacctShowArray;
    NSDictionary   *_tmpacctDict;
}
@synthesize tmpacctArray=_tmpacctArray;

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
        label.text=@"挂账";
        [self addSubview:label];
        _tmpacctShowArray=[[NSMutableArray alloc] init];
        _searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(10, 70, self.frame.size.width-20, 50)];
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        _searchBar.backgroundColor=[UIColor clearColor];
        _searchBar.translucent=YES;
        _searchBar.placeholder=@"搜索";
        _searchBar.delegate = self;
        _searchBar.barStyle=UIBarStyleDefault;
        [self addSubview:_searchBar];
        tmpacctTableView=[[UITableView alloc] initWithFrame:CGRectMake(10, 120, self.frame.size.width-20, CGRectGetHeight(frame)-200) style:UITableViewStylePlain];
        tmpacctTableView.delegate=self;
        tmpacctTableView.dataSource=self;
        [self addSubview:tmpacctTableView];
        for(int i=0;i<2;i++){
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(110+265*i, 715, 190, 60);
            button.titleLabel.textColor=[UIColor whiteColor];
            button.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [button setBackgroundImage:[UIImage imageNamed:@"AlertViewButton.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:i==0?@"确定":@"取消" forState:UIControlStateNormal];
            [self addSubview:button];
        }
    }
    return self;
}
-(void)buttonClick:(UIButton *)button
{
    if (button.tag==0) {
        [_delegate ZCTmpacctClick:_tmpacctDict];
    }else
    {
        [_delegate ZCTmpacctClick:nil];
    }
}
#pragma mark - 检索
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_tmpacctShowArray removeAllObjects];
    if(searchText.length>0){
    for(NSDictionary *dict in _tmpacctArray){
        if ([[dict objectForKey:@"ITCODE"] rangeOfString:searchBar.text].location !=NSNotFound
            ||[[dict objectForKey:@"NAM"] rangeOfString:searchBar.text].location !=NSNotFound
            ||[[dict objectForKey:@"WHEMP"] rangeOfString:searchBar.text].location !=NSNotFound
            ||[[dict objectForKey:@"FIRM"] rangeOfString:searchBar.text].location !=NSNotFound
            ||[[[dict objectForKey:@"NAMINIT"] uppercaseString] rangeOfString:[searchBar.text uppercaseString]].location !=NSNotFound
            ||[[[dict objectForKey:@"FIRMINIT"] uppercaseString] rangeOfString:[searchBar.text uppercaseString]].location !=NSNotFound) {
            [_tmpacctShowArray addObject:dict];
        }
    }
    }else{
        [_tmpacctShowArray addObjectsFromArray:_tmpacctArray];
    }
    [tmpacctTableView reloadData];
}
-(void)setTmpacctArray:(NSArray *)tmpacctArray
{
    _tmpacctArray=tmpacctArray;
    [_tmpacctShowArray addObjectsFromArray:tmpacctArray];
//    _tmpacctShowArray=[NSMutableArray arrayWithArray:tmpacctArray];
    [tmpacctTableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tmpacctShowArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName=@"cellName";
    ZCTmpacctCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[ZCTmpacctCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.tmpacctDict=[_tmpacctShowArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tmpacctDict=[_tmpacctShowArray objectAtIndex:indexPath.row];

}


@end
