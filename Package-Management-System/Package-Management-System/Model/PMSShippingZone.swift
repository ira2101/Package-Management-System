//
//  PMSShippingZone.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/6/23.
//

import Foundation

class PMSShippingZone: PMSZone {
    
    let route: PMSShippingRoute
    
    var nextShippingDate: Date
    
    private var timer: Timer?
    
    init(route: PMSShippingRoute, batchSize: Int) {
        self.route = route
        nextShippingDate = .now.addingTimeInterval(5)
        
        super.init(batchSize: batchSize)
        
        timer = Timer.scheduledTimer(
            timeInterval: 5,
            target: self,
            selector: #selector(shipBatchOfPackages),
            userInfo: nil,
            repeats: true
        )
    }
    
    override func enqueue(package: PMSPackage) throws {
        try super.enqueue(package: package)
        
        package.status = .inShippingZone(self, .now)
    }
                
    @objc func shipBatchOfPackages() {
        let numberOfPackagesToShip = min(batchSize, packageQueue.count)
        
        for _ in 0..<numberOfPackagesToShip {
            if let package = self.dequeue() {
                package.status = .shipped(.now)
            }
        }
        
        // The packages have left the facility!
        
        if let timer = timer {
            nextShippingDate = timer.fireDate
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
