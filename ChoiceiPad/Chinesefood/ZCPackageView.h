//
//  ZCPackageView.h
//  ChoiceiPad
//
//  Created by chensen on 15/4/9.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCPackageViewDelegate <NSObject>

-(void)package:(NSArray *)array;

@end

@interface ZCPackageView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,weak)__weak id<ZCPackageViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withPackId:(NSString *)packid;
-(void)notChangeItem;
@end
