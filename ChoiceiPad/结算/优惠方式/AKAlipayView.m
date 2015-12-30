//
//  AKAlipayView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/5/16.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKAlipayView.h"


@implementation AKAlipayView
{
    NSString *readStr;
    NSDictionary *_alipay;
    UITextField *text;
}
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withAlipayDict:(NSDictionary *)alipayDict
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:[alipayDict objectForKey:@"OPERATENAME"]];
        _alipay=alipayDict;
        // Initialization code
        ZBarReaderView *readerView = [[ZBarReaderView alloc]init];
        readerView.frame = CGRectMake(20, 60, 250, 250);
        readerView.readerDelegate = self;
        readerView.tag=100;
        //关闭闪光灯
        readerView.torchMode = 0;
        //扫描区域
        CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(readerView.frame) - 126, 250, 250);
        
        //处理模拟器
        if (TARGET_IPHONE_SIMULATOR) {
            ZBarCameraSimulator *cameraSimulator
            = [[ZBarCameraSimulator alloc]initWithViewController:self];
            cameraSimulator.readerView = readerView;
        }
        [self addSubview:readerView];
//         [self presentViewController:reader animated:YES completion:nil];
        //扫描区域计算
        
        readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.bounds];
        [readerView start];
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(280, 70,200, 40)];
        lb.text=[NSString stringWithFormat:@"付款金额:%@",[alipayDict objectForKey:@"PAYABILL"]];
        lb.font=[UIFont systemFontOfSize:20];
        [self addSubview:lb];
        text=[[UITextField alloc] initWithFrame:CGRectMake(280, 120, 300, 40)];
        [self addSubview:text];
        UIButton *buttonSure = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonSure.frame=CGRectMake(270, 265, 90, 40);
        buttonSure.titleLabel.textColor=[UIColor whiteColor];
        buttonSure.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [buttonSure setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [buttonSure setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"OK"] forState:UIControlStateNormal];
        buttonSure.tag=1;
        [buttonSure addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonSure];
        UIButton *buttonCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCancle.frame=CGRectMake(370, 265, 90, 40);
        buttonCancle.titleLabel.textColor=[UIColor whiteColor];
        buttonCancle.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [buttonCancle setBackgroundImage:[[CVLocalizationSetting sharedInstance] imgWithContentsOfFile:@"AlertViewButton.png"] forState:UIControlStateNormal];
        [buttonCancle setTitle:[[CVLocalizationSetting sharedInstance] localizedString:@"Cancel"] forState:UIControlStateNormal];
        buttonCancle.tag=2;
        [buttonCancle addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonCancle];
    }
    return self;
}


-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        readStr=symbol.data;
        break;
    }
    if (readStr) {
        [_alipay setValue:readStr forKey:@"auth_code"];
//        [_delegate AKAlipayViewButtonClick:_alipay];
        [readerView stop];
        [_delegate AKAlipayViewButtonClick:_alipay];
//        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.tag=1;
//        [self buttonClick:btn];
    }
    
}
//-(void)
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag==1) {
        if (!readStr&&[text.text length]>0) {
            readStr =text.text;
        }
        if (!readStr) {
            UIAlertView  *alet=[[UIAlertView alloc] initWithTitle:@"请扫描支付宝后进行结算" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alet show];
            return;
        }
        [_alipay setValue:readStr forKey:@"auth_code"];
        [_delegate AKAlipayViewButtonClick:_alipay];
    }else
    {
        [_delegate AKAlipayViewButtonClick:nil];
    }
}
@end
