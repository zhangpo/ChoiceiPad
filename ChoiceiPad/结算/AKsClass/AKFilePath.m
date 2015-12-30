//
//  AKFilePath.m
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import "AKFilePath.h"
#define kPDAID          @"8"
@implementation AKFilePath
+(NSString *)getBundleFilePathWithFileName:(NSString *)name
{
    return [[NSBundle mainBundle] pathForResource:name ofType:nil];
}
+(NSString *)getDocumentFilePathWithFileName:(NSString *)name
{
    NSArray *docPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [docPaths objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:name];
    return filePath;
}

+(NSString *)getPadID{
    NSString *deviceID=[[NSUserDefaults standardUserDefaults] objectForKey:@"PDAID"];
    return deviceID;
}
+(NSDictionary *)getDicCurrentPageConfig
{
    
//    aryPageConfigList = mut>0?[[NSArray arrayWithArray:mut] retain]:nil;
    
    //  当前选择的配置
    NSDictionary *pageConfig = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentPageConfig"];
    if (!pageConfig){
        //  配置文件列表
        NSArray *pageConfigAry = [NSArray arrayWithContentsOfFile:[@"PageConfigList.plist" documentPath]];
        if (!pageConfigAry)
            pageConfigAry = [NSArray arrayWithContentsOfFile:[@"PageConfigListDemo.plist" bundlePath]];
        NSMutableArray *mut = [NSMutableArray array];
        for (int i=0;i<pageConfigAry.count;i++){
            //        NSLog(@"ary = %@",ary);
            NSDictionary *dict = [pageConfigAry objectAtIndex:i];
            NSString *pathLayout = [dict objectForKey:@"layout"];
            NSString *pathSQLite = [dict objectForKey:@"sqlite"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            BOOL layoutExist = ([fileManager fileExistsAtPath:[pathLayout documentPath]] || [fileManager fileExistsAtPath:[pathLayout bundlePath]]);
            BOOL sqliteExist = ([fileManager fileExistsAtPath:[pathSQLite documentPath]] || [fileManager fileExistsAtPath:[pathSQLite bundlePath]]);
            if (layoutExist && sqliteExist)
                [mut addObject:dict];
        }
        NSArray *ary = [NSArray arrayWithArray:mut];
        if (ary.count>0)
            pageConfig = [ary objectAtIndex:0];
        if (!pageConfig){
            pageConfig = [NSDictionary dictionaryWithObjectsAndKeys:@"PageConfigDemo.plist",@"layout",@"BookSystem.sqlite",@"sqlite",@"Demo",@"name",@"1",@"number", nil];
            [[NSUserDefaults standardUserDefaults] setObject:pageConfig
                                                      forKey:@"CurrentPageConfig"];
        }
    }
    return pageConfig;
}
@end
