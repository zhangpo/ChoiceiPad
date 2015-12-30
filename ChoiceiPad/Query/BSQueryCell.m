//
//  BSQuerym
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 MyCompanyName. All rights reserved.
//

#import "BSQueryCell.h"
#import "BSDataProvider.h"
#import "Singleton.h"


@implementation BSQueryCell
{
    CGPoint startPoint;
    BOOL bMove;
}
@synthesize dataDic=_dataDic,delegete=_delegate,ZCdataDic=_ZCdataDic;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
//    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self addActionButtons:[self leftButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationLeft];
//        [self addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
        //        [self configureCellWithTitle:self.tableData[indexPath.row]];
//        [self setNeedsLayout];
//        [self setNeedsUpdateConstraints];
//        [self updateConstraintsIfNeeded];
        lblhua=[[UILabel alloc] initWithFrame:CGRectMake(768/7*2, 25, 500, 2)];
        lblhua.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:lblhua];
        btn=[[UIImageView alloc] init];
        btn.userInteractionEnabled=YES;
        btn.frame=CGRectMake(30, 15, 20, 20);
        btn.backgroundColor=[UIColor blackColor];
        [self.contentView addSubview:btn];
        lblstart=[[UILabel alloc] initWithFrame:CGRectMake(768/7-40, 10, 35, 35)];
        [self.contentView addSubview:lblstart];
        over=[[UILabel alloc] initWithFrame:CGRectMake(768/7-10, 10, 35+10, 40)];
        [self.contentView addSubview:over];
        lblover=[[UIImageView alloc] initWithFrame:CGRectMake(768/7+35,10,40, 40)];
        [self.contentView addSubview:lblover];
        lblCame=[[UILabel alloc] init];
        lblCame.numberOfLines =0;
        lblCame.lineBreakMode = NSLineBreakByWordWrapping;
        lblCame.frame=CGRectMake(768/7*2, 0, 768/7,50);
        [self.contentView addSubview:lblCame];
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 0.8;
        
        lblCount=[[UILabel alloc] init];
        lblCount.userInteractionEnabled=YES;
