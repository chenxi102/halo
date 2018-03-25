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
    requestM.HTTPMethod = httpModel.httpType;
    requestM.HTTPBody = [NSJSONSerialization dataWithJSONObject:httpModel.params options:(NSJSONWritingPrettyPrinted) error:nil];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:requestM completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          if (res) {
                                              res(data, response, error);
                                          }
                                      }];
    
    [dataTask resume];
}
@end
