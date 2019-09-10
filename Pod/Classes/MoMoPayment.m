//
//  MoMoPayment.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//  Last updated: 08/17/2017
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

- (void)initializingAppBundleId:(NSString*)bundleid merchantId:(NSString*)merchantId merchantName:(NSString*)merchantname merchantNameTitle:(NSString*)merchantNameTitle billTitle:(NSString*)billTitle{
    [MoMoConfig setAppBundleId:bundleid];
    [MoMoConfig setMerchantcode:merchantId];
    [MoMoConfig setMerchantname:merchantname];
    [MoMoConfig setMerchantnameLabel:@"Nhà cung cấp"];
    [MoMoConfig setUsernameLabel:@"Tài khoản"];
    //[MoMoConfig setPublickey:publickey];
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
    //Open MoMo App to get token
    if ([paymentInfo isKindOfClass:[NSMutableDictionary class]]) {
        NSString *inputParams = [NSString stringWithFormat:@"action=%@&partner=merchant",[MoMoConfig getAction]];
        
        if (paymentInfo[@"action"]) {
            inputParams = [NSString stringWithFormat:@"action=%@&partner=merchant&campaign=register",paymentInfo[@"action"]];
        }
        [paymentInfo setValue:[MoMoConfig getMerchantcode]          forKey:MOMO_PAY_CLIENT_MERCHANT_CODE_KEY];
        [paymentInfo setValue:[MoMoConfig getMerchantname]       forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY];
        [paymentInfo setValue:[MoMoConfig getMerchantnameLabel]  forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY];
        [paymentInfo setValue:@""          forKey:MOMO_PAY_CLIENT_PUBLIC_KEY_KEY];
        [paymentInfo setValue:[MoMoConfig getIPAddress]          forKey:MOMO_PAY_CLIENT_IP_ADDRESS_KEY];
        [paymentInfo setValue:[self getDeviceInfoString]   forKey:MOMO_PAY_CLIENT_OS_KEY];
        [paymentInfo setValue:[MoMoConfig getAppBundleId]        forKey:MOMO_PAY_CLIENT_APP_SOURCE_KEY];
        [paymentInfo setValue:MOMO_PAY_SDK_VERSION               forKey:MOMO_PAY_SDK_VERSION_KEY];
        
        for (NSString *key in [paymentInfo allKeys]) {
            if ([paymentInfo objectForKey:key] != nil) {
                inputParams = [inputParams stringByAppendingFormat:@"&%@=%@",key,[paymentInfo objectForKey:key]];
            }
        }
        
        NSString *appSource = [NSString stringWithFormat:@"%@://?%@",MOMO_APP_BUNDLE_ID,inputParams];
        BOOL isProduction = [MoMoConfig getEnvironment];
        if (!isProduction) {
            appSource = [NSString stringWithFormat:@"com.momo.appv2.ios://?%@",inputParams];
        }
        
        appSource = [appSource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *ourURL = [NSURL URLWithString:appSource];
        
        if ([[UIApplication sharedApplication] canOpenURL:ourURL])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterTokenStartRequest" object:@"AppMoMoInstalled"];
            
            UIApplication *application = [UIApplication sharedApplication];
            if (IS_IOS_10_OR_LATER && [application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                NSLog(@"iOS 10.X handle openURL");
                [application openURL:ourURL options:@{}
                   completionHandler:^(BOOL success) {
                       ////
                   }];
            }
            else{
                [[UIApplication sharedApplication] openURL:ourURL];
            }
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoficationCenterTokenStartRequest" object:@"AppMoMoNotInstall"];
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

-(void)initPayment:(NSMutableDictionary*)info environment:(MOMO_ENVIRONTMENT)type_environment
{
    if (type_environment == MOMO_SDK_DEVELOPMENT || type_environment == MOMO_SDK_DEBUG) {
        [MoMoConfig setEnvironment:NO];
    }else{
        [MoMoConfig setEnvironment:YES];
    }
    paymentInfo = [[NSMutableDictionary alloc] initWithDictionary:info];
    
}

-(void)setEnvironment:(MOMO_ENVIRONTMENT)type_environtment{
    if (type_environtment == MOMO_SDK_DEVELOPMENT || type_environtment == MOMO_SDK_DEBUG) {
        [MoMoConfig setEnvironment:NO];
    }
    else{
         [MoMoConfig setEnvironment:YES];
    }
}

-(BOOL)getEnvironment{
    return [MoMoConfig getEnvironment];
}
/*
 //End SDK v.2.2
 //Dated: 7/25/17.
 */
@end
