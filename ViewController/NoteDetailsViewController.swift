//
//  NoteDetailsViewController.swift
//  TodoApp
//
//  Created by Joshua on 06/03/2022.
//

import Foundation
import UIKit


class NoteDetailsViewController: UIViewController {
    private var viewModel = NoteViewModel()
    var myNote: Note? = nil

    @IBOutlet private weak var titleTextField: UITextField!
    
    @IBOutlet private weak var detailsTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.isEnabled = false
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupNote()
        
        let tap = UIGestureRecognizer(target: self.view,
                                      action: #selector(UIView.endEditing))
        
        view.addGestureRecognizer(tap)
    }

    
    @IBAction private func saveNote(_ sender: Any) {
        guard let title = titleTextField.text,
              let details = detailsTextView.text else { return }

         if (myNote == nil){
         self.viewModel.addNote(title: title, details: details)
         navigationController?.popViewController(animated: true)
         } else {
             editNote()
         }
    }

    @IBAction private func deleteNote(_ sender: Any) {
        guard let title = titleTextField.text,
              let details = detailsTextView.text else { return }
        
        for notes in viewModel.notelist {
            let note = notes
            if note == myNote {
                self.viewModel.deleteNote(title: title, details: details)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func editNote() {
         guard let title = titleTextField.text,
               let details = detailsTextView.text else { return }
        self.viewModel.editNote(title: title, details: details)
            navigationController?.popViewController(animated: true)
    }

    private func setupNote() {
        if myNote != nil {
            titleTextField.text = myNote?.title
            detailsTextView.text = myNote?.details
            saveButton.isEnabled = true
        }
    }

    func controlButtons(title: String) {
        saveButton.isEnabled = title.isEmptyString() ? false : true
    }
}

extension NoteDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard titleTextField != nil,
              let text = titleTextField.text else { return false }
        controlButtons(title: text)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            guard let text = textField.text else { return }
            controlButtons(title: text)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        saveButton.isEnabled = false
        return true
    }
}

extension NoteDetailsViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         guard titleTextField != nil,
               let text = titleTextField.text else { return false }
            controlButtons(title: text)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = titleTextField.text else { return }
        controlButtons(title: text)
    }
}
