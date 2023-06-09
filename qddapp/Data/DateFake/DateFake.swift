//
//  DateFake.swift
//  qddapp
//
//  Created by gabatx on 16/4/23.
//

import Foundation

struct DateFake {
    static let user = UserModel(
        id: 1,
        name: "Angela Cuadros",
        photo: "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg",
        phone: "654789987",
        age: 33,
        description: "Me gusta jugar al juego de la oca... mucho",
        interests: [
            CategoryModel(id: 1, name: "Deporte"),
            CategoryModel(id: 2, name: "Música"),
            CategoryModel(id: 3, name: "Negocios"),
        ],
        ratings: [
            RatingModel(
                idUser: 2,
                date: nil,
                name: "Juan José",
                photo: "https://test3.qastusoft.com.es/proyecto/storage/img/user/1684595598.jpg",
                rating: nil,
                message: "La organización del evento fue excelente, todo estuvo perfectamente planificado y coordinado. ¡Gracias!")
        ])

    static let event = EventDetailModel(
        id: 1,
        tittleEvent: "Concierto en vivo",
        nameOrganiser: "Música Live",
        idOrganiser: 1,
        photoOrganiser: "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg",
        age: 0,
        description: "🎺 Disfruta de un emocionante concierto en vivo con bandas locales. 🎷",
        photoEvent: "https://img.freepik.com/foto-gratis/vista-posterior-audiencia-emocionada-brazos-levantados-animando-frente-al-escenario-concierto-musica-espacio-copia_637285-538.jpg",
        typeEvent: 1,
        dateStart: "2023-06-01 19:30",
        dateEnd: "2023-06-01 22:00",
        locality: "Teatro Central",
        latitude: 40.7128,
        longitude: -74.0060,
        category: "Música",
        numPartipants: 3,
        participants: [
            ParticipantEventModel(
                id: 2,
                name: "Juan José",
                photo: "https://this-person-does-not-exist.com/img/avatar-gen11a1a68c331386a31a9f76c7936267a5.jpg",
                type: "Asistente",
                age: 33)
        ])

    static let eventCell = EventListModel(
        id: 1,
        idOrganiser: 2,
        nameOrganiser: "Jose Antonio Guzman Rodrigez",
        photoOrganiser: "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg",
        age: 33,
        photoEvent: "https://historia.nationalgeographic.com.es/medio/2020/08/05/ninos-jugando-al-parchis_60c556f3_1280x1015.jpg",
        title: "Jugar al futbol",
        eventDescription: "Vamos a echar un partido de futbol 7",
        dateStartTime: "2023-04-14 09:30:43",
        idCategory: 1,
        category: "Deporte")

    static let ratingUser = RatingModel(
        idUser: 2,
        date: nil,
        name: "Juan José",
        photo: "https://test3.qastusoft.com.es/proyecto/storage/img/user/1684595598.jpg",
        rating: nil,
        message: "La organización del evento fue excelente, todo estuvo perfectamente planificado y coordinado. ¡Gracias!")

    static let participant = ParticipantEventModel(
        id: 2,
        name: "Juan José",
        photo: "https://this-person-does-not-exist.com/img/avatar-gen11a1a68c331386a31a9f76c7936267a5.jpg",
        type: "Asistente",
        age: 33)

    static let followedUser = [
        FollowedUser(id: 1,
                     name: "Álvaro Garvín Guerrero",
                     photo: "https://test3.qastusoft.com.es/proyecto/storage/img/user/1684955090.jpg")
    ]

    static let eventHeldCell = EventHeldCellModel(
        idEvent: 3,
        idOrganizer: 2,
        photo: "https://test3.qastusoft.com.es/proyecto/storage/img/user/1684955090.jpg",
        titleEvent: "Concurso de villancicos madrileños",
        dateStart: "2023-12-14 09:30:00")

    static let loginResponseModel = LoginResponseModel(id: 1, token: "aadsfasdfasdf", isVerified: 1, isRegistered: 1)

    static let messageResponseModel = MessageResponseModel(message: "Ha ocurrido un fallo al realizar la petición")
}
