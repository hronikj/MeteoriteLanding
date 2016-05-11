//
//  MeteoriteCollection.swift
//  MeteoriteLanding
//
//  Created by Jiří Hroník on 11/05/16.
//  Copyright © 2016 Jiří Hroník. All rights reserved.
//

import Foundation

class MeteoriteCollection {
    var data: [Meteorite] = []
    
    enum sortOptions {
        case byYear
        case byMass
    }
    
    init(meteoriteCollection: [Meteorite]) {
        self.data = meteoriteCollection
    }
    
    init() {
        
    }
    
    func sortCollection(options: sortOptions) {
        switch options {
        case .byMass:
            self.data.sortInPlace({ $0.mass < $1.mass })
        case .byYear:
            self.data.sortInPlace({ $0.dateOfImpact.compare($1.dateOfImpact) == .OrderedAscending })
        }
    }
}