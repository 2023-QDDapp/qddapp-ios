//
//  TermsOfUse.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import SwiftUI

struct TermsOfUse: View {

    @Binding var isShowTermsOfUse: Bool

    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()
                Button {
                    isShowTermsOfUse = false
                } label: {
                    Image("cerrar")
                        .styleBasicImageLogo()
                        .frame(width: 20)
                }
                .padding(.trailing, 25)

            }
            VStack{
                Image("logo")
                    .styleBasicImageLogo()
                    .frame(width: 140)
                Text("Términos de uso")
                    .modifier(h3())
                    .padding(.top, 20)
                Divider()
                ScrollView{
                    Text(Constants.termsOfUse)
                        .padding(.top)
                        .modifier(body1())
                }
            }
            .padding(Constants.paddinGeneral)
        }

    }
}

struct TermsOfUse_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfUse(isShowTermsOfUse: .constant(true))
    }
}
