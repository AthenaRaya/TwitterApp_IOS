//
//  tweetCellTableViewCell.swift
//  Twitter
//
//  Created by Athena Raya on 2/15/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class tweetCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    
    var favorited:Bool = false
    var tweetId:Int = -1
   var retweeted:Bool = false 
    
    @IBAction func favTweet(_ sender: Any) {
        let tobeFavorited = !favorited
        if(tobeFavorited){
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {self.setFavorite(_isFavorited: true)}, failure: { (error) in print("favorite did not succeed: \(error)")
                
            })
        }else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {self.setFavorite(_isFavorited: false)}, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
       
    }
    
    @IBAction func reTweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: { self.setRetweeted(_isRetweeted: true)
            
        }, failure: {(error) in
            print( "Error is reweeting: \(error)")
        })
        
    }
    
    func setRetweeted(_isRetweeted:Bool){
        if(_isRetweeted){
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }else{
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
            
        }
    }
    
    
    
    func setFavorite(_isFavorited:Bool){
        favorited = _isFavorited
        if(favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }else{favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
