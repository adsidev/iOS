//
//  Answer+CoreDataProperties.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 26/02/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation
import CoreData


extension Answer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer");
    }

    @NSManaged public var answerID: String?
    @NSManaged public var answerContent: String?
    @NSManaged public var explanation: String?
    @NSManaged public var isCorrect: Bool
    
    
    class func getAnswerTemplate(_ data: [String: Any]) -> Answer?{
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: appDelegate.managedObjectContext)
        for (key, value) in data{
            entity.setValue(value, forKey: key)
        }

        return entity as? Answer
    }

}


