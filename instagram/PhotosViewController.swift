//
//  PhotosViewController.swift
//  instagram
//
//  Created by Jim Cai on 4/9/15.
//  Copyright (c) 2015 com.codepath. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var photos: [NSDictionary] = [NSDictionary]()
    var refreshControl: UIRefreshControl!
    let headerWidth = 320
    let headerHeight = 46
    let profileWidthHeight = 30

    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 320
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView=UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: headerHeight)   )
        headerView.backgroundColor = UIColor(white: 3, alpha: 0.5)
        
        var profilePicture = UIImageView(frame: CGRect(x: 8 , y: 8, width: profileWidthHeight, height: profileWidthHeight))
            //profilePicture.backgroundColor = UIColor.redColor()
        profilePicture.setImageWithURL(photos[section].valueForKeyPath("user."))
        headerView.insertSubview(profilePicture, atIndex: 0)
        return headerView
        
        //headerview. = UIColor( white: , alpha)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var headerHeight = CGFloat(46.0)
        return headerHeight
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as PhotoCell
        var photo = self.photos[indexPath.section] as NSDictionary
        var url = photo.valueForKeyPath("images.standard_resolution.url") as? String
        
        
        cell.photoView.setImageWithURL(NSURL(string: url!)!)
//        cell.titleLabel.text = movie["title"] as? String
//        cell.summaryLabel.text = movie["synopsis"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return photos.count
    }
    
    
    
    func refreshData() {
        var clientId = "3938a95b95b64056bc16a6967b3d5b78"
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.photos = responseDictionary["data"] as [NSDictionary]
            self.tableView.reloadData()
            
            println("response: \(self.photos)")
        }
    }
    
    func onRefresh() {
        refreshData()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as PhotoDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
        vc.selectedPhoto = photos[indexPath.section]
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
