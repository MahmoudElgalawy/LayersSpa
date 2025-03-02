//
//  Branches.swift
//  LayersSpa
//
//  Created by 2B on 17/08/2024.
//

import Foundation

// MARK: - Branches
public struct Branches: Codable {
    let status: Bool
    let message: String
    let data: [BranchesData]?
}

// MARK: - Datum
public struct BranchesData: Codable {
    let branch: Branch?
    let vactionDays: [VactionDay]?

    enum CodingKeys: String, CodingKey {
        case branch
        case vactionDays = "vaction_days"
    }
}

// MARK: - Branch
public struct Branch: Codable {
    let id: Int?
    let name: String?
}

// MARK: - VactionDay
public struct VactionDay: Codable {
    let index: Int?
    let title: String?
}

