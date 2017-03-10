//
//  CNBTParseModel.swift
//  Limitless
//
//  Created by Jayprakash Kumar on 1/6/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import UIKit

class CNBTParseModel: NSObject {

    var SubjectID : Int?
    var SubjectName : String?
    var SubjectDescription : String?
    var SubjectICON : String?
    var OrganizationName : String?
    var IsActive : String?
    var CreatedDate : String?
    

}
class CNBTANSParseModel: NSObject {
    
    var AnswerID : Int?
    var QuestionID : Int?
    var AnswerCode : String?
    var AnswerContent : String?
    var IsCorrect : Bool?
    var Explanation : String?
    var IsActive : String?
    var CreatedDate : String?
    
}

