//  RNMomosdk.m
//  Created by Lanh Lukas on 11/23/18.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import "RNMomosdk.h"
#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#define IS_IOS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)
#define MOMO_APP_ITUNES_DOWNLOAD_PATH @"itms-apps://itunes.apple.com/us/app/momo-chuyen-nhan-tien/id918751511"
#define stringIndexOf(fulltext, textcompare) ([fulltext rangeOfString: textcompare ].location != NSNotFound)
@implementation RNMomosdk
RCT_EXPORT_MODULE()
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
- (void)startObserving
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emitEventInternal:)
                                                 name:@"event-emitted"
                                               object:nil];
}

- (void)stopObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (NSArray<NSString *> *)supportedEvents
{
    return @[@"RCTNotSupportEvents",@"RCTMoMoNoficationCenterRequestTokenReceived",@"RCTMoMoNoficationCenterRequestTokenState"];
}
RCT_EXPORT_METHOD(requestPayment:(id)paymentinfo){
    NSDictionary *dic = paymentinfo;
    if ([dic isKindOfClass:[NSString class]]){
        NSData *data = [paymentinfo dataUsingEncoding:NSUTF8StringEncoding];
        dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    [self requestToken: dic];
}

+ (void)handleOpenUrl:(NSURL*)url
{
    NSString *absUrl = url.absoluteString;
    if (absUrl != nil && stringIndexOf(absUrl,@"fromapp=momotransfer")){
        NSLog(@"<MoMoPay> postNotificationName RCTMoMoNoficationCenterRequestTokenReceived");
        NSDictionary *payload = [self dictionaryFromQueryUrl:absUrl];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"event-emitted"
                                                            object:self
                                                          userInfo:payload];
    }else{
        NSLog(@"<MoMoPay> nothing to do");
    }
}

