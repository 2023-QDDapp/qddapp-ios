//
//  Errors.swift
//  qddapp
//
//  Created by gabatx on 1/6/23.
//

import Foundation

enum ErrorsResponseLogin:String, Error, LocalizedError {
    // Aquí ponemos el nombre del error
    case invalidCredentials = "invalid_credentials"
    case emailNotVerified = "email_not_verified"

    // Aquí debemos crear una variable calculada llamada errorDescription (que forma parte del protocolo)
    var errorDescription: String? {
        // Si le indicamos self en el switch, nos obliga a colocar todos los cases
        switch self {
        case .invalidCredentials:
            return "Usuario o contraseña incorrectos"
        case .emailNotVerified:
            return "Aún no has verificado el correo que te hemos enviado."
        }
    }
}
