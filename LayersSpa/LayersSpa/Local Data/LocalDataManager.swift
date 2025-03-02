//
//  LocalDataManger.swift
//  LayersSpa
//
//  Created by Marwa on 01/09/2024.
//

import Foundation
import UIKit
import CoreData
import Networking

protocol LocalDataManagerProtocol {
    func getLikeProductsListFromCoreData(_ type: CoreDataProductType, completion: @escaping ([ProductVM]) -> ())
    func addLikeProductsToCoreData(productsList: ProductVM, _ type: CoreDataProductType)
    func updateProductsListInCoreData(_ product: ProductVM, _ type: CoreDataProductType)
    func checkProductExist(_ productId: String, _ type: CoreDataProductType) -> Bool
    func deleteProduct(_ productId: String, _ type: CoreDataProductType, completion: @escaping (Bool) -> ())
    func deleteAllData(_ type: CoreDataProductType)
    func getCounter() -> Int
}

class LocalDataManager {

    public static let sharedInstance = LocalDataManager()

    private init() {}

    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    private var counter: Int = 0

    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    func getCounter() -> Int {
            return counter
        }
}

extension LocalDataManager: LocalDataManagerProtocol {

    func getLikeProductsListFromCoreData(_ type: CoreDataProductType, completion: @escaping ([ProductVM]) -> ()) {
        var productsList: [ProductVM] = []
        var attributeName: String = ""
        var entityName: String = ""

        switch type {
        case .product:
            entityName = Constants.productsEntityName
            attributeName = Constants.productAttributes
        case .service:
            entityName = Constants.servicesEntityName
            attributeName = Constants.serviceAttributes
        case .cart:
            entityName = Constants.cartEntityName
            attributeName = Constants.cartAttributes
        }

        guard let managedContext = getContext() else { return }
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: entityName)

        do {
            let products = try managedContext.fetch(fetchReq)
            for i in products {
                guard let data = i.value(forKey: attributeName) else { continue }
                let decoder = JSONDecoder()
                if let loadedProduct = try? decoder.decode(ProductVM.self, from: data as! Data) {
                    productsList.append(loadedProduct)
                }
            }
        } catch {
            print("Failed to fetch products: \(error)")
        }

