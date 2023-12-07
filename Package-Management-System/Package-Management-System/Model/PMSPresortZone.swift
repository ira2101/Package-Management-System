//
//  PMSLoadingZone.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/6/23.
//

import Foundation

/// Each of these zones holds a specific category of items. These zones were chosen
/// in order to minimize the probability for package loss.
class PMSPresortZone: PMSZone {
    
    /// The type of items that we are putting into this zone
    var category: PMSCategory
            
    init(category: PMSCategory, batchSize: Int) {
        self.category = category
        super.init(batchSize: batchSize)
    }
    
    override func enqueue(package: PMSPackage) throws {
        try super.enqueue(package: package)
        
        package.status = .inPresortZone(self, .now)
    }
    
}

