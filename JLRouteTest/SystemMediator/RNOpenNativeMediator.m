//
//  RNOpenNativeMediator.m
//  JLRouteTest
//
//  Created by mac on 2017/4/5.
//  Copyright © 2017年 GY. All rights reserved.
//

#import "RNOpenNativeMediator.h"
#import "SystemMediator.h"

@implementation RNOpenNativeMediator

RCT_EXPORT_MODULE()
//RN跳转原生界面
RCT_EXPORT_METHOD(RNOpenOneVC:(NSDictionary *)msg) {
    NSLog(@"RN传入原生界面的数据为:%@",msg);
    NSString *module = msg[@"module"];
    NSString *target = msg[@"target"];
    NSString *action = msg[@"action"];
    NSDictionary *parameter = msg[@"parameter"];
    NSString *parameterStr = [self dataTOjsonString:parameter];
    NSString *urlStr = [NSString stringWithFormat:@"JLRoutesTest://%@/%@/%@/%@",module,target,action,parameterStr];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __block NSURL *url = [NSURL URLWithString:urlStr];
    //主要这里必须使用主线程发送,不然有可能失效
    dispatch_async(dispatch_get_main_queue(), ^{
        [[SystemMediator sharedInstance] openModuleWithURL:url];
    });
}

- (NSString *)dataTOjsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end