//
//  ViewController.swift
//  AddressBook
//
//  Created by Volodymyr Nazarkevych on 28.09.2022.
//

import UIKit

enum FileType {
    case XML
    case JSON
}

class ViewController: UIViewController, UISearchBarDelegate, UpdateMainViewContactDelegate, UpdateDetailViewContactDelegate {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var contacts: [Contact] = []
    private var elementName = String()
    private var filteredData: [Contact] = []
    private var sorted = false

    private var customerID = String()
    private var companyName = String()
    private var contactName = String()
    private var contactTitle = String()
    private var address = String()
    private var city = String()
    private var email = String()
    private var postalCode = String()
    private var country = String()
    private var phone = String()
    private var fax = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseXML()
        setupUI()
    }

    @IBAction private func addAction(_ sender: UIBarButtonItem) {
        guard let vc = UIStoryboard(name: "EditContact", bundle: nil).instantiateViewController(withIdentifier: "EditContactViewController") as? EditContactViewController else {
            return
        }
        vc.contact = Contact(customerID: "", companyName: "", contactName: "", contactTitle: "", address: "", city: "", email: "", postalCode: "", country: "", phone: "", fax: "")
        vc.openFromMain = true
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)

        navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @IBAction func filterAction(_ sender: UIBarButtonItem) {
        if sorted {
            filteredData = filteredData.sorted { $0.contactName > $1.contactName }
        } else {
            filteredData = filteredData.sorted { $0.contactName < $1.contactName }
        }
        sorted = !sorted
        tableView.reloadData()
        
    }
    
    @IBAction func importContact(_ sender: UIBarButtonItem) {
        // create the alert
        let alert = UIAlertController(title: "Allert", message: "What file type are you prefer?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "XML", style: UIAlertAction.Style.default, handler: { _ in
            self.saveContact(fileType: .XML)
        }))
        alert.addAction(UIAlertAction(title: "JSON", style: UIAlertAction.Style.default, handler: { _ in
            self.saveContact(fileType: .JSON)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(cellType: ContactTableViewCell.self)
    }
    
    private func parseXML() {
        if let path = Bundle.main.url(forResource: "ab", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
        filteredData = contacts
    }
    
    func updateContact(value: Contact?, indexPath: IndexPath) {
        guard let value = value else {
            contacts.remove(at: indexPath.row)
            filteredData = contacts
            searchBar.text = ""
            tableView.reloadData()
            return
        }
        filteredData[indexPath.row] = value
        for (index, contact) in contacts.enumerated() {
            if contact.id == value.id {
                contacts[index] = value
            }
        }
        tableView.reloadData()
    }
    
    func updateContact(value: Contact?) {
        guard let value = value else { return }
        contacts.append(value)
        filteredData = contacts
        searchBar?.text = ""
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? contacts : contacts.filter({contact in
            return contact.contactName.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func gatDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return dateFormatterGet.string(from: Date())
    }
    
    func saveContact(fileType: FileType) {
        let url = getDocumentsDirectory().appendingPathComponent(fileType == .XML ? "contact_\(gatDate()).xml" : "contact_\(gatDate()).json")
        let saveString = fileType == .XML ? createXML() : createJSON()
        
        do {
            try saveString.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createXML() -> String {
        var contacts = String()
        for contact in self.contacts {
            let content = """
            <Contact>
                <CustomerID>\(contact.customerID)</CustomerID>
                <CompanyName>\(contact.companyName)</CompanyName>
                <ContactName>\(contact.contactName)</ContactName>
                <ContactTitle>\(contact.contactTitle)</ContactTitle>
                <Address>\(contact.address)</Address>
                <City>\(contact.city)</City>
                <Email>\(contact.email)</Email>
                <PostalCode>\(contact.postalCode)</PostalCode>
                <Country>\(contact.country)</Country>
                <Phone>\(contact.phone)</Phone>
                <Fax>\(contact.fax)</Fax>
            </Contact>\n
            """
            contacts.append(content)
        }
        let testObject = """
            <AddressBook>
            \(contacts)
            </AddressBook>
            """
        return testObject
    }
    
    func createJSON() -> String {
        var contacts = String()
        for contact in self.contacts {
            let content = """
            {
                "customerID": "\(contact.customerID)",
                "companyName": "\(contact.companyName)",
                "contactName": "\(contact.contactName)",
                "contactTitle": "\(contact.contactTitle)",
                "address": "\(contact.address)",
                "city": "\(contact.city)",
                "email": "\(contact.email)",
                "postalCode": "\(contact.postalCode)",
                "country": "\(contact.country)",
                "phone": "\(contact.phone)",
                "fax": "\(contact.fax)",
            },
            """
            contacts.append(content)
        }
        let testObject = """
            {
                "addressBook": {
                    "contact": [
                                \(contacts)
                                ]
                            }
                        }
            """
        return testObject
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        return paths[0]
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.configCell(model: filteredData[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "ContactDetail", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as? ContactDetailViewController else {
            return
        }
        vc.contact = filteredData[indexPath.row]
        vc.indexPath = indexPath
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - XMLParserDelegate
extension ViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "Contact" {
            customerID = String()
            companyName = String()
            contactName = String()
            contactTitle = String()
            address = String()
            city = String()
            email = String()
            postalCode = String()
            country = String()
            phone = String()
            fax = String()
        }

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            switch self.elementName {
            case "CustomerID":
                customerID += data
            case "CompanyName":
                companyName += data
            case "ContactName":
                contactName += data
            case "ContactTitle":
                contactTitle += data
            case "Address":
                address += data
            case "City":
                city += data
            case "Email":
                email += data
            case "PostalCode":
                postalCode += data
            case "Country":
                country += data
            case "Phone":
                phone += data
            case "Fax":
               fax += data
            default:
                break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Contact" {
            let contact = Contact(customerID: customerID, companyName: companyName, contactName: contactName, contactTitle: contactTitle, address: address, city: city, email: email, postalCode: postalCode, country: country, phone: phone, fax: fax)
            self.contacts.append(contact)
        }
    }
}