        completion(productsList)
    }
    
    func getCartServices(_ type: CoreDataProductType)-> [ProductVM]{
        var productsList: [ProductVM] = []
        var attributeName: String = ""
        var entityName: String = ""
        
        switch type {
        case .product:
            entityName = Constants.productsEntityName
            attributeName = Constants.productAttributes
        case .service:
            entityName = Constants.servicesEntityName
            attributeName = Constants.serviceAttributes
        case .cart:
            entityName = Constants.cartEntityName
            attributeName = Constants.cartAttributes
        }
        
        guard let managedContext = getContext() else { return [] }
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let products = try managedContext.fetch(fetchReq)
            for i in products {
                guard let data = i.value(forKey: attributeName) else { continue }
                let decoder = JSONDecoder()
                if let loadedProduct = try? decoder.decode(ProductVM.self, from: data as! Data) {
                    productsList.append(loadedProduct)
                }
            }
        } catch {
            print("Failed to fetch products: \(error)")
        }
        return productsList
    }


    func checkProductExist(_ productId: String, _ type: CoreDataProductType) -> Bool {
        var attributeName: String = ""
        var entityName: String = ""

        switch type {
        case .product:
            entityName = Constants.productsEntityName
            attributeName = Constants.productAttributes
        case .service:
            entityName = Constants.servicesEntityName
            attributeName = Constants.serviceAttributes
        case .cart:
            entityName = Constants.cartEntityName
            attributeName = Constants.cartAttributes
        }

        guard let managedContext = getContext() else { return false }

        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: entityName)
        var result = false

        do {
            let products = try managedContext.fetch(fetchReq)
            for i in products {
                guard let data = i.value(forKey: attributeName) else { continue }
                let decoder = JSONDecoder()
                if let loadedProduct = try? decoder.decode(ProductVM.self, from: data as! Data),
                   loadedProduct.productId == productId {
                    result = true
                    break
                }
            }
        } catch {
            print("Failed to check product existence: \(error)")
        }

        return result
    }

    func updateProductsListInCoreData(_ product: ProductVM, _ type: CoreDataProductType) {
        var attributeName: String = ""
        var entityName: String = ""

        switch type {
        case .product:
            entityName = Constants.productsEntityName
            attributeName = Constants.productAttributes
        case .service:
            entityName = Constants.servicesEntityName
            attributeName = Constants.serviceAttributes
        case .cart:
            entityName = Constants.cartEntityName
            attributeName = Constants.cartAttributes
        }

        guard let managedContext = getContext() else { return }

        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: entityName)

        do {
            let products = try managedContext.fetch(fetchReq)
            for i in products {
                guard let data = i.value(forKey: attributeName) else { continue }
                let decoder = JSONDecoder()
                if let loadedProduct = try? decoder.decode(ProductVM.self, from: data as! Data),
                   loadedProduct.productId == "\(product.productId)" {
                    
                    // ✅ بدلاً من الحذف، قم بتحديث العدد فقط
                    let encoder = JSONEncoder()
                    var updatedProduct = loadedProduct
                    updatedProduct.productCount = product.productCount  // تحديث العدد
                    print("Product Counnt =======================\( product.productCount )")
                    let updatedData = try encoder.encode(updatedProduct)

                    i.setValue(updatedData, forKey: attributeName)  // تحديث البيانات داخل Core Data
                    
                    break  // خروج بعد التحديث
                }
            }
            try managedContext.save()
        } catch {
            print("Failed to update products list: \(error)")
        }
    }

    func addLikeProductsToCoreData(productsList: ProductVM, _ type: CoreDataProductType) {
        var attributeName: String = ""
        var entityName: String = ""

        switch type {
        case .product:
            entityName = Constants.productsEntityName
            attributeName = Constants.productAttributes
        case .service:
            entityName = Constants.servicesEntityName
            attributeName = Constants.serviceAttributes
        case .cart:
            entityName = Constants.cartEntityName
            attributeName = Constants.cartAttributes
        }

        guard let managedContext = getContext() else { return }
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else { return }
        let productsData = NSManagedObject(entity: entity, insertInto: managedContext)

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(productsList) {
            productsData.setValue(encoded, forKey: attributeName)
        }

        do {
            try managedContext.save()
            if type == .product || type == .service {
                counter += 1
            }
            NotificationCenter.default.post(name: Notification.Name("chandedfav"), object: nil)
        } catch {
            print("Failed to add product to Core Data: \(error)")
        }
    }

    func deleteAllData(_ type: CoreDataProductType) {
        var entityName: String = ""

        switch type {
        case .product:
            entityName = Constants.productsEntityName
        case .service:
            entityName = Constants.servicesEntityName
        case .cart:
            entityName = Constants.cartEntityName
        }

        guard let managedContext = getContext() else { return }

        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: entityName)

        do {
            let products = try managedContext.fetch(fetchReq)
            for i in products {
                managedContext.delete(i)
            }
            try managedContext.save()
            NotificationCenter.default.post(name: Notification.Name("deleteall"), object: nil)
        } catch {
            print("Failed to delete all data: \(error)")
        }
    }

    func deleteProduct(_ productId: String, _ type: CoreDataProductType, completion: @escaping (Bool) -> ()) {
        let context = getContext()
        var entityName = ""
        var attributeName = ""

        switch type {
        case .product:
            entityName = Constants.productsEntityName
            attributeName = Constants.productAttributes
        case .service:
            entityName = Constants.servicesEntityName
            attributeName = Constants.serviceAttributes
        case .cart:
            entityName = Constants.cartEntityName
            attributeName = Constants.cartAttributes
        }

        guard let managedContext = context else {
            completion(false)
            return
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            let objects = try managedContext.fetch(fetchRequest)
            for object in objects {
                if let data = object.value(forKey: attributeName) as? Data {
                    let decoder = JSONDecoder()
                    if let product = try? decoder.decode(ProductVM.self, from: data),
                       product.productId == productId {
                        managedContext.delete(object)
                        try managedContext.save()
                        if counter != 0 {
                            if type == .product || type == .service {
                                counter -= 1
                            }
                        }
                        NotificationCenter.default.post(name: Notification.Name("chandedunfav"), object: nil)
                        print("Product Deleted Successfully")
                        completion(true)
                        return
                    }
                }
            }
            completion(false) // Product not found
        } catch {
            print("Error deleting product: \(error)")
            completion(false)
        }
    }

}

extension LocalDataManager {
    struct Constants {
        static let cartEntityName = "CartProducts"
        static let productsEntityName = "LikeProducts"
        static let servicesEntityName = "LikeServices"
        static let productAttributes = "likeProduct"
        static let serviceAttributes = "likeService"
        static let cartAttributes = "cartProduct"
    }
}

enum CoreDataProductType {
    case product
    case service
    case cart
}

