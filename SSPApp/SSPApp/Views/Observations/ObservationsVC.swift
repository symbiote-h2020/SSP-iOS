//
//  ObservationsVC.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 23/08/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import UIKit

class ObservationsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var obsMam: ObservationsManager = ObservationsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setObservations(_ om: ObservationsManager) {
        self.obsMam = om
    }
    
    
    
    
    //MARK - storybord management
    static func getViewController() -> ObservationsVC {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsVC")
        return controller as! ObservationsVC
    }
    
    static func getNavigationViewController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Observations", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ObservationsNavigatioVC")
        return controller as! UINavigationController
    }
}


// MARK: UITableViewDataSource, UITableViewDelegate
extension ObservationsVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return obsMam.observationsByName.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ithKey = Array(obsMam.observationsByName.keys)[section]
        return obsMam.observationsByName[ithKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let ithKey = Array(obsMam.observationsByName.keys)[section]
        return ithKey
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ObservationTableViewCell
        
        let ithKey = Array(obsMam.observationsByName.keys)[indexPath.section]
        let object = obsMam.observationsByName[ithKey]?[indexPath.row]
        if let obs = object {        
            cell.setCell(obs)
        }
        return cell
    }

}
