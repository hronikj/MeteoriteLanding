//
//  LaunchScreenViewController.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 09/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // splash screen image
        self.imageView.image = UIImage(named: "launch")
        self.imageView.layer.borderWidth = 1.0
        self.imageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.layer.cornerRadius = 13
        self.imageView.layer.cornerRadius = imageView.frame.size.height / 2
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.clipsToBounds = true
        
        // blur effect
        let blurEffect = UIBlurEffect(style: .Light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.imageView.bounds
        self.imageView.addSubview(blurredEffectView)

        self.bounceImage()
    }
    
    func bounceImage() {
        let expandTransform: CGAffineTransform = CGAffineTransformMakeScale(0.35, 0.35)
        UIView.animateWithDuration(1, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .CurveEaseIn, animations: {
            self.imageView.transform = CGAffineTransformInvert(expandTransform)
            self.bottomTextLabel.textColor = UIColor.whiteColor()
            }, completion: {
                (Bool) in
                self.performSegueWithIdentifier("LaunchScreenSegueIdentifier", sender: nil)
        })
    }
    
}