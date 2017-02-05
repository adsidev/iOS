//
//  CNBTDashBoardViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 12/5/16.
//  Copyright © 2016 CNBT. All rights reserved.
//

import UIKit

class CNBTDashBoardViewController: UIViewController {

    @IBOutlet weak var topNavTitle: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionlistView: UICollectionView!
    let identifier = "CategoryCell"
    lazy var subjectList  : [CNBTParseModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        callWebService()
        topNavTitle.addCharactersSpacingWithDiffrentColoe(spacing: 1.5, text:"LIMILESSgameprep")
         NotificationCenter.default.addObserver(self, selector: #selector(CNBTDashBoardViewController.getSubjectResponse), name: NSNotification.Name(rawValue: "subjectResponse"), object: nil)


        // Do any additional setup after loading the view.
    }
    
    private func callWebService(){
        self.activityIndicator.startAnimating()
        let parameter  = ["PageIndex" : 1 , "PageSize" : 10  , "OrderBy" : "SubjectName"  , "SortDirection": "asc"] as [String : Any]
        let serviceView = CNBTServiceController()
        serviceView.callServiceForSubject(requestParameter: parameter)
    }
    func getSubjectResponse(notification : Notification)  {
        
        guard let responseData = notification.userInfo?["Response"] as? NSData    else {
            return
        }
        do {
            if let json  = try JSONSerialization.jsonObject(with: responseData as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
            {
                DispatchQueue.main.async{
                    print(json)
                    let listofSubject = json["List"] as! String
                    let Resdata = listofSubject.data(using: .utf8)
                    do{
                        if let Subjson  = try JSONSerialization.jsonObject(with: Resdata! as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]{
                            for item in Subjson{
                            let modelClass = CNBTParseModel()
                                modelClass.CreatedDate = item["CreatedDate"] as? String
                                modelClass.IsActive = item["IsActive"] as? String
                                modelClass.OrganizationName = item["OrganizationName"] as? String
                                modelClass.SubjectDescription = item["SubjectDescription"] as? String
                                modelClass.SubjectICON = item["SubjectICON"] as? String
                                 modelClass.SubjectName = item["SubjectName"] as? String
                                modelClass.SubjectID = item["SubjectID"] as? Int
                                self.subjectList.append(modelClass)
                            }
                            self.collectionlistView.reloadData()
                        }
                    }catch let error as NSError {
                        self.activityIndicator.stopAnimating()
                        appdel.window?.makeToast("Parse Issue")
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        } catch let error as NSError {
            self.activityIndicator.stopAnimating()
            appdel.window?.makeToast("Parse Issue")
            print("Failed to load: \(error.localizedDescription)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
extension CNBTDashBoardViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return subjectList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! dashBoardCollectionViewCell
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        let subjectModel = subjectList[indexPath.row]
        cell.subjectName.text = subjectModel.SubjectName!
        if subjectModel.IsActive == "Active" {
            cell.lockUnLockImage.image = UIImage(named : "icn_unlock")
        }
        else{
        cell.lockUnLockImage.image = UIImage(named : "icn_lock")
        }
        
        //let image = UIImage(named:todayProductList[indexPath.row]) //UIImage(name : todayProductList[indexPath.row] )
       // cell.cellImage.image = image
       
        return cell
    }
    
}


// MARK:- UICollectionViewDelegate Methods
extension CNBTDashBoardViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        let subjectModel = subjectList[indexPath.row]
        let Vc = appdel.mainStoryBoard.instantiateViewController(withIdentifier: "QuestionView") as! CNBTQuestionViewController
        Vc.selectedmodel = subjectModel
        self.navigationController?.pushViewController(Vc, animated: true)
        //
    }
}
extension CNBTDashBoardViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (UIScreen.main.bounds.width - 20)
        return CGSize(width :length,height : 126);
    }
}
