//
//  PMSEmployee.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/5/23.
//

import Foundation

class PMSEmployee {
    
    enum Role {
        
        /// Handles packages that are just entered into the facility
        case presorter(PMSEntryZone)
        
        /// Moves packages of a specific presort zone and puts them in the right holding zone
        case onboarder(PMSPresortZone)
        
        /// Moves packages of a specific holding zone and puts them in the right shipping zone
        case shipper(PMSHoldingZone)
            
    }
    
    /// The role of the employee
    var role: Role
        
    /// The facility the employee belongs to. Necessary to have when the employee
    /// needs to handle packages
    weak var facility: PMSFacility?
    
    /// How efficient this employee is. We decide this randomly. 0.5 = lowest efficiency,
    /// 1.0 = highest efficiency
    private var efficiency: Double
    
    /// The employee processes a package every time the timer fires
    private var timer: Timer?
    
    /// Determines how long of a break the employee gets
    private var breakTimer: Timer?
    
    /// Determines whether the employee is taking a break
    private var isTakingBreak: Bool
    
    /// If an employee is unable to finish processing the package they are working on, then
    /// they will remember it, so that they can process this package before moving on to another one.
    /// This reduces the probabilty of loss because an employee is only focusing on one package
    /// at a time
    /// which minimizes the chance of a loss
    private var pendingPackage: PMSPackage?
    
    init(role: Role, facility: PMSFacility) {
        self.role = role
        self.facility = facility
        efficiency = Double.random(in: 0.5...1)
        isTakingBreak = false
                
        timer = Timer.scheduledTimer(
            timeInterval: 1 - efficiency,
            target: self,
            selector: #selector(processPackage),
            userInfo: nil,
            repeats: true
        )
    }
    
    /// We will presort the packages after they enter the facility and place them in loading zones
    /// before they are onboarded. This way, we can ensure that employees are handling packages
    /// of similar types, which reduces the chance of someone mshandling or losing a package.
    ///
    /// Packages are sorted into priority loading zones. From highest to lowest priority: Perishables,
    /// Fragiles, Large Items, General.
    ///
    /// If there is an overlap, meaning a package fits multiple categories, then we will take priority
    /// into account.
    private func presortPackage(_ package: PMSPackage) throws {
        guard let facility = facility else {
            return
        }
                        
        // If the package has not just entered the facility and it is
        // being presorted, then something has gone wrong
        switch package.status {
        case .enteredFacility:
            break
        default:
            throw PMSPackageMishandledError.packageMishandled
        }
                
        // Enter the package into the correct persort zone, by priority
        if package.contentType == .perishables {
            try facility.presortZones[.perishables]?.enqueue(package: package)
        }
        else if package.isFragile {
            try facility.presortZones[.fragileItems]?.enqueue(package: package)
        }
        else if package.size == .large {
            try facility.presortZones[.largeItems]?.enqueue(package: package)
        }
        else {
            try facility.presortZones[.general]?.enqueue(package: package)
        }
    }
    
    /// Onboard the package and put it into the correct holding zone
    private func onboardPackage(_ package: PMSPackage) throws {
        guard let facility = facility else {
            return
        }
        
        switch package.status {
        case .inPresortZone:
            // Do whatever onboarding is necessary. Add extra labels, etc...
            
            // Insert it into the correct holding zone
            try facility.holdingZones[package.route]?.enqueue(package: package)
        default:
            // If the package is not in the presort zone and it is being onboarded,
            // then something has gone wrong
            throw PMSPackageMishandledError.packageMishandled
        }
    }
    
    /// Put the package into the correct shipping zone to be delivered
    private func shipPackage(_ package: PMSPackage) throws {
        guard let facility = facility else {
            return
        }

        switch package.status {
        case .inHoldingZone:
            // Insert it into the correct shipping zone
            try facility.shippingZones[package.route]?.enqueue(package: package)
        default:
            // If the package is not in the onboarding zone and it is being shipped,
            // then something has gone wrong
            throw PMSPackageMishandledError.packageMishandled
        }
    }
    
    private func handlePackage() -> PMSPackage? {
        // Process the pending package, if one exists, before processing
        // another package.
        if let pendingPackage = pendingPackage {
            self.pendingPackage = nil
            return pendingPackage
        }
        
        // Find a new package to process
        let package: PMSPackage?
        
        switch role {
        case .presorter(let entryZone):
            package = entryZone.dequeue()
        case .onboarder(let presortZone):
            package = presortZone.dequeue()
        case .shipper(let holdingZone):
            package = holdingZone.dequeue()
        }
        
        // Mark that the package is being handled
        package?.startHandling(employee: self)
        
        return package
    }
        
    /// Process the package at the given stage in the pipeline. Throw an error if
    /// the package was lost
    @objc func processPackage() {
        if isTakingBreak {
            return
        }
                
        // Find a package to process, or return if we can't find one
        guard let package = handlePackage() else {
            return
        }
                    
        do {
            // Something went wrong and the package was lost
            if Double.random(in: 0...efficiency) <= package.probabilityOfLoss {
                throw PMSPackageMishandledError.packageLost
            }

            switch role {
            case .presorter:
                try presortPackage(package)
            case .onboarder:
                try onboardPackage(package)
            case .shipper:
                try shipPackage(package)
            }

            // Done handling the package
            package.finishHandling()
        }
        catch let error as PMSPackageMishandledError {
            switch error {
            case .packageLost:
                markLostPackage(package)
            case .packageMishandled:
                markLostPackage(package)
            }
        }
        catch let error as PMSZoneError {
            // Unable to take the package out of its current zone and
            // insert it into a new zone. Remember it so we can process
            // it next
            pendingPackage = package

            switch error {
            case .noAvailableRoom:
                // There's no more room to move packages. Take a little
                // break to regain efficiency. More packages will arrive soon.
                startBreak()
                break
            default:
                break
            }
        } catch {
            // Nothing else to catch
        }
    }
    
    /// Mark the package as lost in the zone where it was lost
    func markLostPackage(_ package: PMSPackage) {
        switch role {
        case .presorter(let entryZone):
            entryZone.insertLostPackage(package)
        case .onboarder(let presortZone):
            presortZone.insertLostPackage(package)
        case .shipper(let holdingZone):
            holdingZone.insertLostPackage(package)
        }
    }
    
    /// If the employee is phyiscally unable to process the next package,
    /// due to some holdup, then they can take a break to regain energy.
    /// This keeps employees efficient and reduces the chance of them losing
    /// a package
    private func startBreak() {
        isTakingBreak = true
        
        // Invalidate the current timer, if one exists
        breakTimer?.invalidate()
        
        breakTimer = Timer(
            timeInterval: Double.random(in: 0...0.5),
            target: self,
            selector: #selector(finishBreak),
            userInfo: nil,
            repeats: false
        )
        
        breakTimer?.fire()
    }
    
    /// Finish break and get back to work
    @objc func finishBreak() {
        // Gain some efficiency back
        let boost = Double.random(in: 0..<0.1)
        
        // You can't be more efficient than 'maximum efficiency'
        efficiency = min(1.0, efficiency + boost)
                
        isTakingBreak = false
    }
            
    deinit {
        timer?.invalidate()
        breakTimer?.invalidate()
    }
    
}
