//
//  File.swift
//  
//
//  Created by marwa on 13/08/2024.
//

import Foundation
import Alamofire

public struct Connectivity {

    private init() {}
    static let sharedInstance = NetworkReachabilityManager()!
    public static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}



