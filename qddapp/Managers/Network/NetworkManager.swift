//
//  NetworkManager.swift
//  qddapp
//
//  Created by gabatx on 17/4/23.
//

import Foundation

class NetworkManager {

    private let urlBase: String

    init(urlBase: String) {
        self.urlBase = urlBase
    }

    func get<T: Codable>(endPoint: String) async throws -> T {
        let url = URL(string: "\(urlBase)\(endPoint)")!

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print(String(data: data, encoding: .utf8) ?? "No hay nada")
                throw NSError(domain: "https://test3.qastusoft.com.es", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error de respuesta HTTP"])
            }

            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                return decodedData
            } else {
                return try JSONDecoder().decode([T].self, from: data) as! T
            }

        } catch {
            throw error
        }
    }

    func get<T: Codable>(endPoint: String, token: String) async throws -> T {
        let url = URL(string: "\(urlBase)\(endPoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Agrega el token al encabezado de la solicitud
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "https://test3.qastusoft.com.es", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error de respuesta HTTP"])
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorMessageModel.self, from: data)
            let errorMessage = errorResponse?.error ?? "Respuesta de error HTTP"
            let error = NSError(domain: "https://test3.qastusoft.com.es", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            throw error
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }


    func getImage(url: String) async -> Data {
        let url = URL(string: url)!
        let (data, _) = try! await URLSession.shared.data(from: url)
        return data
    }

    func post<T: Codable, Body: Encodable>(endPoint: String, body: Body) async throws -> T {
        let url = URL(string: "\(urlBase)\(endPoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Codifica los datos del cuerpo de la solicitud
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData

        // Establece el encabezado "Content-Type"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "https://test3.qastusoft.com.es", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error de respuesta HTTP"])
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorMessageModel.self, from: data)
            let errorMessage = errorResponse?.error ?? "Respuesta de error HTTP"
            let error = NSError(domain: "https://test3.qastusoft.com.es", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            throw error
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    func post<T: Codable, Body: Encodable>(endPoint: String, body: Body, token: String) async throws -> T {
        let url = URL(string: "\(urlBase)\(endPoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Codifica los datos del cuerpo de la solicitud
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData

        // Establece el encabezado "Content-Type"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Agrega el token al encabezado de la solicitud
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "https://test3.qastusoft.com.es", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error de respuesta HTTP"])
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorMessageModel.self, from: data)
            let errorMessage = errorResponse?.error ?? "Respuesta de error HTTP"
            let error = NSError(domain: "https://test3.qastusoft.com.es", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            throw error
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    // Delete request
    func delete<T: Codable>(endPoint: String, token: String) async throws -> T {
        let url = URL(string: "\(urlBase)\(endPoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        // Agrega el token al encabezado de la solicitud
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "https://test3.qastusoft.com.es", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error de respuesta HTTP"])
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorMessageModel.self, from: data)
            let errorMessage = errorResponse?.error ?? "Respuesta de error HTTP"
            let error = NSError(domain: "https://test3.qastusoft.com.es", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            throw error
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

    func put<T: Codable, Body: Encodable>(endPoint: String, body: Body, token: String) async throws -> T {
        let url = URL(string: "\(urlBase)\(endPoint)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        // Codifica los datos del cuerpo de la solicitud
        let jsonData = try JSONEncoder().encode(body)
        request.httpBody = jsonData

        // Establece el encabezado "Content-Type"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Agrega el token al encabezado de la solicitud
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "https://test3.qastusoft.com.es", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error de respuesta HTTP"])
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorMessageModel.self, from: data)
            let errorMessage = errorResponse?.error ?? "Respuesta de error HTTP"
            let error = NSError(domain: "https://test3.qastusoft.com.es", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            throw error
        }

        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }

}
