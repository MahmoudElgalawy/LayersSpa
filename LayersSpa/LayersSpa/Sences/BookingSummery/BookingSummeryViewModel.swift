//  
//  BookingSummeryViewModel.swift
//  LayersSpa
//
//  Created by 2B on 31/07/2024.
//

import Foundation
import UIKit

// MARK: BookingSummeryViewModel

class BookingSummeryViewModel {
    private var sectionsItems = [BookingSummerySectionsItem]()

    var cartItems: [ProductVM] = [] 
    var productsId: [String] = []
       
    let sectionsHeaderInfo: [BookingSummerySectionsVM] = [
        BookingSummerySectionsVM(sectionIcon: .details, sectionTitle: String(localized: "bookingDetails")),
        BookingSummerySectionsVM(sectionIcon: .bookingCart, sectionTitle: String(localized:"cartItems")),
        BookingSummerySectionsVM(sectionIcon: .bookingCart, sectionTitle: "")
    ]
    
    init() {
        drawBookingSummeryPage()
               loadCartData()
      }
    
    func loadCartData() {
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] products in
            guard let self = self else { return }
            
            self.cartItems = products

            // ترتيب العناصر بحيث تأتي العناصر من النوع "service" أولاً
            let sortedProducts = self.cartItems.sorted { (first, second) in
                return first.type == "service" && second.type != "service"
            }

            // استخراج IDs بعد الترتيب
            self.productsId = sortedProducts.map { $0.productId }
            
            print("Sorted Product IDs: \(self.productsId)")

            self.updateCartItemsInSection()
        }
    }


       private func updateCartItemsInSection() {
           // تعديل نوع القسم المخصص للسلة لعرض البيانات الحقيقية
           let cartItem = BookingSummeryCartItemsSectionsItem(rowCount: cartItems.count)
           sectionsItems[1] = cartItem // تحديث السلة في الأقسام
       }
   }



// MARK: BookingSummeryViewModel

extension BookingSummeryViewModel: BookingSummeryViewModelInput {}

// MARK: BookingSummeryViewModelOutput

extension BookingSummeryViewModel: BookingSummeryViewModelOutput {
    
    func getSectionItem (_ index: Int) -> BookingSummerySectionsItem {
        return sectionsItems[index]
    }
    
    func getSectionsNumber() -> Int {
        return sectionsItems.count
    }
    
    func getSectionHeaderInfo(_ index: Int) -> BookingSummerySectionsVM {
        return sectionsHeaderInfo[index]
    }
    
    func removeBookingDetailsSection() {
        sectionsItems.removeAll { $0 is BookingSummeryDetailsSectionsItem }
    }

}

// MARK: Private Handlers

private extension BookingSummeryViewModel {
    func drawBookingSummeryPage() {
        let bookingDetailslItem = BookingSummeryDetailsSectionsItem()
        sectionsItems.append(bookingDetailslItem)
        
        let cartItem = BookingSummeryCartItemsSectionsItem(rowCount: 3)
        sectionsItems.append(cartItem)
        
        let footer = BookingSummeryFooterSectionsItem()
        sectionsItems.append(footer)
    }

}

struct BookingSummerySectionsVM {
    let sectionIcon: UIImage
    let sectionTitle: String
}


//"status": true,
//    "message": "done",
//    "data": {
//        "uuid": "8ddcdf0b-2aef-480b-91df-52448da57d34",
//        "business_id": 259,
//        "reference": 558,
//        "created_date": "2025-02-03",
//        "type": "1",
//        "account_id": 53,
//        "cleared_date": "2025-02-03",
//        "payee_payer_type": "1",
//        "payee_payer_id": "2311",
//        "total": "5000",
//        "advanced_payment": 1,
//        "paid_received_type": 1,
//        "updated_at": "2025-02-03T05:39:00.000000Z",
//        "created_at": "2025-02-03T05:39:00.000000Z",
//        "id": 733
//    }
//}
