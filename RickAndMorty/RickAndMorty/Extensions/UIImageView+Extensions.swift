//
//  UIImageView+Extensions.swift
//  RickAndMorty
//
//  Created by Iván Estévez Nieto on 3/12/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadFrom(url: String, placeholder: UIImage?) {
        if let placeholder {
            image = placeholder
        }
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
