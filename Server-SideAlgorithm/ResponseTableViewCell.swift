//
//  ResponseTableViewCell.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/17/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - ResponseTableViewCell
class ResponseTableViewCell: UITableViewCell
{
    // MARK: - Properties
    var response: String?
    {
        didSet
        {
            
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var responseLabel: UILabel!
    
    // MARK:- Lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        responseLabel.textColor = UIColor.app_green
        responseLabel.font = UIFont.app_font(ofSize: 15.0)
    }

}
