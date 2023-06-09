//
//  Helper.swift
//  qddapp
//
//  Created by gabatx on 16/4/23.
//

import UIKit

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            print("No se pudo encontrar \(file) en el paquete.")
            return nil
        }

        guard let data = try? Data(contentsOf: url) else {
            print("No se pudo cargar \(file) desde el paquete.")
            return nil
        }

        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("No se pudo decodificar \(file) desde el paquete: \(error.localizedDescription)")
            return nil
        }
    }
}
