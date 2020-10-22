//
//  FirebaseDatabaseEndpoint.swift
//  QuizApp
//
//  Created by oguzparlak on 27.02.2020.
//  Copyright © 2020 Oguz Parlak. All rights reserved.
//

import Foundation

protocol FirebaseDatabaseEndpoint {
    
    var path: String { get }
    var synced: Bool { get }
    
}

extension FirebaseDatabaseEndpoint {
    
    func retrieve<T: Codable>(completion: @escaping (T?) -> Void,
                              onError: ((Error) -> Void)? = nil) {
        FirebaseDatabaseManager.shared.readOnce(from: self,
                                                completion: completion,
                                                onError: onError)
    }
    
    func post<T: Codable>(data: T,
                          createNewKey: Bool = false,
                          completion: ((Result<T, Error>) -> Void)? = nil) {
        FirebaseDatabaseManager.shared.post(from: self,
                                            data: data,
                                            createNewKey: createNewKey,
                                            completion: completion)
    }
    
    func remove(completion: (() -> Void)?, onError: ((Error) -> Void)?) {
        FirebaseDatabaseManager.shared.remove(from: self, completion: completion, onError: onError)
    }
    
}
