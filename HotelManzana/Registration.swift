//
//  Registration.swift
//  HotelManzana
//
//  Created by Антон Шалимов on 13.02.2023.
//

import Foundation

/// Registration model data to store client registration values
struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
}
