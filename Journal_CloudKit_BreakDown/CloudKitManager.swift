//
//  CloudKitManager.swift
//  Journal_CloudKit_BreakDown
//
//  Created by Steven Patterson on 8/8/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class CloudKitManager {
    
    let database = CKContainer.defaultContainer().publicCloudDatabase
    
    func saveRecord(record: CKRecord, completion: ((NSError?) -> Void) = { _ in }) {
        
        database.saveRecord(record) { (_, error) in
            completion(error)
        }
    }
    
    func fetchRecordsWithType(type: String, sortDescriptors: [NSSortDescriptor]? = nil, completion: ([CKRecord]?, NSError?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: type, predicate: predicate)
        query.sortDescriptors = sortDescriptors
        
        database.performQuery(query, inZoneWithID: nil, completionHandler: completion)
    }
    
    func subscribeToCreationOfRecordsWithType(type: String, completion: ((NSError?)-> Void)? = nil) {
        let subscription = CKSubscription(recordType: type, predicate: NSPredicate(value: true), options: .FiresOnRecordCreation)
        
        let notificationInfo = CKNotificationInfo()
        notificationInfo.alertBody = "You have a Message"
        notificationInfo.soundName = UILocalNotificationDefaultSoundName
        
        subscription.notificationInfo = notificationInfo
        database.saveSubscription(subscription) { (subscription, error) in
            if let error = error {
                print("Error saving subscription: \(error.localizedDescription)")
            }
            completion?(error)
        }
    }
}