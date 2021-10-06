# MoMo App test
https://developers.momo.vn/#/docs/testing_information
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
       <string>appScheme</string>
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
- CFBundleURLTypes: add scheme <appScheme> value . Note: partnerSchemeId provided by MoMo , get from business.momo.vn
- LSApplicationQueriesSchemes: add the scheme as "momo"

### ios-swift CocoaPods
    -   pod "MomoiOSSwiftSdk", :git => "https://github.com/momo-wallet/mobile-sdk.git", :branch => "release_swift", submodules: true

### ios-Objective-C CocoaPods
    -   pod "MomoiOSSwiftSdk", :git => "https://github.com/momo-wallet/mobile-sdk.git", :branch => "release_objc", submodules: true

```
Params description

Name                    Type      REQUIRED ?     Description
merchantcode           String    required      provided by MoMo. get from business.momo.vn
merchantname           String    required      partner name / merchant name
merchantnamelabel      String    optional      Merchantname Hint/Label
appScheme              String    required      partnerSchemeId provided by MoMo , get from business.momo.vn
orderId                String    required      billing purchaseId / Contract id
amount                 int       required      bill amount total
orderLabel             String    optional      Contract Number Hint/Label . Example value: "OrderId" , "BillId"
description            String    required      bill description
fee                    int       optional        fee amount (just review). default = 0
username               String    optional        user id/user identify/user email
extra                  String    optional        json string - that should be more bill extra info
```

### STEP 2: Init the order parameters

```
override func viewDidLoad() {
	// Do any additional setup after loading the view.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)
}	 
```	 

#### usage method init paymentInfo - Swift
```
    let paymentinfo = NSMutableDictionary()
    paymentinfo["merchantcode"] = "CGV01"
    paymentinfo["merchantname"] = "CGV Cinemas"
    paymentinfo["merchantnamelabel"] = "Service"
    paymentinfo["orderId"] = "012345XXX"
    paymentinfo["orderLabel"] = "OrderID"
    paymentinfo["amount"] = 20000
    paymentinfo["fee"] = 0
    paymentinfo["description"] = "Thanh toán vé xem phim"
    paymentinfo["extra"] = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
    paymentinfo["username"] = payment_username //user id/user identify/user email
    paymentinfo["appScheme"] = "partnerSchemeId"   //partnerSchemeId provided by MoMo , get from business.momo.vn
    MoMoPayment.createPaymentInformation(info: paymentinfo)
```

### STEP 3: ADD BUTTON PAYMENT TO OPEN MOMO APP
```
        // Button title: ENGLISH = MoMo E-Wallet , VIETNAMESE = Ví MoMo
	let buttonPay = UIButton()
        buttonPay.frame = CGRect(x: 20, y: 200, width: 260, height: 40)
        buttonPay.setTitle("Pay Via MoMo Wallet", for: .normal)
        buttonPay.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        buttonPay.backgroundColor = UIColor.purple
        // Add Button Action to OPEN MOMO APP
        buttonPay.addTarget(self, action: #selector(self.openAppMoMo), for: .touchUpInside) //see @objc func gettoken()
```

```
@objc func openAppMoMo() {
        MoMoPayment.requestToken()
    }
@objc func NoficationCenterTokenReceived(notif: NSNotification) {
            //Token Replied - Call Payment to MoMo Server
            print("::MoMoPay Log::Received Token Replied::\(notif.object!)")
            //lblMessage.text = "RequestToken response:\n  \(notif.object as Any)"
            
            let response:NSMutableDictionary = notif.object! as! NSMutableDictionary
            let _reference_orderId = response["orderId"] as! String
            let _statusStr = "\(response["status"] as! String)"
            let _messageStr = "\(response["message"] as! String)"	    
    }
```


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
	        compile 'com.github.momo-wallet:mobile-sdk:1.0.7'
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
        eventValue.put("merchantname", merchantName); //Tên đối tác. được đăng ký tại https://business.momo.vn. VD: Google, Apple, Tiki , CGV Cinemas
        eventValue.put("merchantcode", merchantCode); //Mã đối tác, được cung cấp bởi MoMo tại https://business.momo.vn 
        eventValue.put("amount", total_amount); //Kiểu integer 
	eventValue.put("orderId", "orderId123456789"); //uniqueue id cho Bill order, giá trị duy nhất cho mỗi đơn hàng  
	eventValue.put("orderLabel", "Mã đơn hàng"); //gán nhãn 
	
	//client Optional - bill info
	eventValue.put("merchantnamelabel", "Dịch vụ");//gán nhãn 
        eventValue.put("fee", total_fee); //Kiểu integer
	eventValue.put("description", description); //mô tả đơn hàng - short description 

        //client extra data 
        eventValue.put("requestId",  merchantCode+"merchant_billId_"+System.currentTimeMillis());
        eventValue.put("partnerCode", merchantCode);
	//Example extra data 
        JSONObject objExtraData = new JSONObject();
        try {
            objExtraData.put("site_code", "008");
            objExtraData.put("site_name", "CGV Cresent Mall");
            objExtraData.put("screen_code", 0);
            objExtraData.put("screen_name", "Special");
            objExtraData.put("movie_name", "Kẻ Trộm Mặt Trăng 3");
            objExtraData.put("movie_format", "2D");
        } catch (JSONException e) {
            e.printStackTrace();
        }
        eventValue.put("extraData", objExtraData.toString());

        eventValue.put("extra", "");
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

 * **Lành Lưu**
 * **Hưng Đỗ**

 ## License
 Since 2015 (c) MoMo

 ## Contact - Support
 * itc.payment@mservice.com.vn
