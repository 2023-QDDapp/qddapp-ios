//
//  DataExtension.swift
//  qddapp
//
//  Created by gabatx on 2/6/23.
//

import Foundation

extension Data {
    func toBase64() -> String {
        "data:image/jpeg;base64,\(base64EncodedString())"
    }
}
