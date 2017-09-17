//
//  ConsoleViewController.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/17/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - ConsoleViewController
class ConsoleViewController: UIViewController
{
    // MARK: - Types
    enum ConsoleContent
    {
        case prompt(prompt: Prompt)
        case response(response: String)
    }
    
    // MARK: - Properties
    fileprivate var content = [ConsoleContent]()
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    
    fileprivate var zipCodeCalculator: ZipCodeCalculator?
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        styleViews()
        fetchZipCodes()
    }
    
    // MARK: - Setup
    private func styleViews()
    {
        view .backgroundColor = .black
        
        tableView.estimatedRowHeight = 25.0
        tableView.rowHeight = UITableViewAutomaticDimension
        content = [.prompt(prompt: Prompt())]
    }
    
    // MARK: - Networking
    private func fetchZipCodes()
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        animateCursor(shouldAnimate: true)
        ZipCodeClient.fetchJSONData
        { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.animateCursor(shouldAnimate: false)
            switch response
            {
            case .error:
                let alert = UIAlertController(title: "Error", message: "Failed to get required info.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            case .success(let states):
                self.zipCodeCalculator = ZipCodeCalculator(states: states)
            }
        }
    }
    
    // MARK: - Helpers
    private func animateCursor(shouldAnimate: Bool)
    {
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: content.count - 1, section: 0)) as? PromptTableViewCell else { return }
        if shouldAnimate
        {
            cell.animateCurser()
        }
        else
        {
            cell.stopAnimatingCurser()
        }
    }
}

// MARK: - UITableViewDataSource
extension ConsoleViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let content = self.content[indexPath.row]
        switch content
        {
        case .prompt(let prompt):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(PromptTableViewCell.self)", for: indexPath) as! PromptTableViewCell
            cell.prompt = prompt
            return cell
        case .response(let response):
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(ResponseTableViewCell.self)", for: indexPath) as! ResponseTableViewCell
            cell.response = response
            return cell
        }
    }
}
