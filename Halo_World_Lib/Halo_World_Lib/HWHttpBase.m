//
//  HWHttpBase.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/25.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWHttpBase.h"

@implementation HWHttpBase

- (void)sendDataWithHttpModel:(nonnull HWHttpModel *)httpModel result:(void(^_Nullable)(NSData* _Nullable, NSURLResponse* _Nullable, NSError* _Nullable))res {
    
    NSURL * url = [NSURL URLWithString:httpModel.url];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.cachePolicy = NSURLRequestReloadIgnoringCacheData;
//    [requestM setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    requestM.HTTPMethod = httpModel.httpType;
//    NSData * data = [NSJSONSerialization dataWithJSONObject:httpModel.params options:(NSJSONWritingPrettyPrinted) error:nil];
//    NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    dataStr = [dataStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    requestM.HTTPBody =  [httpModel.params dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
//    NSLog(@"发起请求: url:%@ params:%@ ", httpModel.url, httpModel.params);
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          if (res) {
                                              res(data, response, error);
                                          }
                                      }];
    
    [dataTask resume];
    
}
@end
