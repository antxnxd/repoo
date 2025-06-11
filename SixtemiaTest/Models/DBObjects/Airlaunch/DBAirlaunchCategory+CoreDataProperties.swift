//
//  DBAirlaunchCategory+CoreDataProperties.swift
//  
//
//  Created by Kevin Costa on 11/02/2020.
//
//

import Foundation
import CoreData


extension DBAirlaunchCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBAirlaunchCategory> {
        return NSFetchRequest<DBAirlaunchCategory>(entityName: "DBAirlaunchCategory")
    }

    @NSManaged public var idCategory: Int64
    @NSManaged public var strTitle: String?
    @NSManaged public var isActive: Bool

}
