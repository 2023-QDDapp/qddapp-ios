//
//  SearchEventFilterViewModel.swift
//  qddapp
//
//  Created by gabatx on 5/5/23.
//

import Foundation
import SwiftUI
import MapKit

class SearchEventFilterViewModel: ObservableObject {

    @Published var tittleEvent: String = ""
    @Published var currentDateStart: Date = Date()
    @Published var currentDateEnd: Date = Date()
    @Published var distanceCounter: Float = 200
    @Published var typeEvent = Constants.typeEventDefault

    @Published var isPresentedShowCatergoriesView = false
    @Published var isActiveNavigationtoMapFilterView = false
    @Published var isPresentedSearchEventFilterView: Bool = false

}
