//
//  CloudKitHelper.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 1/25/21.
//  Copyright © 2021 O'Ryan Hampton. All rights reserved.
//

import Foundation
import SwiftUI
import CloudKit

struct CloudKitHelper {
    
    struct RecordType {
        static let Items = "Items"
    }
    
    enum CloudKitHelperError: Error {
        case recordFailure
        case recordIDFailure
        case castFailure
        case cursorFailure
    }
    
    // MARK: saving to CloudKit
    static func save(item: ListElement, completion: @escaping (Result<ListElement, Error>) -> ()){
//        let itemRecord = CKRecord(recordType: RecordType.Items)
//        itemRecord["text"] = item.text as CKRecordValue
//        
//        CKContainer.default().publicCloudDatabase.save(itemRecord) { (record, err) in
//            if let err = err {
//                completion(.failure(err))
//                return
//            }
//            guard let record = record else {
//                completion(.failure(CloudKitHelperError.recordFailure))
//                return
//            }
//            let id = record.recordID.self
//            guard let text = record["text"] as? String else {
//                completion(.failure(CloudKitHelperError.castFailure))
//                return
//            }
//            let element = ListElement(recordID: id, text: text)
//            completion(.success(element))
//        }
    }
}
