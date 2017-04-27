//
//  CacheService.swift
//  Alpa
//
//  Created by ROHAN DAVE on 12/04/17.
//  Copyright © 2017 Rohan Dave. All rights reserved.
//

import Foundation

import AlamofireImage



class CacheService {
    
    
    // MARK:
    // MARK: Properties
    
    static let cacheService = CacheService()
    
    let imageCache: AutoPurgingImageCache
    
    
    // MARK:
    // MARK: Initialization 
    
    private init() {
        
        self.imageCache = AutoPurgingImageCache()
    }
    
    
    // MARK:
    // MARK: Public Methods
    
    /// This method caches the downloaded profile image using the @c AlamofireImage image caching.
    ///
    /// - Parameters:
    ///   - imageUrl: The url string for the image.
    ///   - image: The @c UIImage to be cached.
    ///   - fbUserId: The facebook user id of the user/friend who's image is to be cached.
    
    func cacheDownloadedProfileImage(image: Image!, fbUserId: String!) {
        
        // Add to cache.
        self.imageCache.add(image, withIdentifier: fbUserId)
    }
    
    /// This method fetches the cached image associated with the URL Request and the id.
    ///
    /// - Parameters:
    ///   - imageCache: The @c AutoPurgingImageCache instance.
    ///   - imageUrl: The url string for the image.
    ///   - fbUserId: The facebook user id for the user whose image is cached.
    /// - Returns: The @c Image that is cached.
    
    func fetchUserImageFromCache(fbUserId: String!) -> Image? {
        
        // Fetch from cache.
        return self.imageCache.image(withIdentifier: fbUserId)
    }
    
    /// This method creates and returns a @c URLRequest from a URL string.
    ///
    /// - Parameter urlString: The url string to form into @c URLRequest.
    /// - Returns: The created @c URLRequest from the URL string.
    
    private func getUrlRequestFromUrl(urlString: String!) -> URLRequest? {
        
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
}
