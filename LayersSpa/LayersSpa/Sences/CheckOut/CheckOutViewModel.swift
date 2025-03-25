//  
//  CheckOutViewModel.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import Foundation
import Networking

class CheckOutViewModel {
    private var sectionsItems = [CheckoutSectionsItem]()
    private var transactionRemote: TransactionRemoteProtocol
    var paymentRemote: PaymentRemoteProtocol
    var itemCount = [Int]()
    var productsId: [String] = []
    var orderID : Int?
    var reservationData:ReservationData?
    var selectedPaymentMethod:String?
    var visa: Visa?
    let sectionsHeaderInfo: [BookingSummerySectionsVM] = [BookingSummerySectionsVM(sectionIcon: .payment, sectionTitle: String(localized: "paymentMethod"))]
    var totalPrice  = 0.0
    init(transactionRemote: TransactionRemoteProtocol = TransactionRemote(network: AlamofireNetwork()), paymentRemote: PaymentRemoteProtocol =  PaymentRemote(network: AlamofireNetwork())) {
        self.paymentRemote = paymentRemote
        self.transactionRemote = transactionRemote
        drawCheckOutPage()
    }
}

// MARK: CheckOutViewModelOutput

extension CheckOutViewModel: CheckOutViewModelOutput,CheckOutViewModelInput {
   
    
    func getSectionItem(_ index: Int) -> CheckoutSectionsItem {
        return sectionsItems[index]
    }
    
    func getSectionsNumber() -> Int {
        return sectionsItems.count
    }
    
    func getSectionHeaderInfo(_ index: Int) -> BookingSummerySectionsVM {
        return sectionsHeaderInfo[index]
    }
}

// MARK: Private Handlers

extension CheckOutViewModel {
    func drawCheckOutPage() {
//        let discoundCart = CheckoutDiscountCodeSectionsItem()
//        sectionsItems.append(discoundCart)
        
//        let orderSummeryItem = CheckoutPaymentSectionsItem()
//        sectionsItems.append(orderSummeryItem)
        
        let paymentItem = CheckoutPaymentSectionsItem()
        sectionsItems.append(paymentItem)
        
        let footer = CheckoutFooterSectionsItem()
        sectionsItems.append(footer)
    }
    
