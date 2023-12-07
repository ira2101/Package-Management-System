//
//  PMSStagingZone.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/6/23.
//

import Foundation

class PMSHoldingZone: PMSZone {
    
    let route: PMSShippingRoute
            
    init(route: PMSShippingRoute, batchSize: Int) {
        self.route = route
        super.init(batchSize: batchSize)
    }
    
    override func enqueue(package: PMSPackage) throws {
        try super.enqueue(package: package)
        
        package.status = .inHoldingZone(self, .now)
    }
    
}
