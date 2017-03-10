//
//  CNBTTabBarViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/6/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit

class CNBTTabBarViewController: UITabBarController , UITabBarControllerDelegate {
    
    override func loadView() {
        super.loadView()
        self.delegate = self
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.init(red: 14.0/255.0, green: 143.0/255.0, blue: 116.0/255.0, alpha: 1)
        // Do any additional setup after loading the view.
        
        // home tab
        let homeTab = appdel.tabStoryBoard.instantiateViewController(withIdentifier: "HomeView") as! CNBTHomeViewController
        let homenav = UINavigationController.init(rootViewController: homeTab)
        homenav.navigationBar.isHidden = true
        let homeTabBarItem = UITabBarItem(title: "", image: UIImage(named: "icn_home"), selectedImage: UIImage(named: "icn_home"))
        homenav.tabBarItem = homeTabBarItem
        
        // library tab
        let libraryTab = appdel.tabStoryBoard.instantiateViewController(withIdentifier: "libraryView") as! CNBTLibraryViewController
        let librarayNav = UINavigationController.init(rootViewController: libraryTab)
        librarayNav.navigationBar.isHidden = true
        let libraryTabBarItem = UITabBarItem(title: "", image: UIImage(named: "icn_library"), selectedImage: UIImage(named: "icn_library"))
        librarayNav.tabBarItem = libraryTabBarItem
        
        // Sound tab
        let soundTab = appdel.tabStoryBoard.instantiateViewController(withIdentifier: "soundView") as! CNBTSoundViewController
        let soundNav = UINavigationController.init(rootViewController: soundTab)
        soundNav.navigationBar.isHidden = true
        let soundTabBarItem = UITabBarItem(title: "", image: UIImage(named: "icn_sound"), selectedImage: UIImage(named: "icn_sound"))
        soundNav.tabBarItem = soundTabBarItem
        
        // Graph tab
        let graphTab = appdel.tabStoryBoard.instantiateViewController(withIdentifier: "graphView") as! CNBTGraphViewController
        let graphNav = UINavigationController.init(rootViewController: graphTab)
        graphNav.navigationBar.isHidden = true
        let graphTabBarItem = UITabBarItem(title: "", image: UIImage(named: "icn_graph"), selectedImage: UIImage(named: "icn_graph"))
        graphNav.tabBarItem = graphTabBarItem
        
        // Graph setting
        let settingTab = appdel.tabStoryBoard.instantiateViewController(withIdentifier: "settingView") as! CNBTSettingViewController
        let settingNav = UINavigationController.init(rootViewController: settingTab)
        settingNav.navigationBar.isHidden = true
        let settingTabBarItem = UITabBarItem(title: "", image: UIImage(named: "icn_setting"), selectedImage: UIImage(named: "icn_setting"))
        settingNav.tabBarItem = settingTabBarItem
        
        self.viewControllers = [homenav,librarayNav,soundNav,graphNav,settingNav]
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       // print("Selected \(viewController.title!)")
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
