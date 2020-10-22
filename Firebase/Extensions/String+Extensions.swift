//
//  String+Extensions.swift
//  Codabase
//
//  Created by Oğuz Parlak on 11.10.2020.
//

import Foundation

extension Swift.Optional where Wrapped == String {
    
    var orEmptyString: String {
        if let unwrappedString = self {
            return unwrappedString
        }
        return ""
    }
    
}
