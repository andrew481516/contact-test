//
//  ContactTableViewCell.swift
//  AddressBook
//
//  Created by Volodymyr Nazarkevych on 28.09.2022.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    func configCell(model: Contact) {
        nameLabel.text = model.contactName
        print("")
    }
    
}
