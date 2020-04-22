//
//  IndexPath extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 22.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


extension IndexPath {
    init(row: Int) {
        self.init(row: row, section: 0)
    }
}
