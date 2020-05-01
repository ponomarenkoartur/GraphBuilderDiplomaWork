//
//  Error extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 12.03.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


extension Error {
    var readableDescription: String {
        (self as? LocalizedError)?.errorDescription ?? localizedDescription
    }
}


extension Error where Self: RawRepresentable, RawValue == String {
    var localizedDescription: String { rawValue }
}
