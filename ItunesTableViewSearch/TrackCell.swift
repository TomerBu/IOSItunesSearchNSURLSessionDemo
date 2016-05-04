//
//  TrackCell.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 04/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit

    protocol TrackDelegate {
        func pauseTapped(cell: TrackCell)
        func resumeTapped(cell: TrackCell)
        func cancelTapped(cell: TrackCell)
        func downloadTapped(cell: TrackCell)
    }
    
    class TrackCell: UITableViewCell {
        
        var delegate: TrackDelegate?
        
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var artistLabel: UILabel!
        @IBOutlet weak var progressView: UIProgressView!
        @IBOutlet weak var progressLabel: UILabel!
        @IBOutlet weak var pauseButton: UIButton!
        @IBOutlet weak var cancelButton: UIButton!
        @IBOutlet weak var downloadButton: UIButton!
        
        @IBAction func pauseOrResumeTapped(sender: AnyObject) {
            if(pauseButton.titleLabel!.text == "Pause") {
                delegate?.pauseTapped(self)
            } else {
                delegate?.resumeTapped(self)
            }
        }
        
        @IBAction func cancelTapped(sender: AnyObject) {
            delegate?.cancelTapped(self)
        }
        
        @IBAction func downloadTapped(sender: AnyObject) {
            delegate?.downloadTapped(self)
        }
}
