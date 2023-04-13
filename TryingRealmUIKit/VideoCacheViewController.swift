//
//  VideoCacheViewController.swift
//  TryingRealmUIKit
//
//  Created by 290 G2 on 13/04/2023.
//

import UIKit
import RealmSwift
import SnapKit
import AVFoundation


class VideoCacheViewController: UIViewController {
    
    
    
    private var playerViewWithCache: VideoPlayerView!
    
    
    // URL for the test video.
    private let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        makePlayer()
        
        playVideo()
        
        view.backgroundColor = .systemBackground
        
    }

    func makePlayer(){
        
        //        playerView = PlayerView()
        playerViewWithCache = VideoPlayerView()
        
        playerViewWithCache.layer.borderColor = UIColor.red.cgColor
        playerViewWithCache.layer.borderWidth = 2
        
        view.addSubview(playerViewWithCache)
        
        playerViewWithCache.snp.makeConstraints({ make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(250)
        })
    }
    
    // controller
    func playVideo() {
        guard let url = URL(string: videoURL) else { return }
        
        playerViewWithCache.configure(url: url, fileExtension: ".mp4", size: (700, 800))
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
