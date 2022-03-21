//
//  StringExtension.swift
//  TodoApp
//
//  Created by Joshua on 06/03/2022.
//

import Foundation


extension String {
    func isEmptyString() -> Bool {
        let trimmedString = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString.count == 0
    }
}
