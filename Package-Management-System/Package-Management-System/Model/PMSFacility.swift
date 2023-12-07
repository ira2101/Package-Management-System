//
//  PMSFacility.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/5/23.
//

import Foundation

class PMSFacility: ObservableObject {
        
    /// A list of all packages managed by the facility
    var packages: [PMSPackage]
    
    /// The employees of the facility
    var employees: [PMSEmployee]
    
    /// The packages that just entered the facility
    @Published var entryZone: PMSEntryZone
    
    /// There is a presort zone for each category. Time here is no more than a few hours
    @Published var presortZones: [PMSCategory : PMSPresortZone]
    
    /// There is a holding zone for each shipping route. Time here can be up to days
    @Published var holdingZones: [PMSShippingRoute : PMSHoldingZone]
    
    /// There is a shipping zone for each shipping route. Time here is no more than a few hours
    @Published var shippingZones: [PMSShippingRoute : PMSShippingZone]
    
    /// The number of packages that have shipped from this facility
    @Published var numberOfPackagesShipped: Int
    
    /// The number of packages that have been lost in this facility
    @Published var numberOfPackagesLost: Int
        
    /// The overall health of the facility, determined by the amount of package loss
    var health: Double {
        get {
            return Double(numberOfPackagesShipped) / Double(numberOfPackagesShipped + numberOfPackagesLost)
        }
    }
        
    init(employeeCount: Int, packageCount: Int) {
        packages = []
        employees = []
        entryZone = PMSEntryZone(batchSize: packageCount)
        presortZones = [:]
        holdingZones = [:]
        shippingZones = [:]
        numberOfPackagesShipped = 0
        numberOfPackagesLost = 0
        
        initializeZones(packageCount)
        initializeEmployees(employeeCount)
        initializePackages(packageCount)
    }
        
    private func initializeZones(_ packageCount: Int) {
        // For batch sizes, I figure holding zones can fit the most packages at a time, presorting
        // zones next, and shipping zones last
        for category in PMSCategory.allCases {
            presortZones[category] = PMSPresortZone(category: category, batchSize: packageCount / 4)
        }
        
        for route in PMSShippingRoute.allCases {
            holdingZones[route] = PMSHoldingZone(route: route, batchSize: packageCount / 2)
            shippingZones[route] = PMSShippingZone(route: route, batchSize: packageCount / 8)

        }
    }
    
    private func initializeEmployees(_ employeeCount: Int) {
        var presortZoneIndex = 0
        var holdingZoneIndex = 0
        
        // Evenly distribute the number of employees between roles. Some roles
        // may require more employees than others, but that is worked out
        // as the simulation progresses
        var count = 0
        while count < employeeCount {
            if count < employeeCount {
                let employee = PMSEmployee(role: .presorter(entryZone), facility: self)
                employees.append(employee)
                count += 1
            }
            
            if count < employeeCount {
                let category = PMSCategory.allCases[presortZoneIndex]
                let employee = PMSEmployee(role: .onboarder(presortZones[category]!), facility: self)
                employees.append(employee)
                count += 1
                
                // get the next role ready
                presortZoneIndex += 1
                if presortZoneIndex == PMSCategory.allCases.count {
                    presortZoneIndex = 0
                }
            }
            
            if count < employeeCount {
                let shippingRoute = PMSShippingRoute.allCases[holdingZoneIndex]
                let employee = PMSEmployee(role: .shipper(holdingZones[shippingRoute]!), facility: self)
                employees.append(employee)
                count += 1
                
                // get the next role ready
                holdingZoneIndex += 1
                if holdingZoneIndex == PMSShippingRoute.allCases.count {
                    holdingZoneIndex = 0
                }
            }
        }
    }
        
    private func initializePackages(_ packageCount: Int) {
        packages = (0..<packageCount).map { _ in
            let package = PMSPackage.generate(facility: self)
            
            try! entryZone.enqueue(package: package)
            
            return package
        }
    }
    
    /// The facility has lost a package
    func packageLost() {
        numberOfPackagesLost += 1
    }
    
    /// The facility has shipped a package
    func packageShipped() {
        numberOfPackagesShipped += 1
    }
        
}
