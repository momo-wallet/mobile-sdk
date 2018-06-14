//
//  ViewController.swift
//  testapp001
//
//  Created by mptt2 on 6/14/18.
//  Copyright © 2018 MService JSC. All rights reserved.
//

import UIKit
import MomoiOSSwiftSdk
class ViewController: UIViewController {

    var lblMessage: UILabel!
    var txtAmount: UITextField!
    var btnPay: UIButton!
    /*
     Just testing values. PLease change it with yours.
     */
    var payment_merchantCode = "CGV01"
    var payment_merchantName = "CGV Cinemas"
    var payment_amount       = 20000
    var payment_fee_display  = 0
    var payment_userId       = "lanh.luu.vn@gmail.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlayout()
        
        /* Integrate MoMo SDK step by step
         *
         *Please make sure the instance 'handleOpenUrl' is already inserted into AppDelegate to handle MoMo app callback as bellow
         * open func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
         *   MoMoPayment.sharedInstance.handleOpenUrl(url: url, sourceApp: sourceApplication!)
         *
         */
        
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
        
        
        
        //////////////////////////////////////////// MoMoPayment.sharedInstance.addMoMoPayCustomButton /////////////////////////////
        //btnPay = MoMoPayment.sharedInstance.addMoMoPayCustomButton(button: btnPay, forControlEvents: .touchUpInside, toView: self.view)
        
        
        //Tạo button Thanh toán bằng Ví MoMo
        let btnPay = UIButton()
        btnPay.frame = CGRect(x: 20, y: 200, width: 260, height: 40)
        btnPay.setTitle("Pay Via MoMo Wallet", for: .normal)
        btnPay.setTitleColor(UIColor.white, for: .normal)
        btnPay.titleLabel!.font = UIFont.systemFont(ofSize: 15)
        btnPay.backgroundColor = UIColor.purple
        btnPay.addTarget(self, action: #selector(self.gettoken), for: .touchUpInside)
        self.view.addSubview(btnPay)
        
        ///////////////////////////////
    }
    
