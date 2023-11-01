//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Enes Kaya on 1.11.2023.
//

import UIKit

class GFAvatarImageView: UIImageView {
    private enum ViewMetrics {
        static let cornerRadius: CGFloat = 10.0
    }
    
    let cache            = NetworkManagers.shared.cache
    var placeholderImage = UIImage(named: "placeholder")!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image          = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = ViewMetrics.cornerRadius
        
    }
    
    
    func downloadImage(from urlString: String) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
        
        task.resume()
    }
}
