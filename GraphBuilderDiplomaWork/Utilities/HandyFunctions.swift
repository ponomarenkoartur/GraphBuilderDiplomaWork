//
//  HandyFunctions.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 04.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


func assignIfNotEqual<T: Equatable>(_ assignee: inout T, _ value: T) {
    if assignee != value {
        assignee = value
    }
}

func assignIfValueIsNotNil<T: Equatable>(_ assignee: inout T, _ value: T?) {
    if let value = value {
        assignee = value
    }
}
