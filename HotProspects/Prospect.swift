//
//  Prospect.swift
//  HotProspects
//
//  Created by Mark Booth on 29/12/2019.
//  Copyright © 2019 Mark Booth. All rights reserved.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "HPSavedData"
    init() {
        if let data = UserDefaults.standard.data(forKey: Prospects.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
            
        }
        
        self.people = []
    }
    
    private func save()  {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Prospects.saveKey)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
