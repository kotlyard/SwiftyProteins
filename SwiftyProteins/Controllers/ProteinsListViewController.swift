//
//  ProteinsListViewController.swift
//  SwiftyProteins
//
//  Created by Denis KOTLYAR on 5/30/19.
//  Copyright © 2019 Denis KOTLYAR. All rights reserved.
//

import UIKit

class ProteinsListViewController: UITableViewController {

    // - Mark: Variables
    var proteinsList =   [String]()
    var filteredProteins =   [String]()
    var molecule: Molecule? = nil
  
    
    // - Mark: Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        parseProteinsListFile()
        filteredProteins = proteinsList
    }
 
    
    // - Mark: Actions
    @IBAction func randomProteinChoice(_ sender: UIBarButtonItem) {
        let randomRow = Int.random(in: 0...filteredProteins.count - 1)
        getProteinModel(with: filteredProteins[randomRow])
    }
    
    @IBAction func toTop(_ sender: Any) {
        self.tableView.setContentOffset(CGPoint(x: 0, y: -(self.view.bounds.height * 0.1)), animated: true)
    }
    
    
    // - Mark: Private Functions
    private func parseProteinsListFile() {
        
        if let path = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            do {
                let allProteinsList = try String(contentsOfFile: path)
                self.proteinsList = allProteinsList.components(separatedBy: CharacterSet.newlines).filter( { !$0.isEmpty } )
            }
            catch { fatalError(error.localizedDescription) }
        }
        else { fatalError("ligands.txt is not found") }
        
    }
    
    private func getProteinModel(with name: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.view.endEditing(true)
        self.turnOffInterface()
        NetworkController.requestMolecule(with: name) { moleculeString in
            if moleculeString.isEmpty {
                self.showAlert(with: "There was an error downloading molecule model")
            } else {
                self.molecule = NetworkController.parseMolecule(with: moleculeString)
                self.performSegue(withIdentifier: "toProteinModel", sender: nil)
            }
            self.turnOnInterface()
        }
    }
}



// - MARK: Navigation
extension ProteinsListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProteinModel" {
            if let dest = segue.destination as? ProteinModelViewController {
                dest.molecule = molecule
                dest.title = molecule?.name
            }
        }
    }
}



// - MARK: TableView Delegating
extension ProteinsListViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.getProteinModel(with: cell?.textLabel?.text ?? "011")
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



// - MARK: SearchBar delegating
extension ProteinsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            filteredProteins = proteinsList.filter( { $0.lowercased().contains(searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased()) } )
        } else {
            filteredProteins = proteinsList
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
       
    }
}


extension ProteinsListViewController {
    func turnOnInterface() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            self.view.layer.opacity = 1
        }
        
    }
    
    func turnOffInterface() {
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            self.view.layer.opacity = 0.6
        }
    }
}
