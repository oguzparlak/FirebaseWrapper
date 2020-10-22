//
//  FirebaseDatabaseManager.swift
//  QuizApp
//
//  Created by oguzparlak on 27.02.2020.
//  Copyright © 2020 Oguz Parlak. All rights reserved.
//

import Foundation
import FirebaseDatabase

// TODO: - Add query support

class FirebaseDatabaseManager {
    
    // MARK: - Singleton Instance
    
    static let shared = FirebaseDatabaseManager()
    
    // MARK: - Instance Variables
    
    private let databaseReference: DatabaseReference

    // MARK: - Init
    
    private init() {
        databaseReference = Database.database().reference()
    }
    
    // MARK: - CRUD Operations
    
    func readOnce<T: Codable>(from endpoint: FirebaseDatabaseEndpoint,
                              completion: @escaping (T?) -> Void,
                              onError: ((Error) -> Void)? = nil) {
        let query = databaseReference.child(endpoint.path)
        query.keepSynced(endpoint.synced)
        
        query.observeSingleEvent(of: .value,
                                 with: { snapshot in
            var decodedValue: T?
            if let value = snapshot.value as? NSDictionary {
                decodedValue = value.decodeAsArray(T.self)
                if decodedValue == nil {
                    decodedValue = value.decode(T.self)
                }
            }
            if let value = snapshot.value as? NSArray {
                decodedValue = value.decode(T.self)
            }
            if decodedValue == nil {
                onError?(FirebaseError.decodingError)
                return
            }
            completion(decodedValue)
        }) { error in
            onError?(error)
        }
    }
    
    func post<T: Codable>(from endpoint: FirebaseDatabaseEndpoint,
                          data: T,
                          createNewKey: Bool = false,
                          completion: ((Result<T, Error>) -> Void)? = nil) {
        var encodedData: Any?
        if let value = data.dictionary {
            encodedData = value
        }
        if let value = data.array {
            encodedData = value
        }
        if encodedData == nil {
            completion?(.failure(FirebaseError.encodingError))
            return
        }
        var reference: DatabaseReference = databaseReference.child(endpoint.path)
        if createNewKey { reference = reference.childByAutoId() }
        reference.setValue(encodedData) { (error, _) in
            if let error = error { completion?(.failure(error)) }
            completion?(.success(data))
        }
    }
    
    func remove(from endpoint: FirebaseDatabaseEndpoint,
                completion: (() -> Void)?,
                onError: ((Error) -> Void)?) {
        databaseReference.child(endpoint.path).removeValue { (error, reference) in
            if let error = error {
                onError?(error)
                return
            }
            completion?()
        }
    }
    
}
