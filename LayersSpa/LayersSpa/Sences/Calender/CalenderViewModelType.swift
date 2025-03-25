//  
//  CalenderViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 28/07/2024.
//

import Foundation

/// Calender Input & Output
///
typealias CalenderViewModelType = CalenderViewModelInput & CalenderViewModelOutput

/// Calender ViewModel Input
///
protocol CalenderViewModelInput {
    var calenders: [Calender] {get set}
    var ordersDetails : [Order?] {get set}
    var isDataLoaded: Bool {get set}
    var currentPage: Int {get}
    var lastPage: Int {get}
}

/// Calender ViewModel Output
///
protocol CalenderViewModelOutput {
    func getAppointment(date:String, completion: @escaping (Bool) -> Void)
    func fetchAppointmentDetails(completion: @escaping (Bool) -> Void)
    func reset()
}
