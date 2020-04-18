//
//  SafeAreaInsets.swift
//  LimoDad
//
//  Created by artur_ios on 11.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import UIKit


enum WindowSafeArea {
    static var insets: UIEdgeInsets {
        UIApplication.shared.keyWindow!.safeAreaInsets
    }
}
