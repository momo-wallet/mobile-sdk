# MomoiOSSwiftSdkV2

[![CI Status](http://img.shields.io/travis/momodevelopment/MomoiOSSwiftSdk.svg?style=flat)](https://travis-ci.org/momodevelopment/MomoiOSSwiftSdkV2)
[![Version](https://img.shields.io/cocoapods/v/MomoiOSSwiftSdk.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdk)
[![License](https://img.shields.io/cocoapods/l/MomoiOSSwiftSdk.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdk)
[![Platform](https://img.shields.io/cocoapods/p/MomoiOSSwiftSdk.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdk)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MomoiOSSwiftSdkV2 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MomoiOSSwiftSdk', :git => 'https://github.com/momodevelopment/MomoiOSSwiftSdk.git',:branch => "master"
```

At a minimum, MoMo SDK is designed to work with iOS 8.0 or newest.


## Installation

To use the MoMo iOS SDK, Import MoMoPaySDK framework into your project
Include: MoMoConfig, MoMoPayment

Step 1. Config file Plist
```
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>momopartner0001</string>
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
Step 2. Import SDK
AppDelegate instance
```
import MomoiOSSwiftSdk

func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    MoMoPayment.handleOpenUrl(url: url, sourceApp: sourceApplication!)
    return true
}

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    MoMoPayment.handleOpenUrl(url: url, sourceApp: "")
    return true
}
```

Step 3. Update Layout Payment

#NotificationCenter registration
MOMO NOTIFICATION KEYS SHOULD BE REMOVED WHEN THE VIEWCONTROLLERS DEALLOCATING OR DISMISSING COMPLETED
(Notification keys: NoficationCenterTokenReceived , NoficationCenterTokenStartRequest)
```
import MomoiOSSwiftSdk

override func viewDidLoad() {
    super.viewDidLoad()
    
    //STEP 1: addObserver Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceivedUri"), object: nil)
        //
    //STEP 2: INIT MERCHANT AND PAYMENT INFO. YOU CAN MODIFY ANYTIME IF NEED

    let paymentinfo = NSMutableDictionary()
    paymentinfo["merchantcode"] = "CGV01"
    paymentinfo["merchantname"] = "CGV Cinemas"
    paymentinfo["merchantnamelabel"] = "Service"

    paymentinfo["amount"] = payment_amount
    paymentinfo["fee"] = payment_fee_display
    paymentinfo["description"] = "Thanh toán vé xem phim"
    paymentinfo["extra"] = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
    paymentinfo["username"] = payment_userId
    paymentinfo["appScheme"] = "momopartnerscheme001" //<partnerSchemeId>: app uniqueueId provided by MoMo , get from business.momo.vn. PLEASE MAKE SURE TO ADD <partnerSchemeId> TO PLIST file ( URL types > URL Schemes ). View more detail on https://github.com/momo-wallet/mobile-sdk/tree/master/ios
    MoMoPayment.createPaymentInformation(info: paymentinfo)
    
    //STEP 3: INIT LAYOUT - ADD BUTTON PAYMENT VIA MOMO
    let buttonPay = UIButton()
    buttonPay.frame = CGRect(x: 20, y: 200, width: 260, height: 40)

    // Button title: ENGLISH = MoMo Wallet , VIETNAMESE = Ví MoMo
    buttonPay.setTitle("Pay Via MoMo Wallet", for: .normal)
    buttonPay.setTitleColor(UIColor.white, for: .normal)
    buttonPay.titleLabel!.font = UIFont.systemFont(ofSize: 15)
    buttonPay.backgroundColor = UIColor.purple
    // Add Button Action to OPEN MOMO APP 
    buttonPay.addTarget(self, action: #selector(self.gettoken), for: .touchUpInside) //see @objc func gettoken() 
    self.view.addSubview(buttonPay)
}

@objc func gettoken() {
    MoMoPayment.requestToken()
}
```
#Handle MoMoNotificationReceive
```
@objc func NoficationCenterTokenReceived(notif: NSNotification) {
        //Token Replied - Call Payment to MoMo Server
        print("::MoMoPay Log::Received Token Replied::\(notif.object!)")
        lblMessage.text = "RequestToken response:\n  \(notif.object as Any)"
        
        let response:NSMutableDictionary = notif.object! as! NSMutableDictionary
        
        
        
        //let _status = response["status"] as! String
        let _statusStr = "\(response["status"] as! String)"
        
        if (_statusStr == "0") {
            
            print("::MoMoPay Log: SUCESS TOKEN. CONTINUE TO CALL API PAYMENT")
            print(">>phone \(response["phonenumber"] as! String)   :: data \(response["data"] as! String)")
            
            let merchant_username       = "username_or_email_or_fullname"
            
            let orderInfo = NSMutableDictionary();
            orderInfo.setValue(response["phonenumber"] as! String,            forKey: "phonenumber");
            orderInfo.setValue(response["data"] as! String,            forKey: "data");
            
            
            orderInfo.setValue(Int(payment_amount),            forKey: "amount");
            orderInfo.setValue(Int(0),            forKey: "fee");
            orderInfo.setValue(payment_merchantCode,            forKey: "merchantcode");
            orderInfo.setValue(merchant_username,            forKey: "username");
            
            lblMessage.text = "Get token success! Processing payment..."
            submitOrderToServer(parram: orderInfo)
            
        }
        else{
            lblMessage.text = "RequestToken response:\n \(notif.object!) | Fail token. Please check input params "
        }
}
```
## Author

MoMo Development Team

## License

MomoiOSSwiftSdk is available under the MIT license. See the LICENSE file for more info.
