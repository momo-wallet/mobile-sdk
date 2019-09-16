//
//  MoMoPayment.swift
//  SampleApp-Swift
//
//  Created by Luu Lanh on 4/24/17.
//  Copyright © 2017 LuuLanh. All rights reserved.
// Updated on on 12/07/17.
//

import Foundation
import UIKit
//let IS_IOS_10_OR_LATER = Int(UIDevice.current.systemVersion) >= 10.0

var paymentInfo: NSMutableDictionary? = nil
let _sharedInstance = MoMoPayment()
struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0)
}
public class MoMoPayment: NSObject {
    class var sharedInstance:MoMoPayment {
        return _sharedInstance
    }
    
    public static func initMerchant(merchantCode: String, merchantName: String, merchantNameLabel: String) {
        
        MoMoConfig .setMerchantcode(merchantCode: merchantCode)
        MoMoConfig .setMerchantname(merchantName: merchantName)
        MoMoConfig .setMerchantnameLabel(merchantnameLabel: merchantNameLabel)
        MoMoConfig .setPublickey(merchantpublickey:"")
        print("<MoMoPay> initializing successful - Your merchantcode \(merchantCode)")
    }
    
    public static func handleOpenUrl(url: URL, sourceApp: String) {
        //let sourceURI = url.absoluteString! as String
        let sourceURI = url.absoluteString;
        let response = getDictionaryFromUrlQuery(query: sourceURI)
        //let partner = "\(response["fromapp"] as! String)"
        if response.count > 0 {
            let status = "\(response["status"] as! String)"
            let message = "\(response["message"] as! String)"
            if (status == MOMO_TOKEN_RESPONSE_SUCCESS) {
                print("<MoMoPay> SUCESS TOKEN.")
            }
            else if (status == MOMO_TOKEN_RESPONSE_REGISTER_PHONE_NUMBER_REQUIRE) {
                print("<MoMoPay> REGISTER_PHONE_NUMBER_REQUIRE.")
            }
            else if (status == MOMO_TOKEN_RESPONSE_LOGIN_REQUIRE) {
                print("<MoMoPay> LOGIN_REQUIRE.")
            }
            else if (status == MOMO_TOKEN_RESPONSE_NO_WALLET) {
                print("<MoMoPay> NO_WALLET. You need to cashin to MoMo Wallet ")
            }
            else if (status == MOMO_TOKEN_RESPONSE_USER_CANCELED) {
                print("<MoMoPay> Canceled ")
            }
            
            print("<MoMoPay> \(message)")
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "NoficationCenterTokenReceived"), object: response, userInfo: nil)
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: "NoficationCenterTokenReceivedUri"), object: sourceURI, userInfo: nil)
        }
        else {
            print("<MoMoPay> Do nothing")
        }
    }
    
    public static func getQueryStringParameter(url: String?, param: String) -> String? {
        if let url = url, let urlComponents = URLComponents(string: url), let queryItems = (urlComponents.queryItems) {
            return queryItems.filter({ (item) in item.name == param }).first?.value ?? "NIL"
        }
        return "NIL"
    }
    
    public static func getDictionaryFromUrlQuery(query: String) -> (NSDictionary) {
        let info : NSMutableDictionary = NSMutableDictionary()
        //let openUrl:URL = URL(string:query)!
        let momoappversion:String = getQueryStringParameter(url: query,param: "momoappversion")!
        let status:String = getQueryStringParameter(url: query,param: "status")!
        let message:String = getQueryStringParameter(url: query,param: "message")!
        let phonenumber:String = getQueryStringParameter(url: query,param: "phonenumber")!
        let data:String = getQueryStringParameter(url: query,param: "data")!
        let fromapp:String = getQueryStringParameter(url: query,param: "fromapp")!
        let appSource:String = getQueryStringParameter(url: query,param: "appSource")!
        let base64Encoded:String = getQueryStringParameter(url: query,param: "extra")!
        
        var extra = base64Encoded
        if (extra != ""){
            if let base64Decoded = NSData(base64Encoded: base64Encoded, options:   NSData.Base64DecodingOptions(rawValue: 0))
                .map({ NSString(data: $0 as Data, encoding: String.Encoding.utf8.rawValue) })
            {
                // Convert back to a string
                extra = base64Decoded! as String;
            }
        }
        
        info.setValue(String(describing: momoappversion), forKey: "momoappversion")
        info.setValue(String(describing: status), forKey: "status")
        info.setValue(String(describing: message), forKey: "message")
        info.setValue(String(describing: phonenumber), forKey: "phonenumber")
        info.setValue(String(describing: data), forKey: "data")
        info.setValue(String(describing: fromapp), forKey: "fromapp")
        info.setValue(String(describing: appSource), forKey: "appSource")
        info.setValue(String(describing: extra), forKey: "extra")
        
        return info
    }
    
    public static func createPaymentInformation(info: NSMutableDictionary) {
        paymentInfo = info
    }
    
