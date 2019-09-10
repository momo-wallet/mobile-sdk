# MoMoiOSsdkv2

[![CI Status](http://img.shields.io/travis/momodevelopment/MoMoiOSsdkv2.svg?style=flat)](https://travis-ci.org/momodevelopment/MoMoiOSsdkv2)
[![Version](https://img.shields.io/cocoapods/v/MoMoiOSsdkv2.svg?style=flat)](http://cocoapods.org/pods/MoMoiOSsdkv2)
[![License](https://img.shields.io/cocoapods/l/MoMoiOSsdkv2.svg?style=flat)](http://cocoapods.org/pods/MoMoiOSsdkv2)
[![Platform](https://img.shields.io/cocoapods/p/MoMoiOSsdkv2.svg?style=flat)](http://cocoapods.org/pods/MoMoiOSsdkv2)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MoMoiOSsdkv2 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'MoMoiOSsdkv2', :git => 'https://github.com/momodevelopment/MoMoiOSsdkv2.git',:branch => "master"
```

Step 1. Config file Plist
```
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.abcFoody.LuckyLuck</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>com.momo.appv2.ios</string>
  <string>com.mservice.com.vn.MoMoTransfer</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```
Step 2. Import SDK
AppDelegate instance
```
#import "MoMoPayment.h"

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[MoMoPayment shareInstant] handleOpenUrl:url];
    return YES;
}
```

Step 3. Update Layout Payment
```
#import "MoMoPayment.h"
#import "MoMoDialogs.h"
```

#NotificationCenter registration
MOMO NOTIFICATION KEYS SHOULD BE REMOVED WHEN THE VIEWCONTROLLERS DEALLOCATING OR DISMISSING COMPLETED
(Notification keys: NoficationCenterTokenReceived , NoficationCenterTokenStartRequest)
```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenReceived:) name:@"NoficationCenterTokenReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenStartRequest:) name:@"NoficationCenterTokenStartRequest" object:nil];
    ///
    [self initOrderAndButtonAction];
}
```
#Handle MoMoNotificationReceive
```
-(void)processMoMoNoficationCenterTokenReceived:(NSNotification*)notif{
  //Token Replied
  NSLog(@"::MoMoPay Log::Received Token Replied::%@",notif.object);
  lblMessage.text = [NSString stringWithFormat:@"%@",notif.object];

  NSString *sourceText = [NSString stringWithFormat:@"%@",notif.object];

  NSURL *url = [NSURL URLWithString:sourceText];
  if (url) {
      sourceText = url.query;
  }

  NSArray *parameters = [sourceText componentsSeparatedByString:@"&"];

  NSDictionary *response = [self getDictionaryFromComponents:parameters];
  NSString *status = [NSString stringWithFormat:@"%@",[response objectForKey:@"status"]];
  NSString *message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
  if ([status isEqualToString:@"0"]) {

      NSLog(@"::MoMoPay Log: SUCESS TOKEN.");
      NSLog(@">>response::%@",notif.object);

      NSString *sessiondata = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];       //session data
      NSString *phoneNumber =  [NSString stringWithFormat:@"%@",[response objectForKey:@"phonenumber"]]; //wallet Id

      NSString *env = @"app";
      if (response[@"env"]) {
          env =  [NSString stringWithFormat:@"%@",[response objectForKey:@"env"]];
      }

      if (response[@"extra"]) {
          //This a extra value which you put at initOrderAndButtonAction. Decode base 64 for using if need (Optional)
      }

      /*  SEND THESE PARRAM TO SERVER:  phoneNumber, sessiondata, env
       CALL API MOMO PAYMENT
       */
       lblMessage.text = [NSString stringWithFormat:@">>response:: SUCESS TOKEN. \n %@",notif.object];

  }else
  {
      if ([status isEqualToString:@"1"]) {
          NSLog(@"::MoMoPay Log: REGISTER_PHONE_NUMBER_REQUIRE.");
      }
      else if ([status isEqualToString:@"2"]) {
          NSLog(@"::MoMoPay Log: LOGIN_REQUIRE.");
      }
      else if ([status isEqualToString:@"3"]) {
          NSLog(@"::MoMoPay Log: NO_WALLET. You need to cashin to MoMo Wallet ");
      }
      else
      {
          NSLog(@"::MoMoPay Log: %@",message);
      }
  }
}
-(void)NoficationCenterTokenStartRequest:(NSNotification*)notif
{
    if (notif.object != nil && [notif.object isEqualToString:@"MoMoWebDialogs"]) {
        dialog = [[MoMoDialogs alloc] init];
        [self presentViewController:dialog animated:YES completion:nil];
    }
}
```
Add Button Action to Pay Via MOMO
Button title: EN = MoMo Wallet , VI = Ví MoMo
```
-(void)initOrderAndButtonAction{
    //STEP 1: INIT ORDER INFO
    NSMutableDictionary *paymentinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            [NSNumber numberWithInt:99000],@"amount",
                                            [NSNumber numberWithInt:0],@"fee",
                                            @"Buy CGV Cinemas",@"description",
                                            @"{\"key1\":\"value1\",\"key2\":\"value2\"}",@"extra", //OPTIONAL
                                            @"vi",@"language",
                                            username,@"username",
                                            @"Người dùng",@"usernamelabel",
                                            nil];
    [[MoMoPayment shareInstant] initPaymentInformation:paymentinfo momoAppScheme:@"com.mservice.com.vn.MoMoTransfer" environment:MOMO_SDK_PRODUCTION];

    //STEP 2: ADD BUTTON ACTION TO PAY VIA MOMO WALLET
    //buttonAction will open MoMo app to pay
    [[MoMoPayment shareInstant] addMoMoPayCustomButton:buttonAction forControlEvents:UIControlEventTouchUpInside toView:yourPaymentView];

}
```

## Author

MoMo Development Team

## License

MoMoiOSsdkv2 is available under the MIT license. See the LICENSE file for more info.
