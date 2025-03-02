//  
//  BookTimeSlotsViewModelType.swift
//  LayersSpa
//
//  Created by 2B on 31/07/2024.
//

import Foundation

/// BookTimeSlots Input & Output
///
typealias BookTimeSlotsViewModelType = BookTimeSlotsViewModelInput & BookTimeSlotsViewModelOutput

/// BookTimeSlots ViewModel Input
///
protocol BookTimeSlotsViewModelInput { var selectedTime: String? {get set}}

/// BookTimeSlots ViewModel Output
///
protocol BookTimeSlotsViewModelOutput {}
