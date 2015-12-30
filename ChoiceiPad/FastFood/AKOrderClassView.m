//
//  AKOrderClassView.m
//  ChoiceiPad
//
//  Created by chensen on 15/7/15.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKOrderClassView.h"
#import "AKOrderClassCell.h"

@implementation AKOrderClassView
{
    NSArray *_classArray;
    NSMutableArray *_clsaaShow;
    UICollectionView *_classCV;
}
@synthesize delegate=_delegate;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (mydish:) name:@"classData" object:nil];
        _classArray=[[BSDataProvider sharedInstance] getClassById];
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(frame),CGRectGetHeight(frame))];
        [image setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"ClassBG.png"]];
        [self addSubview:image];
//        [scrollview addSubview:image];
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.itemSize = CGSizeMake(100, 60);
        flowLayout.minimumInteritemSpacing =0;//列距
        flowLayout.minimumLineSpacing=2;
        
        _classCV=[[UICollectionView alloc] initWithFrame:image.frame collectionViewLayout:flowLayout];
        _classCV.backgroundColor=[UIColor clearColor];
        _classCV.delegate=self;
        _classCV.dataSource=self;
        [_classCV registerClass:[AKOrderClassCell class] forCellWithReuseIdentifier:@"colletionCell2"];
        [self addSubview:_classCV];

    }
    return self;
}
-(void)mydish:(NSNotification *)center
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        //异步操作代码块
    _classArray =nil;
    _clsaaShow=[NSMutableArray arrayWithArray:(NSArray *)center.object];
//        for (NSMutableDictionary *dict in _classArray) {
//            [dict removeObjectForKey:@"count"];
//        }
//        _clsaaShow=[[NSMutableArray alloc] initWithArray:_classArray];
//        for (NSDictionary *dict in array1) {
//            NSMutableDictionary *dic=[_classArray objectAtIndex:[[dict objectForKey:@"CLASSINDEX"] intValue]];
//            int i=[[dic objectForKey:@"count"] intValue]+[[dict objectForKey:@"total"] intValue];
//            [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"count"];
//        }

//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            //回到主线程操作代码块
            [_classCV reloadData];
//
//        });
//        
//    });
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_clsaaShow count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdetify = @"colletionCell2";
    AKOrderClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
   
    cell.dataDic=[_clsaaShow objectAtIndex:indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSDictionary *dict in _clsaaShow) {
        if ([[dict objectForKey:@"SELECT"] boolValue]==YES) {
            [dict setValue:[NSNumber numberWithBool:NO] forKey:@"SELECT"];
            break;
        }
    }
    [_delegate AKOrderClassViewClick:indexPath.row];
    [[_clsaaShow objectAtIndex:indexPath.row] setObject:[NSNumber numberWithBool:YES] forKey:@"SELECT"];

    [_classCV reloadData];
}
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
//    
//    [cell setBackgroundColor:[UIColor purpleColor]];
//}
//
//- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
//    
//    [cell setBackgroundColor:[UIColor yellowColor]];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
