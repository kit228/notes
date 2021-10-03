//
//  UserDefaultsService.swift
//  notes-kitchenko
//
//  Created by Вениамин Китченко on 03.10.2021.
//

import Foundation

let kKeyNotesForUserDefaults = "userDefaultsNotes"

final class UserDefaultsService {
    
    private let userDefaults = UserDefaults.standard
    
    func saveNotesToUserDefaults(notes: [Note]) {
        let stringNotesArray = notes.compactMap { $0.text }
        userDefaults.setValue(stringNotesArray, forKey: kKeyNotesForUserDefaults)
    }
    
    func loadNotesFromUserDefaults() -> [Note] {
        guard let arrayOfString = userDefaults.value(forKey: kKeyNotesForUserDefaults) as? [String] else { return [] }
        return arrayOfString.map { Note(text: $0) }
    }
    
    func deleteAllNotesFromUserDefaults() {
        userDefaults.setValue(nil, forKey: kKeyNotesForUserDefaults)
    }
    
}
