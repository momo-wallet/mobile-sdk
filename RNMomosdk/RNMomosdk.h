//  RNMomosdk.h
//  Created by Lanh Lukas on 11/23/18.
//  Copyright © 2018 Facebook. All rights reserved.
//
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
@interface RNMomosdk : RCTEventEmitter <RCTBridgeModule>
+ (void)handleOpenUrl:(NSURL*)url;
@end
  
