//
//  AutoSizingTF.swift
//  qddapp
//
//  Created by gabatx on 22/5/23.
//

import Foundation
import SwiftUI

struct AutoSizingTF: UIViewRepresentable {

    var hint: String
    @Binding var text: String
    @Binding var containerHeight: CGFloat
    var onEnd : ()->()

    func makeCoordinator() -> Coordinator {
        return AutoSizingTF.Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView{

        let textView = UITextView()
        // Placeholder
        textView.text = hint
        textView.textColor = UIColor(Color(LocalizedColor.grayIconTextField))
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "Montserrat-Medium", size: 16)

        // Delegado de configuración...
        textView.delegate = context.coordinator

        // ToolBar personalizado....
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default

        // Colocamos un espaciador para que se vaya todos los botones a la derecha
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(title: "Aplicar", style: .done, target: context.coordinator, action: #selector(context.coordinator.closeKeyBoard))
        doneButton.tintColor = UIColor(Color(LocalizedColor.secondary))

        toolBar.items = [spacer,doneButton]
        toolBar.sizeToFit()

        textView.inputAccessoryView = toolBar

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {

        DispatchQueue.main.async {

            // Cuando cambie text, actualizará el input si no está vacío
            if !text.isEmpty {
                uiView.text = text
                uiView.textColor = UIColor(Color(LocalizedColor.textDark))
            }

            // Le damos la altura del contenido para que se ajuste al texto introducido
            if uiView.contentSize.height != containerHeight {
                containerHeight = uiView.contentSize.height
            }
        }
    }

    class Coordinator: NSObject,UITextViewDelegate {

        // Para leer todas las propiedades de los padres...
        var parent: AutoSizingTF

        init(parent: AutoSizingTF) {
            self.parent = parent
        }

        // Para cerrar el teclado @objc...
        @objc func closeKeyBoard(){
            parent.onEnd()
        }

        func textViewDidBeginEditing(_ textView: UITextView) {

            // comprobar si la caja de texto está vacía...
           // si lo está, borra la sugerencia...
            if textView.text == parent.hint{
                textView.text = ""
                textView.textColor =  UIColor(Color(LocalizedColor.textDark))
            }
        }

        // Actualizando texto en SwiftUI View...
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.containerHeight = textView.contentSize.height
        }

        // Comprueba si la caja de texto está vacía
        // Si es así, ponga una pista..
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == ""{
                textView.text = parent.hint
                textView.textColor = UIColor(Color(LocalizedColor.grayIconTextField))
            }
        }
    }
}
