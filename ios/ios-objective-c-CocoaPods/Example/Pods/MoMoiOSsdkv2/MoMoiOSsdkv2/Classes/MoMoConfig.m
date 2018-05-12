//
//  MoMoConfig.m
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//  Last updated: 08/17/2017
//

#import "MoMoConfig.h"
#import <ifaddrs.h>
#import <sys/types.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <sys/time.h>
#import <netinet/in.h>
#import <net/if_dl.h>
#import <netdb.h>
#import <errno.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <UIKit/UIKit.h>
#define stringIndexOf(fulltext, textcompare) ([fulltext rangeOfString: textcompare ].location != NSNotFound)

@implementation MoMoConfig

+(void)setAppBundleId:(NSString*)bundleId{
    if (![bundleId isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:bundleId forKey:APP_MERCHANT_BUNDLE_ID_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set bundleId. This value is not null");
    }
}
+(NSString*)getAppBundleId
{
    NSString *bundleid = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:APP_MERCHANT_BUNDLE_ID_KEY]];
    @try {
        if ([bundleid isEqualToString:@""]) {
            bundleid = [[NSBundle mainBundle] bundleIdentifier];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return bundleid;
}
+(void)setMerchantcode:(NSString*)merchantCode{
    if (![merchantCode isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:merchantCode forKey:MOMO_PAY_CLIENT_MERCHANT_CODE_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set merchantCode. This value is not null");
    }
}

+(NSString*)getMerchantcode{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:MOMO_PAY_CLIENT_MERCHANT_CODE_KEY]];
}

+(void)setUsernameLabel:(NSString*)usernameLabel{
    if (![usernameLabel isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:usernameLabel forKey:MOMO_PAY_CLIENT_USERNAME_LABEL_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set usernameLabel. This value is not null");
    }
}

+(NSString*)getUsernameLabel{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:MOMO_PAY_CLIENT_USERNAME_LABEL_KEY]];
}

+(NSString*)getAction{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:APP_MERCHANT_ACTION_KEY]) {
        return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:APP_MERCHANT_ACTION_KEY]];
    }
    
    return MOMO_PAY_SDK_ACTION_GETTOKEN;
}

+(void)setAction:(NSString*)action{
    if (![action isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:action forKey:APP_MERCHANT_ACTION_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set action. This value is not null");
    }
}

+(void)setMerchantname:(NSString*)merchantName{
    if (![merchantName isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:merchantName forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set merchantName. This value is not null");
    }
}

+(NSString*)getMerchantname{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:MOMO_PAY_CLIENT_MERCHANT_NAME_KEY]];
}

+(void)setMerchantnameLabel:(NSString*)merchantnameLabel{
    if (![merchantnameLabel isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:merchantnameLabel forKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set merchantnameLabel. This value is not null");
    }
}

+(NSString*)getMerchantnameLabel{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY]];
}

+(void)setPublickey:(NSString*)merchantpublickey{
    if (![merchantpublickey isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:merchantpublickey forKey:MOMO_PAY_CLIENT_PUBLIC_KEY_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set merchantipaddress. This value is not null");
    }
}

+(NSString*)getPublickey{
    return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:MOMO_PAY_CLIENT_PUBLIC_KEY_KEY]];
}


+(NSString *)getIPAddress {
    
    //create the random number.
    int max = 500;
    int min = 10;
    int randNum = rand() % (max - min) + min;
    
    NSString *address = [NSString stringWithFormat:@"101.101.101.%i",randNum];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    NSArray *tempArr = [address componentsSeparatedByString:@"."];
    
    if ([tempArr count]!=4) {
        address = [NSString stringWithFormat:@"101.101.101.%i",randNum];
    }
    
    return address;
    
}
//Version 2.2 update
+(void)setSubmitUrl:(NSString*)submiturl{
    if (![submiturl isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:submiturl forKey:MOMO_PAY_CLIENT_APP_SUBMIT_URL_WEB];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set submiturl. This value is not null");
    }
}
+(NSString*)getSubmitUrl{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:MOMO_PAY_CLIENT_APP_SUBMIT_URL_WEB]) {
        return [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:MOMO_PAY_CLIENT_APP_SUBMIT_URL_WEB]];
    }
    
    return @"";
}
+(NSString*)getDeviceInfoString{
    UIDevice *aDevice = [UIDevice currentDevice];
    NSString *deviceInfoString = [NSString stringWithFormat:@"%@ %@ %@",aDevice.name,aDevice.systemName,aDevice.localizedModel];
    return deviceInfoString;
}
+(void)setMoMoAppScheme:(NSString*)bundleId{
    if (![bundleId isKindOfClass:[NSNull class]]) {
        [[NSUserDefaults standardUserDefaults] setValue:bundleId forKey:MOMO_APP_SCHEME_BUNDLE_ID_KEY];
    }
    else
    {
        NSLog(@"<MoMoPay> Can not set bundleId. This value is not null");
    }
}
+(NSString*)getMoMoAppScheme
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:MOMO_APP_SCHEME_BUNDLE_ID_KEY];
}

+(void)setEnvironment:(BOOL)isproduct{
    [[NSUserDefaults standardUserDefaults] setBool:isproduct forKey:@"MOMO_SDK_ENVIRONTMENT"];
}

+(BOOL)getEnvironment{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"MOMO_SDK_ENVIRONTMENT"];
}


#define stringIndexOf(fulltext, textcompare) ([fulltext rangeOfString: textcompare ].location != NSNotFound)
@end
