//
//  CNBTHomeViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/6/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit

class CNBTHomeViewController: UIViewController {
    @IBOutlet weak var titletopNavLab: UILabel!
    
    @IBOutlet weak var infiniteView: UIView!
    
    @IBOutlet weak var lessionView: UIView!
    @IBOutlet weak var towpalayerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titletopNavLab.addCharactersSpacingWithDiffrentColoe(spacing: 1.5, text:"LIMITLESSgameprep")
        creatRoundView()
        
        // Do any additional setup after loading the view.
    }
    private func creatRoundView()
    {
        
        infiniteView.layer.cornerRadius = 5.0
        lessionView.layer.cornerRadius = 5.0
        towpalayerView.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func lessionButtonClick(_ sender: Any) {
    }
    
    @IBAction func towButtonClicked(_ sender: Any) {
    }
    
    @IBAction func infiniteButtonClick(_ sender: Any) {
        let Vc = appdel.mainStoryBoard.instantiateViewController(withIdentifier: "CNBTDashBoard") as! CNBTDashBoardViewController
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
