//  
//  CalenderViewModel.swift
//  LayersSpa
//
//  Created by marwa on 28/07/2024.
//

import Foundation
import Networking

// MARK: CalenderViewModel

class CalenderViewModel {
    private var calenderRemote: CalendersRemoteProtocol
    init(calenderRemote: CalendersRemoteProtocol = CalendersRemote(network: AlamofireNetwork())) {
        self.calenderRemote = calenderRemote
    }
    
    var calenders = [Calender]()
    var ordersIds = ""
    var ordersDetails = [Order?]()
    var data = [Calender]()
    var reload: () -> Void = {}
    var isDataLoaded = false
    var currentPage: Int = 0
    var lastPage: Int = 1
    
    func reset() {
        calenders.removeAll()
        ordersIds = ""
        ordersDetails.removeAll()
        data.removeAll()
        isDataLoaded = false
        currentPage = 0
        lastPage = 1
    }
}

// MARK: - CalenderViewModelOutput
extension CalenderViewModel: CalenderViewModelOutput, CalenderViewModelInput {
    
    func getAppointment(date: String, completion: @escaping (Bool) -> Void) {
        guard currentPage + 1 <= lastPage else {
            return
        }
        currentPage += 1
        
        let userId = Defaults.sharedInstance.userData?.userId ?? 0
        isDataLoaded = false
        
        calenderRemote.getAppointment(userId: userId, type: "", filterDate: date, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.lastPage = data.data.lastPage
                
                if ordersIds == "" {
                    self.ordersIds = data.data.reservations.compactMap { $0.ecommOrderID }.joined(separator: ",")
                } else {
                    self.ordersIds = self.ordersIds + "," + data.data.reservations.compactMap { $0.ecommOrderID }.joined(separator: ",")
                }
                
                self.data.append(contentsOf: data.data.reservations)

                if self.ordersIds.isEmpty {
                    self.calenders = self.data
                    self.ordersDetails = Array(repeating: nil, count: self.data.count) // إضافة هنا
                    self.isDataLoaded = true
                    self.reload()
                    completion(true)
                } else {
                    self.fetchAppointmentDetails { success in
                        self.calenders.append(contentsOf: data.data.reservations)
                        self.isDataLoaded = true
                        self.reload()
                        completion(success)
                    }
                }
                
            case .failure(let error):
                print("❌ Failed to fetch appointments: \(error.localizedDescription)")
                self.isDataLoaded = true
                self.reload()
                completion(false)
            }
        }
    }
    
    internal func fetchAppointmentDetails(completion: @escaping (Bool) -> Void) {
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
                self.sortOrdersByCalender()
                completion(true)
                
            case .failure(let error):
                print("❌ Failed to fetch details: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    private func sortOrdersByCalender() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let orderDict = Dictionary(uniqueKeysWithValues: self.ordersDetails.compactMap { $0 }.map { ($0.id, $0) })
            let sortedOrders = self.data.map { calender -> Order? in
                if let ecommIDString = calender.ecommOrderID, let ecommID = Int(ecommIDString) {
                    return orderDict[ecommID]
                }
                return nil
            }
            
            DispatchQueue.main.async {
                self.ordersDetails = sortedOrders
                self.printIDsComparison()
            }
        }
    }
    private func printIDsComparison() {
        print("🔹 OrderDetails IDs vs. Calenders ecommOrderIDs 🔹")
        let maxCount = max(ordersDetails.count, calenders.count)
        
        for i in 0..<maxCount {
            let orderID = i < ordersDetails.count ? "\(ordersDetails[i]?.id)" : "N/A"
            let calenderID = i < calenders.count ? "\(calenders[i].ecommOrderID ?? "N/A")" : "N/A"
            print("🔹 OrderDetails ID: \(orderID)  |  Calender ecommOrderID: \(calenderID)")
        }
    }
}
