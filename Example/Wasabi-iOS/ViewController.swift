//
//  ViewController.swift
//  Wasabi-iOS
//
//  Created by francescu on 04/05/2018.
//  Copyright (c) 2018 francescu. All rights reserved.
//

import UIKit
import Wasabi_iOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        WasabiAPIClient.defaultApplication = "app-ios"
        WasabiAPIClient.defaultBaseUrl = URL(string:"http://URL/api/v1/")!
        
        WasabiAPIClient(userId: "test", experiment: "dev-test").request(WasabiAssignmentRequest()).onComplete { result in
            print("\(result)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

