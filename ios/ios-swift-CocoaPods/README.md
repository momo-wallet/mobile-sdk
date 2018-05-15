# MomoiOSSwiftSdkV2

[![CI Status](http://img.shields.io/travis/momodevelopment/MomoiOSSwiftSdkV2.svg?style=flat)](https://travis-ci.org/momodevelopment/MomoiOSSwiftSdkV2)
[![Version](https://img.shields.io/cocoapods/v/MomoiOSSwiftSdkV2.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdkV2)
[![License](https://img.shields.io/cocoapods/l/MomoiOSSwiftSdkV2.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdkV2)
[![Platform](https://img.shields.io/cocoapods/p/MomoiOSSwiftSdkV2.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdkV2)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MomoiOSSwiftSdkV2 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MomoiOSSwiftSdkV2', :git => 'https://github.com/momodevelopment/MomoiOSSwiftSdkV2.git',:branch => "master"
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

open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        MoMoPayment.sharedInstance.handleOpenUrl(url: url, sourceApp: sourceApplication!)
        return true
}
```

Step 3. Update Layout Payment

#NotificationCenter registration
MOMO NOTIFICATION KEYS SHOULD BE REMOVED WHEN THE VIEWCONTROLLERS DEALLOCATING OR DISMISSING COMPLETED
(Notification keys: NoficationCenterTokenReceived , NoficationCenterTokenStartRequest)
```
override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceivedUri"), object: nil)

    MoMoPayment.sharedInstance.initMerchant(merchantCode: "SCB01", merchantName: "Manchester United", merchantNameLabel: "Nhà cung cấp")
        
    
    initOrderAndButtonAction()
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
Add Button Action to Pay Via MOMO
Button title: EN = MoMo Wallet , VI = Ví MoMo
```
func initOrderAndButtonAction() {
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

    MoMoPayment.sharedInstance.setupEnvironment(environment: MoMoConfig.MOMO_ENVIRONEMENT.PRODUCTION)
    
    //Setup amount. YOU CAN UPDATE ANYTIME IF NEED
        let paymentinfo = NSMutableDictionary()
        paymentinfo["amount"] = payment_amount
        paymentinfo["fee"] = payment_fee_display
        paymentinfo["description"] = "Buy Vietjet Air Ticket"
        paymentinfo["extra"] = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
        paymentinfo["username"] = payment_userId
        paymentinfo["appScheme"] = "vntrip.vn.app"
        MoMoPayment.sharedInstance.createPaymentInformation(info: paymentinfo)

    //STEP 2: ADD BUTTON ACTION TO PAY VIA MOMO WALLET
    //buttonAction will open MoMo app to pay
        let btnPay = UIButton()
        btnPay.frame = CGRect(x: 10, y: 100, width: 260, height: 40)
        btnPay.setTitle("Pay Via MoMo Wallet", for: .normal)
        btnPay.setTitleColor(UIColor.white, for: .normal)
        btnPay.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        btnPay.backgroundColor = UIColor.purple
        //btnPay.addTarget(self, action: #selector(MoMoPayment.sharedInstance.requestToken), for: UIControlEvents.touchUpInside)
        //paymentArea.addSubview(btnPay)
        btnPay = MoMoPayment.sharedInstance.addMoMoPayCustomButton(button: btnPay, forControlEvents: .touchUpInside, toView: paymentArea)
        

}
```

## Author

MoMo Development Team

## License

MomoiOSSwiftSdkV2 is available under the MIT license. See the LICENSE file for more info.
