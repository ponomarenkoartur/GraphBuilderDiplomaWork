//
//  EquationDataService.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 27.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


protocol EquationDataServiceProtocol {
    func getEquations() -> [Equation]
    func addEquation(_ equation: Equation)
    func removeEquation(at index: Int)
    func fetchData()
    func commitChanges()
}

class EquationDataService: EquationDataServiceProtocol {
    
    private enum Constants {
        static let savedEquationsKey = "SavedEquations"
    }
    
    
    // MARK: - Singleton
    
    static let shared = EquationDataService()
    private init() {}
    
    
    // MARK: - Properties
    
    private var equations: [Equation] = []
    
    
    // MARK: - API Methods
    
    func getEquations() -> [Equation] {
        equations
    }
    
    func addEquation(_ equation: Equation) {
        equations.append(equation)
    }
    
    func removeEquation(at index: Int) {
        if equations.hasIndex(index) {
            equations.remove(at: index)
        }
    }
    
    
    
    func fetchData() {
        equations =
            UserDefaults.standard.array(forKey: Constants.savedEquationsKey)?
                .compactMap { $0 as? String }
                .map { Equation(equation: $0) } ?? []
    }
    
    func commitChanges() {
        UserDefaults.standard.set(equations.map { $0.latex },
                                  forKey: Constants.savedEquationsKey)
    }
}
