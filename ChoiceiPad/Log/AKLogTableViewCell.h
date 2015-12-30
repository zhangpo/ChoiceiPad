//
//  AKLogTableViewCell.h
//  ChoiceiPad
//
//  Created by chensen on 15/6/30.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKAdditionView.h"
#import "BSChuckView.h"
#import "ZCAdditionalView.h"

@class AKLogTableViewCell;

@protocol AKLogTableViewCellDelegate <NSObject>

-(void)AKLogTableViewCellClick:(AKLogTableViewCell *)cell;

@end

@interface AKLogTableViewCell : UITableViewCell<AKAdditionViewDelegate,ChuckViewDelegate,UIAlertViewDelegate,ZCAdditionalViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic)NSDictionary *foodInfo;             //菜品数据
@property (strong,nonatomic)NSIndexPath  *indexPath;            //位置
@property (strong, nonatomic) UILabel *foodName;         //菜品名称
@property (strong, nonatomic) UILabel *foodUnit;         //菜品单位
@property (strong, nonatomic) UILabel *foodAddition;     //菜品附加项
@property (strong, nonatomic) UITextField *foodCount;    //菜品数量
@property (strong, nonatomic) UIButton *foodPresent;     //赠送按钮
@property (strong, nonatomic) UIButton *foodAdditional;  //附加项按钮
@property (strong, nonatomic) UIButton *foodDelete;      //删除按钮
@property (strong, nonatomic) UIButton *foodAdd;         //加按钮
@property (strong, nonatomic) UIButton *foodSubtract;    //减按钮
@property (strong, nonatomic) UIButton *foodCall;        //即起叫起按钮
@property (strong, nonatomic) UILabel *foodTalPrice;
@property (strong, nonatomic) UILabel *foodPrice;
@property (strong, nonatomic) UILabel *foodLine;
@property (weak, nonatomic) __weak id<AKLogTableViewCellDelegate>delegate;

@end
