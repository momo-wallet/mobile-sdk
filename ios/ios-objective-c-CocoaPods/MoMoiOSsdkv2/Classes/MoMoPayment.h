//
//  MoMoPayment.h
//  SampleApp-Xcode
//
//  Created by Luu Lanh on 9/30/15.
//  Copyright (c) 2015 LuuLanh. All rights reserved.
//  Last updated: 08/17/2017
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    MOMO_SDK_DEVELOPMENT,
    MOMO_SDK_PRODUCTION,
    MOMO_SDK_DEBUG,
} MOMO_ENVIRONTMENT ;

@interface MoMoPayment : NSObject
+(MoMoPayment*)shareInstant;
- (void)initializingAppBundleId:(NSString*)bundleid merchantId:(NSString*)merchantId merchantName:(NSString*)merchantname merchantNameTitle:(NSString*)merchantNameTitle billTitle:(NSString*)billTitle;
-(void)requestToken;
-(void)handleOpenUrl:(NSURL*)url;
-(void)createPaymentInformation:(NSMutableDictionary*)info;
-(void)addMoMoPayDefaultButtonToView:(UIView*)parrentView;
-(UIButton*)addMoMoPayCustomButton:(UIButton*)button forControlEvents:(UIControlEvents)controlEvents toView:(UIView*)parrentView;
-(NSString*)getAction;
-(void)setAction:(NSString*)action;
-(void)updateAmount:(long long)amt;
/*
 //SDK v.2.2
 //Dated: 7/25/17.
 */
-(void)setSubmitURL:(NSString*)submitUrl;
-(NSMutableDictionary*)getPaymentInfo;
-(void)requestWebpaymentData:(NSMutableDictionary*)dataPost requestType:(NSString*)requesttype;
-(NSString*)getDeviceInfoString;
-(void)setMoMoAppScheme:(NSString*)bundleId;
-(void)initPaymentInformation:(NSMutableDictionary*)info momoAppScheme:(NSString*)bundleId environment:(MOMO_ENVIRONTMENT)type_environment;
-(void)setEnvironment:(MOMO_ENVIRONTMENT)type_environtment;
-(BOOL)getEnvironment;
@end
