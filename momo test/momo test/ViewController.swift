//
//  ViewController.swift
//  momo test
//
//  Created by mptt2 on 6/13/18.
//  Copyright © 2018 MService JSC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func callback(_ sender: Any) {
        let inputParams = "status=0&message=success"
        var appSource:String = "partnerscheme001://?\(inputParams)"
        
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
                    print("<MoMoPay> momoAppURL fail 1")
                }
            }
            else {
                print("<MoMoPay> momoAppURL fail 2")
                
            }
        }
        else {
            print("<MoMoPay> momoAppURL fail")
        }
    }
    
}

