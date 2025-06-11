//
//  DBAirlaunchNotification+CoreDataClass.swift
//  
//
//  Created by Kevin Costa on 11/02/2020.
//
//

import Foundation
import CoreData
import UIKit

@objc(DBAirlaunchNotification)
public class DBAirlaunchNotification: NSManagedObject {
	
	private static let DBONAME = "DBAirlaunchNotification"
	typealias DBO = DBAirlaunchNotification
	typealias OB = AirlaunchNotification
	
	//-----------------------
	// MARK: - Object Live
	//-----------------------
	
	override public func awakeFromInsert() {
		super.awakeFromInsert()
		setPrimitiveValue("", forKey: "nid")
		setPrimitiveValue("", forKey: "strTitle")
		setPrimitiveValue("", forKey: "strDesc")
		setPrimitiveValue("", forKey: "strDate")
		setPrimitiveValue("", forKey: "strCode")
		setPrimitiveValue("", forKey: "strValue")
		setPrimitiveValue("", forKey: "strUrlImg")
	}
	
	class func setAllValues(_ dbobj: DBO, fromObject obj: OB) {
        dbobj.setValue(obj.nid, forKey: "nid")
        dbobj.setValue(obj.strTitle, forKey: "strTitle")
        dbobj.setValue(obj.strDesc, forKey: "strDesc")
        dbobj.setValue(obj.strDate, forKey: "strDate")
        dbobj.setValue(obj.strCode, forKey: "strCode")
        dbobj.setValue(obj.strValue, forKey: "strValue")
        dbobj.setValue(obj.strUrlImg, forKey: "strUrlImg")
    }
    
    func asObject() -> OB {
        var obj: OB = OB()
        
        obj.nid = self.nid
        obj.strTitle = self.strTitle
        obj.strDesc = self.strDesc
        obj.strDate = self.strDate
        obj.strCode = self.strCode
        obj.strValue = self.strValue
        obj.strUrlImg = self.strUrlImg
        
        return obj
    }
	
	//-----------------------
    // MARK: - Create
    //-----------------------
    
    class func create(_ objs:  [OB]) {
        
        //Creem o actualitzem els objectes que rebem de servidor
        createOrUpdateWithObjects(objs)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    class func createOrUpdateWithObjects(_ objs: [OB]) {
        for obj in objs {
            createOrUpdateWithObject(obj)
        }
    }
    
    @discardableResult
    class func createOrUpdateWithObject(_ obj: OB) -> DBO? {
        var dbObj = getDBObjectWithNid(obj.nid ?? "")
        
        if dbObj == nil {
            dbObj = NSEntityDescription.insertNewObject(forEntityName: DBONAME, into: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) as? DBO
        }
        
        // Set properties
        setAllValues(dbObj!, fromObject:obj)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        return dbObj
    }
	
	//-----------------------
    // MARK: - Get
    //-----------------------
    
    class func getAll() -> [DBO] {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: DBONAME)
        
        do {
            let fetchedProductes = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest) as! [DBO]
            let arrayToReturn = fetchedProductes.sorted { $0.strDate ?? "" > $1.strDate ?? ""}
            
            if let dbFetched = arrayToReturn.first {
                if let strDate = dbFetched.strDate{
                    UserDefaults.standard.set(strDate, forKey: K_DATE)
                }
            }
            
            return arrayToReturn
            
        } catch {
			print("\(DBONAME).getAll - ERROR")
        }
        
        return [DBO]()
    }
    
    class func getAllAsObjs() -> [OB] {
        var arrayObjs = [OB]()
        let arrayDBObjs = getAll()
        
        for dbObj in arrayDBObjs {
            arrayObjs.append(dbObj.asObject())
        }
        
        return arrayObjs
    }
    
    class func getDBObjectWithNid(_ nid: String) -> DBO? {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: DBONAME)
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "nid == %@", nid)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest) as! [DBO]
            
            if fetchedEntities.count != 0 {
                return fetchedEntities.first!
            }
        }
        catch {
			print("\(DBONAME).getDBObjectWithId - ERROR")
            return nil
        }
        
        return nil
    }
	
	//-----------------------
    // MARK: - Delete
    //-----------------------
    
    class func deleteObjWithId(_ nid: String) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: DBONAME)
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "nid == %@", nid)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest) as! [DBO]
            
            for dbFetchedEntity in fetchedEntities {
                (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.delete(dbFetchedEntity)
            }
        }
        catch {
			print("\(DBONAME).deleteAll - ERROR")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    class func deleteAll() {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: DBONAME)
        
        do {
            let fetchedEntities = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest) as! [DBO]
            
            for dbFetchedEntity in fetchedEntities {
                (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.delete(dbFetchedEntity)
            }
        }
        catch {
			print("\(DBONAME).deleteAll - ERROR")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
	
}
