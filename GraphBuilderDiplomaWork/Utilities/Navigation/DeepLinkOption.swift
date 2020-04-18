//
//  DeepLinkOption.swift
//  LimoDad
//
//  Created by Artur on 26.02.2020.
//  Copyright © 2020 pulssoftware. All rights reserved.
//

import Foundation

enum DeepLinkOption {
    
    case emailConfirmed(token: String)
    case passwordRestore(token: String)
    
//    static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//            let url = userActivity.webpageURL,
//            let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) {
//            //TODO: extract string and match with DeepLinkURLConstants
//        }
//        return nil
//    }
//
//    static func build(with dict: [String : AnyObject]?) -> DeepLinkOption? {
//        guard let id = dict?["launch_id"] as? String else { return nil }
//        return DeepLinkOption(rawValue: id)
//    }
}
