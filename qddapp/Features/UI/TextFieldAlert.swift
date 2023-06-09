//
//  TextFieldAlert.swift
//  qddapp
//
//  Created by gabatx on 19/5/23.
//

import SwiftUI

struct TextFieldAlert: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    @Binding var text: String
    let placeholder: String
    let action: (String) -> Void
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            content
                .disabled(isPresented)
            if isPresented {
                ZStack {

                    VStack(spacing: 0) {
                        HStack {
                            Text(title).font(.headline).padding()
                        }
                     
                        // El texto del mensaje hace salto de línea
                        HStack{
                            Text(message).font(.body).multilineTextAlignment(.center).padding()
                        }
                        .padding(.vertical, -15)
                        .padding(.horizontal, 2)

                        TextField(placeholder, text: $text).textFieldStyle(.roundedBorder).padding()
                            .padding(.bottom, 12)

                        Divider()

                        HStack{
                            Spacer()
                            Button(role: .cancel) {
                                withAnimation {
                                    isPresented.toggle()
                                }
                            } label: {
                                Text("Cancelar")
                            }
                            Spacer()
                            Divider()
                            Spacer()
                            Button() {
                                action(text)
                                withAnimation {
                                    isPresented.toggle()
                                }
                            } label: {
                                Text("Enviar")
                            }
                            Spacer()
                        }
                        .frame(height: 50)
                    }
                    .background(.background)
                    .frame(width: 300)
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.quaternary, lineWidth: 1)
                    }
                }
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
    }
}
