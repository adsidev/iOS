//
//  Score+CoreDataProperties.swift
//  Limitless
//
//  Created by Sunilkumar Gavara on 26/02/17.
//  Copyright © 2017 CNBT. All rights reserved.
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score");
    }

    @NSManaged public var questionID: String?
    @NSManaged public var answeID: String?
    @NSManaged public var subjectID: String?
    @NSManaged public var currentTime: NSDate?
    @NSManaged public var validAnswer: Bool

}
