# mobile-sdk
If your business have a mobile app. You can use this SDK to integrate your mobile with MoMo App
# MoMoSDKiOSObjc

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MoMoSDKiOSObjc is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'MoMoSDKiOSObjc', :git => 'https://github.com/momo-wallet/mobile-sdk.git',:branch => "release_objc"
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
      <string>partnerSchemeId00001</string>
    </array>
  </dict>
</array>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>momo</string>
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

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@">>handleopenUrl iOS 9 or newest");
    [[MoMoPayment shareInstances] handleOpenUrl:url];
    return YES;
}
#else
-(BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url
{
    NSLog(@">>handleopenUrl ios < 9.0");
    [[MoMoPayment shareInstances] handleOpenUrl:url];
    return YES;
}
#endif
```

Step 3. Update Layout Payment
```
#import "MoMoPayment.h"
```

#NotificationCenter registration
MOMO NOTIFICATION KEYS SHOULD BE REMOVED WHEN THE VIEWCONTROLLERS DEALLOCATING OR DISMISSING COMPLETED
(Notification keys: NoficationCenterTokenReceived , NoficationCenterTokenStartRequest)
```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NoficationCenterTokenStartRequest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenStartRequest:) name:@"NoficationCenterTokenStartRequest" object:nil]; ///SHOULD BE REMOVE THIS KEY WHEN VIEWCONTROLLER DEALLOCATING OR DISMISSING COMPLETED
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NoficationCenterTokenReceived" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoficationCenterTokenReceived:) name:@"NoficationCenterTokenReceived" object:nil]; 
    
    [[MoMoPayment shareInstances] initAppBundleId:@"com.abcFoody.LuckyLuck" partnerCode:@"CGV01" partnerName:@"CGV" partnerNameLabel:@"Nhà cung cấp" billLabel:@"Mã thanh toán"];
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
    if (notif.object != nil && [notif.object isEqualToString:@"InProgress"]) {
        NSLog(@"::MoMoPay Log::InProgress");
    }else if (notif.object != nil && [notif.object isEqualToString:@"AppMoMoNotInstall"]) {
        NSLog(@"::MoMoPay Log::AppMoMoNotInstall");
    }else{
        NSLog(@"::MoMoPay Log::AppMoMoInstalled");
    }
}
```
Add Button Action to Pay Via MOMO
Button title: EN = MoMo E-Wallet , VI = Ví MoMo
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

-(void)NoficationCenterTokenReceived:(NSNotification*)notif
{
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
        NSString *data = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];//session data
        NSString *phoneNumber =  [NSString stringWithFormat:@"%@",[response objectForKey:@"phonenumber"]];//wallet Id
        NSLog(@">>response::phoneNumber %@ , data:: %@",phoneNumber, data);
        NSString *env = @"app";
        if (response[@"env"]) {
            env =  [NSString stringWithFormat:@"%@",[response objectForKey:@"env"]];
        }
        
        if (response[@"extra"]) {
        }
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
```

## Author

MoMo Development Team

## License

MoMoSDKiOSObjc is available under the MIT license. See the LICENSE file for more info.
