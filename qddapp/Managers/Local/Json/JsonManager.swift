//
//  JsonManager.swift
//  qddapp
//
//  Created by gabatx on 23/4/23.
//

import Foundation

class JsonManager {

    func get<T: Codable>(json: String) -> T? {
        
        var jsonData: Data?

        if let path = Bundle.main.path(forResource: json, ofType: "json") {
            do {
                jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()

                do {
                    let users = try decoder.decode(T.self, from: jsonData!)
                    return  users

                } catch {
                    print("Error al decodificar el archivo JSON: \(error)")
                }
            } catch {
                print("Error al cargar el archivo JSON: \(error)")
            }
        }
        return nil
    }
}
