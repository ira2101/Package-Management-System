//
//  PMSCategory.swift
//  Package-Management-System
//
//  Created by Ira Einbinder on 12/6/23.
//

import Foundation

enum PMSCategory: CaseIterable {
    
    /// Highest priority. For packages that contain perishables that may need to be stored
    /// in a climate-controlled environment
    case perishables
    
    /// 2nd highest priority. For packages that contain fragile items which need to be handled
    /// with care
    case fragileItems
    
    /// 3rd highest priority. For packages that contain large items which are bigger and heavier.
    /// Of course a package can be large but also light, so we will assume that large considers
    /// both size and weight
    case largeItems
    
    /// 4th highest priority. For the rest of tha packages that don't need special care
    case general
    
}
