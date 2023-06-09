//
//  DayOfBirthView.swift
//  qddapp
//
//  Created by gabatx on 21/5/23.
//

import SwiftUI

struct SetDayOfBirthView: View {

    @EnvironmentObject var registerFormViewModel: RegisterFormViewModel

    var body: some View {
        VStack(spacing: 20){
            Text("¿Cual es tu fecha de nacimiento?")
                .modifier(h3(color: (Color(LocalizedColor.secondary))))
                .multilineTextAlignment(.center)
            Text("Necesitamos comprobar que no eres menor de edad")
                .modifier(body1(color: registerFormViewModel.showdateOfBirthError ? .red : Color(LocalizedColor.textDark)))
                .multilineTextAlignment(.center)

            // Día, Mes y Año
            HStack(spacing: 10) {

                // Días
                VStack {
                    Text(registerFormViewModel.selectedDayOfBirth == 0 ? "Día" : String(registerFormViewModel.selectedDayOfBirth))
                        .modifier(body1())
                    Divider()
                        .lineBottom()
                }
                .onTapGesture {
                    withTransaction(Transaction(animation: .easeInOut(duration: 0.2))) {
                        registerFormViewModel.showPickerViewDayOfBirth = true
                        registerFormViewModel.showPickerViewMonthOfBirth = false
                        registerFormViewModel.showPickerViewYearOfBirth = false
                        if registerFormViewModel.showdateOfBirthError {
                            registerFormViewModel.checkDateOfBirth()
                        }
                    }
                }
                .onChange(of: registerFormViewModel.selectedDayOfBirth) { _ in
                    if registerFormViewModel.showdateOfBirthError {
                        registerFormViewModel.checkDateOfBirth()
                    }
                }

                // Meses
                VStack {
                    Text(registerFormViewModel.selectedMonthOfBirth == Constants.notSelected ? "Mes" : registerFormViewModel.selectedMonthOfBirth.capitalized)
                        .modifier(body1())
                    Divider()
                        .lineBottom()
                }
                .onTapGesture {
                    withTransaction(Transaction(animation: .easeInOut(duration: 0.2))) {
                        registerFormViewModel.showPickerViewDayOfBirth = false
                        registerFormViewModel.showPickerViewMonthOfBirth = true
                        registerFormViewModel.showPickerViewYearOfBirth = false
                    }
                }
                .onChange(of: registerFormViewModel.selectedMonthOfBirth) { _ in
                    if registerFormViewModel.showdateOfBirthError {
                        registerFormViewModel.checkDateOfBirth()
                    }
                }

                // Años
                VStack {
                    Text(registerFormViewModel.selectedYearOfBirth == 0 ? "Año" : String(registerFormViewModel.selectedYearOfBirth))
                        .modifier(body1())
                    Divider()
                        .lineBottom()
                }
                .onTapGesture {
                    withTransaction(Transaction(animation: .easeInOut(duration: 0.2))) {
                        registerFormViewModel.showPickerViewDayOfBirth = false
                        registerFormViewModel.showPickerViewMonthOfBirth = false
                        registerFormViewModel.showPickerViewYearOfBirth = true
                    }
                }
                .onChange(of: registerFormViewModel.selectedYearOfBirth) { _ in
                    if registerFormViewModel.showdateOfBirthError {
                        registerFormViewModel.checkDateOfBirth()
                    }
                }
            }

            if registerFormViewModel.showPickerViewDayOfBirth {
                Picker("", selection: $registerFormViewModel.selectedDayOfBirth) {
                    ForEach(1...registerFormViewModel.variableDay,
                            id: \.self) {
                        Text(String($0))
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .transition(.move(edge: .bottom))
                .onChange(of: registerFormViewModel.selectedDayOfBirth) { newValue in
                }
            }

            if registerFormViewModel.showPickerViewMonthOfBirth {
                let months = Date().monthsInYear()
                if registerFormViewModel.showPickerViewMonthOfBirth {
                    Picker("", selection: $registerFormViewModel.selectedMonthOfBirth) {
                        ForEach(months,
                                id: \.self) {
                            Text(String($0).capitalized)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .transition(.move(edge: .bottom))
                    .onChange(of: registerFormViewModel.selectedMonthOfBirth) { newValue in
                        registerFormViewModel.setVariableDay(newValue: newValue)
                    }
                }
            }

            if registerFormViewModel.showPickerViewYearOfBirth {
                Picker("", selection: $registerFormViewModel.selectedYearOfBirth) {
                    ForEach(Date().yearsInBetween(),
                            id: \.self) {
                        Text(String($0))
                    }
                }
                .pickerStyle(InlinePickerStyle())
                .transition(.move(edge: .bottom))
                .onChange(of: registerFormViewModel.selectedYearOfBirth) { newValue in
                    registerFormViewModel.adjustDaysForLeapYearFebruary(newValue: newValue)
                }
            }
        }
        .padding(.horizontal, Constants.paddingLoginHome)
        .onTapGesture {
            // Se va con un fader
            withTransaction(Transaction(animation: .easeInOut(duration: 0.1))) {
                registerFormViewModel.showPickerViewDayOfBirth = false
                registerFormViewModel.showPickerViewMonthOfBirth = false
                registerFormViewModel.showPickerViewYearOfBirth = false
            }
        }
        .onDisappear(){
            registerFormViewModel.checkDateOfBirth()
            registerFormViewModel.createDate()
        }
    }
}

struct SetDayOfBirthView_Previews: PreviewProvider {
    static var previews: some View {
        SetDayOfBirthView()
            .environmentObject(RegisterFormViewModel())
    }
}
