//
//  AppDelegate.swift
//  Todoey
//
//  Created by Dennis M on 2019-05-03.
//  Copyright © 2019 Dennis M. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

//        do {
//            let realm = try Realm()
//        } catch {
//            print("Error initialising new Realm, \(error)")
//        }
        
        return true
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // lazy – only gets loaded up with a value at the time point when is't needed; memory benefit; occupy when needed
    // NSPersistentContainer - SQL like database
    // use persistentContainer to manipulate data
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    //
    func saveContext () {
        // context is a staging (temporary) area where you can update, change or delete your data
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                // once we are ready – save to a permanent storages
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

