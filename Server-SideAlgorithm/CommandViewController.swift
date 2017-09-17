//
//  CommandViewController.swift
//  Server-SideAlgorithm
//
//  Created by Brad G. on 9/17/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

// MARK: - CommandViewControllerDelegate
protocol CommandViewControllerDelegate: class
{
    func command(viewController: CommandViewController, didEnterCommand command: CommandViewController.Command)
}

// MARK: - CommandViewController
class CommandViewController: UIViewController
{
    // MARK: - Outlets
    @IBOutlet fileprivate weak var commandTableView: UITableView!
    @IBOutlet fileprivate weak var statesTableView: UITableView!
    @IBOutlet fileprivate weak var statesLabel: UILabel!
    @IBOutlet fileprivate weak var commandLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: CommandViewControllerDelegate?
    var stateAbbreviations: [String]
    {
        set
        {
            _stateAbbreviations = ["--"] + newValue
            statesTableView.reloadData()
        }
        
        get
        {
            return _stateAbbreviations
        }

    }
    
    fileprivate var _stateAbbreviations = [String]()
    
    fileprivate var selectedCommand = CommandSelection.none
    {
        didSet
        {
            commandTableView.reloadData()
        }
    }
    
    fileprivate var selectedState = "--"
    {
        didSet
        {
            statesTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        styleViews()
    }
    
    // MARK: - Setup
    private func styleViews()
    {
        title = "Commands"
        view.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                                   NSFontAttributeName: UIFont.app_font(ofSize: 20)]
        navigationController?.navigationBar.barTintColor = .black
        
        commandLabel.font = UIFont.app_boldFont(ofSize: 15)
        commandLabel.textColor = .white
        statesLabel.font = UIFont.app_boldFont(ofSize: 15)
        statesLabel.textColor = .white
        
        commandTableView.rowHeight = 40.0
        statesTableView.rowHeight = 40.0
        
        commandTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        statesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        commandTableView.tableFooterView = UIView()
        statesTableView.tableFooterView = UIView()
        
        statesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40.0, right: 0.0)
        
    }
    
    // MARK: - Helpers
    fileprivate func resetState()
    {
        selectedState = "--"
        selectedCommand = .none
        updateStateTableAlpha()
    }
    
    fileprivate func updateStateTableAlpha()
    {
        let showTable = !(selectedCommand == .none || selectedCommand == .overTenMillion)
        UIView.animate(withDuration: 0.2)
        { [unowned self] in
            self.statesLabel.alpha = showTable ? 1.0 : 0.0
            self.statesTableView.alpha = showTable ? 1.0 : 0.0
        }
        
        // If we're hiding the table makes more sense to reset state back to "--"
        if !showTable
        {
            self.selectedState = "--"
        }
    }
    
    fileprivate func checkIfCommandComplete()
    {
        if let command = Command(commandSelection: self.selectedCommand, state: selectedState)
        {
            delegate?.command(viewController: self, didEnterCommand: command)
            resetState()
        }
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate
extension CommandViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView === self.commandTableView
        {
            return CommandViewController.CommandSelection.all.count
        }
        else
        {
            return _stateAbbreviations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.app_font(ofSize: 15.0)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.tintColor = UIColor.app_yellow
        cell.selectionStyle = .none
        if tableView === self.commandTableView
        {
            let command = CommandViewController.CommandSelection.all[indexPath.row]
            cell.textLabel?.text = command.displayString
            cell.accessoryType = command == selectedCommand ? .checkmark : .none
        }
        else
        {
            let abbreviation = _stateAbbreviations[indexPath.row]
            cell.textLabel?.text = abbreviation
            cell.accessoryType = abbreviation == selectedState ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView === commandTableView
        {
            selectedCommand = CommandViewController.CommandSelection.all[indexPath.row]
            updateStateTableAlpha()
            checkIfCommandComplete()
        }
        else
        {
            selectedState = stateAbbreviations[indexPath.row]
            checkIfCommandComplete()
        }
    }
}
