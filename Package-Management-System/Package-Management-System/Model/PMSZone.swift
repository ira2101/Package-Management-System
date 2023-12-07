//
//  PMSZone.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/6/23.
//

import Foundation

class PMSZone: ObservableObject {
    
    /// The number of packages that can fit in this zone
    let batchSize: Int
    
    /// The queue of packages
    @Published var packageQueue: [PMSPackage]
    
    /// The packages that were lost in this zone
    @Published var lostPackages: [PMSPackage]
    
    @Published var packageCount: Int
    
    /// The number of packages somewhere in this zone, both ones that are lost and
    /// ones that are in the queue
    var packagesInZoneCount: Int {
        get {
            return packageQueue.count + lostPackages.count
        }
    }
        
    init(batchSize: Int) {
        self.batchSize = batchSize
        packageQueue = []
        lostPackages = []
        packageCount = 0
    }
    
    /// Add a package to the end of the queue. Throw if the queue is already full
    func enqueue(package: PMSPackage) throws {
        if packageQueue.count >= batchSize {
            throw PMSZoneError.noAvailableRoom
        }
        
        packageQueue.append(package)
        
        packageCount += 1
    }
    
    /// Dequeue a package. Return nil if the queue is empty, or no package can be handled
    func dequeue() -> PMSPackage? {
        let package = packageQueue.first(where: {
            $0.canBeHandled()
        })
        
        guard let package = package else {
            return nil
        }
        
        if let index = packageQueue.firstIndex(of: package) {
            packageQueue.remove(at: index)
        }
        else {
            return nil
        }
        
        packageCount -= 1
        return package
    }
    
    /// A package was lost in this zone
    func insertLostPackage(_ package: PMSPackage) {
        lostPackages.append(package)
        package.status = .lost(.now)
        
        packageCount += 1
    }
    
}
