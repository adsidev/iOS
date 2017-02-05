//
//  CNBTQuestionViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/6/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit

class CNBTQuestionViewController: UIViewController {
    @IBOutlet weak var topNavTitle: UILabel!
    var selectedmodel : CNBTParseModel!
    lazy var questionList  : [CNBTQuestionModel] = []
    lazy var ansList  : [CNBTANSParseModel] = []
  
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fourthAnsLbl: UILabel!
    @IBOutlet weak var fourthAnsView: UIView!
    @IBOutlet weak var thiredAndLBL: UILabel!
    @IBOutlet weak var triredAnsView: UIView!
    @IBOutlet weak var secondAndLBL: UILabel!
    @IBOutlet weak var secondAnsView: UIView!
    @IBOutlet weak var firstAnsLBLView: UILabel!
    @IBOutlet weak var firstAnsView: UIView!
    @IBOutlet weak var questionScroll: UIScrollView!
    @IBOutlet weak var titleName: UILabel!
    var pageNo  : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        unabledisableAnsview()
        titleName.text = selectedmodel.SubjectName!
        topNavTitle.addCharactersSpacingWithDiffrentColoe(spacing: 1.5, text:"LIMILESSgameprep")
         callWebService()
        NotificationCenter.default.addObserver(self, selector: #selector(CNBTQuestionViewController.getQuestionResponse), name: NSNotification.Name(rawValue: "QuestionResponse"), object: nil)
        updateTimer()
        // Do any additional setup after loading the view.
    }
    private func updateTimer(){
    
        timerView.layer.cornerRadius = timerView.frame.width/2
        timerView.layer.borderWidth = 5.0
        timerView.layer.borderColor = UIColor.red.cgColor
        
        // Create a new CircleView
        let circleView = CNBTcricleView(frame: CGRect.init(x: 15, y: 15, width: timerView.frame.width - 30, height: timerView.frame.height - 30))
        timerView.addSubview(circleView)
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(duration: 45.0)
        
    }
     func unabledisableAnsview(){
        firstAnsView.isHidden = true
        secondAnsView.isHidden = true
        triredAnsView.isHidden = true
        fourthAnsView.isHidden = true
        firstAnsLBLView.textColor = UIColor.white
        secondAndLBL.textColor = UIColor.white
        thiredAndLBL.textColor = UIColor.white
        fourthAnsLbl.textColor = UIColor.white
        firstAnsView.backgroundColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        secondAnsView.backgroundColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        triredAnsView.backgroundColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        fourthAnsView.backgroundColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        firstAnsView.layer.borderWidth = 1
        firstAnsView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        triredAnsView.layer.borderWidth = 1
        triredAnsView.layer.borderColor = UIColor.lightGray.cgColor
        
        secondAnsView.layer.borderWidth = 1
        secondAnsView.layer.borderColor = UIColor.lightGray.cgColor
        
        fourthAnsView.layer.borderWidth = 1
        fourthAnsView.layer.borderColor = UIColor.lightGray.cgColor
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    private func callWebService(){
        self.activityIndicator.startAnimating()
        let parameter  = ["PageIndex" : 1 , "PageSize" : 10  , "OrderBy" : "3"  , "SortDirection": "asc"] as [String : Any]
        let serviceView = CNBTServiceController()
        serviceView.callServiceForQuestion(requestParameter: parameter)
    }
    func getQuestionResponse(notification : Notification)  {
        
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
                            print(Subjson)
                            for item in Subjson{
                                let modelClass = CNBTQuestionModel()
                                modelClass.CreatedDate = item["CreatedDate"] as? String
                                modelClass.IsActive = item["IsActive"] as? String
                                modelClass.Difficulty = item["Difficulty"] as? String
                                modelClass.QuestionCode = item["QuestionCode"] as? String
                                modelClass.QuestionContent = item["QuestionContent"] as? String
                                modelClass.QuestionID = item["QuestionID"] as? Int
                                self.questionList.append(modelClass)
                            }
                            self.loadQuestionView()
                            self.callServiceToGetAns(Index : self.pageNo)
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
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    func loadQuestionView()  {
        let framerect = questionScroll.bounds
        for (index , item) in questionList.enumerated(){
            let view = Bundle.main.loadNibNamed("CNBTQuestionView.", owner: nil, options: nil)![0] as! CNBTQuestionView
            let frame = CGRect.init(x: 10.0 + (CGFloat(index) * framerect.size.width), y: 0, width: framerect.size.width - 20, height: framerect.size.height)
            view.frame = frame
            view.tag = index + 1
            view.loadQuestion(Questiontext: item.QuestionContent!)
            questionScroll.addSubview(view)
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
        
        }
        
        questionScroll.contentSize = CGSize.init(width: framerect.size.width * CGFloat(questionList.count), height: framerect.size.height )
    }
    func loadAnsView()  {
        for (index , item ) in ansList.enumerated(){
            if index == 0
            {
                self.firstAnsView.isHidden = false
                self.firstAnsLBLView.text = item.AnswerContent!
            }
            else if index == 1
            {
                self.secondAnsView.isHidden = false
                self.secondAndLBL.text = item.AnswerContent!
            }
            else if index == 2
            {
                self.triredAnsView.isHidden = false
                self.thiredAndLBL.text = item.AnswerContent!
            }
            else if index == 3
            {
                self.fourthAnsView.isHidden = false
                self.fourthAnsLbl.text = item.AnswerContent!
            }
        }
        
    }
    @IBAction func fourthAnsBtnClicked(_ sender: Any) {
        let questionView = questionScroll.viewWithTag(pageNo + 1) as! CNBTQuestionView
        questionView.andtextField.text = self.firstAnsLBLView.text
        let ansdata = ansList[0]
        if ansdata.IsCorrect! == true {
            questionView.andtextField.backgroundColor = UIColor.init(red: 19.0/255.0, green: 181.0/255.0, blue: 146.0/255.0, alpha: 1.0)
            fourthAnsLbl.text = "CORRECT!"
            fourthAnsLbl.textColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            fourthAnsView.backgroundColor = UIColor.white
        }
        else{
            questionView.andtextField.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            fourthAnsLbl.text = "INCORRECT!"
            fourthAnsView.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }

        
    }
    @IBAction func thiredAnsClicked(_ sender: Any) {
        
        let questionView = questionScroll.viewWithTag(pageNo + 1) as! CNBTQuestionView
        questionView.andtextField.text = self.thiredAndLBL.text
        let ansdata = ansList[2]
        if ansdata.IsCorrect! == true {
            questionView.andtextField.backgroundColor = UIColor.init(red: 19.0/255.0, green: 181.0/255.0, blue: 146.0/255.0, alpha: 1.0)
            thiredAndLBL.text = "CORRECT!"
            thiredAndLBL.textColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            triredAnsView.backgroundColor = UIColor.white
        }
        else{
            questionView.andtextField.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            thiredAndLBL.text = "INCORRECT!"
            triredAnsView.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }
        
    }

    @IBAction func secondAnsClick(_ sender: Any) {
        
        let questionView = questionScroll.viewWithTag(pageNo + 1) as! CNBTQuestionView
        questionView.andtextField.text = self.secondAndLBL.text
        let ansdata = ansList[1]
        if ansdata.IsCorrect! == true {
            questionView.andtextField.backgroundColor = UIColor.init(red: 19.0/255.0, green: 181.0/255.0, blue: 146.0/255.0, alpha: 1.0)
            secondAndLBL.text = "CORRECT!"
            secondAndLBL.textColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            secondAnsView.backgroundColor = UIColor.white
        }
        else{
            questionView.andtextField.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            secondAndLBL.text = "INCORRECT!"
            secondAnsView.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }

        
    }
    @IBAction func firstAnsClick(_ sender: Any) {
        let questionView = questionScroll.viewWithTag(pageNo + 1) as! CNBTQuestionView
        questionView.andtextField.text = self.firstAnsLBLView.text
        let ansdata = ansList[0]
        if ansdata.IsCorrect! == true {
            questionView.andtextField.backgroundColor = UIColor.init(red: 19.0/255.0, green: 181.0/255.0, blue: 146.0/255.0, alpha: 1.0)
            firstAnsLBLView.text = "CORRECT!"
           firstAnsLBLView.textColor = UIColor.init(red: 1.0/255.0, green: 138.0/255.0, blue: 118.0/255.0, alpha: 1.0)
            firstAnsView.backgroundColor = UIColor.white
        }
        else{
            questionView.andtextField.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
            firstAnsLBLView.text = "INCORRECT!"
            firstAnsView.backgroundColor = UIColor.init(red: 211.0/255.0, green: 15.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        }


        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callServiceToGetAns(Index : Int)  {
        
        let question = questionList[Index]
        self.activityIndicator.startAnimating()
        let parameter  = ["ID" : question.QuestionID!] as [String : Any]
        let serviceView = CNBTServiceController()
        serviceView.delegate = self
        serviceView.callServiceForselectQuestionAns(requestParameter: parameter)
        
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
extension CNBTQuestionViewController : UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let optionVCShown = Int(scrollView.contentOffset.x/self.view.bounds.size.width)
        print(optionVCShown)
        if  pageNo != optionVCShown{
            pageNo = optionVCShown
            callServiceToGetAns(Index : pageNo)
            unabledisableAnsview()
        }
        
        
    }



}
extension CNBTQuestionViewController : ansDetailListResponse
{
    func getAnsList(response : NSData){
        
        do {
            if let json  = try JSONSerialization.jsonObject(with: response as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
            {
                DispatchQueue.main.async{
                    print(json)
                    let listofSubject = json["SelectedDetails"] as! String
                    let Resdata = listofSubject.data(using: .utf8)
                    do{
                        if let Subjson  = try JSONSerialization.jsonObject(with: Resdata! as Data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [AnyObject]{
                            print(Subjson)
                            if self.ansList.count > 0{
                            
                                self.ansList.removeAll()
                            }
                            for  item  in Subjson{
                                let modelClass = CNBTANSParseModel()
                                modelClass.CreatedDate = item["CreatedDate"] as? String
                                modelClass.IsActive = item["IsActive"] as? String
                                modelClass.AnswerID = item["AnswerID"] as? Int
                                modelClass.QuestionID = item["QuestionID"] as? Int
                                modelClass.AnswerCode = item["AnswerCode"] as? String
                                modelClass.AnswerContent = item["AnswerContent"] as? String
                                modelClass.IsCorrect = item["IsCorrect"] as? Bool
                                modelClass.Explanation = item["Explanation"] as? String
                                self.ansList.append(modelClass)
                                                            }
                            self.loadAnsView()
                            self.activityIndicator.stopAnimating()
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
}
