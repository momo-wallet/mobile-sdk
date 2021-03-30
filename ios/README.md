# MoMo iOS SDK

[![CI Status](http://img.shields.io/travis/momodevelopment/MomoiOSSwiftSdk.svg?style=flat)](https://travis-ci.org/momodevelopment/MomoiOSSwiftSdkV2)
[![Version](https://img.shields.io/cocoapods/v/MomoiOSSwiftSdk.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdk)
[![License](https://img.shields.io/cocoapods/l/MomoiOSSwiftSdk.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdk)
[![Platform](https://img.shields.io/cocoapods/p/MomoiOSSwiftSdk.svg?style=flat)](http://cocoapods.org/pods/MomoiOSSwiftSdk)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation Swift

MomoiOSSwiftSdkV2 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MomoiOSSwiftSdk", :git => "https://github.com/momo-wallet/mobile-sdk.git", :branch => "release_swift", submodules: true
```

## Installation Objective-C

MoMoiOSsdkv2 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MoMoSDKiOSObjc', :git => "https://github.com/momo-wallet/mobile-sdk.git", :branch => "release_objc", submodules: true
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
      <string>momopartnerscheme001</string>
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

//Objective-c code
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

#NotificationCenter registration
MOMO NOTIFICATION KEYS SHOULD BE REMOVED WHEN THE VIEWCONTROLLERS DEALLOCATING OR DISMISSING COMPLETED
(Notification keys: NoficationCenterTokenReceived , NoficationCenterTokenStartRequest)
```
//Swift code
import MomoiOSSwiftSdk

override func viewDidLoad() {
    super.viewDidLoad()
    
    //STEP 1: addObserver Notification
        //Remove all MOMO NOTIFICATION by self
    NotificationCenter.default.removeObserver(self, name: "NoficationCenterTokenReceived", object: nil)
        //Registration MOMO NOTIFICATION by self
        NotificationCenter.default.addObserver(self, selector: #selector(self.NoficationCenterTokenReceived), name:NSNotification.Name(rawValue: "NoficationCenterTokenReceived"), object: nil)\
        //
    //STEP 2: INIT MERCHANT AND PAYMENT INFO. YOU CAN MODIFY ANYTIME IF NEED

    let paymentinfo = NSMutableDictionary()
    paymentinfo["merchantcode"] = "CGV01"
    paymentinfo["merchantname"] = "CGV Cinemas"
    paymentinfo["merchantnamelabel"] = "Service"
    paymentinfo["orderId"] = "ID123456789"
    paymentinfo["amount"] = 20000
    paymentinfo["fee"] = 0
    paymentinfo["description"] = "Thanh toán vé xem phim"
    paymentinfo["extra"] = "{\"key1\":\"value1\",\"key2\":\"value2\"}"
    paymentinfo["username"] = payment_userId
    paymentinfo["appScheme"] = "partnerSchemeId" //<partnerSchemeId>: uniqueueId provided by MoMo , get from business.momo.vn. PLEASE MAKE SURE TO ADD <partnerSchemeId> TO PLIST file ( URL types > URL Schemes ). View more detail on https://github.com/momo-wallet/mobile-sdk/tree/master/ios
    
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


//Objective-c Code 
- (void)viewDidLoad {
    [super viewDidLoad];
    //Remove all MOMO NOTIFICATION by self
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NoficationCenterTokenReceived" object:nil];
    
    //Registration MOMO NOTIFICATION by self
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMoMoNoficationCenterTokenReceived:) name:@"NoficationCenterTokenReceived" object:nil];
    
    NSMutableDictionary *paymentinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                            [NSNumber numberWithInt:99000],@"amount",
                                            [NSNumber numberWithInt:0],@"fee",
                                            @"Buy CGV Cinemas",@"description",
                                            @"{\"key1\":\"value1\",\"key2\":\"value2\"}",@"extra", //OPTIONAL
                                            @"vi",@"language",
                                            @"your_orderId",@"orderId",
                                            @"Người dùng",@"orderLabel",
                                            @"momopartnerscheme001", @"appScheme",
                                            nil];
    
    [[MoMoPayment shareInstances] initPayment:paymentinfo];
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

func submitOrderToServer(parram: NSMutableDictionary) {
        
    //lblMessage.text = "Please wait..."
    let when = DispatchTime.now() + 2 // change 5 to desired number of seconds
    DispatchQueue.main.asyncAfter(deadline: when) {
        // Your code with delay
        //self.lblMessage.text = "Submit order...."
        let alert = UIAlertView()
        alert.title = "MoMoPay alert"
        alert.message = "please continue submit param <phonenumber,data> to server side"
        alert.addButton(withTitle: "Ok")
        alert.show()

    }
    
    /**********END Sample send request on Your Server -To - MoMo Server
     **********WARNING: must to remove it on your product app
     **********/

    let API_REQUEST_PATH = "http://staging.partner.com/api/payment"

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: parram, options: .prettyPrinted)
        print("requestPayment -> \(jsonData)")
        // create post request
        let url = NSURL(string: API_REQUEST_PATH)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil{
                print("Error -> \(String(describing: error))")
            }
            else{
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                    print("Response-> \(String(describing: result))")
                } catch {
                    print("Error -> \(error)")
                }
            }

        }

        task.resume()

    } catch {
        print(error)
    }
}

//Objective-c Code
-(void)processMoMoNoficationCenterTokenReceived:(NSNotification*)notif{
NSString *sourceUri = [NSString stringWithFormat:@"%@",notif.object];
    
    NSURL *url = [NSURL URLWithString:sourceText];
    if (url) {
        sourceText = url.query;
    }
    
    NSArray *parameters = [sourceUri componentsSeparatedByString:@"&"];
    
    NSDictionary *response = [self getDictionaryFromComponents:parameters];
    NSString *status = [NSString stringWithFormat:@"%@",[response objectForKey:@"status"]];
    NSString *message = [NSString stringWithFormat:@"%@",[response objectForKey:@"message"]];
    if ([status isEqualToString:@"0"]) {
        
        NSLog(@"::MoMoPay Log: SUCESS TOKEN.");
        NSString *data = [NSString stringWithFormat:@"%@",[response objectForKey:@"data"]];//session data
        NSString *phoneNumber =  [NSString stringWithFormat:@"%@",[response objectForKey:@"phonenumber"]];//wallet Id
        NSLog(@">>response::phoneNumber %@ , data:: %@",phoneNumber, data);
    }
    else
    {
        NSLog(@"::MoMoPay Log: %@",message);
    }
}
-(NSMutableDictionary*)getDictionaryFromComponents:(NSArray*)components{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    // parse parameters to dictionary
    for (NSString *param in components) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        // get key, value
        NSString* key   = [elts objectAtIndex:0];
        key = [key stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSString* value = [elts objectAtIndex:1];
        
        ///Start Fix HTML Property issue
        if ([elts count]>2) {
            @try {
                value = [param substringFromIndex:([param rangeOfString:@"="].location+1)];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        ///End HTML Property issue
        if(value){
            value = [NSString stringWithCString: [value UTF8String] encoding: NSUTF8StringEncoding];
        }
        
        //
        if(key.length && value.length){
            [params setObject:value forKey:key];
        }
    }
    return params;
}
```
## Author

MoMo Development Team

Lanh.Luu lanh.luu @ mservice.com.vn

## License

MomoiOSSwiftSdk is available under the MIT license. See the LICENSE file for more info.