//    @objc open func addMoMoPayCustomButton(button: UIButton, forControlEvents controlEvents: UIControlEvents, toView parrentView: UIView) -> UIButton {
//        
//        button.addTarget(self, action: #selector(self.requestToken), for: .touchUpInside)
//        
//        parrentView.addSubview(button)
//        return button
//    }
    
    
    public static func requestToken() {

        if (paymentInfo as NSMutableDictionary?) == nil {
            print("<MoMoPay> Payment pakageApp should not be null.")
            return;
        }
        
        print("<MoMoPay> requestToken")
        let bundleId = Bundle.main.bundleIdentifier
        //Open MoMo App to get token
        var inputParams = "action=\(MOMO_PAY_SDK_ACTION_GETTOKEN)&partner=merchant"
        //paymentInfo?[MOMO_PAY_CLIENT_MERCHANT_CODE_KEY] = MoMoConfig.getMerchantcode()
        //paymentInfo?[MOMO_PAY_CLIENT_MERCHANT_NAME_KEY] = MoMoConfig.getMerchantname()
        //paymentInfo?[MOMO_PAY_CLIENT_MERCHANT_NAME_LABEL_KEY] = MoMoConfig.getMerchantnameLabel()
        paymentInfo?[MOMO_PAY_CLIENT_PUBLIC_KEY_KEY] = ""
        paymentInfo?[MOMO_PAY_CLIENT_IP_ADDRESS_KEY] = MoMoConfig.getIPAddress()
        paymentInfo?[MOMO_PAY_CLIENT_OS_KEY] = MoMoConfig.getDeviceInfoString()
        paymentInfo?[MOMO_PAY_CLIENT_APP_SOURCE_KEY] = bundleId
        paymentInfo?[MOMO_PAY_SDK_VERSION_KEY] = MOMO_PAY_SDK_VERSION
        for key in (paymentInfo?.allKeys)! {
            let _value = paymentInfo?[key] as? String ;
            if _value == nil {
                inputParams.append("&\(key as! String)=\(paymentInfo?[key] as! Int)")
            }
            else{
                let _key = key as? String ;
                if _key == "extra" || _key == "extra" {
                    
                    //print("UTF8 Original: \(_value)")
                    
                    let utf8str = _value?.data(using: String.Encoding.utf8)
                    
                    if let base64Encoded = utf8str?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                    {
                        //print("UTF8 Encoded:  \(base64Encoded)")
                        inputParams.append("&\(key as! String)=\(base64Encoded )")
                    }
                    else{
                        inputParams.append("&\(key as! String)=\(paymentInfo?[key] as! String)")
                    }
                    
                }
                else {
                    inputParams.append("&\(key as! String)=\(paymentInfo?[key] as! String)")
                }
                print("<MoMoPay> request param > \(key) = \(paymentInfo?[key] as! String)")
            }
            
        }
        
        var appSource:String = "\(MOMO_APP_BUNDLE_ID)://?\(inputParams)"
        
        appSource = appSource.removingPercentEncoding! as String
        appSource = appSource.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

        print("<MoMoPay> open url \(appSource)")

        if let urlAppMoMo = URL(string: appSource) {
            if UIApplication.shared.canOpenURL(urlAppMoMo) {
                if let momoAppURL:URL = URL(string:""+"\(appSource)") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(momoAppURL, options: [:], completionHandler: nil);
                    }
                    else {
                        UIApplication.shared.openURL(momoAppURL);
                    }
                }
                else{
                    print("<MoMoPay> momoAppURL fail")
                }
            }
            else {
                var appStoreURL:String = "\(MOMO_APP_ITUNES_DOWNLOAD_PATH)"
                appStoreURL = appStoreURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                if let downloadURL:URL = URL(string:appStoreURL) {
                    if UIApplication.shared.canOpenURL(downloadURL) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(downloadURL, options: [:], completionHandler: nil);
                        }
                        else {
                            UIApplication.shared.openURL(downloadURL);
                        }
                    }
                    
                }
                
            }
        }
        else {
            print("<MoMoPay> momoAppURL fail")
        }
        
    }
    
    /*
     * SERVER SIDE DEMO
     * CALL MOMO API http://testing.momo.vn:8093/pay/app
     */

    open func requestPayment(parram: NSMutableDictionary) {
        print("<MoMoPay> please implement this function by your self")
        //
    }
    
}
