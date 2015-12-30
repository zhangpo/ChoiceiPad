//
//  AKOrderClassView.h
//  ChoiceiPad
//
//  Created by chensen on 15/7/15.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKOrderClassViewDelegate <NSObject>

-(void)AKOrderClassViewClick:(int)classGrp;

@end

@interface AKOrderClassView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)__weak id<AKOrderClassViewDelegate>delegate;
@end
