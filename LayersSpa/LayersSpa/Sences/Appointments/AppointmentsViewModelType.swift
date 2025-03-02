//  
//  AppointmentsViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import Foundation

/// Appointments Input & Output
///
typealias AppointmentsViewModelType = AppointmentsViewModelInput & AppointmentsViewModelOutput

/// Appointments ViewModel Input
///
protocol AppointmentsViewModelInput {
    var calenders: [Calender] {get set}
    var ordersDetails : [Order] {get set}
    var reload : ()->() {get set}
    var isDataLoaded: Bool {get set}
}

/// Appointments ViewModel Output
///
protocol AppointmentsViewModelOutput {
    func getAppointment( type:String, completion: @escaping (Bool) -> Void)

    //func getPrice(for ecommid: Int) -> String?
}
