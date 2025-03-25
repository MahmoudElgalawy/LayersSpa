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
    var currentPage: Int = 0
    var lastPage: Int = 1
    
    func reset() {
        calenders.removeAll()
        ordersIds = ""
        ordersDetails.removeAll()
        data.removeAll()
        //reload = {}
        currentPage = 0
        lastPage = 1
        isDataLoaded = false
    }
}

// MARK: AppointmentsViewModel

extension AppointmentsViewModel: AppointmentsViewModelInput {}

// MARK: AppointmentsViewModelOutput

extension AppointmentsViewModel: AppointmentsViewModelOutput {

    
    func getAppointment(type: String, completion: @escaping (Bool) -> Void) {
        guard currentPage + 1 <= lastPage else {
            return
        }
        currentPage += 1
        
        let userId = Defaults.sharedInstance.userData?.userId ?? 0
        isDataLoaded = false
        
        if currentPage == 1 {
            reload()
        }
        
        
        calenderRemote.getAppointment(userId: userId, type: type, filterDate: "", page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.lastPage = data.data.lastPage
                
                if ordersIds == "" {
                    self.ordersIds = data.data.reservations.compactMap { $0.ecommOrderID }.joined(separator: ",")
                } else {
                    self.ordersIds = self.ordersIds + "," + data.data.reservations.compactMap { $0.ecommOrderID }.joined(separator: ",")
                }
                
                if self.ordersIds.isEmpty {
                    self.calenders = [] // تعيين البيانات إلى فارغة
                    self.isDataLoaded = true // تعيين isDataLoaded إلى true لإيقاف المؤشر
                    DispatchQueue.main.async {
                        self.reload()
                    }
                    completion(true)
                } else {
                    self.fetchAppointmentDetails { success in
                        self.calenders.append(contentsOf: data.data.reservations)
                        self.isDataLoaded = true
                        DispatchQueue.main.async {
                            self.reload()
                        }
                        completion(success)
                    }
                }
                
            case .failure(let error):
                print("❌ Failed to fetch appointments: \(error.localizedDescription)")
                self.isDataLoaded = true
                DispatchQueue.main.async {
                    self.reload()
                }
                completion(false)
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
            
            // فلترة المواعيد غير المطابقة
            let validCalenders = self.calenders.filter { calender in
                if let ecommIDString = calender.ecommOrderID, let ecommID = Int(ecommIDString) {
                    return orderDict[ecommID] != nil
                }
                return false
            }
            
            var sortedOrders: [Order] = []
            for calender in validCalenders {
                if let ecommIDString = calender.ecommOrderID, let ecommID = Int(ecommIDString), let order = orderDict[ecommID] {
                    sortedOrders.append(order)
                }
            }

            DispatchQueue.main.async {
                self.ordersDetails = sortedOrders
                self.calenders = validCalenders  // تحديث المواعيد المتطابقة فقط
                self.printIDsComparison()
                self.reload()
            }
        }
    }


        
    private func printIDsComparison() {
        print("\n🔹🔹🔹 Final Matching Results 🔹🔹🔹")
        
        let ordersDict = Dictionary(uniqueKeysWithValues: ordersDetails.map { ("\($0.id)", $0) })
        
        let sortedOrders = ordersDetails.sorted { $0.id < $1.id }
        let sortedCalenders = calenders.sorted { ($0.ecommOrderID ?? "") < ($1.ecommOrderID ?? "") }
        
        let minCount = min(sortedOrders.count, sortedCalenders.count)
        let maxCount = max(sortedOrders.count, sortedCalenders.count)
        
        for i in 0..<minCount {
            let orderID = "\(sortedOrders[i].id)"
            let calenderID = sortedCalenders[i].ecommOrderID ?? "N/A"
            let status = ordersDict[calenderID] != nil ? "✅" : "❌"
            
            print("\(status) OrderDetails ID: \(orderID) | Calender ecommOrderID: \(calenderID)")
        }
        
        if sortedOrders.count > sortedCalenders.count {
            for i in minCount..<maxCount {
                print("❌ OrderDetails ID: \(sortedOrders[i].id) | Calender ecommOrderID: N/A")
            }
        } else if sortedCalenders.count > sortedOrders.count {
            for i in minCount..<maxCount {
                print("❌ OrderDetails ID: N/A | Calender ecommOrderID: \(sortedCalenders[i].ecommOrderID ?? "N/A")")
            }
        }
        
        let successfulMatches = sortedOrders.filter { order in
            sortedCalenders.contains { $0.ecommOrderID == "\(order.id)" }
        }.count
        
        print("\n🔹 Matching Summary:")
        print("Total Orders: \(sortedOrders.count)")
        print("Total Calenders: \(sortedCalenders.count)")
        print("Successful Matches: \(successfulMatches)")
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
