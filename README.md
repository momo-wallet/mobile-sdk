# mobile-sdk
If your business have a mobile app. You can use this SDK to integrate MoMo app into your app.

 # iOS APP
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

Name                    Type      REQUIRED ?     Description
action                 String    required      value = gettoken. DO NOT EDIT
partner                String    required      value = merchant. DO NOT EDIT
merchantcode           String    required      provided by MoMo. get from business.momo.vn
merchantname           String    required      partner name / merchant name
merchantnamelabel      String    optional      Merchantname Hint/Label
appScheme              String    required      partnerSchemeId provided by MoMo , get from business.momo.vn
amount                 int       required      bill amount total
description            String    required      bill description
language               String    optional        DO NOT EDIT. value = vi
fee                    int       optional        fee amount (just review). default = 0
username               String    optional        user id/user identify/user email
billId                 String    optional        billId/Oder id
orderLabel             String    optional        Contract Number Hint/Label  
orderId                String    optional        Contract id
extra                  String    optional        json string - that should be more bill extra info
```


### Sample app ios-swift-CocoaPods
    -   pod "MomoiOSSwiftSdk", :git => "https://github.com/momodevelopment/MomoiOSSwiftSdk.git", :branch => "master", submodules: true



# Android App

At a minimum, this SDK is designed to work with Android SDK 14.


## Installation

To use the MoMo Android SDK, add the compile dependency with the latest version of the MoMo SDK.

### Gradle

Step 1. Import SDK
Add the JitPack repository to your `build.gradle`:
```
allprojects {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
    }
}
```

Add the dependency:
```
dependencies {
	        compile 'com.github.momodevelopment:androidsdkV2.2:1.1'
}
```

Step 2. Config AndroidMainfest
```
<uses-permission android:name="android.permission.INTERNET" />
```
Step 3. Build Layout
Confirm order Activity
```
import vn.momo.momo_partner.AppMoMoLib;
import vn.momo.momo_partner.MoMoParameterNameMap;

private String amount = "10000";
private String fee = "0";
int environment = 0;//developer default
private String merchantName = "Demo SDK";
private String merchantCode = "SCB01";
private String merchantNameLabel = "Nhà cung cấp";
private String description = "Thanh toán dịch vụ ABC";

void onCreate(Bundle savedInstanceState)
        AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.DEVELOPMENT); // AppMoMoLib.ENVIRONMENT.PRODUCTION
```
- Display MoMo button label language (required): English = "MoMo e-wallet", Vietnamese = "Ví MoMo"
- Display icon or button color (optional): title color #b0006d , icon https://img.mservice.io/momo-payment/icon/images/logo512.png

Step 4. Get token & request payment
```
//Get token through MoMo app
private void requestPayment() {
        AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.PAYMENT);
        AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.GET_TOKEN);
        if (edAmount.getText().toString() != null && edAmount.getText().toString().trim().length() != 0)
            amount = edAmount.getText().toString().trim();

        Map<String, Object> eventValue = new HashMap<>();
        //client Required
        eventValue.put(MoMoParameterNamePayment.MERCHANT_NAME, merchantName);
        eventValue.put(MoMoParameterNamePayment.MERCHANT_CODE, merchantCode);
        eventValue.put(MoMoParameterNamePayment.AMOUNT, amount);
        eventValue.put(MoMoParameterNamePayment.DESCRIPTION, description);
        //client Optional
        eventValue.put(MoMoParameterNamePayment.MERCHANT_BILL_ID, "merchant_billId_");
        eventValue.put(MoMoParameterNamePayment.FEE, fee);
        eventValue.put(MoMoParameterNamePayment.MERCHANT_NAME_LABEL, merchantNameLabel);

        //client call webview
        eventValue.put(MoMoParameterNamePayment.REQUEST_ID,  merchantCode+"merchant_billId_"+System.currentTimeMillis());
        eventValue.put(MoMoParameterNamePayment.PARTNER_CODE, merchantCode);

        JSONObject objExtraData = new JSONObject();
        try {
            objExtraData.put("site_code", "008");
            objExtraData.put("site_name", "CGV Cresent Mall");
            objExtraData.put("screen_code", 0);
            objExtraData.put("screen_name", "Special");
            objExtraData.put("movie_name", "Kẻ Trộm Mặt Trăng 3");
            objExtraData.put("movie_format", "2D");
            objExtraData.put("ticket", "{\"ticket\":{\"01\":{\"type\":\"std\",\"price\":110000,\"qty\":3}}}");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        eventValue.put(MoMoParameterNamePayment.EXTRA_DATA, objExtraData.toString());
        eventValue.put(MoMoParameterNamePayment.REQUEST_TYPE, "payment");
        eventValue.put(MoMoParameterNamePayment.LANGUAGE, "vi");

        eventValue.put(MoMoParameterNamePayment.EXTRA, "");
        AppMoMoLib.getInstance().requestMoMoCallBack(this, eventValue);


    }
//Get token callback from MoMo app an submit to server side
void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO && resultCode == -1) {
            if(data != null) {
                if(data.getIntExtra("status", -1) == 0) {
                    //TOKEN IS AVAILABLE
                    tvMessage.setText("message: " + "Get token " + data.getStringExtra("message"));
                    String token = data.getStringExtra("data"); //Token response
                    String phoneNumber = data.getStringExtra("phonenumber");
                    String env = data.getStringExtra("env");
                    if(env == null){
                        env = "app";
                    }

                    if(token != null && !token.equals("")) {
                        // TODO: send phoneNumber & token to your server side to process payment with MoMo server
                        // IF Momo topup success, continue to process your order
                    } else {
                        tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
                    }
                } else if(data.getIntExtra("status", -1) == 1) {
                    //TOKEN FAIL
                    String message = data.getStringExtra("message") != null?data.getStringExtra("message"):"Thất bại";
                    tvMessage.setText("message: " + message);
                } else if(data.getIntExtra("status", -1) == 2) {
                    //TOKEN FAIL
                    tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
                } else {
                    //TOKEN FAIL
                    tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
                }
            } else {
                tvMessage.setText("message: " + this.getString(R.string.not_receive_info));
            }
        } else {
            tvMessage.setText("message: " + this.getString(R.string.not_receive_info_err));
        }
    }
```
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
