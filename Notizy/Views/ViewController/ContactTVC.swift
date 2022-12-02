//
//  ContactTableViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 09.09.22.
//

import UIKit
import CoreData

protocol ContactDelegate: AnyObject {
    func update(contact: Contact, index: Int)
}


class ContactTVC: UITableViewController {
    
    
  
    
    @IBOutlet var contactListTV: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Datengrundlage
    
    // var contacts: [ContactModel] = [ContactModel]()
    var meineKontakte:[Contact]?
    var filteredContacts: [Contact]!
    
    var selectedContact: Contact?
    
    // Referenz zum Core Data Persistent Store / managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        MARK: DataSource übergeben
        contactListTV.dataSource = self
        searchBar.delegate = self
        
        print(meineKontakte ?? "")
        
        
        // Navigation Bar einrichten
        title = "Kontakte"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(saveView))
        
        // Notification Center: Observer
        NotificationCenter.default.addObserver(self, selector: #selector(addNewContact(_ :)), name: NSNotification.Name.init("de.ViewsWechseln.addContact"), object: nil)
        
        fetchContacts()
        
        
        // Initialisierung des filtered Contacts Arrays
        filteredContacts = meineKontakte
        
        
        
    }
    
    
    // Fetch Contacts
    func fetchContacts() {
        
        // Fetching Data
        do {
            self.meineKontakte = try context.fetch(Contact.fetchRequest())
            print("fetchContact")
            print(self.meineKontakte!)
            filteredContacts = meineKontakte
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error by trying fetch request")
        }
        
    }
    
    //MARK: objc addNewContact
    @objc func addNewContact(_ notification: NSNotification) {
        
        // Re-fetch Data
        self.fetchContacts()
        
    }
    //MARK: addContactSegue f. BarButton
    @objc func saveView(){
        performSegue(withIdentifier: "saveView", sender: nil)
    }
    
    //MARK: deinit Notification Center
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("de.ViewsWechseln.addContact"), object: nil)
    }
    
    
}

//MARK: Extension_ DataSource
//TODO:  Protokol einfügen
// MARK: - Table view data source
//UITableViewDataSource
extension ContactTVC {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        print(filteredContacts[indexPath.row])
        
        // Cell registrieren
        let cell = contactListTV.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        // Inhalte / Eigenschaften der Cell anpassen
        var content = cell.defaultContentConfiguration()
        content.text = filteredContacts[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    override func tableView(_ tableView:UITableView, commit editingStyle:UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == .delete {
            if searchBar.text != ""{
                let contact:Contact = filteredContacts[indexPath.row]
                let index = meineKontakte!.firstIndex{ $0.name == contact.name}
                meineKontakte!.remove(at: index!)
                
                
                filteredContacts.remove(at: indexPath.row)
                contactListTV.deleteRows(at: [indexPath], with: .fade)
                
            }else {
                meineKontakte!.remove(at: indexPath.row)
                filteredContacts.remove(at: indexPath.row)
                contactListTV.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Prepare")
        print(sender!)
        print("***************")
        guard let destinationVC = segue.destination as? EditVC else { return }
        guard let selectedContact = sender as? Contact else { return }
       

        
        destinationVC.contact = selectedContact
       

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContact = meineKontakte![indexPath.row]
        print("****************_----****")
        print(selectedContact!)
        print("****************_----****")
        
        //        TODO: DetailSegue bearbeiten einrichten 27.09.22 muss noch gemacht werden
        
                performSegue(withIdentifier: "editView", sender: selectedContact)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
}

//MARK: extension: UISearchBarDelegate
extension ContactTVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredContacts = []
        
        if searchText == "" {
            filteredContacts = meineKontakte!
        } else {
            
            for contact in meineKontakte! {
                if contact.name!.lowercased().contains(searchText.lowercased()) {
                    filteredContacts.append(contact)
                }
            }
        }
        contactListTV.reloadData()
        
    }
    
}



