//
//  NSRegularExpression extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 07.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    func matches(in string: String, options: MatchingOptions = []) ->
        [(group: String, range: NSRange)] {
        matches(in: string, options: options, range: string.range).map {
            (String((string as NSString).substring(with: $0.range)), $0.range)
        }
    }
}
