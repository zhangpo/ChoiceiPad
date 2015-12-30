//
//  BSTableButtion.h
//  BookSystem
//
//  Created by Dream on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ZCTableTypeOrdered=0,   
    ZCTableTypeKongXian=2,
    ZCTableTypeKaiTai=4,
    ZCTableTypeDianCai=1,
    ZCTableTypeYuDing=3
}ZCTableType;

@class ZCTableButton;


@interface ZCTableButton : UIButton {
    ZCTableType   tableType;
    
    NSString *tableTitle;
    
    
    BOOL isMoving;
    
    CGPoint ptStart;
    
    UIImageView *imgvCopy;
    UIImageView *imageView;
    UILabel *tableLable;
    UILabel *pNumLable;
}

@property(nonatomic,strong)UILabel *manTitle;
@property (nonatomic,assign) ZCTableType tableType;
@property (nonatomic,strong) NSString *tableTitle;
@end
