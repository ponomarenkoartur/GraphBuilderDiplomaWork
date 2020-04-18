//
//  NavigationBarPresenter.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 18.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import Foundation


protocol NavigationBarPresenter {
    var shouldPresentNavigationBar: Bool { get }
    var shouldPreferLargeTitle: Bool { get }
}
