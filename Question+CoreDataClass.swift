//
//  Question+CoreDataClass.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 26/02/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation
import CoreData

@objc(Question)
public class Question: NSManagedObject {
    
}

extension Question{
    
    
    /// <#Description#>
    ///
    /// - Parameter data: <#data description#>
    class func save(_ data: [String: Any]){
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Question", into: appDelegate.managedObjectContext)
        for (key, value) in data{
            entity.setValue(value, forKey: key)
        }
        appDelegate.saveContext()
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter questionID: <#questionID description#>
    /// - Returns: <#return value description#>
    class func getBy(questionID: String, subjectID: String) -> Question? {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        fetchRequest.predicate = NSPredicate(format: "questionID == %@ AND subjectID == %@", questionID, subjectID)
        let results = try? appDelegate.managedObjectContext.fetch(fetchRequest)
        return results?.first as! Question?
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter subjectID: <#subjectID description#>
    class func deleteBy(subjectID: String)  {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        fetchRequest.predicate = NSPredicate(format: "subjectID == %@ ", subjectID)
        let results = try? appDelegate.managedObjectContext.fetch(fetchRequest)
        for result in (results ?? [Any]()){
            appDelegate.managedObjectContext.delete(result as! NSManagedObject)
        }
        appDelegate.saveContext()
        
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - subjectID: <#subjectID description#>
    ///   - difficulty: <#difficulty description#>
    ///   - attempted: <#attempted description#>
    /// - Returns: <#return value description#>
    class func getNextQuestion(subjectID: String, difficulty: String, attempted: Bool, asc: Bool = true) -> Question? {
        
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        fetchRequest.predicate = NSPredicate(format: "subjectID == %@ AND attempted == %@ AND difficulty == %@", subjectID, NSNumber(booleanLiteral: attempted), difficulty)
        
        if let results = try? appDelegate.managedObjectContext.fetch(fetchRequest){
            if results.count > 0{
                return results[results.count.randomGenerator()] as? Question
            }else{
                if asc {
                    
                    let value = Int(difficulty)!+1
                    if value > 3 {
                        return nil
                    }else{
                        return getNextQuestion(subjectID: subjectID, difficulty: "\(value)", attempted: attempted)
                    }
                }else{
                    let value = Int(difficulty)!-1
                    if value > 0 {
                        return getNextQuestion(subjectID: subjectID, difficulty: "\(value)", attempted: attempted, asc: asc)
                    }else{
                        return nil
                    }
                }
            }
        }
        return nil
    }
    

    
    /// <#Description#>
    ///
    /// - Parameter subjectID: <#subjectID description#>
    /// - Returns: <#return value description#>
    class func getAttemptedQuestions(subjectID: String) -> [Question]? {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Question")
        fetchRequest.predicate = NSPredicate(format: "subjectID == %@ AND attempted == %@", subjectID, NSNumber(booleanLiteral: true))
        let results = try? appDelegate.managedObjectContext.fetch(fetchRequest)
        return results as! [Question]?
    }
    
}

extension Int{
    func randomGenerator() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
    
    func randomSequences() -> [Int] {
        var sequencer = [Int]()
        for _ in 0..<self {
            while(true){
                let indexV = self.randomGenerator()
                let vlues = sequencer.filter({ (ele) -> Bool in
                    return ele == indexV
                })
                
                if vlues.isEmpty{
                    sequencer.append(indexV)
                    break
                }
                
            }
        }
        return sequencer
        
    }
}
