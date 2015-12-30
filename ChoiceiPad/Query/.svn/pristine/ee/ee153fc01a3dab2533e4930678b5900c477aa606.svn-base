//
//  BSQueryCell.m
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSQueryCell.h"
#import "FMDatabase.h"
#import "BSDataProvider.h"


@implementation BSQueryCell
{
    CGPoint startPoint;
    BOOL bMove;
}
@synthesize lblCame=_lblCame,lblPrice=_lblPrice,lblUnit=_lblUnit,lblCount=_lblCount,delegete=_delegate,btn=_btn,lblcui=_lblcui,lblover=_lblover,lbltalPreice=_lbltalPreice,over=_over,lblstart=_lblstart,lblfujia=_lblfujia,view=_view,dataDic=_dataDic,lblhua=_lblhua;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        UIScrollView *scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 50)];
        [scrollview setContentSize:CGSizeMake(768, 50)];
        _lblhua=[[UILabel alloc] initWithFrame:CGRectMake(768/7*2, 25, 500, 2)];
        _lblhua.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_lblhua];
        _btn=[[UIImageView alloc] init];
        _btn.userInteractionEnabled=YES;
        _btn.frame=CGRectMake(30, 15, 20, 20);
        _btn.backgroundColor=[UIColor blackColor];
        //        [_btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
        _lblstart=[[UILabel alloc] initWithFrame:CGRectMake(768/7-40, 10, 35, 35)];
        [self.contentView addSubview:_lblstart];
        _over=[[UILabel alloc] initWithFrame:CGRectMake(768/7-10, 10, 35+10, 40)];
        
        [self.contentView addSubview:_over];
        _lblover=[[UIImageView alloc] initWithFrame:CGRectMake(768/7+35,10,40, 40)];
        [self.contentView addSubview:_lblover];
        _lblCame=[[UILabel alloc] init];
        _lblCame.numberOfLines =0;
        _lblCame.lineBreakMode = UILineBreakModeWordWrap;
        _lblCame.frame=CGRectMake(768/7*2, 0, 768/7,50);
        [self.contentView addSubview:_lblCame];
        _lblCount=[[UILabel alloc] init];
        _lblCount.textAlignment=NSTextAlignmentCenter;
        _lblCount.frame=CGRectMake(768/7*3, 0, (768-768/7*3)/5, 40);
        [self.contentView addSubview:_lblCount];
        _lblPrice=[[UILabel alloc] init];
        _lblPrice.textAlignment=NSTextAlignmentRight;
        _lblPrice.frame=CGRectMake(768/7*3+(768-768/7*3)/5, 0, (768-768/7*3)/5, 40);
        [self.contentView addSubview:_lblPrice];
        _lblUnit=[[UILabel alloc] init];
        _lblUnit.textAlignment=NSTextAlignmentCenter;
        _lblUnit.frame=CGRectMake(768/7*3+(768-768/7*3)/5*2, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:_lblUnit];
        
        _lbltalPreice=[[UILabel alloc] init];
        _lbltalPreice.textAlignment=NSTextAlignmentRight;
        _lbltalPreice.frame=CGRectMake(768/7*3+(768-768/7*3)/5*3, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:_lbltalPreice];
        _lblcui=[[UILabel alloc] init];
        _lblcui.textAlignment=NSTextAlignmentCenter;
        _lblcui.frame=CGRectMake(768/7*3+(768-768/7*3)/5*4, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:_lblcui];
        _lblcui=[[UILabel alloc] init];
        _lblcui.textAlignment=NSTextAlignmentCenter;
        _lblcui.frame=CGRectMake(768/7*3+(768-768/7*3)/5*4, 0,(768-768/7*3)/5, 40);
        [self.contentView addSubview:_lblcui];
        _lblfujia=[[UILabel alloc] init];
        _lblfujia.textAlignment=NSTextAlignmentLeft;
        _lblfujia.frame=CGRectMake(40,40,768-40,40);
        _lblfujia.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_lblfujia];
        _view=[[UIView alloc] initWithFrame:CGRectMake(0, 59, 768, 2)];
        _view.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_view];
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
////滑动开始事件
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint pointone = [touch locationInView:self.view];//获得初始的接触点
//    startPoint  = pointone;
//}
////滑动移动事件
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    //imgViewTop是滑动后最后接触的View
//    CGPoint pointtwo = [touch locationInView:self];  //获得滑动后最后接触屏幕的点
//    
//    if(fabs(pointtwo.x-startPoint.x)>100)
//    {  //判断两点间的距离
//        bMove = YES;
//    }
//}
////滑动结束处理事件
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint pointtwo = [touch locationInView:self.view];  //获得滑动后最后接触屏幕的点
//    if((fabs(pointtwo.x-startPoint.x)>50)&&(bMove))
//    {
//        //判断点的位置关系 左滑动
//        if(pointtwo.x-startPoint.x>0)
//        {   //左滑动业务处理
//            NSLog(@"判断点的位置关系 左滑动");
//            [_delegate cell:self hua:@"0"];
//
//            [UIView animateWithDuration:0.5 animations:^{
//                self.imageView.alpha = 0.2;
//                self.imageView.center = CGPointMake(0,50);
//            }];
////            if (clicks>0) {
////                clicks--;
////                if ([wyKPI.sortZbs count]>1) {
////                    [btnRight setEnabled:YES];
////                    if(clicks==0)
////                    {
////                        [btnLeft setEnabled:NO];
////                        [btnRight setEnabled:YES];
////                    }
////                    [labTitle setText:[wyKPI.sortZbs objectAtIndex:(NSUInteger)clicks]];
////                    [labTitle setFont:[UIFont systemFontOfSize:14.0f]];
////                    [tabWyKPI reloadData];
////                }
////            }
//        }
//        //判断点的位置关系 右滑动
//        else
//        {
//            NSLog(@"判断点的位置关系 右滑动");
//            [_delegate cell:self hua:@"1"];
//            self.imageView.alpha=0;
//            //右滑动业务处理
////            if (clicks<[wyKPI.sortZbs count]-1) {
////                clicks++;
////                if ([wyKPI.sortZbs count]>1) {
////                    [btnLeft setEnabled:YES];
////                    if(clicks==[wyKPI.sortZbs count]-1)
////                    {
////                        [btnLeft setEnabled:YES];
////                        [btnRight setEnabled:NO];
////                    }
////                    [labTitle setText:[wyKPI.sortZbs  objectAtIndex:clicks]];
////                    [labTitle setFont:[UIFont systemFontOfSize:14.0f]];
////                    [tabWyKPI reloadData];
////                }
////            }
//        }
//        
//    }
//}
/* 识别侧滑 */
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];
    
//	[self drawImageForGestureRecognizer:gestureRecognizer atPoint:location underAdditionalSituation:nil];
    NSLog(@"%f",location.x);
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

-(void)cuiClick:(UIButton *)btn
{
    [_delegate cell:self cuiClick:@"<#string#>"];
}
-(void)tuiClick:(UIButton *)btn
{
    [_delegate cell:self tuiClick:@"<#string#>"];
    NSLog(@"退菜");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
