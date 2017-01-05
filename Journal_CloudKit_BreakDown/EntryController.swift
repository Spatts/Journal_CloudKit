//
//  EntryController.swift
//  Journal_CloudKit_BreakDown
//
//  Created by Diego Aguirre on 8/7/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation

let EntryControllerDidRefreshNotification = "MessagesControllerDidRefreshNotification"

class EntryController {
    
    private let cloudKitManager = CloudKitManager()
    
    static let sharedController = EntryController()
    
    private (set) var entries = [Entry]() {
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(EntryControllerDidRefreshNotification, object: self)
                
            })
        }
    }
    
    init() {
        fetchEntrys { (error) in
            if let error = error {
                print("Error fetching Entries on startup: \(error.localizedDescription)")
            }
      //  self.entries = []
        }
    }
        
    func addEntry(entry: Entry) {
        cloudKitManager.saveRecord(entry.cloudKitRecord) { (error) in
            if error == nil {
                self.entries.append(entry)
            }
        }

    }
    
    func fetchEntrys(completion: (NSError?) -> Void) {
        cloudKitManager.fetchRecordsWithType(Entry.RecordType) { (records, error) in
            defer { completion(error) }
            
            if let error = error {
                print("Error fetching Entries: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {return}
            self.entries = records.flatMap({Entry(cloudKitRecord: $0)})
        }
    }
}