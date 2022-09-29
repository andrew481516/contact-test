//
//  ContactDetailViewController.swift
//  AddressBook
//
//  Created by Volodymyr Nazarkevych on 28.09.2022.
//

import UIKit
import MessageUI

protocol UpdateMainViewContactDelegate {
    func updateContact(value: Contact?, indexPath: IndexPath)
}

class ContactDetailViewController: UIViewController, UpdateDetailViewContactDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet private weak var customerID: UILabel!
    @IBOutlet private weak var companyName: UILabel!
    @IBOutlet private weak var contactName: UILabel!
    @IBOutlet private weak var contactTitle: UILabel!
    @IBOutlet private weak var address: UILabel!
    @IBOutlet private weak var city: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var postalCode: UILabel!
    @IBOutlet private weak var country: UILabel!
    @IBOutlet private weak var phone: UILabel!
    @IBOutlet private weak var fax: UILabel!

    var contact: Contact?
    var indexPath: IndexPath?
    var delegate: UpdateMainViewContactDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(didTapEdit))
        setupLabel()
        addPhoneCallOnTap()
        addEmainSend()
    }
        
    func updateContact(value: Contact?) {
        self.contact = value
        setupLabel()
        guard let indexPath = indexPath else { return }
        guard let value = value else {
            delegate?.updateContact(value: nil, indexPath: indexPath)
            navigationController?.popToRootViewController(animated: true)
            return
        }
        delegate?.updateContact(value: value, indexPath: indexPath)
    }
    
    func setupLabel() {
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
    
    func addPhoneCallOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(phoneTap))
        phone.isUserInteractionEnabled = true
        phone.addGestureRecognizer(tap)
    }
    
    func addEmainSend() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(emailTap))
        email.isUserInteractionEnabled = true
        email.addGestureRecognizer(tap)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - @objc func
    @objc func phoneTap(sender: UITapGestureRecognizer) {
        guard let numb = contact?.phone else { return }
        print(numb)
        guard let number = URL(string: "tel://" + numb) else { return }
        if UIApplication.shared.canOpenURL(number) {
            UIApplication.shared.open(number)
        } else {
            print("Can't open url on this device")
        }
    }
    
    @objc func emailTap(sender: UITapGestureRecognizer) {
        if MFMailComposeViewController.canSendMail(), let email = contact?.email {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["\(String(describing: email))"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            print("show failure alert")
        }
    }
    
    @objc func didTapEdit() {
        guard let vc = UIStoryboard(name: "EditContact", bundle: nil).instantiateViewController(withIdentifier: "EditContactViewController") as? EditContactViewController else {
            return
        }
        vc.contact = contact
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)

        navController.modalPresentationStyle = .overFullScreen
        navigationController?.present(navController, animated: false, completion: nil)
    }
}
