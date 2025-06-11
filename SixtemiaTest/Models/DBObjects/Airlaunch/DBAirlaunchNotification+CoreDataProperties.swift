//
//  DBAirlaunchNotification+CoreDataProperties.swift
//  
//
//  Created by Kevin Costa on 11/02/2020.
//
//

import Foundation
import CoreData


extension DBAirlaunchNotification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBAirlaunchNotification> {
        return NSFetchRequest<DBAirlaunchNotification>(entityName: "DBAirlaunchNotification")
    }

    @NSManaged public var nid: String?
    @NSManaged public var strCode: String?
    @NSManaged public var strDate: String?
    @NSManaged public var strDesc: String?
    @NSManaged public var strTitle: String?
    @NSManaged public var strUrlImg: String?
    @NSManaged public var strValue: String?

}
