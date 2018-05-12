# mobile-sdk
If your business have a mobile app. You can use this SDK to integrate MoMo app into your app.
 
 # iOS App
 ### STEP 1: Config file Plist (CFBundleURLTypes and LSApplicationQueriesSchemes)
 
 ```
 <key>CFBundleURLTypes</key>
 <array>
   <dict>
     <key>CFBundleURLName</key>
     <string></string>
     <key>CFBundleURLSchemes</key>
     <array>
       <string>partnerSchemeId</string>
     </array>
   </dict>
 </array>
 <key>LSApplicationQueriesSchemes</key>
 <array>
   <string>momo</string>
 </array>
 <key>NSAppTransportSecurity</key>
 <dict>
   <key>NSAllowsArbitraryLoads</key>
   <true/>
 </dict>
 ```
- CFBundleURLTypes: add scheme <partnerSchemeId> . Note: partnerSchemeId provided by MoMo , get from business.momo.vn
 - LSApplicationQueriesSchemes: add scheme "momo"
 
 ### STEP 2: Your Button CTA / Open MoMo app. Build the deeplink as bellow
  ```
 momo://?action=gettoken&merchantname=CGV Cinemas&amount=99000&merchantcode=CGV01&language=vi&description=Buy ticket&fee=0&ipaddress=192.168.1.154&username=username_accountId@yahoo.com&sdkversion=2.0&appScheme=partnerSchemeId
```
- partnerSchemeId: match with partnerSchemeId as Step 1
```
Deeplink Params description

Name             Type    REQUIRED ?    Description
action          String    required      value = gettoken. DO NOT EDIT
partner         String    required      value = merchant. DO NOT EDIT
merchantcode    String    required      provided by MoMo. get from business.momo.vn
merchantname    String    required      partner name / merchant name
appScheme       String    required      partnerSchemeId provided by MoMo , get from business.momo.vn
amount          int       required      bill amount total
language        String    option        DO NOT EDIT. value = vi
description     String    option        bill description
fee             int       option        fee amount (just review). default = 0
username        String    option        billId/user id/user identify/user email
extra           String    option        decodebase64 json string - that should be more bill extra info
```

### Sample app ios-objective-c-CocoaPods, ios-swift-CocoaPods
    -   https://github.com/momo-wallet/mobile-sdk/tree/master/ios
 # Android App

### Sample app android
    -   https://github.com/momo-wallet/mobile-sdk/tree/master/android
 
 ## Version
 
 ```
 Version 2.0
 ```
 
 ## Authors
 
 * **Lành Lưu** - lanh.luu@mservice . com . vn
 * **Hưng Đỗ** - hung.do@mservice . com . vn
 
 
 ## License
 Since 2015 (c) MoMo
 
 ## Contact - Support
 * itc.payment@mservice.com.vn
 
 
