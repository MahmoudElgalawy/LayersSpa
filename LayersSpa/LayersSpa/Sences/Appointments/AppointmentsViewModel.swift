//  
//  AppointmentsViewModel.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import Foundation
import Networking
import UIKit

// MARK: AppointmentsViewModel

class AppointmentsViewModel {
    private var calenderRemote: CalendersRemoteProtocol
    init( calenderRemote: CalendersRemoteProtocol = CalendersRemote(network: AlamofireNetwork())) {
        self.calenderRemote = calenderRemote
    }
    var calenders = [Calender]()
    var ordersIds = ""
    var ordersDetails = [Order]()
    var data = [Calender]()
    var reload : ()->() = {}
    var isDataLoaded = false
}

// MARK: AppointmentsViewModel

extension AppointmentsViewModel: AppointmentsViewModelInput {}

// MARK: AppointmentsViewModelOutput

extension AppointmentsViewModel: AppointmentsViewModelOutput {

    
//    func getAppointment(type: String, completion: @escaping (Bool) -> Void) {
//        let userId = Defaults.sharedInstance.userData?.userId ?? 0
//        isDataLoaded = false
//        reload() // تحديث الواجهة لإخفاء الجدول وعرض الـ indicator
//        
//        calenderRemote.getAppointment(userId: userId, type: type, filterDate: "") { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(let data):
//                self.ordersIds = data.data.reservations.compactMap { $0.ecommOrderID }.joined(separator: ",")
//                
//                if self.ordersIds.isEmpty {
//                    self.calenders = [] // تعيين البيانات إلى فارغة
//                    self.isDataLoaded = true // تعيين isDataLoaded إلى true لإيقاف المؤشر
//                    DispatchQueue.main.async {
//                        self.reload()
//                    }
//                    completion(true)
//                } else {
//                    self.fetchAppointmentDetails { success in
//                        self.calenders = data.data.reservations
//                        self.isDataLoaded = true
//                        DispatchQueue.main.async {
//                            self.reload()
//                        }
//                        completion(success)
//                    }
//                }
//                
//            case .failure(let error):
//                print("❌ Failed to fetch appointments: \(error.localizedDescription)")
//                self.isDataLoaded = true // تعيين isDataLoaded إلى true لإيقاف المؤشر
//                DispatchQueue.main.async {
//                    self.reload()
//                }
//                completion(false)
//            }
//        }
//    }
    
    func getAppointment(type: String, completion: @escaping (Bool) -> Void) {
        let userId = Defaults.sharedInstance.userData?.userId ?? 0
        isDataLoaded = false
        self.calenders = []
        self.ordersDetails = []
        DispatchQueue.main.async { [weak self] in
            self?.reload()
        }
        
        calenderRemote.getAppointment(userId: userId, type: type, filterDate: "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.ordersIds = data.data.reservations.compactMap { $0.ecommOrderID }.joined(separator: ",")
                
                if self.ordersIds.isEmpty {
                    DispatchQueue.main.async {
                        self.calenders = []
                        self.isDataLoaded = true
                        self.reload()
                        completion(true)
                    }
                } else {
                    self.fetchAppointmentDetails { success in
                        DispatchQueue.main.async {
                            self.calenders = data.data.reservations
                            self.isDataLoaded = true
                            self.reload()
                            completion(success)
                        }
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isDataLoaded = true
                    self.reload()
                    completion(false)
                }
            }
        }
    }

        
    private func fetchAppointmentDetails(completion: @escaping (Bool) -> Void) {
        guard !ordersIds.isEmpty else {
            print("⚠️ No orders IDs to fetch details.")
            completion(false)
            return
        }
        
        calenderRemote.getAppointmentDetails(ordersID: ordersIds) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let details):
                self.ordersDetails = details.data
                print("🔹 Fetched Orders Details: \(self.ordersDetails)")
                self.sortOrdersByCalender()
                completion(true)
                
            case .failure(let error):
                print("❌ Failed to fetch appointment details: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
        
    private func sortOrdersByCalender() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let orderDict = Dictionary(uniqueKeysWithValues: self.ordersDetails.map { ($0.id, $0) })
            let sortedOrders = self.calenders.compactMap { calender -> Order? in
                if let ecommIDString = calender.ecommOrderID, let ecommID = Int(ecommIDString) {
                    return orderDict[ecommID]
                }
                return nil
            }
            
            DispatchQueue.main.async {
                self.ordersDetails = sortedOrders
                self.printIDsComparison()
                self.reload()
            }
        }
    }
        
    private func printIDsComparison() {
        print("🔹 OrderDetails IDs vs. Calenders ecommOrderIDs 🔹")
        
        let maxCount = max(ordersDetails.count, calenders.count)
        
        for i in 0..<maxCount {
            let orderID = i < ordersDetails.count ? "\(ordersDetails[i].id)" : "N/A"
            let calenderID = i < calenders.count ? "\(calenders[i].ecommOrderID ?? "N/A")" : "N/A"
            
            print("🔹 OrderDetails ID: \(orderID)  |  Calender ecommOrderID: \(calenderID)")
        }
    }
    }

// MARK: Private Handlers

private extension AppointmentsViewModel {}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? self
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}
