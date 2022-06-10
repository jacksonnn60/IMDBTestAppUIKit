//
//  UIImage.swift
//  IMDBAppUIKit
//
//  Created by Jackson  on 10/06/2022.
//

import UIKit

typealias Source = URL

extension UIImageView {
    func setImage(from source: Source) {
        URLSession.shared.dataTask(with: source) { [weak self] data, _, error in
            guard error == nil, data != nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data!) ?? UIImage(systemName: "film")
                self?.image = image
            }
            
        }.resume()
    }
}
