//
//  ParticipantPhoto.swift
//  qddapp
//
//  Created by gabatx on 20/4/23.
//

import SwiftUI

struct ParticipantPhoto: View {

    var photoParticipant: String

    init(photoParticipant: String) {
        self.photoParticipant = photoParticipant
    }

    var body: some View {
        ImageRoundedItem(photo: photoParticipant, width: 50, height: 50)
    }
}

struct ParticipantPhoto_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantPhoto(photoParticipant: "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg")
    }
}
