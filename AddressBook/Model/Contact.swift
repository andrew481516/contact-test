//
//  Contact.swift
//  AddressBook
//
//  Created by Volodymyr Nazarkevych on 28.09.2022.
//

import Foundation

struct Contact {
    let id = UUID()
    var customerID: String
    var companyName: String
    var contactName: String
    var contactTitle: String
    var address: String
    var city: String
    var email: String
    var postalCode: String
    var country: String
    var phone: String
    var fax: String
}
