//
//  DataService.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


protocol DataServiceProtocol {
    func getEquations() -> [Equation]
    func addEquation(_ equation: Equation)
    func removeEquation(at index: Int)
}

class DataService: DataServiceProtocol {
    
    
    // MARK: - Singleton
    
    static let shared = DataService()
    private init() {}
    
    
    // MARK: - API Methods
    
    func getEquations() -> [Equation] {
        []
    }
    
    func addEquation(_ equation: Equation) {
        
    }
    
    func removeEquation(at index: Int) {
        
    }
}
