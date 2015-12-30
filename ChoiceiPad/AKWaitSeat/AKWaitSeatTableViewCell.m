//
//  AKWaitSeatTableViewCell.m
//  ChoiceiPad
//
//  Created by chensen on 15/6/23.
//  Copyright (c) 2015年 zp. All rights reserved.
//

#import "AKWaitSeatTableViewCell.h"

@implementation AKWaitSeatTableViewCell
@synthesize dataInfo=_dataInfo,delegate=_delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
//    self.contentView.backgroundColor=[UIColor clearColor];
    self.backgroundColor=[UIColor clearColor];
    self.myView.layer.masksToBounds = YES;
    self.myView.layer.cornerRadius = 6.0;
    self.myView.layer.borderWidth = 1.0;
    self.myView.backgroundColor=[UIColor whiteColor];
    self.myView.layer.borderColor = [[UIColor redColor] CGColor];
    self.numLabel.layer.masksToBounds = YES;
    self.numLabel.layer.cornerRadius = 12.5;
    self.numLabel.backgroundColor=[UIColor redColor];
    
}
-(void)setDataInfo:(NSDictionary *)dataInfo
{
    _dataInfo=dataInfo;
    self.numberLabel.text=[_dataInfo objectForKey:@"rec"]==nil?[_dataInfo objectForKey:@"waitNum"]:[_dataInfo objectForKey:@"rec"];
    self.telLabel.text=[_dataInfo objectForKey:@"tele"]==nil?[_dataInfo objectForKey:@"phoneNum"]:[_dataInfo objectForKey:@"tele"];
    self.peopleLabel.text=[_dataInfo objectForKey:@"pax"]==nil?[NSString stringWithFormat:@"%d",[[_dataInfo objectForKey:@"manNum"] intValue]+[[_dataInfo objectForKey:@"womanNum"] intValue]]:[_dataInfo objectForKey:@"pax"];
    self.timeLabel.text=[_dataInfo objectForKey:@"wtime"];
    if ([_dataInfo objectForKey:@"phoneNum"]) {
        [self.button1 setImage:[UIImage imageNamed:@"jiucan_up.png"] forState:UIControlStateNormal];
        [self.button2 setImage:[UIImage imageNamed:@"zhuantai_up.png"] forState:UIControlStateNormal];
        [self.button3 setImage:[UIImage imageNamed:@"chexiao_up.png"] forState:UIControlStateNormal];
    }
//    self.numLabel.text=[_dataInfo objectForKey:@"wtime"];
}
- (IBAction)cancelSeat:(id)sender {
    UIButton *btn=sender;
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:self.dataInfo];
    [dict setObject:[NSNumber numberWithInt:btn.tag] forKey:@"TAG"];
    [_delegate AKWaitSeatTableViewCell:dict];
}
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
