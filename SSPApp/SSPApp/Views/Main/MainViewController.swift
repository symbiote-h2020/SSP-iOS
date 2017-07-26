//
//  ViewController.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 25/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import DrawerController

class MainViewController: DrawerController {
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        configureDrawer()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    
    fileprivate func configureDrawer() {
        
        // view controllers
        if self.centerViewController == nil {
            self.centerViewController = SearchDevicesVC.getViewController()
        }
        if self.leftDrawerViewController == nil {
            self.leftDrawerViewController = DrawerMenuTableVC.getViewController()
        }
        if self.rightDrawerViewController == nil {
            self.rightDrawerViewController = nil
        }
        
        // drawer settings
        openDrawerGestureModeMask = []
        closeDrawerGestureModeMask = .all
        drawerVisualStateBlock = DrawerVisualState.slideVisualStateBlock
        showsShadows = true
        updateDrawerSize(self.view.bounds.size)
    }
    
    fileprivate func updateDrawerSize(_ size: CGSize) {
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.maximumLeftDrawerWidth = 400.0
        }
        else {
            self.maximumLeftDrawerWidth = min(size.width, size.height) - 60.0
        }
    }
    
    
}

