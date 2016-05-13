//
//  NavigationController.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 08/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        self.navigationBar.translucent = true
        self.navigationBar.tintColor = UIColor.whiteColor()
        let fontDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.titleTextAttributes = fontDictionary
        
        self.navigationBar.setBackgroundImage(UIImage(named: "top"), forBarMetrics: .Default)
        self.navigationBar.shadowImage = UIImage()
    }
}