//        lblCount.backgroundColor=[UIColor redColor];
        lblCount.textAlignment=NSTextAlignmentCenter;
        lblCount.frame=CGRectMake(768/7*3, 0, (768-768/7*3)/5, 40);
        [lblCount addGestureRecognizer:longPressGr];
        [self.contentView addSubview:lblCount];
        lblPrice=[[UILabel alloc] init];
        lblPrice.textAlignment=NSTextAlignmentRight;
        lblPrice.frame=CGRectMake(768/7*3+(768-768/7*3)/5, 0, (768-768/7*3)/5, 40);
        [self.contentView addSubview:lblPrice];
        lblUnit=[[UILabel alloc] init];
        lblUnit.textAlignment=NSTextAlignmentCenter;
        lblUnit.frame=CGRectMake(768/7*3+(768-768/7*3)/5*2, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:lblUnit];
        
        lbltalPreice=[[UILabel alloc] init];
        lbltalPreice.textAlignment=NSTextAlignmentRight;
        lbltalPreice.frame=CGRectMake(768/7*3+(768-768/7*3)/5*3, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:lbltalPreice];
        lblcui=[[UILabel alloc] init];
        lblcui.textAlignment=NSTextAlignmentCenter;
        lblcui.frame=CGRectMake(768/7*3+(768-768/7*3)/5*4, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:lblcui];
        lblcui=[[UILabel alloc] init];
        lblcui.textAlignment=NSTextAlignmentCenter;
        lblcui.frame=CGRectMake(768/7*3+(768-768/7*3)/5*4, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:lblcui];
        lblfujia=[[UILabel alloc] init];
        lblfujia.textAlignment=NSTextAlignmentLeft;
        lblfujia.frame=CGRectMake(40,40,768-40,40);
        lblfujia.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:lblfujia];
        view=[[UILabel alloc] initWithFrame:CGRectMake(0, 59, 768, 2)];
        view.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:view];
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [swipeLeft setNumberOfTouchesRequired:1];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setNumberOfTouchesRequired:1];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.contentView addGestureRecognizer:swipeLeft];
        [self.contentView addGestureRecognizer:swipeRight];

        
    }
    return self;
}
#pragma mark - 长按事件
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        if ([Mode isEqualToString:@"zc"]&&[[_ZCdataDic objectForKey:@"UNITCNT"] isEqualToString:@"Y"])
        {
            [_delegate changeCountCell:self];
        }
    }
}
//- (NSArray *)leftButtons
//{
////    __typeof(self) __weak weakSelf = self;
//    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"Delete" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
//        [cell completePinToTopViewAnimation];
////        [weakSelf leftMostButtonSwipeCompleted:cell];
//        NSLog(@"Left Button: Delete Pressed");
//    }];
//    
//    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"Mark as unread" color:[UIColor blueColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mark As Unread" message:@"Done!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        NSLog(@"Left Button: Mark as unread Pressed");
//    }];
//    
//    return @[button1, button2];
//}
//
//- (NSArray *)rightButtons
//{
////    __typeof(self) __weak weakSelf = self;
//    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"Archive" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
//        [cell completePinToTopViewAnimation];
////        [weakSelf rightMostButtonSwipeCompleted:cell];
//        NSLog(@"Right Button: Archive Pressed");
//    }];
//    
//    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"Flag" color:[UIColor blueColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag" message:@"Flag pressed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        NSLog(@"Right Button: Flag Pressed");
//    }];
//    JAActionButton *button3 = [JAActionButton actionButtonWithTitle:@"More" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"More Options" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Option 1" otherButtonTitles:@"Option 2",nil];
//        [sheet showInView:self.superview];
//        NSLog(@"Right Button: More Pressed");
//    }];
//    
//    return @[button1, button2, button3];
//}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic=dataDic;
    [btn setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:[[dataDic objectForKey:@"select"] intValue]==1?@"select_yes.png":@"select_no.png"]];
    NSArray *ary4=[[dataDic objectForKey:@"fujianame"] componentsSeparatedByString:@"!"];
    if ([ary4 count]==1&&([dataDic objectForKey:@"fujianame"]==NULL||[dataDic objectForKey:@"fujianame"]==nil||[[dataDic objectForKey:@"fujianame"] isEqualToString:@""])) {
        view.frame=CGRectMake(0, 49, 768, 2);
        lblfujia.hidden=YES;
    }else
    {
        lblfujia.hidden=NO;
        view.frame=CGRectMake(0, 79, 768, 2);
    }
    NSArray *ary5=[[dataDic objectForKey:@"fujiaPrice"] componentsSeparatedByString:@"!"];
    float fAdditionPrice=0.00f;
    if ([ary5 count]>0) {
        for (NSString *addition in ary5) {
            fAdditionPrice+=[addition floatValue];
        }
    }
    NSMutableString *FujiaName =[NSMutableString string];
    FujiaName=[NSMutableString stringWithFormat:@"附加项:"];
    for (NSString *str1 in ary4) {
        [FujiaName appendFormat:@"%@ ",str1];
    }
    [FujiaName appendFormat:@"附加项价格:%.2f",fAdditionPrice];
    lblfujia.text=FujiaName;
    lblCount.text=[dataDic objectForKey:@"pcount"];
    lblPrice.text=[dataDic objectForKey:@"price"];
    if ([[dataDic objectForKey:@"pcount"] intValue]-[[dataDic objectForKey:@"Over"] intValue]==0) {
        [lblover setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Neat.png"]];
        lblhua.hidden=NO;
    }
    else
    {
        [lblover setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Irregular.png"]];
        lblhua.hidden=YES;
    }
    over.text=[NSString stringWithFormat:@"%d/%@",[[dataDic objectForKey:@"pcount"] intValue]-[[dataDic objectForKey:@"Over"] intValue],[dataDic objectForKey:@"pcount"]];
    
    
    if([Singleton sharedSingleton].isYudian)
    {
        lblstart.text=@"预";
        lblstart.textColor=[UIColor orangeColor];
    }
    else if([[dataDic objectForKey:@"CLASS"] intValue]==2)
    {
        lblstart.text=@"叫";
        lblstart.textColor=[UIColor redColor];
    }
    else if([[dataDic objectForKey:@"CLASS"] intValue]==1)
    {
        lblstart.text=@"即";
        lblstart.textColor=[UIColor blueColor];
    }else
    {
        lblstart.text=@"";
    }
    
    if ([[dataDic objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dataDic objectForKey:@"Tpcode"] isEqualToString:[dataDic objectForKey:@"Pcode"]]||[[dataDic objectForKey:@"Tpcode"] isEqualToString:@""]) {
        lblPrice.text=[NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"price"] floatValue]];
        if ([[dataDic objectForKey:@"promonum"] intValue]>0) {
            lblCame.text=[NSString stringWithFormat:@"%@-赠%@",[dataDic objectForKey:@"PCname"],[dataDic objectForKey:@"promonum"]];
            lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"talPreice"] floatValue]];
            lblCount.text=[dataDic objectForKey:@"pcount"];
        }
        else
        {
            lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[dataDic objectForKey:@"talPreice"] floatValue]];
            
            lblCame.text=[dataDic objectForKey:@"PCname"];
            
        }
        lblUnit.text=[dataDic objectForKey:@"unit"];
        lblcui.text=[NSString stringWithFormat:[[CVLocalizationSetting sharedInstance] localizedString:@"Urge"],[[dataDic objectForKey:@"Urge"] intValue]];
    }
    else
    {
        lblCame.text=[NSString stringWithFormat:@"--%@",[dataDic objectForKey:@"PCname"]];
        
        lblCount.text=[dataDic objectForKey:@"pcount"];
        lblUnit.text=[dataDic objectForKey:@"unit"];
        lblcui.text=[NSString stringWithFormat:@"催%d次",[[dataDic objectForKey:@"Urge"] intValue]];
    }

}
-(void)setZCdataDic:(NSDictionary *)ZCdataDic{
    _ZCdataDic=ZCdataDic;
    //选择按钮
    [btn setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:[[ZCdataDic objectForKey:@"select"] intValue]==1?@"select_yes.png":@"select_no.png"]];
    //菜品状态
    lblstart.textColor=[[ZCdataDic objectForKey:@"CLASS"] isEqualToString:@"即"]?[UIColor redColor]:([[ZCdataDic objectForKey:@"CLASS"] isEqualToString:@"叫"]?[UIColor redColor]:[UIColor orangeColor]);
    lblstart.text=[ZCdataDic objectForKey:@"CLASS"];
    
    if ([[ZCdataDic objectForKey:@"fujia"] length]<1) {
        view.frame=CGRectMake(0, 49, 768, 2);
        lblfujia.hidden=YES;
    }else
    {
        lblfujia.hidden=NO;
        NSMutableString *FujiaName =[NSMutableString string];
        FujiaName=[NSMutableString stringWithFormat:@"附加项:"];
        [FujiaName appendFormat:@"%@ ",[ZCdataDic objectForKey:@"fujia"]];
        lblfujia.text=FujiaName;
        view.frame=CGRectMake(0, 79, 768, 2);
    }
    lblCount.text=[ZCdataDic objectForKey:@"pcount"];
    lblPrice.text=[NSString stringWithFormat:@"%.2f",[[ZCdataDic objectForKey:@"price"] floatValue]];
    lblUnit.text=[ZCdataDic objectForKey:@"unit"];
    lblcui.text=[NSString stringWithFormat:@"催%d次",[[ZCdataDic objectForKey:@"Urge"] intValue]];
    lblCame.text=[ZCdataDic objectForKey:@"PCname"];
    lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[ZCdataDic objectForKey:@"talPreice"] floatValue]];
    if ([ZCdataDic objectForKey:@"Over"]) {
        [lblover setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Neat.png"]];
        lblhua.hidden=NO;
    }
    else
    {
        [lblover setImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"Irregular.png"]];
        lblhua.hidden=YES;
    }

}
/* 识别侧滑 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        location.x -= 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight                forView:self.contentView cache:YES];
        } completion:^(BOOL finished) {
            [_delegate cell:self hua:@"0"];
        }];
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        location.x -= 0.0;
    }
    else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        location.x -= 0.0;
    }
    else{
        location.x += 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft                 forView:self.contentView cache:YES];
        } completion:^(BOOL finished) {
            [_delegate cell:self hua:@"1"];
        }];
        
    }
}

//- (void)drawImageForGestureRecognizer:(UIGestureRecognizer *)recognizer
//                              atPoint:(CGPoint)centerPoint underAdditionalSituation:(NSString *)addtionalSituation{
//    NSString *imageName = @"title.png";
//    self.imageView.image = [UIImage imageNamed:imageName];
//    self.imageView.center = centerPoint;
//    self.imageView.alpha = 0.2;
//	
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
