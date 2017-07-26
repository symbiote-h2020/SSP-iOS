//
//  DrawerMenuTableVC.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 21/07/2017.
//  Copyright © 2017 PSNC All rights reserved.
//

import UIKit


class DrawerMenuTableVC: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // See https://github.com/sascha/DrawerController/issues/12
        self.navigationController?.view.setNeedsLayout()
        
//        self.tableView.reloadSections(IndexSet(integersIn: NSRange(location: 0, length: self.tableView.numberOfSections - 1).toRange() ?? 0..<0), with: .none)
    }
    
    
    
    //MARK - storybord management
    static func getViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Drawer", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DrawerMenuTableVC")
        return controller
    }
}
