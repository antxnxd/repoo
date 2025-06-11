//
//  DBAirlaunchCategory+CoreDataClass.swift
//  
//
//  Created by Kevin Costa on 11/02/2020.
//
//

import Foundation
import CoreData
import UIKit

@objc(DBAirlaunchCategory)
public class DBAirlaunchCategory: NSManagedObject {
	
	private static let DBONAME = "DBAirlaunchCategory"
	typealias DBO = DBAirlaunchCategory
	typealias OB = AirlaunchCategory
	
	//-----------------------
	// MARK: - Object Live
	//-----------------------
	
	override public func awakeFromInsert() {
		super.awakeFromInsert()
		setPrimitiveValue(-1, forKey: "idCategory")
		setPrimitiveValue("", forKey: "strTitle")
		setPrimitiveValue(true, forKey: "isActive")
		
	}
	
	class func setAllValues(_ dbobj: DBO, fromObject obj: OB) {
		dbobj.setValue(obj.idCategory, forKey: "idCategory")
		dbobj.setValue(obj.strTitle, forKey: "strTitle")
	}
	
	func asObject() -> OB {
		var obj: OB = OB()
		
		obj.idCategory = self.idCategory
		obj.strTitle = self.strTitle
		obj.isActive = self.isActive
		
		return obj
	}
	
	//-----------------------
	// MARK: - Create
	//-----------------------
	
	class func create(_ objs:  [OB]) {
		
		//Eliminem aquells que ja no arriben de servidor
		deleteRemoved(objs)
		
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
        var dbObj = getDBObjectWithId(obj.idCategory ?? -1)
        
        if dbObj == nil {
            dbObj = NSEntityDescription.insertNewObject(forEntityName: DBONAME, into: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) as? DBO
            dbObj?.setValue(true, forKey: "isActive")
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
			let arrayToReturn = fetchedProductes.sorted { $0.strTitle ?? "" > $1.strTitle ?? ""}
			
			
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
    
    class func getDBObjectWithId(_ idCategory: Int64) -> DBO? {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: DBONAME)
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "idCategory == %d", idCategory)
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
    
    class func setActiveWithId(_ idCategory: Int64, active: Bool) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: DBONAME)
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "idCategory == %d", idCategory)
        fetchRequest.predicate = predicate
        
        do {
            let fetchedEntities = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(fetchRequest) as! [DBO]
            
            if fetchedEntities.count != 0 {
                
                fetchedEntities.first!.setValue(active, forKey: "isActive")
            }
        }
        catch {
            print("\(DBONAME).getDBObjectWithId - ERROR")
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
	
	//-----------------------
	// MARK: - Delete
	//-----------------------
	
	class func deleteRemoved(_ objs:  [OB]){
		let arrayDBObjects = getAll()
		
		for dbObj in arrayDBObjects {
			if !objs.contains(where: { $0.idCategory == dbObj.idCategory }) {
				(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.delete(dbObj)
			}
		}
	}
	
	class func deleteObjWithId(_ idCategory: Int64) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: DBONAME)
        fetchRequest.fetchLimit = 1
        
        let predicate = NSPredicate(format: "idCategory == %d", idCategory)
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
