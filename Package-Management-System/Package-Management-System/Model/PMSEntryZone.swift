//
//  PMSEntryZone.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/6/23.
//

import Foundation

class PMSEntryZone: PMSZone {
    
    override func enqueue(package: PMSPackage) throws {
        try super.enqueue(package: package)
        
        package.status = .enteredFacility(.now)
    }
    
}
