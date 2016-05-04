//
//  TunesTableViewController.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 03/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class TunesTableViewController: UITableViewController {
    let search = UISearchController(searchResultsController: nil)
    let dataSource = ITunesDataSource()
    let downloadDataSource =  DownloadDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        search.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        tableView.tableHeaderView = search.searchBar
        search.searchResultsUpdater = self
        search.searchBar.barTintColor = UIColor.blackColor()
        search.searchBar.tintColor = UIColor.whiteColor()
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-grey")!)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.tunes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as!TrackCell
        
        // Delegate cell button tap events to this view controller
        cell.delegate = self
        
        let track = dataSource.tunes[indexPath.row]
        
        // Configure title and artist labels
        cell.titleLabel.text = track.name
        cell.artistLabel.text = track.artist
        
        var showDownloadControls = false
        if let download = downloadDataSource.activeDownloads[track.previewUrl!] {
            showDownloadControls = true
            
            cell.progressView.progress = download.progress
            cell.progressLabel.text = (download.isDownloading) ? "Downloading..." : "Paused"
            
            let title = (download.isDownloading) ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, forState: UIControlState.Normal)
        }
        cell.progressView.hidden = !showDownloadControls
        cell.progressLabel.hidden = !showDownloadControls
        
        // If the track is already downloaded, enable cell selection and hide the Download button
        let downloaded = FileIO.fileExistsInDocumentsDirectory(track.previewFileName)
        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.Gray : UITableViewCellSelectionStyle.None
        cell.downloadButton.hidden = downloaded || showDownloadControls
        
        cell.pauseButton.hidden = !showDownloadControls
        cell.cancelButton.hidden = !showDownloadControls
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let track = dataSource.tunes[indexPath.row]
        playDownload(track)
    }
    
    // This method attempts to play the local file (if it exists) when the cell is tapped
    func playDownload(track: ItunesTrack) {
        
        let fileName = track.previewFileName
        guard FileIO.fileExistsInDocumentsDirectory(fileName) else {return}
        let url = FileIO.fileUrlInDocumentsDirectory(fileName)
        
        let player = AVPlayer(URL: url) // NSURL(string:track.previewUrl)! will work as well, no need to download the file
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        
        presentViewController(playerController, animated: true, completion: {
            player.play()
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TunesTableViewController : UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController){
        if let query = searchController.searchBar.text{
            dataSource.query(query, delegate: { (data) in
                self.tableView.reloadData()
            })
        }
    }
}


//extension TunesTableViewController : TrackCellDelegate{
//    private func reloadCell(cell: TunesTableViewCell){
//        if let indexPath = tableView.indexPathForCell(cell) {
//            //tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .Middle)
//        }
//    }
//    
//    func pauseTapped(cell: TunesTableViewCell){
//        if let url = cell.data?.previewUrl{
//            downloadDataSource.pause(url)
//            reloadCell(cell)
//        }
//    }
//    func resumeTapped(cell: TunesTableViewCell){
//        if let url = cell.data?.previewUrl{
//            downloadDataSource.resume(url)
//            reloadCell(cell)
//        }
//    }
//    func cancelTapped(cell: TunesTableViewCell){
//        if let url = cell.data?.previewUrl{
//            downloadDataSource.cancel(url)
//            reloadCell(cell)
//        }
//    }
//    func downloadTapped(cell: TunesTableViewCell){
//        if let track = cell.data, url = track.previewUrl{
//            downloadDataSource.download(url, delegate: { (download) in
//                //print(download.progress)
//                if let cell = self.cellForTrack(download){
//                    self.reloadCell(cell)
//                }
//            })
//            
//            reloadCell(cell)
//        }
//    }
//}


extension TunesTableViewController : TrackDelegate{
    private func reloadCell(cell: TrackCell){
        if let indexPath = tableView.indexPathForCell(cell) {
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .Middle)
        }
    }
    
    func pauseTapped(cell: TrackCell){
        
        if let url = trackForCell(cell)?.previewUrl{
            downloadDataSource.pause(url)
            reloadCell(cell)
        }
    }
    func resumeTapped(cell: TrackCell){
        if let url = trackForCell(cell)?.previewUrl{
            downloadDataSource.resume(url)
            reloadCell(cell)
        }
    }
    func cancelTapped(cell: TrackCell){
        if let url = trackForCell(cell)?.previewUrl{
            downloadDataSource.cancel(url)
            reloadCell(cell)
        }
    }
    func downloadTapped(cell: TrackCell){
        if let track = trackForCell(cell), url = track.previewUrl{
            downloadDataSource.download(url, delegate: { (download) in
                //print(download.progress)
                if let cell = self.cellForTrack(download){
                    self.reloadCell(cell)
                }
            })
            
            reloadCell(cell)
        }
    }
}


extension TunesTableViewController {
    func cellForTrack(download: Download)->TrackCell?{
        let url = download.url
        for (index, tune) in dataSource.tunes.enumerate(){
            if tune.previewUrl == url{
                return tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? TrackCell
            }
        }
        return nil
    }
    
    
    func trackForCell(cell:TrackCell)->ItunesTrack?{
        if let indexPath = tableView.indexPathForCell(cell) {
            return dataSource.tunes[indexPath.row]
        }
        return nil
    }
    
}