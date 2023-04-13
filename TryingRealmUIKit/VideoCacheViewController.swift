//
//  VideoCacheViewController.swift
//  TryingRealmUIKit
//
//  Created by 290 G2 on 13/04/2023.
//

import UIKit
import RealmSwift

class VideoCacheViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}

class VideosViewModel {
    let realm = try! Realm()
    var videosCache: Results<VideoCache>?
    //    var dbLastVideo: VideoCache?
    var lastVideo: VideoCache?
    let internetConnectionIsOn = false
    
    
    // add video to cache and video info
    func addVideoToCache(withVideo: VideoData){
        // save video in cache only when 
        
        
        
        // save video data to Realm
        
        
    }
    
    
    // query for videos an video inf
    func loadVideosAndVideosInfo(){
        if internetConnectionIsOn{
            print("internet is here")
        }else{
            // load from cache
            
            // get list of videos from cache
            
            
            // query info for video url
            let videosInfoFromCache = realm.objects(VideoCache.self).filter({
                video in
                print(video.videoURLId)
                return false
            }
            )
            
            
        }
    }
    
}

// Realm model
class VideoCache: Object {
    @objc dynamic var videoURLId: String = ""
    //    @objc dynamic var videoDate: String = ""
    //    @objc dynamic var videoImageURL: String = ""
    @objc dynamic var videoTitle: String = ""
    @objc dynamic var bookmarked: Bool = false
    
    override static func primaryKey() -> String? {
        return "videoURLId"
    }
    
    convenience init(video: VideoData) {
        self.init()
        
        self.videoURLId         = video.url
        self.videoTitle         = video.name
        self.bookmarked         = video.bookmarked ?? false
    }
}

// Model
struct VideoData{
    let name: String
    let url: String
    var bookmarked: Bool?
}
