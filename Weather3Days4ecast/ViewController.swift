//
//  ViewController.swift
//  Weather3Days4ecast
//
//  Created by RA on 17/03/2020.
//  Copyright © 2020 RA. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var backGroundImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        // Control of background image animation of main screen 
        UIView.animate(withDuration: 60.0, delay: 1.0, options: [.curveEaseOut, .curveEaseIn, .autoreverse,] , animations: {
            var backGroundImafeFrame = self.backGroundImage.frame
            backGroundImafeFrame.origin.x += backGroundImafeFrame.size.width - self.view.bounds.width
            self.backGroundImage.frame = backGroundImafeFrame
        })
        
    }
    
}