-(void)requestToken:(NSDictionary*)paymentInfo{
    if ([paymentInfo isKindOfClass:[NSNull class]]) {
        NSLog(@"<MoMoPay> Payment information should not be null.");
        return;
    }
    //Open MoMo App to get token
    
    if ([paymentInfo isKindOfClass:[NSDictionary class]] || [paymentInfo isKindOfClass:[NSMutableDictionary class]]) {
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        NSString *inputParams = [NSString stringWithFormat:@"action=gettoken&partner=merchant&sdktype=reactnative&appSource=%@",bundleIdentifier];
        NSString *environment = @"debug"; //production
        if (paymentInfo[@"action"] && ![paymentInfo[@"action"]  isEqual: @""]) {
            inputParams = [NSString stringWithFormat:@"action=%@&partner=merchant&sdktype=reactnative&appSource=%@",paymentInfo[@"action"],bundleIdentifier];
        }
        NSLog(@"<MoMoPay> Your are requesting token via MoMo App - %@ environment", [environment uppercaseString]);
        if (paymentInfo[@"environment"] && ![paymentInfo[@"environment"]  isEqual: @""]) {
            environment = [NSString stringWithFormat:@"%@",paymentInfo[@"environment"]];
        }
        
        if ([environment isEqualToString:@"debug"]){
            NSLog(@"<MoMoPay> WARINING. Make sure already installed MoMo Test App and Login by Demo Account");
        }else{
            NSLog(@"<MoMoPay> WARINING. Make sure already installed MoMo Live App from Apple Store and Login by Live Account");
        }
        BOOL isHandleAppNotInstalled = YES;
        for (NSString *key in [paymentInfo allKeys]) {
            if ([paymentInfo objectForKey:key] != nil) {
                inputParams = [inputParams stringByAppendingFormat:@"&%@=%@",key,[paymentInfo objectForKey:key]];
                if ([key isEqualToString:@"handleAppNotInstalledBySelf"] && [[paymentInfo objectForKey:key] intValue] == 1) {
                    isHandleAppNotInstalled = NO;
                }
            }
        }
        
        NSString *appSource = [[NSString stringWithFormat:@"momo://?%@",inputParams] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *ourURL = [NSURL URLWithString:appSource];
        
        if ([[UIApplication sharedApplication] canOpenURL:ourURL])
        {
            NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@(1),@"status",
                                     @"Parameters valid - ready to open MoMo app. Make sure the application have an implement of [RNMomosdk handleOpenUrl] to receive data",@"message",nil];
            [self sendEventWithName:@"RCTMoMoNoficationCenterRequestTokenState" body:payload];
            UIApplication *application = [UIApplication sharedApplication];
            if (IS_IOS_10_OR_LATER && [application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                NSLog(@"<MoMoPay>iOS 10.X openURL");
                [application openURL:ourURL options:@{}
                   completionHandler:^(BOOL success) {
                       ////
                   }];
            }
            else{
                NSLog(@"<MoMoPay>iOS 9.X openURL");
                [[UIApplication sharedApplication] openURL:ourURL];
            }
        }
        else{
            NSLog(@"<MoMoPay> CAN NOT open momo app via deeplink momo:// . Make sure LSApplicationQueriesSchemes includes string: momo ");
            NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@(2),@"status",
                                     @"canOpenURL failed for URL MoMo app. Make sure LSApplicationQueriesSchemes includes string 'momo' and MoMo app is installed",@"message",
                                     @"https://momo.vn/download",@"fallbackUrl",
                                     MOMO_APP_ITUNES_DOWNLOAD_PATH,@"appstore",nil];
            [self sendEventWithName:@"RCTMoMoNoficationCenterRequestTokenState" body:payload];
            if (isHandleAppNotInstalled) {
                NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:MOMO_APP_ITUNES_DOWNLOAD_PATH]];
                if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
                    [[UIApplication sharedApplication] openURL:appStoreURL];
                }
            }else{
                NSLog(@"<MoMoPay> handle app is not install by your self");
            }
        }
    }else{
        NSLog(@"<MoMoPay> Params invalid. Make sure paymentInfo is NSDictionary type ");
        NSDictionary *payload = [NSDictionary dictionaryWithObjectsAndKeys:@(3),@"status",
                                 @"Parameters invalid. Parameters must be an dictionary",@"message",
                                 @"https://github.com/momo-wallet/mobile-sdk",@"fallbackUrl",nil];
        [self sendEventWithName:@"RCTMoMoNoficationCenterRequestTokenState" body:payload];
    }
}
+(NSString*) stringForCStr:(const char *) cstr{
    if(cstr){
        return [NSString stringWithCString: cstr encoding: NSUTF8StringEncoding];
    }
    return @"";
}
+(NSDictionary*)dictionaryFromQueryUrl:(NSString*)urlPararm{
    NSArray *components;
    NSURL *_tempUrl = [NSURL URLWithString:urlPararm];
    if ([_tempUrl isKindOfClass:[NSURL class]]) {
        components = [_tempUrl.query componentsSeparatedByString:@"&"];
    }
    else{
        NSString *parramString = urlPararm;
        NSArray *_arraySchemeRemoved = [urlPararm componentsSeparatedByString:@"?"];
        if (_arraySchemeRemoved.count>1) {
            parramString = [_arraySchemeRemoved objectAtIndex:1];
        }
        components = [parramString componentsSeparatedByString:@"&"];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    // parse parameters to dictionary
    for (NSString *param in components) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        // get key, value
        NSString* key   = [elts objectAtIndex:0];
        key = [key stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSString* value = [elts objectAtIndex:1];
        
        ///Start Fix HTML Property issue
        if ([elts count]>2) {
            @try {
                value = [param substringFromIndex:([param rangeOfString:@"="].location+1)];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        ///End HTML Property issue
        if(value){
            value = [self stringForCStr:[value UTF8String]];
        }
        
        //
        if(key.length && value.length){
            [params setObject:value forKey:key];
        }
    }
    return params;
}

- (void)emitEventInternal:(NSNotification *)notification
{
    NSLog(@"<MoMoPay> emitEventInternal %@", notification.userInfo );
    [self sendEventWithName:@"RCTMoMoNoficationCenterRequestTokenReceived"
                       body:notification.userInfo];
}

@end

