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
    //MARK: Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        makePlayer()
        
        playVideo()
        
        view.backgroundColor = .systemBackground
        
    }
    
    //MARK: Add Player to the screen
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

//MARK: Realm Manager
class VideosInfoManagerWithRealm {
    static let realm = try! Realm()
    var videosCache: Results<VideoEntityRealm>?
    
        
    // add video to cache and video info
    static func addVideoInfoToRealm(video: VideoData){
        
        let videoToAdd = VideoEntityRealm(video: video)
        
        try! realm.write {
            realm.add(videoToAdd)
        }
        // save video data to Realm
        
    }
    
    
    // query for videos an video inf
    static func queryVideoInfo(videoUrl: String) -> VideoEntityRealm?{
        
        // query info for video url
        let videosInfoFromCache = realm.objects(VideoEntityRealm.self).filter({
            video in
            videoUrl == video.videoURLId
//            print(video.videoURLId)
//            return false
        })
        
        print(videosInfoFromCache, "found or not")
        
        return videosInfoFromCache.first
    }
    
    // Retrieve
    // Get all videos in the realm
    static func getAllObjects()->Results<VideoEntityRealm>{
        return realm.objects(VideoEntityRealm.self)
    }
    
    // Delete All
    static func clearDatabase(){
        // All modifications to a realm must happen in a write block.
        let videosInfo = realm.objects(VideoEntityRealm.self)
        
        for videoInfo in videosInfo{
            try! realm.write {
                // Delete the Todo.
                realm.delete(videoInfo)
            }
        }
    }
}

//MARK: Realm model
class VideoEntityRealm: Object {
    @objc dynamic var videoURLId: String = ""
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

//MARK: Network Model
struct VideoData{
    let name: String
    let url: String
    var bookmarked: Bool?
}
