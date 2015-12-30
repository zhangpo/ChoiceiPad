//
//  AKScanTableView.m
//  XinLaDaoBookSystemCode
//
//  Created by chensen on 15/6/9.
//  Copyright (c) 2015年 凯_SKK. All rights reserved.
//

#import "AKScanTableView.h"

@implementation AKScanTableView
{
    ZBarReaderView *_readerView;
    NSString       *readStr;
}
@synthesize delegate=_delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
        [image setImage:[UIImage imageNamed:@"JD.jpg"]];
        [self addSubview:image];
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(180, 780, 400, 80);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor=[UIColor clearColor];
        [self addSubview:button];
        
        _readerView = [[ZBarReaderView alloc]init];
        _readerView.frame = CGRectMake(205,425, 345, 345);
        _readerView.readerDelegate = self;
        _readerView.tag=100;
        //关闭闪光灯
        _readerView.torchMode = 0;
        //扫描区域
        CGRect scanMaskRect = CGRectMake(60, CGRectGetMidY(_readerView.frame) - 126, 600, 600);
        //处理模拟器
        if (TARGET_IPHONE_SIMULATOR) {
            ZBarCameraSimulator *cameraSimulator
            = [[ZBarCameraSimulator alloc]initWithViewController:self];
            cameraSimulator.readerView = _readerView;
        }
        
        //扫描区域计算
//        _readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:_readerView.bounds];
        _readerView.scanCrop=CGRectMake(0, 0, 1, 1);
        
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
//按钮事件
-(void)buttonClick:(UIButton *)button{
    ZBarReaderView *view=(ZBarReaderView *)[self viewWithTag:100];
    if (view) {
        [_readerView stop];
        [view removeFromSuperview];
    }else
    {
        [_readerView start];
        [self addSubview:_readerView];
    }
}
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    for (ZBarSymbol *symbol in symbols) {
        NSLog(@"%@", symbol.data);
        readStr=symbol.data;
        break;
    }
    if (readStr) {
        [readerView stop];
        [_delegate AKScanTableViewClick:readStr];
        [_readerView removeFromSuperview];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
