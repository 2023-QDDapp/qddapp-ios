//
//  SearchEventFilterModel.swift
//  qddapp
//
//  Created by gabatx on 12/5/23.
//

import Foundation

struct SearchEventFilterModel {
    var tittleEvent: String?
    var categorySelected: Int?
    var currentDateStart: String?
    var currentDateEnd: String?
    var typeEvent: String?
    var locationName: String?
    var eventLatitude: Double?
    var eventLongitude: Double?
    var distanceCounter: Float?
}
