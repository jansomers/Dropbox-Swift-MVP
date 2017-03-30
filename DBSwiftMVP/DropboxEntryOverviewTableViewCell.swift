//
//  DropboxEntryOverviewTableViewCell.swift
//  DBSwiftMVP
//
//  S.Jan on 28/03/2017.
//  Copyright © 2017 sjan. All rights reserved.
//

import UIKit

class DropboxEntryOverviewTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet var typeImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var optionImage: UIImageView!
    
    //MARK: - View Lifecycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
