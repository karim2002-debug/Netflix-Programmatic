//
//  Extension.swift
//  Netflix Programmatic
//
//  Created by Macbook on 22/06/2023.
//

import Foundation
import Foundation
extension String{
    
    // this used to make the first letter of the word captial
    func captialTheFirstLetter()->String{
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    
    
}
 
