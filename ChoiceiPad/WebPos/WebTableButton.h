//
//  BSTableButtion.h
//  BookSystem
//
//  Created by Dream on 11-7-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WebTableButton;


@interface WebTableButton : UIButton {
    NSString *tableTitle;
    UILabel *tableLable;
    UILabel *pNumLable;
}

@property(nonatomic,strong)UILabel *manTitle;
@property (nonatomic,strong) NSString *tableTitle;
@property(nonatomic,strong)NSDictionary *tableInfo;
@end
