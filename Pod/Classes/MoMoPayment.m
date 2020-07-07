//
//  MoMoPayment.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//  Last updated: 2020/07/03
//

#import "MoMoPayment.h"
#import "MoMoConfig.h"
#import <UIKit/UIKit.h>

#define stringIndexOf(fulltext, textcompare) ([fulltext rangeOfString: textcompare ].location != NSNotFound)
#define IS_IOS_10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)
static MoMoPayment *shareInstance = nil;
static NSMutableDictionary *paymentInfo = nil;
@implementation MoMoPayment

+(MoMoPayment*)shareInstances{
    if (!shareInstance) {
        shareInstance = [[super allocWithZone:NULL] init];
    }
    return shareInstance;
}

- (void)initAppBundleId:(NSString*)bundleid partnerCode:(NSString*)partnerCode partnerName:(NSString*)partnerName partnerNameLabel:(NSString*)partnerNameLabel billLabel:(NSString*)billLabel{
    [MoMoConfig setAppBundleId:bundleid];
    [MoMoConfig setMerchantcode:partnerCode];
    [MoMoConfig setMerchantname:partnerName];
    [MoMoConfig setMerchantnameLabel:@"Nhà cung cấp"];
    [MoMoConfig setUsernameLabel:@"Tài khoản"];
    [MoMoConfig setEnvironment:1];
    NSLog(@"<MoMoPay> initializing successful");
}
-(void)setMerchantName:(NSString*)merchantname merchantNameTitle:(NSString*)merchantNameTitle{
    
}

-(void)setBillName:(NSString*)merchantname billTitle:(NSString*)billTitle{
    
}

-(void)handleOpenUrl:(NSURL*)url
{
    NSString *sourceURI = [url absoluteString];
    NSDictionary *response = [self dictionaryFromUrlParram:sourceURI];
    NSString *partner = [NSString stringWithFormat:@"%@",[response objectForKey:@"fromapp"]];
    if (![partner isKindOfClass:[NSNull class]] && [[partner lowercaseString] isEqualToString:@"momotransfer"]) {
        if ([response count]) {
            
            NSString *status = [NSString stringWithFormat:@"%@",[response objectForKey:@"status"]];
            NSString *message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
            
            if ([status isEqualToString:MOMO_TOKEN_RESPONSE_SUCCESS]) {
                NSLog(@"<MoMoPay> SUCESS TOKEN.");
            }
            else if ([status isEqualToString:MOMO_TOKEN_RESPONSE_REGISTER_PHONE_NUMBER_REQUIRE]) {
                NSLog(@"<MoMoPay> REGISTER_PHONE_NUMBER_REQUIRE.");
            }
            else if ([status isEqualToString:MOMO_TOKEN_RESPONSE_LOGIN_REQUIRE]) {
                NSLog(@"<MoMoPay> LOGIN_REQUIRE.");
            }
            else if ([status isEqualToString:MOMO_TOKEN_RESPONSE_NO_WALLET]) {
                NSLog(@"<MoMoPay> NO_WALLET. You need to cashin to MoMo Wallet ");
            }
            NSLog(@"<MoMoPay> %@",message);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterTokenReceived" object:sourceURI];
        }
    }
    else
    {
        NSLog(@"<MoMoPay> Do nothing");
    }
}

-(void)createPaymentInformation:(NSMutableDictionary*)info
{
    [MoMoConfig setEnvironment:YES];
    paymentInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
}

-(void)updateAmount:(long long)amt
{
    [paymentInfo setValue:[NSNumber numberWithLongLong:amt] forKey:MOMO_PAY_CLIENT_AMOUNT_TRANSFER];
}

