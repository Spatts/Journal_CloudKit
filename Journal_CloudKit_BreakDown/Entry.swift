//
//  Entry.swift
//  Journal_CloudKit_BreakDown
//
//  Created by Diego Aguirre on 8/7/16.
//  Copyright © 2016 home. All rights reserved.
//

import Foundation
import CloudKit

struct Entry {
    
    var title: String
    var body: String
}

extension Entry {
    static var RecordType: String { return "Entry" }
    static var kTitle: String {return "Title"}
    static var kBody: String {return "Body"}
    
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: Entry.RecordType)
        record.setValue(title, forKey: Entry.kTitle)
        record.setValue(body, forKey: Entry.kBody)
        
        return record
    }
    
    
    
    init?(cloudKitRecord: CKRecord) {
        guard let title = cloudKitRecord[Entry.kTitle] as? String,
            body = cloudKitRecord[Entry.kBody] as? String
            where cloudKitRecord.recordType == Entry.RecordType else
        {
            return nil
        }
        
        self.init(title: title, body: body)
    }

}