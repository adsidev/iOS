//
//  CNBTQuestionViewController.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/6/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit
import Alamofire

class CNBTQuestionViewController: UIViewController {
    @IBOutlet weak var topNavTitle: UILabel!
    var selectedmodel : CNBTParseModel!
    lazy var questionList  : [CNBTQuestionModel] = []
    lazy var ansList  : [CNBTANSParseModel] = []
    var timerCount: Int = 0
    @IBOutlet weak var viewImageAndQuestion: LMCustomView!
    @IBOutlet weak var viewTextfieldAndTextview: LMCustomView!
    @IBOutlet weak var viewRandom: UIView!
    @IBOutlet weak var viewLabels: UIView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageViewQuestion: UIImageView!
    @IBOutlet weak var imageviewAnimation: UIImageView!
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var textFieldStreak: LMCustomTextField!
    @IBOutlet weak var textFieldLives: LMCustomTextField!
    @IBOutlet weak var textFieldScore: LMCustomTextField!
    
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    @IBOutlet weak var constraintTextfieldTop: NSLayoutConstraint!
    @IBOutlet weak var constraintTextfieldHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintImageWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintImageTop: NSLayoutConstraint!
    
    
    var currentHiddenView: UIView!
    var frameOfRecognizer: CGRect?
    var difficulty: String = "1"
    var pageNo  : Int = 0
    var currentQuestion: Question?
    var choices: [Answer]?
    var lives: Int = 3
    var timerLabelText: Int! = 30
    var isModel: Bool = true
    // streak
    var currentStreak: Int = 0
    var startTime: TimeInterval!
    
    // score
    var currentScore: Double = 0.0
    
    
    var trackImageIndex: Int = 0
    var imageTimer: Timer?
    
    
    //answer 
    var rightAnswerCount: Int = 0
    var wrongAnswerCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    func initialSetup() {
        viewImageAndQuestion.isHidden = false
        viewTextfieldAndTextview.isHidden = true
        textView.contentOffset = CGPoint(x: 0, y: 0)
        addShadows()
        loadQuestion()
        self.textFieldLives.text = "\(lives)"
        self.textFieldStreak.text = "\(self.currentStreak)"
        self.textFieldScore.text = "\(self.currentScore)"
        self.titleName.text = "\(selectedmodel.SubjectName!)"
    }
    func addShadows() {
        viewImageAndQuestion.addShadow()
        viewTextfieldAndTextview.addShadow()
        //viewLabels.addShadow()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(updateLabelTimer),
                             userInfo: nil,
                             repeats: true)
        
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func updateLabelTimer() {
        timerCount = timerCount + 1
        labelTimer.text = "\(timerCount)"
    }
    
