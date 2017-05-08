//
//  SaveAndLoadModel.swift
//  BDing
//
//  Created by MILAD on 3/13/17.
//  Copyright © 2017 MILAD. All rights reserved.
//

import Foundation

import CoreData

import UIKit

class SaveAndLoadModel {
    
    
    func save(entityName: String , datas : [String : Any?]){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1
        if #available(iOS 10.0, *) {
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            
            // 2
            let entity =
                NSEntityDescription.entity(forEntityName: entityName,
                                           in: managedContext)!
            
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            
            
            // 3
            for row in datas {
                person.setValue(row.value, forKeyPath: row.key)
            }
            
            // 4
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    //---------------------------------------------------------------------------------------//
    
    func load(entity : String) -> [NSManagedObject]? {
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        if #available(iOS 10.0, *) {
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            //2
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: entity)
            
            //3
            do {
                let rows = try managedContext.fetch(fetchRequest) as [NSManagedObject]
                return rows
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return nil
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        return nil
        
    }
    
    //---------------------------------------------------------------------------------------//
    
    func deleteAllObjectIn(entityName : String){
        
        let moc = getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        let result = try? moc?.fetch(fetchRequest)
        
        for object in result!! {
            
            moc?.delete(object as! NSManagedObject)
            
        }
        
        do {
            try moc?.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }
    
    func deleteSpecificItemIn(entityName : String , keyAttribute : String , item : String){
        
        let moc = getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        var s : String = keyAttribute
        
        s.append(" == %@")
        
        fetchRequest.predicate = NSPredicate(format: s, item)
        
        let result = try? moc?.fetch(fetchRequest)
        
        if((result??.count)! > 0){
         
            for object in result!! {
                
                moc?.delete(object as! NSManagedObject)
                
            }
            
        }
        
        do {
            try moc?.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    func updateSpecificItemIn(entityName : String , keyAttribute : String , item : String , newItem : [String : Any?]){
        
        let moc = getContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        var s : String = keyAttribute
        
        s.append(" == %@")
        
        fetchRequest.predicate = NSPredicate(format: s, item)
        
        let result = try? moc?.fetch(fetchRequest) as? [NSManagedObject]
        
        if((result??.count)! > 0){
     
            result??[0].setValuesForKeys(newItem)
            
        }
        
        do {
            try moc?.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    
    
    
    func getContext () -> NSManagedObjectContext? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            return appDelegate.persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
           
        }
        return nil
    }
    
    
    
}




















