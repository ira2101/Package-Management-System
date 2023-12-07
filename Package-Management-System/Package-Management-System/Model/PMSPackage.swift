//
//  PMSPackage.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/5/23.
//

import Foundation

class PMSPackage: Equatable {
    
    static func == (lhs: PMSPackage, rhs: PMSPackage) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    
    /// This outlines the pipleline that the package will follow as it goes from entering the facility
    /// to being shipped
    enum Status {
        
        /// The package was first checked-in to the facility
        case enteredFacility(Date)
        
        /// The package is in a loading zone, waiting to be processed
        case inPresortZone(PMSPresortZone, Date)
        
        /// The package is processed as soon as it enters the facility
        case inHoldingZone(PMSHoldingZone, Date)
        
        /// After it is processed, then it is ready to ship
        case inShippingZone(PMSShippingZone, Date)
        
        /// The package has been shipped
        case shipped(Date)
                        
        /// The package was lost at some point
        case lost(Date)
        
    }
    
    /// The different sizes a package can be
    enum Size: CaseIterable {
        case small
        case medium
        case large
    }
    
    /// The content that the package contains. Assumed general, electronics, and perishables for
    /// simplicity
    enum ContentType: CaseIterable {
        
        /// Accounts for most goods
        case general
        
        /// The package contains electronics
        case electronics
        
        /// The package contains perishables
        case perishables
        
    }
            
    /// The stage in the pipeline that the package is at
    var status: Status {
        didSet {
            switch status {
            case .lost:
                // Update the facility that the package has been lost
                facility?.packageLost()
            case .shipped:
                // Update the facility that the package has been shipped
                facility?.packageShipped()
            default:
                break
            }
        }
    }
    
    /// The facility the package belongs to
    weak var facility: PMSFacility?
    
    /// The size of the package (S, M, or L)
    var size: Size
    
    /// The contents of the package
    var contentType: ContentType
    
    /// Whether the package is fragile
    var isFragile: Bool
    
    /// The employees that have touched this package
    var handlers: [PMSEmployee]
    
    /// Whether the package is actively being handled. We don't want two employees
    /// handling the same package at the same time
    var isBeingHandled: Bool
    
    /// The shipping route the package is on
    var route: PMSShippingRoute
    
//    /// The probability that this package is going to be lost
//    var probabilityOfLoss: Double {
//        get {
//            // The more people that touch the package, the more likely it will be lost
//            let handlerFactor = Double(handlers.count) * 0.005
//
//            // A fragile package is more likely to be broken, and therefore, lost
//            let fragilityFactor = isFragile ? 0.005 : 0.0
//
//            // Smaller packages may be more likely to be mishandled
//            let sizeFactor: Double
//            switch size {
//            case .small:
//                sizeFactor = 0.005
//            case .medium:
//                sizeFactor = 0.002
//            case .large:
//                sizeFactor = 0.001
//            }
//
//            return handlerFactor + fragilityFactor + sizeFactor
//        }
//    }
    
    /// The probability that this package is going to be lost
    var probabilityOfLoss: Double {
        get {
            // The more people that touch the package, the more likely it will be lost
            let handlerFactor = Double(handlers.count) * 0.05
            
            // A fragile package is more likely to be broken, and therefore, lost
            let fragilityFactor = isFragile ? 0.05 : 1.0
            
            // Smaller packages may be more likely to be mishandled
            let sizeFactor: Double
            switch size {
            case .small:
                sizeFactor = 0.05
            case .medium:
                sizeFactor = 0.02
            case .large:
                sizeFactor = 0.01
            }

            return handlerFactor * fragilityFactor * sizeFactor
        }
    }
    
    init(facility: PMSFacility, size: PMSPackage.Size, contentType: PMSPackage.ContentType, isFragile: Bool, route: PMSShippingRoute) {
        self.facility = facility
        self.size = size
        self.contentType = contentType
        self.isFragile = isFragile
        self.route = route
        
        status = .enteredFacility(.now)
        handlers = []
        isBeingHandled = false
    }
    
    /// Determines whether the package can be handled by an employee
    func canBeHandled() -> Bool {
        return !isLost() && !isBeingHandled
    }
    
    /// Determines whether the package is lost
    func isLost() -> Bool {
        switch status {
        case .lost:
            return true
        default:
            return false
        }
    }
    
    /// When an employee starts handling a package
    func startHandling(employee: PMSEmployee) {
        isBeingHandled = true
        handlers.append(employee)
    }
    
    /// When an employee finishes handling a package
    func finishHandling() {
        isBeingHandled = false
    }
            
    static func generate(facility: PMSFacility) -> PMSPackage {
        let size = Size.allCases[Int.random(in: 0..<Size.allCases.count)]
        
        let contentType = ContentType.allCases[Int.random(in: 0..<ContentType.allCases.count)]
        
        let isFragile = Bool.random()
        
        let route = PMSShippingRoute.allCases[
            Int.random(in: 0..<PMSShippingRoute.allCases.count)
        ]
                
        return PMSPackage(
            facility: facility,
            size: size,
            contentType: contentType,
            isFragile: isFragile,
            route: route
        )
    }
    
}
