//
//  ProteinsListViewController.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/30/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import UIKit

class ProteinsListViewController: UITableViewController {

    //variables
    var proteinsList =   [String]()
    var filteredProteins =   [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseProteinsListFile()
        filteredProteins = proteinsList
    }
 
    @IBAction func toTop(_ sender: Any) {
        self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.view.bounds.height * 0.1)), animated: true)
    }
    
    func parseProteinsListFile() {
        
        if let path = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            do {
                let allProteinsList = try String(contentsOfFile: path)
                self.proteinsList = allProteinsList.components(separatedBy: CharacterSet.newlines).filter( { !$0.isEmpty } )
            
                print(self.proteinsList)
            }
            catch { fatalError(error.localizedDescription) }
        }
        else { fatalError("ligands.txt is not found") }
        
    }
    
}

// TableView Delegating
extension ProteinsListViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
            self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProteins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "proteinNameCell") {
            cell.textLabel?.text = filteredProteins[indexPath.row]
            return cell
        }
       return UITableViewCell()
    }
}

// SearchBar delegating
extension ProteinsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            filteredProteins = proteinsList.filter( { $0.contains(searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) } )
        } else {
            filteredProteins = proteinsList
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
       
    }
}


