//
//  CNBTSettingViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/6/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit

class CNBTSettingViewController: UIViewController {
    @IBOutlet weak var tableViewMain: UITableView!
    var arrayDataSource: [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    func initialSetup() {
        arrayDataSource = [["My Profile", "User"], ["LogOut", "User"]]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CNBTSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
    func getCell(indexPath: IndexPath) -> LMSettingsTableviewCell {
        var cell = tableViewMain.dequeueReusableCell(withIdentifier: CellIdentifiers.LMSettingsTableviewCell) as? LMSettingsTableviewCell
        if cell == nil {
            cell = LMSettingsTableviewCell(style: .default, reuseIdentifier: CellIdentifiers.LMSettingsTableviewCell)
        }
        let arrayModel = arrayDataSource[indexPath.row]
        cell?.labelCustom.text = arrayModel[0]
        cell?.imageViewMain.image = UIImage(named: arrayModel[1])
        return cell!
    }
}
