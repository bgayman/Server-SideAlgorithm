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
    // MARK: - Types
    enum Sections: Int
    {
        case commands
        case states
        
        var displayString: String
        {
            switch self
            {
            case .commands:
                return "Commands:"
            case .states:
                return "States:"
            }
        }
        
        static var all: [Sections]
        {
            return [.commands, .states]
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    weak var delegate: CommandViewControllerDelegate?
    var stateAbbreviations: [String]
    {
        set
        {
            _stateAbbreviations = ["--"] + newValue
            tableView.reloadData()
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
            
            updateShowStatesSection(oldValue: oldValue)
        }
        
    }
    fileprivate var selectedState = "--"
    fileprivate var showStatesSection: Bool = false
    
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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 40.0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40.0, right: 0.0)
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
    }
    
    // MARK: - Helpers
    fileprivate func resetState()
    {
        selectedCommand = .none
        selectedState = "--"
        showStatesSection = false
    }
    
    fileprivate func updateShowStatesSection(oldValue: CommandSelection)
    {
        guard let oldIndex = CommandSelection.all.index(of: oldValue),
              let newIndex = CommandSelection.all.index(of: selectedCommand)
        else { return }
        
        let oldShowStates = showStatesSection
        showStatesSection = (selectedCommand == .averageCity || selectedCommand == .bigSmallCity)
        let reloadIndexPaths = [oldIndex, newIndex].map { IndexPath(row: $0, section: Sections.commands.rawValue) }
        
        switch (oldShowStates, showStatesSection)
        {
        case (false, false), (true, true):
            self.tableView.reloadData()
        case (false, true):
            UIView.animate(withDuration: 0.2)
            { [unowned self] in
                self.tableView.beginUpdates()
                self.tableView.insertSections([Sections.states.rawValue], with: .automatic)
                self.tableView.reloadRows(at: reloadIndexPaths, with: .automatic)
                self.tableView.endUpdates()
            }
        case (true, false):
            UIView.animate(withDuration: 0.2)
            { [unowned self] in
                self.tableView.beginUpdates()
                self.tableView.deleteSections([Sections.states.rawValue], with: .automatic)
                self.tableView.reloadRows(at: reloadIndexPaths, with: .automatic)
                self.tableView.endUpdates()
            }
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
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return showStatesSection ? Sections.all.count : Sections.all.count - 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section
        {
        case .commands:
            return CommandViewController.CommandSelection.all.count
        case .states:
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
        guard let section = Sections(rawValue: indexPath.section) else { return cell }
        switch section
        {
        case .commands:
            let command = CommandViewController.CommandSelection.all[indexPath.row]
            cell.textLabel?.text = command.displayString
            cell.accessoryType = command == selectedCommand ? .checkmark : .none
        case .states:
            let abbreviation = _stateAbbreviations[indexPath.row]
            cell.textLabel?.text = abbreviation
            cell.accessoryType = abbreviation == selectedState ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let section = Sections(rawValue: indexPath.section) else { return }
        switch  section
        {
        case .commands:
            selectedCommand = CommandViewController.CommandSelection.all[indexPath.row]
            checkIfCommandComplete()
        case .states:
            selectedState = stateAbbreviations[indexPath.row]
            checkIfCommandComplete()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        guard let section = Sections(rawValue: section) else { return nil }
        return section.displayString
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.font = UIFont.app_boldFont(ofSize: 15.0)
        headerView.textLabel?.textColor = .white
        headerView.contentView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        headerView.backgroundView = nil
    }
}