- (NSString*) stringForCStr:(const char *) cstr{
    if(cstr){
        return [NSString stringWithCString: cstr encoding: NSUTF8StringEncoding];
    }
    return @"";
}
-(NSMutableDictionary*)dictionaryFromUrlParram:(NSString*)urlPararm{
    NSArray *components;
    NSURL *_tempUrl = [NSURL URLWithString:urlPararm];
    NSLog(@"sourceUrl >> %@",urlPararm);
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
-(UIButton*)addMoMoPayCustomButton:(UIButton*)button forControlEvents:(UIControlEvents)controlEvents toView:(UIView*)parrentView
{
    if (controlEvents) {
        [button addTarget:self action:@selector(requestToken) forControlEvents:controlEvents];
    }
    else
    {
        [button addTarget:self action:@selector(requestToken) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [parrentView addSubview:button];
    
    return button;
}

-(void)addMoMoPayDefaultButtonToView:(UIView*)parrentView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];// [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [button setFrame:CGRectMake(0, 0, 50, 50)];
    [button setImage:[UIImage imageNamed:@"momo.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"momo_highlights.png"] forState:UIControlStateHighlighted];
    button.layer.borderColor   = [UIColor colorWithWhite:192/255.0 alpha:1].CGColor;
    button.layer.borderWidth   = 0;
    button.layer.cornerRadius  = 5;
    button.layer.masksToBounds = YES;
    
    [button addTarget:self action:@selector(requestToken) forControlEvents:UIControlEventTouchUpInside];
    [parrentView addSubview:button];
}

-(NSString*)getAction{
    return [MoMoConfig getAction];
}

-(void)setAction:(NSString*)action{
    [MoMoConfig setAction:action];
}
/*
//SDK v.2.2
//Dated: 7/25/17.
 */

-(NSString*)getDeviceInfoString{
    UIDevice *aDevice = [UIDevice currentDevice];
    NSString *deviceInfoString = [NSString stringWithFormat:@"iOS_%@ %@ %.2f",aDevice.name,aDevice.systemName,[aDevice.systemVersion floatValue]];
    return deviceInfoString;
}
- (NSData*)encodeDictionary:(NSDictionary*)dictionary
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

-(void)setSubmitURL:(NSString*)submitUrl{
    [MoMoConfig setSubmitUrl:submitUrl];
}

-(NSMutableDictionary*)getPaymentInfo{
    return paymentInfo;
}

-(void)requestToken{
    if ([paymentInfo isKindOfClass:[NSNull class]]) {
        NSLog(@"<MoMoPay> Payment information should not be null.");
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterStartRequestToken" object:@"InProgress"];
    NSMutableDictionary *requestInfo = [[NSMutableDictionary alloc] initWithDictionary:paymentInfo];
    
    //Open MoMo App to get token
    if ([requestInfo isKindOfClass:[NSMutableDictionary class]]) {
        NSString *inputParams = @"action=gettoken&partner=merchant";
        if (requestInfo[@"action"]) {
            inputParams = [NSString stringWithFormat:@"action=%@&partner=merchant&campaign=appinapp",requestInfo[@"action"]];
        }
        [requestInfo setValue:[MoMoConfig getMerchantcode]          forKey:MOMO_PAY_CLIENT_MERCHANT_CODE_KEY];
        [requestInfo setValue:[MoMoConfig getMerchantname]       forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY];
        [requestInfo setValue:[MoMoConfig getMerchantnameLabel]  forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY];
        [requestInfo setValue:@""          forKey:MOMO_PAY_CLIENT_PUBLIC_KEY_KEY];
        [requestInfo setValue:[MoMoConfig getIPAddress]          forKey:MOMO_PAY_CLIENT_IP_ADDRESS_KEY];
        [requestInfo setValue:[self getDeviceInfoString]   forKey:MOMO_PAY_CLIENT_OS_KEY];
        [requestInfo setValue:[MoMoConfig getAppBundleId]        forKey:MOMO_PAY_CLIENT_APP_SOURCE_KEY];
        [requestInfo setValue:MOMO_PAY_SDK_VERSION               forKey:MOMO_PAY_SDK_VERSION_KEY];
        
         [requestInfo setValue:@"202007031548"               forKey:@"buildversion"];
         if (paymentInfo[@"merchantcode"] && ![paymentInfo[@"merchantcode"]  isEqualToString:@"(null)"]){
             [requestInfo setValue:paymentInfo[@"merchantcode"]         forKey:@"merchantcode"];
             
         }
        if ([paymentInfo objectForKey:MOMO_PAY_CLIENT_PARTNER_CODE_KEY] != nil){
            [requestInfo setValue:[paymentInfo objectForKey:MOMO_PAY_CLIENT_PARTNER_CODE_KEY]         forKey:MOMO_PAY_CLIENT_PARTNER_CODE_KEY];
            [requestInfo setValue:paymentInfo[@"partnerCode"]         forKey:MOMO_PAY_CLIENT_MERCHANT_CODE_KEY];
        }
         if ([paymentInfo objectForKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY] != nil){
             [requestInfo setValue:[requestInfo objectForKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY]         forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY];
         }
         if ([paymentInfo objectForKey:MOMO_PAY_CLIENT_PARTNER_NAME_KEY] != nil){
             [requestInfo setValue:[paymentInfo objectForKey:MOMO_PAY_CLIENT_PARTNER_NAME_KEY]          forKey:MOMO_PAY_CLIENT_PARTNER_NAME_KEY];
             [requestInfo setValue:[paymentInfo objectForKey:MOMO_PAY_CLIENT_PARTNER_NAME_KEY]          forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY];
         }
         if ([paymentInfo objectForKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY] != nil){
             [requestInfo setValue:[paymentInfo objectForKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY]         forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY];
         }
        if ([paymentInfo objectForKey:MOMO_PAY_CLIENT_APP_SOURCE_KEY] != nil){
            [requestInfo setValue:[paymentInfo objectForKey:MOMO_PAY_CLIENT_APP_SOURCE_KEY]         forKey:MOMO_PAY_CLIENT_APP_SOURCE_KEY];
        }
         for (NSString *key in [requestInfo allKeys]) {
             //if ([requestInfo objectForKey:key]) {
                 NSLog(@"<MoMoSDK> add key value to deeplink %@", key);
                 if ([key isEqualToString:@"amount"] || [key isEqualToString:@"fee"]) {
                     inputParams = [inputParams stringByAppendingFormat:@"&%@=%ld",key,[[requestInfo objectForKey:key] integerValue]];
                 }else{
                     inputParams = [inputParams stringByAppendingFormat:@"&%@=%@",key,[ NSString stringWithFormat:@"%@", [requestInfo objectForKey:key] ]];
                 }
             //}
         }
        
        NSString *appSource = [NSString stringWithFormat:@"%@://?%@",MOMO_APP_BUNDLE_ID,inputParams];
        
        appSource = [appSource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *ourURL = [NSURL URLWithString:appSource];
        UIApplication *application = [UIApplication sharedApplication];
        if ([application canOpenURL:ourURL])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterTokenStartRequest" object:@"AppMoMoInstalled"];
            NSLog(@"<MoMoSDK> App MoMo has already installed");
            if (@available(iOS 10.0, *)) {
                [application openURL:ourURL options:@{}
                   completionHandler:^(BOOL success) {
                    ////
                }];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:ourURL];
            }
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterTokenStartRequest" object:@"AppMoMoNotInstall"];
            NSLog(@"<MoMoSDK> This app is not allowed to query for scheme momo MoMo App. May be: - App MoMo is not installed \n- Not add scheme momo into plist yet");
            bool isProduction = [MoMoConfig getEnvironment];
            NSString *storeUrl = MOMO_STORE_DOWNLOAD;
            if (!isProduction) {
                storeUrl = MOMO_STORE_DOWNLOAD_TEST;
            }
            ourURL = [NSURL URLWithString:storeUrl];
            if (@available(iOS 10.0, *)) {
                [application openURL:ourURL options:@{}
                   completionHandler:^(BOOL success) {
                    ////
                }];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:ourURL];
            }
        }
        
    }
}
-(void)setMoMoAppScheme:(NSString*)bundleId{
    [MoMoConfig setMoMoAppScheme:bundleId];
}
-(NSString*)getMoMoAppScheme{
    return [MoMoConfig getMoMoAppScheme];
}

//-(void)initPaymentInformation:(NSMutableDictionary*)info momoAppScheme:(NSString*)bundleId environment:(MOMO_ENVIRONTMENT)type_environment
//{
//    [self setEnvironment:type_environment];
//    [MoMoConfig setMoMoAppScheme:bundleId];
//    [MoMoConfig setSubmitUrl: type_environment == MOMO_SDK_DEVELOPMENT ? MOMO_WEB_SDK_REQUEST_DEV : MOMO_WEB_SDK_REQUEST_PRODUCTION ];
//    paymentInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
//    
//}

-(void)initPayment:(NSMutableDictionary*)info
{
    [MoMoConfig setEnvironment:1];
    paymentInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
}

-(void)setEnvironment:(int)type_environtment{
    if (type_environtment == 0) {
        [MoMoConfig setEnvironment:NO];
    }
    else{
         [MoMoConfig setEnvironment:YES];
    }
}

-(BOOL)getEnvironment{
    return [MoMoConfig getEnvironment];
}

-(BOOL) isNumeric: (NSString*) text
{
    NSScanner *sc = [NSScanner scannerWithString: text];
    // We can pass NULL because we don't actually need the value to test
    // for if the string is numeric. This is allowable.
    if ( [sc scanFloat:NULL] )
    {
        // Ensure nothing left in scanner so that "42foo" is not accepted.
        // ("42" would be consumed by scanFloat above leaving "foo".)
        return [sc isAtEnd];
    }
    // Couldn't even scan a float :(
    return NO;
}
- (NSString *)stringForStringOrNumber:(id)object
{
    NSString *result = nil;
    if ([object isKindOfClass:[NSString class]]) {
        result = object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        result = [object stringValue];
    } else {
        result = @"<MoMoSDK>I can't convert this object";
    }
    return result;
}
/*
 //End SDK v.2.3.1
 //Dated: 2020/07/03.
 */
@end
