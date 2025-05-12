//
//  CarFilter.swift
//  final
//
//  Created by Алан Абзалханулы on 11.05.2025.
//
import SwiftUI

struct CarFilter: Encodable {
    var brandID: String?
    var seriesID: String?
    var generationID: String?
    var minMileage: Int?
    var maxMileage: Int?
    var isNew: Bool?
    var page: Int = 1
    
    func asQuery() -> [String: String] {
        var q: [String: String] = ["page": "\(page)"]
        if let brandID     { q["brand"]        = brandID }
        if let minMileage  { q["mileageMin"]   = "\(minMileage)" }
        if let maxMileage  { q["mileageMax"]   = "\(maxMileage)" }
        if let isNew       { q["isNew"]        = isNew ? "true" : "false" }
        return q
    }
}
