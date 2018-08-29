//
//  ViewControllerWithDrawerMenu.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 21/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit
import DrawerController



//all screens that allows to open drawer must inherit from this
class ViewControllerWithDrawerMenu : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLeftMenuButton()
    }
    
    func setupLeftMenuButton() {
        let leftDrawerButton = DrawerBarButtonItem(target: self, action: "leftDrawerButtonPress:")
        self.navigationItem.setLeftBarButton(leftDrawerButton, animated: true)
    }
    
    func leftDrawerButtonPress(sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
}
