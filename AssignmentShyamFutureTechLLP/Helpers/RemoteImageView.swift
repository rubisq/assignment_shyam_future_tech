//
//  RemoteImageView.swift
//  AssignmentShyamFutureTechLLP
//
//  Created by openweb on 14/02/23.
//

import SwiftUI
import Combine

struct RemoteImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    private let size: CGSize
    private var defaultImage = UIImage(named: "image-placeholder")
    
    init(urlString: String?, size: CGSize) {
        urlImageModel = UrlImageModel(urlString: urlString)
        self.size = size
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? defaultImage!)
            .resizable()
            .scaledToFit()
            .frame(width: size.width, height: size.height)
    }
}

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var imageCache = ImageCache.getImageCache()
    var urlString: String?
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
        if loadImageFromCache() {
            return
        }
        loadImageFromUrl()
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else {
            return
        }
        
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString) else {
            return false
        }
        
        image = cacheImage
        return true
    }
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.imageCache.set(forKey: self.urlString!, image: loadedImage)
            self.image = loadedImage
        }
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
