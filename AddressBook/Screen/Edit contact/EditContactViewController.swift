//
//  EditContactViewController.swift
//  AddressBook
//
//  Created by Volodymyr Nazarkevych on 28.09.2022.
//

import UIKit

protocol UpdateDetailViewContactDelegate {
    func updateContact(value: Contact?)
}

class EditContactViewController: UIViewController {
    
    @IBOutlet private weak var customerID: UITextField!
    @IBOutlet private weak var companyName: UITextField!
    @IBOutlet private weak var contactName: UITextField!
    @IBOutlet private weak var contactTitle: UITextField!
    @IBOutlet private weak var address: UITextField!
    @IBOutlet private weak var city: UITextField!
    @IBOutlet private weak var email: UITextField!
    @IBOutlet private weak var postalCode: UITextField!
    @IBOutlet private weak var country: UITextField!
    @IBOutlet private weak var phone: UITextField!
    @IBOutlet private weak var fax: UITextField!
    @IBOutlet private weak var deleteContact: UIButton!
    
    var contact: Contact?
    var delegate: UpdateDetailViewContactDelegate?
    var openFromMain = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        delegate?.updateContact(value: nil)
        dismiss(animated: openFromMain ? true : false)
    }
    
    func setupController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(didTapDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        deleteContact.layer.cornerRadius = 5
        deleteContact.isHidden = openFromMain ? true : false
        
        customerID.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        companyName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contactName.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        contactTitle.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        address.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        city.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        email.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        postalCode.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        country.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phone.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        fax.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        customerID.text = contact?.customerID
        companyName.text = contact?.companyName
        contactName.text = contact?.contactName
        contactTitle.text = contact?.contactTitle
        address.text = contact?.address
        city.text = contact?.city
        email.text = contact?.email
        postalCode.text = contact?.postalCode
        country.text = contact?.country
        phone.text = contact?.phone
        fax.text = contact?.fax
    }
    
    // MARK: - @objc func
    @objc func didTapDone() {
        contact?.customerID = (customerID.text == "" ? "emty" : customerID.text) ?? ""
        contact?.companyName = (companyName.text == "" ? "emty" : companyName.text) ?? ""
        contact?.contactName = (contactName.text == "" ? "emty" : contactName.text) ?? ""
        contact?.contactTitle = (contactTitle.text == "" ? "emty" : contactTitle.text) ?? ""
        contact?.address = (address.text == "" ? "emty" : address.text) ?? ""
        contact?.city = (city.text == "" ? "emty" : city.text) ?? ""
        contact?.email = (email.text == "" ? "emty" : email.text) ?? ""
        contact?.postalCode = (postalCode.text == "" ? "emty" : postalCode.text) ?? ""
        contact?.country = (country.text == "" ? "emty" : country.text) ?? ""
        contact?.phone = (phone.text == "" ? "emty" : phone.text) ?? ""
        contact?.fax = (fax.text == "" ? "emty" : fax.text) ?? ""
        
        delegate?.updateContact(value: contact)
        dismiss(animated: false)
    }
    
    @objc func didTapCancel() {
        dismiss(animated: openFromMain ? true : false)
    }
    
    @objc func textFieldDidChange() {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
