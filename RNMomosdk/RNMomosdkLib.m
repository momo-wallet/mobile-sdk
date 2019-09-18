//
//  RNMomoLib.m
//  RNMomosdk
//
//  RNMomosdk.h
//  Created by Lanh Lukas on 11/23/18.
//  Copyright © 2018 Facebook. All rights reserved.
//
//  Created by react-native-create-bridge

// import RCTBridgeModule
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include(“RCTBridgeModule.h”)
#import “RCTBridgeModule.h”
#else
#import “React/RCTBridgeModule.h” // Required when used as a Pod in a Swift project
#endif

// import RCTEventEmitter
#if __has_include(<React/RCTEventEmitter.h>)
#import <React/RCTEventEmitter.h>
#elif __has_include(“RCTEventEmitter.h”)
#import “RCTEventEmitter.h”
#else
#import “React/RCTEventEmitter.h” // Required when used as a Pod in a Swift project
#endif
#import "React/RCTViewManager.h"

// Export a native module
@interface RCT_EXTERN_MODULE(RNMomosdkLib, RCTViewManager)
RCT_EXTERN_METHOD(handleOpenUrl:(NSString*)urlString)
@end
