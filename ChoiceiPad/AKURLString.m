//
//  AKURLString.m
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import "AKURLString.h"
#import "AKFilePath.h"
#import "PaymentSelect.h"


#define AkSocketServer   @"61.174.28.122:8010"
@implementation AKURLString
+(NSString *)getMainURLWithKey:(NSString *)HHTName
{
    NSString *plistPath = [AKFilePath  getDocumentFilePathWithFileName:@"apiList.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [AKFilePath getBundleFilePathWithFileName:@"apiList.plist"];
    }
//    NSString *keyStr = [[NSDictionary dictionaryWithContentsOfFile:plistPath]objectForKey:key]; 
    NSString *ipPath = [AKFilePath getDocumentFilePathWithFileName:@"ip.plist"];
    NSString *ipStr= [[NSDictionary dictionaryWithContentsOfFile:ipPath]objectForKey:@"ip"];
    if (!ipStr) {
        ipStr = AkSocketServer;
    }
    NSString *mainUrl = [NSString stringWithFormat:WEBSERVICEURL,ipStr,HHTName];
    return mainUrl;
}
+(NSString *)getMainURLWithKey1:(NSString *)key
{
    NSString *plistPath = [AKFilePath  getDocumentFilePathWithFileName:@"apiList.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [AKFilePath getBundleFilePathWithFileName:@"apiList.plist"];
    }
    NSString *keyStr = [[NSDictionary dictionaryWithContentsOfFile:plistPath]objectForKey:key];
    NSString *ipPath = [AKFilePath getDocumentFilePathWithFileName:@"ip.plist"];
    NSString *ipStr= [[NSDictionary dictionaryWithContentsOfFile:ipPath]objectForKey:@"ip"];
    if (!ipStr) {
        ipStr = AkSocketServer;
    }
    NSString *mainUrl = [NSString stringWithFormat:@"http://%@/ChoiceWebService/services/HHTSocket?%@",ipStr,keyStr];
    return mainUrl;
}


@end
