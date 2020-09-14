//
//  ImageLoader.swift
//  Makas
//
//  Created by Adem Özsayın on 29.08.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {
    
    let sampleData: [String] = ["https://picsum.photos/id/1021/2048/1206",
    "https://picsum.photos/id/1022/6000/3376",
    "https://picsum.photos/id/1023/3955/2094",
    "https://picsum.photos/id/1024/1920/1280",
    "https://picsum.photos/id/1004/5616/3744",
    "https://picsum.photos/id/1005/5760/3840",
    "https://picsum.photos/id/1006/3000/2000",
    "https://picsum.photos/id/1008/5616/3744",
    "https://picsum.photos/id/1009/5000/7502",
    "https://picsum.photos/id/101/2621/1747",
    "https://picsum.photos/id/1010/5184/3456",
    "https://picsum.photos/id/1011/5472/3648",
    "https://picsum.photos/id/1012/3973/2639",
    "https://picsum.photos/id/1013/4256/2832",
    "https://picsum.photos/id/1014/6016/4000",
    "https://picsum.photos/id/1015/6000/4000",
    "https://picsum.photos/id/1016/3844/2563",
    "https://picsum.photos/id/1018/3914/2935"]

    var imageURL: URL?

    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL) {

        // setup activityIndicator...
        activityIndicator.color = .darkGray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url

        image = nil
        activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    if self.imageURL == url {
                        self.image = imageToCache
                    }

                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
    
    func getSampleData () ->[String] {
        return self.sampleData
    }
}
