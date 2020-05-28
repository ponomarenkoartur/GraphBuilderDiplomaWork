//
//  UIImageView extension.swift
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 28.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(byURL url: URL, placeholderImage: UIImage?,
                  completion: @escaping () -> () = {}) {
        if let placeholderImage = placeholderImage {
            self.image = placeholderImage
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                completion()
            }
        }.resume()
    }
}
