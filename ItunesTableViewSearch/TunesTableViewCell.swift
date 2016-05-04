//
//  TunesTableViewCell.swift
//  ItunesTableViewSearch
//
//  Created by Tomer Buzaglo on 03/05/2016.
//  Copyright © 2016 Tomer Buzaglo. All rights reserved.
//

import UIKit

class TunesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var download: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var dlControlsStack: UIStackView!
 
    var data:ItunesTrack?{
        didSet{
            artist.text = data?.artist
            title.text = data?.name
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @IBAction func download(sender: UIButton) {
        delegate?.downloadTapped(self)
    }
    @IBAction func pause(sender: UIButton) {
        sender.titleForState(.Normal) == "pause" ? delegate?.pauseTapped(self) : delegate?.resumeTapped(self)
        
        //toggle the title:
        let title = sender.titleForState(.Normal) == "pause" ? "resume" : "pause"
        pause.setTitle(title, forState: .Normal)
        
        
    }
    
    @IBAction func cancel(sender: UIButton) {
        delegate?.cancelTapped(self)
    }
    
    var delegate:TrackCellDelegate?
}

protocol TrackCellDelegate {
    func pauseTapped(cell: TunesTableViewCell)
    func resumeTapped(cell: TunesTableViewCell)
    func cancelTapped(cell: TunesTableViewCell)
    func downloadTapped(cell: TunesTableViewCell)
}




extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = borderColor?.CGColor
        }
    }
}