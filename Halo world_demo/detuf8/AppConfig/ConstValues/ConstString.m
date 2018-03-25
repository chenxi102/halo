//
//  ConstString.m
//  detuf8
//
//  Created by Seth on 2017/11/30.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "ConstString.h"




// url
#if DEBUG
NSString const * APP_NET_JSON_URL = @"APP_NET_JSON_URL_DEBUG" ;
#elif DELEASE_TEST
NSString const * APP_NET_JSON_URL = @"APP_NET_JSON_URL_ENTERPRISE" ;
#else
NSString const * APP_NET_JSON_URL = @"APP_NET_JSON_URL_APPSTORE" ;
#endif


NSString const * Socket_exception_String = @"Socket_exception_String";


// notice
NSNotificationName const AppLanguageChangeNotify = @"AppLanguageChangeNotify";
NSNotificationName const CameraExceptionNotify = @"CameraExceptionNotify";
NSNotificationName const applicationStateNotify = @"applicationStateNotify";


