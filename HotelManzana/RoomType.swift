//
//  RoomType.swift
//  HotelManzana
//
//  Created by Антон Шалимов on 13.02.2023.
//

import Foundation

/// Model RoomType to store hotel room type data
struct RoomType: Equatable {
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    /// Static variable that will store the same info across all instances of RoomType
    static var all: [RoomType] {
        return [
            RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
            RoomType(id: 1, name: "One King", shortName: "K", price: 209),
            RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309),
        ]
    }
    
    /// Equatable method delegate
    /// - Parameters:
    ///   - lhs: Room type
    ///   - rhs: Room type
    /// - Returns: Returns true if room type ID's are equal
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
}