    func getImages() -> [UIImage] {
        var imagesArray = [UIImage]()
        for i in 1...12 {
            imagesArray.append(UIImage(named: "Image\(i).png")!)
        }
        return imagesArray
    }
    private func getQuestions(_ pageIndex: Int, pageSize: UInt = 10)  {
        self.showHud()
        
        let parameter  = ["PageIndex" : pageIndex , "PageSize" : pageSize  , "OrderBy" : "QuestionID"  , "SortDirection": "asc", "OrganizationID" : UserDefaults.standard.value(forKey: "OrganizationID") ?? "1",
                          "SubjectID" : selectedmodel.SubjectID ?? 7] as [String : Any]
        
        var trimmedString = mainpUrl + "Question/GetQuestionAnswerList"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = URL(string:trimmedString)
        var request = URLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.populateAuthorizationHeader()
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        Alamofire.request(request).responseString { [weak self](response) in
            
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                weakSelf.parseQuestion(response.data!)
                weakSelf.hideHUD()
            }
        }
    }
    
    
    func startQuestionTimeImages() {
        
        if trackImageIndex == getImages().count{
            trackImageIndex = 0
        }
        self.imageviewAnimation.image = getImages()[trackImageIndex]
        self.trackImageIndex = self.trackImageIndex + 1
        
        // Set time
        self.startTime =  Date().timeIntervalSince1970
    }
    
    func parseQuestion(_ data: Data) {
        do {
            if let json  = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
            {
                print(json)
                
                if Int(json["TotalRecords"]! as! NSNumber) < 1{
                    DispatchQueue.main.async { [weak self] _ in
                        appdel.window?.makeToast("Quiz over")
                        self?.clanUp()
                    }
                    return
                }
                
                let listString = json["List"] as? String
                let data = listString?.data(using: .utf8)
                if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                    if let questionsJSon = jsonData?["Table"] as? [[String: Any]]{
                        for questionJson in questionsJSon{
                            print(questionJson)
                            var question = [String: Any]()
                            question["questionID"] = "\(questionJson["QuestionID"]!)"
                            question["subObjectiveID"] = "\(questionJson["SubObjectiveID"]!)"
                            question["questionTypeID"] = "\(questionJson["QuestionTypeID"]!)"
                            question["attempted"] = false
                            question["content"] = questionJson["QuestionContent"]!
                            //question["imageUrl"] = questionJson["QuestionImage"] ?? ""
                            question["imageUrl"] = ""
                            question["subjectID"] = "\(selectedmodel.SubjectID!)"
                            question["difficulty"] = "\(questionJson["Difficulty"]!)"
                            Question.save(question)
                        }
                    }
                    if let answersJson = jsonData?["Table1"] as? [[String: Any]]{
                        for answerJson in answersJson{
                            print(answerJson)
                            if let question = Question.getBy(questionID: "\(answerJson["id"]!)", subjectID: "\(self.selectedmodel.SubjectID!)"){
                                var answer = [String: Any]()
                                answer["answerID"] = "\(answerJson["AnswerID"]!)"
                                answer["answerContent"] = "\(answerJson["AnswerContent"]!)"
                                answer["isCorrect"] = answerJson["IsCorrect"] as! Bool
                                answer["explanation"] = answerJson["Explanation"]!
                                let answerObj = Answer.getAnswerTemplate(answer)
                                question.addToAnswers(answerObj!)
                                
                                guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                                appDelegate.saveContext()
                            }
                            
                        }
                    }
                    self.loadQuestion()
                }
            }
            
        }catch let error as NSError {
            appdel.window?.makeToast("Parse Issue")
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    
    func loadQuestion()  {
        
        DispatchQueue.main.async { [weak self] _ in
            
            guard let weakSelf = self else {return}
            
            if let question = Question.getNextQuestion(subjectID: "\(weakSelf.selectedmodel.SubjectID!)", difficulty: weakSelf.difficulty, attempted: false){
                weakSelf.currentQuestion = question
                print("questionID \(question.questionID!) difficulty \(question.difficulty!) questioContnet \(question.content!) questionTYpe \(question.questionTypeID)")
                // load table
                let content = question.content!
                //TODO: questions load from here
                weakSelf.labelQuestion.text = content
                
                // TODO: change the value to true
                guard let answers = question.answers else {return}
                if answers.count < 1{
                    return
                }
                // Change QuestionView
                let predicate = NSPredicate(format: "isCorrect == %@", NSNumber(booleanLiteral: true))
                let correctAnswer = question.answers!.filtered(using: predicate).first!
                var wrongAnswers = Array(question.answers!.filtered(using: NSPredicate(format: "isCorrect == %@", NSNumber(booleanLiteral: false))))
                
                var answesrList = [correctAnswer]
                let firstChoice = wrongAnswers.count.randomGenerator()
                answesrList.append(wrongAnswers[firstChoice])
                wrongAnswers.remove(at: firstChoice)
                if wrongAnswers.count > 0{
                    answesrList.append(wrongAnswers[wrongAnswers.count.randomGenerator()])
                }
                // Random the answer array
                let randomNumbers = answesrList.count.randomSequences()
                print(randomNumbers)
                weakSelf.choices = [Answer]()
                for i in randomNumbers{
                    weakSelf.choices!.append(answesrList[i] as! Answer)
                }
                for (index,answer) in weakSelf.choices!.enumerated(){
                    //TODO: Answers loads from here
                    if let button = weakSelf.view.viewWithTag(index+200) as? UIButton{
                        button.isHidden = false
                        button.setTitle(answer.answerContent, for: .normal)
                        button.setTitle(answer.answerContent, for: .highlighted)
                    }
                    
                }
                
                weakSelf.changeQuestionView(questionID: Int(question.questionTypeID!)!, content: content, image: "")
                
                weakSelf.startQuestionTimeImages()
                
                weakSelf.imageTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self](timer) in
                    self?.startQuestionTimeImages()
                })
                
            }else{
                // load the data from webservice
                weakSelf.pageNo = weakSelf.pageNo + 1
                weakSelf.getQuestions(weakSelf.pageNo)
            }
            
        }
        
    }
    func changeQuestionView(questionID: Int, content: String?, image: String?) {
        switch questionID {
        case 1, 2:
            viewTextfieldAndTextview.isHidden = false
            viewImageAndQuestion.isHidden = true
            textView.text = content
            if questionID == 2{
                setTextfieldConstraint()
            }
            
            
        case 3,4:
            viewTextfieldAndTextview.isHidden = true
            viewImageAndQuestion.isHidden = false
            labelQuestion.text = content
            if questionID == 4 {
                setImageConstraints()
            }
            
        default:
            break
            
        }
    }
    func setImageConstraints() {
        constraintImageTop.constant = 0
        constraintImageWidth.constant = viewImageAndQuestion.frame.size.height / 1.1
        labelQuestion.text = ""
        self.viewImageAndQuestion.layoutIfNeeded()
    }
    func setTextfieldConstraint() {
        constraintTextfieldTop.constant = 0
        constraintTextfieldHeight.constant = 0
        self.viewTextfieldAndTextview.layoutIfNeeded()
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        let _ = self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Button Action
    private func updateCorrect(button: UIButton)  {
        button.isHidden = false
        button.setTitle("CORRECT!", for: .normal)
        button.setTitle("CORRECT!", for: .highlighted)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.green, for: .normal)
        button.setTitleColor(UIColor.green, for: .highlighted)
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 0.2
        
    }
    
    private func updateIncorrect(button: UIButton)  {
        button.setTitle("INCORRECT!", for: .normal)
        button.setTitle("INCORRECT!", for: .highlighted)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 5.0
        button.layer.borderWidth = 0.2
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
    }
    
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - startTime: <#startTime description#>
    ///   - endTime: <#endTime description#>
    ///   - subjectID: <#subjectID description#>
    /// - Returns: <#return value description#>
    
    
    private func calculateScore(startTime: TimeInterval, endTime: TimeInterval, subjectID: Int) -> Double {
        
        let difference = endTime - startTime

        // If Subject is English
        
        if  subjectID == 6 {
            
            switch difference {
            case 0...5 :
                return 1000
            case 5.01...10:
                return  (900 + (10 - difference) * 20)
            case 10.01...15:
                return (800 + (15 - difference) * 20)
            case 15.01...20:
                return (700 + (20 - difference) * 20)
            case 20.01...25:
                return (600 + (25 - difference) * 20)
            case 25.01...500:
                return 500
            default:
                return 0
            }
            
        } else  if subjectID == 7 || subjectID == 8 || subjectID == 9 {
            
            switch difference {
            case 0...30 :
                return 1000
            case 30.01...40:
                return  (900 + (10 - difference) * 20)
            case 40.01...45:
                return (800 + (15 - difference) * 20)
            case 45.01...50:
                return (700 + (20 - difference) * 20)
            case 50.01...55:
                return (600 + (25 - difference) * 20)
            case 55.01...500:
                return 500
            default:
                return 0
            }
        }
        return 0
    }
    
    @IBAction func buttonActionSender(sender: UIButton) {
        var correctChoice = 200
        for (index, answer) in self.choices!.enumerated(){
            if answer.isCorrect{
                correctChoice = correctChoice + index
            }
        }

        let endTime = Date().timeIntervalSince1970
        if sender.tag == correctChoice {
            
            // TODO: Changed Subject ID
            
            self.currentScore = self.currentScore + self.calculateScore(startTime: self.startTime, endTime: endTime, subjectID: selectedmodel.SubjectID!)
            self.updateCorrect(button: sender)
            self.currentStreak = self.currentStreak + 1
            if self.currentStreak >= Utility.getStreak(){
                Utility.set(streak: self.currentStreak)
            }
            self.rightAnswerCount = self.rightAnswerCount + 1
            UserDefaults.standard.set(self.rightAnswerCount, forKey: "GlobalRightAnswerCount")
            
        }else{
            self.wrongAnswerCount = self.wrongAnswerCount + 1
            UserDefaults.standard.set(self.wrongAnswerCount, forKey: "GlobalWrongAnswerCount")
            self.lives = self.lives - 1
            self.updateIncorrect(button: sender)
            if let button = self.view.viewWithTag(correctChoice) as? UIButton{
                self.updateCorrect(button: button)
            }
            
            if self.lives >= 0{
                self.textFieldLives.text = "\(self.lives)"
            }
        }
        self.currentQuestion?.attempted = true
        self.currentQuestion?.attemptedDate = Date()
        self.currentQuestion?.attemptedAnswer = self.choices![sender.tag-200].answerID
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
        if self.lives == 0 {
            self.displayNoMoreLives()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] _ in
            self?.displayNextQuestion()
        }
        
    }
    
    
    private func updateDataOnServer(completionHandler: @escaping () -> Void)  {
        self.showHud()
        
        var trimmedString = mainpUrl + "Answer/SaveQuestionAnswer"
        trimmedString = trimmedString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        let urlPath = URL(string:trimmedString)
        var request = URLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.populateAuthorizationHeader()
        
        do {
            var questionArray = [[String: Any]]()
            if let questions = Question.getAttemptedQuestions(subjectID: "\(self.selectedmodel.SubjectID!)"){
                for question in questions {
                    questionArray.append(["QuestionID" : question.questionID! , "AnswerID" : question.attemptedAnswer!, "UserID" :  UserDefaults.standard.value(forKey: "UserID") ?? "1", "AttemptDate" : question.attemptedDate!.description, "Streak" : "\(self.currentStreak)"])
        
                }
                
                let globalRightAnswerCount = UserDefaults.standard.integer(forKey: "GlobalRightAnswerCount")
                let globalWrongAnswerCount = UserDefaults.standard.integer(forKey: "GlobalWrongAnswerCount")
                let table2 = ["UserID" : UserDefaults.standard.value(forKey: "UserID") ?? "1", "SubObjectiveID" : questions.first?.subObjectiveID ?? "18", "RightsCount" : self.rightAnswerCount, "WrongCount": self.wrongAnswerCount, "SubObjectiveScoreDate" : "\(self.currentScore)", "RightsGlobalCount" : "\(globalRightAnswerCount)", "WrongGlobalCount" : "\(globalWrongAnswerCount)"]
                
                let payload = ["Table1" : questionArray, "Table2" : table2] as [String : Any]
                print(payload)
                
                request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            }
            
            Alamofire.request(request).responseString { [weak self](response) in
                
                print("response \(response)")
                
                DispatchQueue.main.async {
                    guard let weakSelf = self else { return }
                    weakSelf.hideHUD()
                    completionHandler()
                }
            }
            
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func displayNoMoreLives()  {
        self.clanUp()
        
        self.updateDataOnServer {
            // Send the data to server
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
                appDelegate.window?.makeToast("No More lives")
                DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                    appDelegate.tabBarView()
                })
            }
        }
    }
    
    func displayNextQuestion()  {
        
        self.clanUp()
        if let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CNBTQuestionViewController") as? CNBTQuestionViewController{
            viewController.selectedmodel = self.selectedmodel
            viewController.difficulty = self.difficulty
            viewController.pageNo = self.pageNo
            viewController.lives = self.lives
            viewController.currentStreak = self.currentStreak
            viewController.currentScore = self.currentScore
            viewController.wrongAnswerCount = self.wrongAnswerCount
            viewController.rightAnswerCount = self.rightAnswerCount
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true) {
            }
        }
    }
    
    func clanUp()  {
        self.imageTimer?.invalidate()
    }
    
}

extension UIView {
    
    func addShadow() {
        self.layer.cornerRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0
        self.layer.masksToBounds =  false
    }
    
}
