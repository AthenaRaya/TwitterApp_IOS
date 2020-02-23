//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Athena Raya on 2/15/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    

   override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
       tableView.refreshControl = myRefreshControl
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.estimatedRowHeight = 50
     }
      
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()    }
    
    @objc func loadTweets() {
         
        numOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() // clean array
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: {(Error) in
            print("could not retreive tweets! oh no!!")
        })
    }
    
    
    func loadMoreTweets(){
         print("loadMore")
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweets = numOfTweets + 20
        let myParam = ["count": numOfTweets]

        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam , success: { (tweets: [NSDictionary]) in

                  self.tweetArray.removeAll() // clean array
                  for tweet in tweets{
                      self.tweetArray.append(tweet)
                  }
                  self.tableView.reloadData()

              }, failure: {(Error) in
                  print("could not retreive tweets! oh no!!")
              })
    }
    
    
    //infinte scroll function
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){

        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
           

        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
           TwitterAPICaller.client?.logout()
           self.dismiss(animated: true, completion: nil)
           UserDefaults.standard.set(false, forKey: "userLoggedIn")
       }
      
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell",for: indexPath) as! tweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        //set image
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(_isFavorited: tweetArray[indexPath.row]["favorited"] as! Bool)
        //add _isFavorite as per recomendation.
        
        cell.tweetId =  tweetArray[indexPath.row]["id"] as! Int
        
        cell.setRetweeted(_isRetweeted: tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        
        return cell
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    
    
    


}
