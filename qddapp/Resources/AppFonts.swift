//
//  AppFonts.swift
//  qddapp
//
//  Created by gabatx on 1/5/23.
//

import Foundation
import SwiftUI

struct h1: ViewModifier {
    var color = Color(LocalizedColor.textDark)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Bold", size: 34).bold())
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct h2: ViewModifier {
    var color = Color(LocalizedColor.textDark)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Bold", size: 28).bold())
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct h3: ViewModifier {
    var color = Color(LocalizedColor.textDark)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-SemiBold", size: 22).bold())
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct h4: ViewModifier {
    var color = Color(LocalizedColor.textDark)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Medium", size: 18).bold())
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct h5: ViewModifier {
    var color = Color(LocalizedColor.textDark)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Medium", size: 16).bold())
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct h6: ViewModifier {
    var color = Color(LocalizedColor.textDark)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Medium", size: 14).bold())
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)
    }
}

struct subtitle1: ViewModifier {
    var color = Color(LocalizedColor.textRegular)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-SemiBold", size: 16).bold())
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct subtitle2: ViewModifier {
    var color = Color(LocalizedColor.textRegular)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Light", size: 16))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct body1: ViewModifier {
    var color = Color(LocalizedColor.textRegular)

    func body(content: Content) -> some View {
        content
             // Fuente de sistema
            .font(Font.custom("Montserrat-Medium", size: 16))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct body2: ViewModifier {
    var color = Color(LocalizedColor.textRegular)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Regular", size: 14))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct button: ViewModifier {
    var color = Color(LocalizedColor.textRegular)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-SemiBold", size: 15))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct caption: ViewModifier {
    var color = Color(LocalizedColor.textRegular)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Regular", size: 13))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct overline: ViewModifier {
    var color = Color(LocalizedColor.textDark)
    var click: () -> Void

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Regular", size: 14))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
            .onTapGesture(perform: { click() })
    }
}

struct messageUnderDivider: ViewModifier {
    var color = Color(LocalizedColor.errorValidation)

    func body(content: Content) -> some View {
        content
            .font(Font.custom("Montserrat-Regular", size: 11))
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension Font {

    static func montserratBold(size: CGFloat) -> Font {
        Font.custom("Montserrat-Bold", size: size)
    }

    static func montserratLight(size: CGFloat) -> Font {
        Font.custom("Montserrat-Light", size: size)
    }

    static func montserratMedium(size: CGFloat) -> Font {
        Font.custom("Montserrat-Medium", size: size)
    }

    static func montserratRegular(size: CGFloat) -> Font {
        Font.custom("Montserrat-Regular", size: size)
    }

    static func montserratSemiBold(size: CGFloat) -> Font {
        Font.custom("Montserrat-SemiBold", size: size)
    }

    static func ralewaytBold(size: CGFloat) -> Font {
        Font.custom("Raleway-Bold", size: size)
    }

    static func ralewayLight(size: CGFloat) -> Font {
        Font.custom("Raleway-Light", size: size)
    }

    static func ralewayMedium(size: CGFloat) -> Font {
        Font.custom("Raleway-Medium", size: size)
    }

    static func ralewayRegular(size: CGFloat) -> Font {
        Font.custom("Raleway-Regular", size: size)
    }

    static func ralewayThin(size: CGFloat) -> Font {
        Font.custom("Raleway-Thin", size: size)
    }

    static func ralewaySemiBold(size: CGFloat) -> Font {
        Font.custom("Raleway-SemiBold", size: size)
    }
}


