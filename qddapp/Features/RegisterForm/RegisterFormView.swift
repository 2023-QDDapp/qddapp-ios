//
//  RegisterFormView.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import SwiftUI

struct RegisterFormView: View {

    @StateObject var registerFormViewModel = RegisterFormViewModel()
    @StateObject var categoriesViewModel = CategoriesViewModel()

    // Le damos color a los indicadores de paginación
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor =  UIColor(Color(LocalizedColor.secondary))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(LocalizedColor.primary))
        UIPageControl.appearance().preferredIndicatorImage = UIImage(systemName: "circle.fill")?.withTintColor(UIColor(Color(LocalizedColor.secondary)))
    }

    var body: some View {
        TabView{
            SetNameView()
                .environmentObject(registerFormViewModel)
            SetDayOfBirthView()
                .environmentObject(registerFormViewModel)
            SetPhoneView()
                .environmentObject(registerFormViewModel)
            SetPhotoAvatarView()
                .environmentObject(registerFormViewModel)
            SetAboutMeView()
                .environmentObject(registerFormViewModel)
            SetPreferencesView()
                .environmentObject(registerFormViewModel)
                .environmentObject(categoriesViewModel)
            ResumeRegisterFormView()
                .environmentObject(registerFormViewModel)
                .environmentObject(categoriesViewModel)
        }
        .tabViewStyle(PageTabViewStyle())
        // Le añade fondo a los puntos de paginación
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .onTapGesture {
            self.hideKeyboard()
        }
    }
}

struct RegisterFormView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterFormView()
            .environmentObject(RegisterFormViewModel())
    }
}




