//
//  ImageRoundedItem.swift
//  qddapp
//
//  Created by gabatx on 15/5/23.
//

import SwiftUI

struct ImageRoundedItem: View {

    var photo: String
    var width: CGFloat
    var height: CGFloat

    init(photo: String,
         width: CGFloat,
         height: CGFloat) {
        self.photo = photo
        self.width = width
        self.height = height
    }

    var body: some View {
        AsyncImage(url: URL(string: photo)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipShape(Circle())
                .clipped()
                .overlay(Circle().stroke(Constants.borderColor, lineWidth: Constants.lineWidth))
        } placeholder: {
            Image(LocalizedImage.backgroundProfileDefault)
                .resizable()
                .frame(width: width, height: height)
                .clipShape(Circle())
                .overlay(Circle().stroke(.gray, lineWidth: 1))
                .redacted(reason: .placeholder)
        }
    }
}

struct ImageRoundedItem_Previews: PreviewProvider {
    static var previews: some View {

        let photoMock = "https://this-person-does-not-exist.com/img/avatar-gen11c3c22425531189b0bfb571fe9acd16.jpg"
        ImageRoundedItem(photo: photoMock, width: 60, height: 60)
    }
}
