//
//  PromptTableViewCell.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/17/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - PromptTableViewCell
class PromptTableViewCell: UITableViewCell
{
    // MARK: - Static Properties
    static let dateFormatter: DateFormatter =
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    // MARK: - Outlets
    @IBOutlet private weak var promptLabel: UILabel!
    
    // MARK: - Properties
    private var animationCount = 0
    private var shouldShowHorizontalCursor: Bool = false
    {
        didSet
        {
            updateAttribString()
        }
    }
    
    var prompt: Prompt?
    {
        didSet
        {
            updateAttribString()
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    // MARK: - Helpers
    @objc func animateCurser()
    {
        animationCount += 1
        self.shouldShowHorizontalCursor = animationCount % 2 == 1
        self.perform(#selector(self.animateCurser), with: nil, afterDelay: 0.05)
    }

    func stopAnimatingCurser()
    {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.animateCurser), object: nil)
        shouldShowHorizontalCursor = false
    }
    
    private func updateAttribString()
    {
        guard let prompt = self.prompt else { return }
        self.promptLabel.attributedText = self.attributedString(for: prompt)
    }
    
    private func attributedString(for prompt: Prompt) -> NSAttributedString
    {
        let dateString = PromptTableViewCell.dateFormatter.string(from: prompt.timestamp)
        let cursor =  shouldShowHorizontalCursor ? "▬" : "▮"
        let components: [String?] = ["[" + dateString + "]", "~$", prompt.command, "▮"]
        let promptComponents: [String] = components.flatMap { $0 }
        let promptString = promptComponents.joined(separator: " ") as NSString
        let promptAttribString = NSMutableAttributedString(string: promptString as String,
                                                           attributes: [NSFontAttributeName: UIFont.app_font(ofSize: 15.0),
                                                                        NSForegroundColorAttributeName: UIColor.white])
        let dateRange = promptString.range(of: dateString)
        promptAttribString.addAttribute(NSBackgroundColorAttributeName,
                                        value: UIColor.app_blue,
                                        range: dateRange)
        
        let cursorRange = promptString.range(of: cursor)
        promptAttribString.addAttribute(NSForegroundColorAttributeName,
                                        value: UIColor.app_pink,
                                        range: cursorRange)
        return promptAttribString
    }
}
