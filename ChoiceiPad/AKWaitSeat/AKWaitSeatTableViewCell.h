//
//  AKWaitSeatTableViewCell.h
//  ChoiceiPad
//
//  Created by chensen on 15/6/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AKWaitSeatTableViewCellDelegate <NSObject>

-(void)AKWaitSeatTableViewCell:(NSDictionary *)info;

@end

@interface AKWaitSeatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) NSDictionary     *dataInfo;
@property (weak, nonatomic) __weak id<AKWaitSeatTableViewCellDelegate>delegate;
@end