    // Save Cart
    func firstRequest() {
        print("✅ firstRequest - بيانات الطلب:")
     //   print("🔹 UserID: \(Defaults.sharedInstance.userData?.userId ?? "N/A")")
        print("🔹 Products ID: \(productsId)")
        print("🔹 Item Count: \(itemCount)")

        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
            guard let self = self else { return }
            
            var productCountMap: [String: Int] = [:]
            for service in services {
                productCountMap[service.productId] = service.productCount
            }
            
            self.itemCount = self.productsId.map { productCountMap[$0] ?? 0 }
            
            print("📦 Final Data Sent to Server:")
            print("   ➡️ Products: \(self.productsId)")
            print("   ➡️ Quantities: \(self.itemCount)")

            self.transactionRemote.SaveCartProduct((Defaults.sharedInstance.userData?.userId) ?? 0, self.productsId, self.itemCount)

            self.transactionRemote.savedToCart = { [weak self] id in
                self?.orderID = id
                print("✅ Order Saved! Order ID: \(id)")
            }
        }
    }

    
    func abandonedState(completion: @escaping (Bool) -> ()) {
        let userId = "\((Defaults.sharedInstance.userData?.userId ) ?? 0)"
        let currentOrderID = orderID ?? 0

        print("🚨 abandonedState Request:")
        print("🔹 UserID: \(userId)")
        print("🔹 OrderID: \(currentOrderID)")

        transactionRemote.abandonedState(userId, currentOrderID) { flag in
            print("✅ abandonedState Response: \(flag ? "Success" : "Failed")")
            completion(flag)
        }
    }

    
    func reservation(completion: @escaping (Bool) -> ()) {
        let userId = Defaults.sharedInstance.userData?.userId ?? 0
        let date = UserDefaults.standard.string(forKey: "selectedDate") ?? getCurrentDateString()

        print("📌 Starting Reservation Request:")
        print("🔹 User ID: \(userId)")
        print("🔹 Date: \(date)")
        
        guard let savedEmployeeIds = UserDefaults.standard.array(forKey: "selectedEmployeeIds") as? [Int] else {
            print("❌ No Employee IDs found!")
            return
        }
        
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
            guard let self = self else { return }

            guard let savedTimes = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] else {
                print("❌ No Service Times found!")
                return
            }

            let servicesMap = Dictionary(uniqueKeysWithValues: services.map { ($0.productId, $0) })
            let sortedServices = self.productsId.compactMap { servicesMap[$0] }
            
            // 🔹 **تصفية الخدمات حسب النوع "service"**
            let filteredServices = sortedServices.filter { $0.type == "service" }

            var startTime = [String]()
            var endTime = [String]()
            var serviceQty = [Int]()
            var period = [Int]()

            self.calcTotalPrice(filteredServices)

            for service in filteredServices {
                if let fullTime = savedTimes["\(service.productId)"] {
                    let arabicDigits = ["٠", "١", "٢", "٣", "٤", "٥", "٦", "٧", "٨", "٩"]
                    let englishDigits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
                    var convertedString = fullTime
                    for (index, arabicDigit) in arabicDigits.enumerated() {
                        convertedString = convertedString.replacingOccurrences(of: arabicDigit, with: englishDigits[index])
                    }

                    let totalTime = convertedString.split(separator: "-")
                    startTime.append(totalTime[0].trimmingCharacters(in: .whitespaces))
                    endTime.append(totalTime[1].trimmingCharacters(in: .whitespaces))
                }

                print("📌 المنتج: \(service.productId) - الكمية: \(service.productCount)")
                serviceQty.append(service.productCount)
                period.append(service.unit ?? 1)
            }

            print("🔹 Total Price: \(totalPrice)")
            print("🔹 Filtered Services: \(filteredServices.map { $0.productId })")
            print("🔹 Service Qty: \(serviceQty)")
            print("🔹 Start Time: \(startTime)")
            print("🔹 End Time: \(endTime)")

            self.transactionRemote.createReservation(
                customerId: userId,
                startDate: date,
                endDate: date,
                ecommOrderId: orderID ?? 0,
                branchId: Defaults.sharedInstance.branchId?.id ?? "2",
                serviceId: filteredServices.compactMap { Int($0.productId) },
                serviceQty: serviceQty,
                employeeId: savedEmployeeIds,
                startTime: startTime,
                endTime: endTime
            ) { [weak self] response in
                switch response {
                case .success(let data):
                    print("✅ Reservation Success! Data: \(data)")
                    if data.status == true {
                        self?.reservationData = data.data
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure(let error):
                    print("❌ Reservation Failed! Error: \(error)")
                    completion(false)
                }
            }
        }
    }



    
    func  bookingConfirmation(completion: @escaping (Bool) -> ()){
        let servicesIds = ((reservationData?.items?.map{$0.serviceID}))
        let reservationIds = reservationData?.items?.map{$0.id}
        let pareentReservationId = reservationData?.id
        transactionRemote.bookingConfirmation(servicesIds: servicesIds, reservationIds: reservationIds, pareentReservationId: pareentReservationId, orderId: orderID ?? 0) { flag in
            if flag{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    
    func  PaymentConfirmation(name: String, visaNumber: String, month: String, year: String, cvc: String, total: String, completion: @escaping (Bool) -> ()){
      
    
        paymentRemote.bookingConfirmation(name: name, visaNumber: visaNumber, month: month, year: year, cvc: cvc, total: total, customerId: "\((Defaults.sharedInstance.userData?.userId) ?? 0)", ecommOrderId: "\((orderID)!)"){ flag in
            if flag{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    
    func calcTotalPrice(_ cartData: [ProductVM]) {
        for item in cartData {
            let price = Double(item.productPrice) ?? 0.0
            self.totalPrice += price * Double(item.productCount)
        }
    }
    
}





//let cardData: [String: String] = [
//    "cardHolder": cardHolder,
//    "cardNumber": cleanedCardNumber,
//    "cvv": cvv,
//    "month": month,
//    "year": year
//]

struct Visa {
    let cardHolder: String
    let cardNumber: String
    let cvv: String
    let month: String
    let year: String
}




// 📌 Products IDs: ["1445", "1444", "1441", "1274"]
//Sorted Product IDs: ["1445", "1444", "1441", "1274"]

