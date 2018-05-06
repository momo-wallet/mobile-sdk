//
//  MoMoConfig.h
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//  Last updated: 08/17/2017
//

#import <Foundation/Foundation.h>

#define APP_MERCHANT_BUNDLE_ID_KEY               @"APP_MERCHANT_BUNDLE_ID_KEY"
#define MOMO_PAY_CLIENT_MERCHANT_CODE_KEY        @"merchantcode"
#define MOMO_PAY_CLIENT_PARTNER_CODE_KEY        @"partnerCode"
#define MOMO_PAY_CLIENT_MERCHANT_NAME_KEY        @"merchantname"
#define MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY  @"merchantnamelabel"
#define MOMO_PAY_CLIENT_IP_ADDRESS_KEY           @"ipaddress"
#define MOMO_PAY_CLIENT_PUBLIC_KEY_KEY           @"accesskey"
#define MOMO_PAY_SDK_VERSION_KEY                 @"sdkversion"
#define MOMO_PAY_CLIENT_OS_KEY                   @"clientos"
#define MOMO_PAY_CLIENT_APP_SOURCE_KEY           @"appSource"
#define MOMO_PAY_CLIENT_USERNAME_LABEL_KEY     @"usernamelabel"

#define MOMO_PAY_CLIENT_MERCHANT_TRANS_ID    @"merchanttransId"
#define MOMO_PAY_CLIENT_AMOUNT_TRANSFER      @"amount"
#define MOMO_PAY_CLIENT_FEE_TRANSFER         @"fee"
#define MOMO_PAY_CLIENT_DESCRIPTION @"description"
#define MOMO_PAY_CLIENT_USERNAME             @"username"

#define MOMO_NOTIFICATION_CENTER_TOKEN_RECEIVED  @"NoficationCenterTokenReceived"
#define MOMO_APP_BUNDLE_ID    @"com.mservice.com.vn.MoMoTransfer"
#define MOMO_PAY_SDK_VERSION  @"2.0"
#define MOMO_APP_ITUNES_DOWNLOAD_PATH @"itms-apps://itunes.apple.com/us/app/momo-chuyen-nhan-tien/id918751511"

#define APP_MERCHANT_ACTION_KEY  @"APP_MERCHANT_ACTION_KEY"

#define MOMO_PAY_SDK_ACTION_GETTOKEN  @"gettoken"
#define MOMO_PAY_SDK_ACTION_MAPPING  @"mapping"

#define MOMO_TOKEN_RESPONSE_SUCCESS @"0"
#define MOMO_TOKEN_RESPONSE_REGISTER_PHONE_NUMBER_REQUIRE @"1"
#define MOMO_TOKEN_RESPONSE_LOGIN_REQUIRE @"2"
#define MOMO_TOKEN_RESPONSE_NO_WALLET @"3"

#define MOMO_HTTP @"http://"
#define MOMO_HTTPS @"https://"

/*
 Sanbox API http://
 */

#define MOMO_REQUEST_PATH @"172.16.43.22:8082/paygamebill" //@"apptest2.momo.vn:8091/paygamebill" //
#define MOMO_PAYMENT_URL [NSString stringWithFormat:@"%@%@",MOMO_HTTP,MOMO_REQUEST_PATH]

//Version 2.2 update
#define MOMO_PAY_CLIENT_APP_SUBMIT_URL_WEB           @"momofeedurl"
#define MOMO_APP_SCHEME_BUNDLE_ID_KEY               @"MOMO_APP_SCHEME_BUNDLE_ID_KEY"
#define MOMO_WEB_SDK_REQUEST_DEV @"http://118.69.187.119:9090/sdk/api/v1/payment/request"
#define MOMO_WEB_SDK_REQUEST_PRODUCTION @"https://payment.momo.vn:18088/sdk/api/v1/payment/request"
extern NSString *CLIENT_MERCHANT_CODE;
extern NSString *CLIENT_MERCHANT_NAME;
extern NSString *CLIENT_MERCHANT_NAME_LABEL;
extern NSString *CLIENT_IP_ADDRESS;
extern NSString *CLIENT_PUBLIC_KEY;

static NSString *CLIENT_MERCHANT_TRANS_ID;
static long long CLIENT_AMOUNT_TRANSFER;
static long long CLIENT_AMOUNT_FEE;
static NSString *CLIENT_DESCRIPTION_TRANSFER;
static NSString *CLIENT_TRANSFER_DESCRIPTION;
static NSString *CLIENT_USERNAME;

@interface MoMoConfig : NSObject

+(void)setAppBundleId:(NSString*)bundleId;
+(void)setMerchantcode:(NSString*)merchantCode;
+(void)setMerchantname:(NSString*)merchantName;
+(void)setMerchantnameLabel:(NSString*)merchantnameLabel;
+(void)setPublickey:(NSString*)merchantpublickey;

+(NSString*)getAppBundleId;
+(NSString*)getPublickey;
+(NSString*)getMerchantnameLabel;
+(NSString*)getMerchantname;
+(NSString*)getMerchantcode;
+(NSString *)getIPAddress;
+(NSString*)getDeviceInfoString;

+(NSString*)getAction;

+(void)setAction:(NSString*)action;
+(void)setUsernameLabel:(NSString*)usernameLabel;

+(NSString*)getUsernameLabel;

//Version 2.2 update
+(void)setSubmitUrl:(NSString*)submiturl;
+(NSString*)getSubmitUrl;
+(void)setMoMoAppScheme:(NSString*)bundleId;
+(NSString*)getMoMoAppScheme;

+(void)setEnvironment:(BOOL)isproduct;
+(BOOL)getEnvironment;
@end
