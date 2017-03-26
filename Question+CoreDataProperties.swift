//
//  Question+CoreDataProperties.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 26/02/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question");
    }

    @NSManaged public var attempted: Bool
    @NSManaged public var content: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var questionID: String?
    @NSManaged public var questionTypeID: String?
    @NSManaged public var subjectID: String?
    @NSManaged public var subObjectiveID: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var attemptedAnswer: String?
    @NSManaged public var answers: NSSet?
    @NSManaged public var attemptedDate: Date?
    @NSManaged public var finalQuestionContent: String?
    @NSManaged public var isDraggable: String?

}

// MARK: Generated accessors for answers
extension Question {

    @objc(addAnswersObject:)
    @NSManaged public func addToAnswers(_ value: Answer)

    @objc(removeAnswersObject:)
    @NSManaged public func removeFromAnswers(_ value: Answer)

    @objc(addAnswers:)
    @NSManaged public func addToAnswers(_ values: NSSet)

    @objc(removeAnswers:)
    @NSManaged public func removeFromAnswers(_ values: NSSet)

}
