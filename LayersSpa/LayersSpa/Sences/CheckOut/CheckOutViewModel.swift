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
    let sectionsHeaderInfo: [BookingSummerySectionsVM] = [BookingSummerySectionsVM(sectionIcon: .payment, sectionTitle: "Payment Method")]
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
        print("pID:\(productsId),,,UID:2311,,,,IQ:\(itemCount)")
        
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
            guard let self = self else { return }
            
            // إنشاء قاموس يربط بين الـ productId و عدد المنتجات
            var productCountMap: [String: Int] = [:]
            for service in services {
                productCountMap[service.productId] = service.productCount
            }
            
            // ترتيب itemCount بناءً على ترتيب productsId
            self.itemCount = self.productsId.map { productCountMap[$0] ?? 0 }
            
            // إرسال البيانات بعد الترتيب
            self.transactionRemote.SaveCartProduct((Defaults.sharedInstance.userData?.userId)!, self.productsId, self.itemCount)
            
            self.transactionRemote.savedToCart = { [weak self] id in
                self?.orderID = id
            }
        }
    }
    
    func abandonedState(completion: @escaping (Bool) -> ()) {
        print("Ordddddddddeeeeeeeeeerrrrrrrr iiiiiiidddddddddd ======== \(orderID ?? 0)")
        transactionRemote.abandonedState("\((Defaults.sharedInstance.userData?.userId)!)", orderID ?? 0){ flag in
            if flag{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    func reservation(completion: @escaping (Bool) -> ()) {
        let userId = Int((Defaults.sharedInstance.userData?.userId)!)
        let date = UserDefaults.standard.string(forKey: "selectedDate")
        
        guard let savedEmployeeIds = UserDefaults.standard.array(forKey: "selectedEmployeeIds") as? [Int] else {
            return print("Saved Employee IDs: savedEmployeeIds")
        }
        
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
            guard let self = self else { return }
            
            guard let savedTimes = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] else { return }
            
            // تحويل الـ services إلى قاموس ليسهل الوصول إليها باستخدام الـ productId
            let servicesMap = Dictionary(uniqueKeysWithValues: services.map { ($0.productId, $0) })
            
            // ترتيب الخدمات بناءً على ترتيب `productsId`
            let sortedServices = self.productsId.compactMap { servicesMap[$0] }
            
            var startTime = [String]()
            var endTime = [String]()
            var serviceQty = [Int]()
            var period = [Int]()
            
            self.calcTotalPrice(sortedServices)
            
            for service in sortedServices {
                if let fullTime = savedTimes["\(service.productId)"] {
                    let totalTime = fullTime.split(separator: "-")
                    startTime.append(totalTime[0].trimmingCharacters(in: .whitespaces))
                    endTime.append(totalTime[1].trimmingCharacters(in: .whitespaces))
                }
                
                print("📌 المنتج: \(service.productId) - الكمية: \(service.productCount)") // ✅ لمتابعة القيم اللي بتتضاف
                serviceQty.append(service.productCount)
                period.append(service.unit ?? 1)
            }
            
            print("🛒 سعر المنتجات: \(totalPrice)")
            
            self.transactionRemote.createReservation(
                customerId: userId,
                startDate: date ?? getCurrentDateString(),
                endDate: date ?? getCurrentDateString(),
                ecommOrderId: orderID ?? 0,
                branchId: Defaults.sharedInstance.branchId?.id ?? "2",
                serviceId: productsId.compactMap { Int($0) },
                serviceQty: serviceQty,
                employeeId: savedEmployeeIds,
                startTime: startTime,
                endTime: endTime
            ) { [weak self] response in
                switch response {
                case .success(let data):
                    if data.status == true {
                        self?.reservationData = data.data
                        completion(true)
                    } else {
                        completion(false)
                    }
                case .failure(_):
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
      
    
        paymentRemote.bookingConfirmation(name: name, visaNumber: visaNumber, month: month, year: year, cvc: cvc, total: total, customerId: "\((Defaults.sharedInstance.userData?.userId)!)", ecommOrderId: "\((orderID)!)"){ flag in
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

