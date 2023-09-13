//
//  ImageLoader.swift
//  MovieDisplay
//
//  Created by Ali Bahadir Sensoz on 26.07.2023.
//

import Foundation
import UIKit


private let _imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: ObservableObject {
    
 
    
    @Published var image: UIImage?
    
    var imageCache = _imageCache
    
    
    func loadImage(with url: URL){
        let urlString = url.absoluteString
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else {return}
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else {
                    return
                }
                self.imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

    
    
}
