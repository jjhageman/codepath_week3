//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Jeremy Hageman on 2/18/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.nameLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
        self.handleLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
        self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.nameLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
        self.handleLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
        self.tweetLabel.preferredMaxLayoutWidth = self.tweetLabel.frame.size.width
    }

}
