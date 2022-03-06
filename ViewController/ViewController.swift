//
//  ViewController.swift
//  TodoApp
//
//  Created by Joshua on 05/03/2022.
//

import UIKit

class ViewController: UITableViewController {
    
    private var viewModel = NoteViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notelist.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        noteCell.titleLabel.text = viewModel.notelist[indexPath.row].title
        noteCell.detailsLabel.text = viewModel.notelist[indexPath.row].details
        
        return noteCell
    }
}

// MARK: - UITableViewDelegate
extension ViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let title = viewModel.notelist[indexPath.row].title
        let details = viewModel.notelist[indexPath.row].details
        if editingStyle == .delete {
            viewModel.deleteNote(title: title, details: details)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            guard let noteDetail = segue.destination as? NoteDetailsViewController else { return }
            
            let note : Note!
            note = viewModel.notelist[indexPath.row]
            noteDetail.myNote = note

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
