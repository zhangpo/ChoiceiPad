//
//  AKComboView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 14-8-30.
//  Copyright (c) 2014年 凯_SKK. All rights reserved.
//

#import "AKComboView.h"
#import "AKFoodOrderCell.h"
#import "BSPackageReusableView.h"

@implementation AKComboView
{
    UICollectionView *_foodCV;
    NSMutableArray   *_dataArray;
    NSMutableArray   *_selectArray;
    NSMutableDictionary     *_foodDic;
    NSMutableDictionary     *_comDic;
    AKFoodOrderCell         *_foodCell;
    AKPrivateAdditionView   *privateAddition;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withPcode:(NSDictionary *)food
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *comboArray=[[BSDataProvider sharedInstance] combo:food];
        _foodDic=[NSMutableDictionary dictionaryWithDictionary:food];
        _dataArray=[[NSMutableArray alloc] init];
        _selectArray=[[NSMutableArray alloc] init];
        for (NSArray *array in comboArray) {
            if ([array count]>1) {
                [_dataArray addObject:array];
            }else
            {
                NSMutableDictionary *dict=[array lastObject];
                if ([[dict objectForKey:@"MINCNT"] intValue]==[[dict objectForKey:@"MAXCNT"] intValue]&&[[dict objectForKey:@"MINCNT"] intValue]==[[dict objectForKey:@"TYPMINCNT"] intValue]) {
                    [dict setObject:[dict objectForKey:@"MINCNT"] forKey:@"total"];
                    [_selectArray addObject:dict];
                }else
                {
                    [_dataArray addObject:array];
                }
            }
        }
        
        UIImageView *imageBG=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [imageBG setImage:[UIImage imageNamed:@"Packagebg.png"]];
        [self addSubview:imageBG];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(120, 80);
        flowLayout.headerReferenceSize=CGSizeMake(CGRectGetWidth(frame)-20,40);
        flowLayout.minimumInteritemSpacing =2;//列距
        flowLayout.minimumLineSpacing=10;
        
        _foodCV=[[UICollectionView alloc] initWithFrame:CGRectMake(10,60, CGRectGetWidth(frame)-20, CGRectGetHeight(frame)-150) collectionViewLayout:flowLayout];
        _foodCV.backgroundColor=[UIColor clearColor];
        _foodCV.delegate=self;
        _foodCV.dataSource=self;
        [_foodCV registerClass:[AKFoodOrderCell class] forCellWithReuseIdentifier:@"colletionCell2"];
        [_foodCV registerClass:[BSPackageReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [self addSubview:_foodCV];
        for (int i=0; i<2; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(400+100*i, CGRectGetHeight(frame)-90, 90, 40);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor=[UIColor redColor];
            [button setBackgroundImage:[[CVLocalizationSetting sharedInstance]imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
            if(i==0)
                [button setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"]  forState:UIControlStateNormal];
            else
               [button setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"]  forState:UIControlStateNormal];
            button.tag=i;
            [self addSubview:button];
        }
    }
    return self;
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
    NSString *reuseIdetify = @"colletionCell2";
    AKFoodOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdetify forIndexPath:indexPath];
    cell.comboDict=[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    BSPackageReusableView *headView;
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headView.titleLabel.text=[NSString stringWithFormat:@"%d %@-%@   %@",indexPath.section,[[[_dataArray objectAtIndex:indexPath.section] lastObject] objectForKey:@"TYPMINCNT"],[[[_dataArray objectAtIndex:indexPath.section] lastObject] objectForKey:@"TYPMAXCNT"],[[[_dataArray objectAtIndex:indexPath.section] lastObject] objectForKey:@"GROUPTITLE"] ];
    }
    return headView;
}
#pragma mark - 菜品选择
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _foodCell=(AKFoodOrderCell *)[_foodCV cellForItemAtIndexPath:indexPath];
    _comDic=[NSMutableDictionary dictionaryWithDictionary:[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    //判断是否满足菜品的最大数量
    if ([[_comDic objectForKey:@"MAXCNT"] intValue]==[[_comDic objectForKey:@"total"] intValue]) {
        [SVProgressHUD showErrorWithStatus:@"套餐已满足该菜品的最大数量"];
        return;
    }
    //判断是否满足该组菜品的最大数量
    int i=0;
    NSLog(@"%@",[_dataArray objectAtIndex:indexPath.section]);
    for (NSDictionary *dict in [_dataArray objectAtIndex:indexPath.section]) {
        i+=[[dict objectForKey:@"total"] intValue];
    }
    if ([[_comDic objectForKey:@"TYPMAXCNT"] intValue]==i) {
        [SVProgressHUD showErrorWithStatus:@"套餐已满足该组的最大数量"];
        return;
    }
    [_comDic setObject:@"1" forKey:@"total"];
    for (NSDictionary *dict in _selectArray) {
        if (![dict objectForKey:@"addition"]&&[[dict objectForKey:@"PCODE1"] isEqualToString:[_foodCell.dataDict objectForKey:@"PCODE1"]]&&[[dict objectForKey:@"PRODUCTTC_ORDER"] isEqualToString:[_foodCell.dataDict objectForKey:@"PRODUCTTC_ORDER"]]) {
            [_selectArray removeObject:dict];
            
            [_comDic setObject:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"total"] intValue]+1] forKey:@"total"];
            break;
        }
    }
    [self privateAdditionView];
    
}
-(void)setDelegate:(id<AKComboViewDelegate>)delegate
{
    _delegate=delegate;
    if ([_dataArray count]==0) {
        [self comboend];
        //        [_delegate AKComboViewClick:_selectArray];
    }
}
#pragma mark - 套餐下按钮事件
-(void)buttonClick:(UIButton *)button
{
    if (button.tag==0) {
        [self comboend];
        
    }else
    {
        [_delegate AKComboViewClick:nil];
    }
}
#pragma mark - 判断是否必选附加项
-(void)privateAdditionView
{
    /**
     *  @author ZhangPo, 15-04-13 14:04:49
     *
     *  @brief  附加产品标识错误   ISTEMP临时菜  ISADDPROD附加产品
     *
     *  @since
     */
    if ([[_foodCell.dataDict objectForKey:@"FUJIAMODE"] intValue]==1||[[_foodCell.dataDict objectForKey:@"ISADDPRO"] intValue]==1) {
        //        aScrollView.userInteractionEnabled=NO;
        if (!privateAddition){
            privateAddition = [[AKPrivateAdditionView alloc] initWithFrame:CGRectMake(0, 0, 384, 512) withFoodDict:_foodCell.dataDict];
            privateAddition.delegate = self;
        }
        if (!privateAddition.superview){
            privateAddition.center = CGPointMake(self.superview.center.x,self.superview.center.y);
            [self.superview addSubview:privateAddition];
        }
        else{
            //            aScrollView.userInteractionEnabled=YES;
            [privateAddition removeFromSuperview];
            privateAddition = nil;
        }
        
    }else
    {
        [_foodCell.comboDict setObject:[NSString stringWithFormat:@"%d",[[_foodCell.dataDict objectForKey:@"total"] intValue]+1] forKey:@"total"];
        [_foodCell setComboDict:_foodCell.comboDict];
        [_selectArray addObject:_comDic];
//        [self addFoodForArray];
        
    }
}
#pragma mark - privateAdditionDelegate
-(void)privateAdditionSelected:(NSArray *)ary
{
    if (ary) {
        [_comDic setObject:ary forKey:@"addition"];
        [_foodCell.comboDict setObject:[NSString stringWithFormat:@"%d",[[_foodCell.dataDict objectForKey:@"total"] intValue]+1] forKey:@"total"];
        [_foodCell setComboDict:_foodCell.comboDict];
        [_selectArray addObject:_comDic];
    }
    [privateAddition removeFromSuperview];
    privateAddition = nil;
}
#pragma mark - 计算套餐价格
-(void)comboend
{
    /**
     *  判断套餐是否选择完毕
     */
    for (int i=0;i<[_dataArray count];i++) {
        int x=0;
        for (NSDictionary *dict in [_dataArray objectAtIndex:i]) {
            x+=[[dict objectForKey:@"total"] intValue];
        }
        NSLog(@"%d",[[[[_dataArray objectAtIndex:i] lastObject] objectForKey:@"TYPMINCNT"] intValue]);
        if (x<[[[[_dataArray objectAtIndex:i] lastObject] objectForKey:@"TYPMINCNT"] intValue]) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:[[CVLocalizationSetting sharedInstance] localizedString:@"Also have no choice"],i]];
            return;
        }
    }
    float mrMoney = 0.00;     //product_sub表里的价格和
    float tcAddMomey=0.00;    //food表里的价格之和
    //套餐价格
    float tcMoney=[[_foodDic objectForKey:@"PRICE"] floatValue];
    //套餐加价
    for (NSDictionary *dict in _selectArray) {
        if ([[dict objectForKey:@"NADJUSTPRICE"] floatValue]>0) {
            tcMoney+=[[dict objectForKey:@"NADJUSTPRICE"] floatValue]*[[dict objectForKey:@"total"] floatValue];
        }
    }
    [_foodDic setObject:[NSNumber numberWithFloat:tcMoney] forKey:@"PRICE"];
    //计算套餐明细价格和，
    for (int i=0; i<[_selectArray count]; i++) {
        NSDictionary *dict=[_selectArray objectAtIndex:i];
        if ([[dict objectForKey:@"TCMONEYMODE"] intValue]==2) {
            [dict setValue:[dict objectForKey:@"PPRICE"] forKey:@"PRICE1"];
        }
        if ([[dict objectForKey:@"TCMONEYMODE"] intValue]==3) {
            tcAddMomey+=[[dict objectForKey:@"PPRICE"] floatValue];
        }
        [dict setValue:[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"PRICE1"]!=nil?[dict objectForKey:@"PRICE1"]:[dict objectForKey:@"PRICE"] floatValue]*[[dict objectForKey:@"total"] floatValue]] forKey:@"PRICE"];
        mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
    }
    //判断是否汇总价格
    if ([[_foodDic objectForKey:@"TCMONEYMODE"] intValue]==2) {
        [_foodDic setObject:[NSNumber numberWithFloat:mrMoney] forKey:@"PRICE"];
    }else
    {
        float gTcprice=0.00;
        for (int i=0; i<[_selectArray count]; i++) {
            NSDictionary *dict=[_selectArray objectAtIndex:i];
            float m_price1=[[dict objectForKey:@"PRICE1"] floatValue];
            //判断是否是固定价格，或者是高优先的固定价格
            if ([[_foodDic objectForKey:@"TCMONEYMODE"] intValue]==1||([[_foodDic objectForKey:@"TCMONEYMODE"] intValue]==3&&tcAddMomey<=tcMoney)) {
                float tempMoney1=m_price1*tcMoney/mrMoney;
                gTcprice+=tempMoney1;
                [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
                //如果最后一个菜品，前面的明细的价格和，与套餐价格不相等，将多出来金额加在最后一个菜品上
                if (i==[_selectArray count]-1&&gTcprice!=tcMoney) {
                    [dict setValue:[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"PRICE"] floatValue]+(tcMoney-gTcprice)] forKey:@"PRICE"];
                }
            }else
            {
                //高优先价格的汇总价格
                [dict setValue:[dict objectForKey:@"PPRICE"] forKey:@"PRICE"];
                [_foodDic setValue:[NSString stringWithFormat:@"%.2f",tcAddMomey] forKey:@"PRICE"];
            }
        }
    }
    [_foodDic setObject:[NSArray arrayWithArray:_selectArray] forKey:@"combo"];
    [_delegate AKComboViewClick:_foodDic];
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
