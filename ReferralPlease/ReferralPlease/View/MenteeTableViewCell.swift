//
//  MenteeTableViewCell.swift
//  
//
//  Created by Justin Lim on 3/8/21.
//

import UIKit

class MenteeTableViewCell: UITableViewCell {

    @IBOutlet weak var menteeName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