    @objc func gettoken() {
        MoMoPayment.requestToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * SERVER SIDE
     */
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
            
            lblMessage.text = "Get token success! status: \(_statusStr) - wallet: \(response["phonenumber"] as! String) - data: \(response["data"] as! String)"
            submitOrderToServer(parram: orderInfo)
            
        }
        else{
            lblMessage.text = "RequestToken response:\n \(notif.object!) | Fail token. Please check input params "
        }
    }
    
    
    func NoficationCenterCreateOrderReceived(notif: NSNotification) {
        
        //Payment Order Replied
        //    NSString *responseString = [[NSString alloc] initWithData:[notif.object dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
        //
        btnPay.backgroundColor = UIColor.purple
        btnPay.isEnabled = true
        
        if notif.object == nil {
            lblMessage.text = "ERROR!"
            return;
        }
        print("::MoMoPay Log::Request Payment Replied::\(notif.object as Any)")
        
        
        if (notif.object! is NSDictionary) {
            
            let response:NSDictionary = notif.object! as! NSDictionary
            
            let _status = response["status"] as? Int
            
            if _status == 0 {
                print("::MoMoPay Log::Payment Success")
            }
            else {
                print("::MoMoPay Log::Payment Error::\(response["message"] as! String)")
            }
            
            lblMessage.text = "Result:\n\n status: \(String(describing: _status)) \n message: \(response["message"] as! String)"
            
            //continue your checkout order here
        }
        else{
            lblMessage.text = "Result:\n \(notif.object as Any)"
        }
    }
    
    
    func initlayout() {
        
        let codedLabel:UILabel = UILabel()
        codedLabel.frame = CGRect(x: 10, y: 50, width: 300, height: 30)
        codedLabel.textAlignment = .center
        codedLabel.text = "Development Environment"
        codedLabel.numberOfLines=1
        codedLabel.textColor=UIColor.red
        codedLabel.font=UIFont.systemFont(ofSize: 18)
        codedLabel.backgroundColor=UIColor.clear
        self.view .addSubview(codedLabel)
        
        //var paymentArea = UIView(frame: CGRectMake(20, 100, 300, 300))
        //paymentArea.backgroundColor = UIColor.whiteColor()
        
        let paymentArea:UIView = UIView()
        paymentArea.frame = CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width-20, height: 500)
        paymentArea.backgroundColor=UIColor.clear
        
        //var imgMoMo = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        
        let imgMoMo:UIImageView = UIImageView()
        imgMoMo.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imgMoMo.image = UIImage(named: "momo.png")!
        paymentArea.addSubview(imgMoMo)
        
        let lbl:UILabel = UILabel()
        lbl.frame = CGRect(x: 60, y: 0, width: 200, height: 20)
        lbl.text = "Code: \(payment_merchantCode)"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.backgroundColor = UIColor.clear
        paymentArea.addSubview(lbl)
        
        let lbl2:UILabel = UILabel()
        lbl2.frame = CGRect(x: 60, y: 30, width: 200, height: 20)
        lbl2.text = "Name: \(payment_merchantName)"
        lbl2.font  = UIFont.boldSystemFont(ofSize: 15)
        lbl2.backgroundColor = UIColor.clear
        paymentArea.addSubview(lbl2)
        
        let amountStrVnd = self.cleanDollars(payment_amount).replacingOccurrences(of: "$", with: "")
        let lbl3:UILabel = UILabel()
        lbl3.frame = CGRect(x: 10, y: 60, width: 200, height: 30)
        lbl3.text = "Total amount:  \(amountStrVnd)  vnd"
        lbl3.font = UIFont.boldSystemFont(ofSize: 15)
        lbl3.backgroundColor = UIColor.clear
        paymentArea.addSubview(lbl3)
        
        let line:UIView = UIView()
        line.frame = CGRect(x: 110, y: 85, width: 100, height: 1)
        line.backgroundColor = UIColor.gray
        paymentArea.addSubview(line)
        
        
        
        //let lblMessage:UILabel = UILabel()
        lblMessage = UILabel()
        lblMessage.frame = CGRect(x: 10, y: 150, width: 300, height: 250)
        lblMessage.text = "{MoMo Response}"
        lblMessage.font = UIFont.systemFont(ofSize: 15)
        lblMessage.backgroundColor = UIColor.clear
        lblMessage.lineBreakMode = NSLineBreakMode.byWordWrapping // || NSLineBreakMode.byTruncatingTail
        lblMessage.numberOfLines = 0
        paymentArea.addSubview(lblMessage)
        
        self.view.addSubview(paymentArea)
        
        
    }
    
    func cleanDollars(_ value: Int?) -> String {
        guard value != nil else { return "$0.00" }
        let doubleValue = Double(value!)
        let formatter = NumberFormatter()
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        
        return formatter.string(from: NSNumber(value: doubleValue)) ?? "\(doubleValue)"
    }
    
    func submitOrderToServer(parram: NSMutableDictionary) {
        btnPay.backgroundColor = UIColor.gray
        
        //lblMessage.text = "Please wait..."
        let when = DispatchTime.now() + 2 // change 5 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            //self.lblMessage.text = "{Submit order success}"
            self.btnPay.isEnabled = true
            self.btnPay.backgroundColor = UIColor.purple
            let alert = UIAlertView()
            alert.title = "MoMoPay alert"
            alert.message = "please continue submit param <phonenumber,data> to server side"
            alert.addButton(withTitle: "Ok")
            alert.show()
            
        }
        print("<MoMoPay> WARNING: implement this feature on your server side")
        
        /**********END Sample send request on Your Server -To - MoMo Server
         **********WARNING: must to remove it on your product app
         **********/
        
    }
}

