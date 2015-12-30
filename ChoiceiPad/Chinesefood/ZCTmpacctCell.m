//
//  ZCTmpacctCell.m
//  ChoiceiPad
//
//  Created by chensen on 15/9/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "ZCTmpacctCell.h"

@implementation ZCTmpacctCell
{
    UILabel *_lblId;        //编码
    UILabel *_lblName;      //名称
    UILabel *_lblFirm;      //公司
    UILabel *_lblWhemp;     //担保人
}
@synthesize tmpacctDict=_tmpacctDict;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lblId=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        [self.contentView addSubview:_lblId];
        _lblName=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 40)];
        [self.contentView addSubview:_lblName];
        _lblFirm=[[UILabel alloc] initWithFrame:CGRectMake(300, 0, 200, 40)];
        [self.contentView addSubview:_lblFirm];
        _lblWhemp=[[UILabel alloc] initWithFrame:CGRectMake(500, 0, 200, 40)];
        [self.contentView addSubview:_lblWhemp];
    }
    return self;
}
-(void)setTmpacctDict:(NSDictionary *)tmpacctDict
{
    _tmpacctDict=tmpacctDict;
    _lblId.text=[tmpacctDict objectForKey:@"ITCODE"];
    _lblName.text=[tmpacctDict objectForKey:@"NAM"];
    _lblFirm.text=[tmpacctDict objectForKey:@"FIRM"];
    _lblWhemp.text=[tmpacctDict objectForKey:@"WHEMP"];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
