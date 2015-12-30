//
//  ZCPackageView.m
//  ChoiceiPad
//
//  Created by chensen on 15/4/9.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCPackageView.h"
#import "ZCPackageCell.h"
#import "BSPackageReusableView.h"

@implementation ZCPackageView
{
    NSMutableArray *_dataArray;
    NSMutableArray *_selectArray;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withPackId:(NSString *)packid
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        BSDataProvider *dp=[BSDataProvider sharedInstance];
        _dataArray=[dp getShiftFoodPackage:packid];
        _selectArray=[[NSMutableArray alloc] init];
        for (NSArray *array in _dataArray) {
            if ([array count]==1) {
                [[array lastObject] setObject:[[array lastObject] objectForKey:@"CNT"] forKey:@"total"];
                [[array lastObject] setObject:[NSString stringWithFormat:@"%d",[_selectArray count]+1] forKey:@"num"];
                [_selectArray addObject:[array lastObject]];
            }
        }
        UIImageView *imgaBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imgaBg setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Packagebg.png"]];
        [self addSubview:imgaBg];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(120, 80);
        flowLayout.minimumInteritemSpacing=0;
        flowLayout.minimumLineSpacing=10;
        flowLayout.headerReferenceSize=CGSizeMake(0.001,50);
//        flowLayout.footerReferenceSize=CGSizeMake(0.001, 0);
        UICollectionView *_collection=[[UICollectionView alloc] initWithFrame:CGRectMake(0,60, frame.size.width-10, frame.size.height-80) collectionViewLayout:flowLayout];
        _collection.delegate=self;
        _collection.dataSource=self;
        [_collection registerClass:[ZCPackageCell class] forCellWithReuseIdentifier:@"colletionCell1"];
        _collection.backgroundColor=[UIColor clearColor];
        [_collection registerClass:[BSPackageReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];//头视图
        [self addSubview:_collection];
    }
    return self;
}
#pragma mark 没有可换购
-(void)notChangeItem
{
    int i=0;
    for (NSArray *array in _dataArray) {
        
        if ([array count]>1) {
            i++;
        }
    }
    if (i==0) {
        [_delegate package:_selectArray];
    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_dataArray count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell1";
    ZCPackageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    [cell setDataInfo:[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZCPackageCell *cell=(ZCPackageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.dataInfo objectForKey:@"total"]) {
        [_selectArray removeObject:cell.dataInfo];
        [cell.dataInfo removeObjectForKey:@"total"];
        [cell setDataInfo:cell.dataInfo];
        return;
    }
    for (NSDictionary *dict in [_dataArray objectAtIndex:indexPath.section]) {
        if ([[dict objectForKey:@"total"] intValue]>0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"该可换购菜已选择完毕" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    [cell.dataInfo setValue:[cell.dataInfo objectForKey:@"CNT"] forKeyPath:@"total"];
    [cell.dataInfo setValue:[NSString stringWithFormat:@"%d",[_selectArray count]+1] forKey:@"num"];
    [_selectArray addObject:cell.dataInfo];
    [cell setDataInfo:cell.dataInfo];
    int i=0;
    for (NSArray *array in _dataArray) {
        for (NSDictionary *dict  in array) {
            if ([[dict objectForKey:@"total"] intValue]>0) {
                i++;
                break;
            }
        }
    }
    if (i==[_dataArray count]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"该套餐选择完毕" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [_delegate package:_selectArray];
        return;
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"HeaderView";
    BSPackageReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
//    UILabel *label =(UILabel *)[view viewWithTag:100];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        view.titleLabel.text=[NSString stringWithFormat:@"%d",indexPath.section+1];
    }
    return view;
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
