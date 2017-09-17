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
    
    lazy var commandViewController: CommandViewController =
    {
        let commandViewController = CommandViewController(nibName: "\(CommandViewController.self)", bundle: nil)
        let navigationController = UINavigationController(rootViewController: commandViewController)
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(navigationController)
        navigationController.view.frame = self.containerView.bounds
        self.containerView.insertSubview(navigationController.view, belowSubview: self.handleView)
        navigationController.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        navigationController.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        navigationController.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        navigationController.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        navigationController.didMove(toParentViewController: self)
        return commandViewController
    }()
    
    private var bottomConstraintStartView: CGFloat = 44.0
    private var bottomClampOffset: CGFloat = 44.0
    
    // MARK: - Outlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var handleView: UIView!
    @IBOutlet fileprivate var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var containerViewToBottomConstraint: NSLayoutConstraint!
    
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
        view.backgroundColor = .black
        
        commandViewController.delegate = self
        tableView.estimatedRowHeight = 25.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomClampOffset, right: 0.0)
        content = [.prompt(prompt: Prompt())]
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        handleView.layer.cornerRadius = handleView.bounds.height * 0.5
        handleView.layer.masksToBounds = true
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
                self.presentError(with: "Failed to get required info.")
            case .success(let states):
                self.zipCodeCalculator = ZipCodeCalculator(states: states)
                self.commandViewController.stateAbbreviations = states.map { $0.abbreviation }.sorted()
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer)
    {
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        switch sender.state
        {
        case .began:
            bottomConstraintStartView = containerViewToBottomConstraint.constant
            containerViewToBottomConstraint.constant += -translation.y
        case .changed:
            containerViewToBottomConstraint.constant = max(bottomClampOffset, bottomConstraintStartView + -translation.y)
        case .failed, .possible:
            break
        case .cancelled, .ended:
            if velocity.y >= 0
            {
                animateDown()
            }
            else
            {
                animateUp()
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
    
    fileprivate func updateLastPrompt(with command: CommandViewController.Command)
    {
        guard let lastContent = content.last,
              case .prompt(var prompt) = lastContent
        else { return  }
        prompt.command = command.displayString
        content.removeLast()
        content.append(ConsoleContent.prompt(prompt: prompt))
    }
    
    fileprivate func presentError(with message: String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        alert.view.tintColor = UIColor.app_yellow
        self.present(alert, animated: true)
    }
    
    fileprivate func addNewPrompt()
    {
        content.append(.prompt(prompt: Prompt()))
        tableView.scrollToRow(at: IndexPath(row: content.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    fileprivate func animateDown()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations:
        { [unowned self] in
            self.containerViewToBottomConstraint.constant = self.bottomClampOffset
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateUp()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations:
        { [unowned self] in
            self.containerViewToBottomConstraint.constant = self.view.bounds.height - 40.0
            self.view.layoutIfNeeded()
        })
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

extension ConsoleViewController: CommandViewControllerDelegate
{
    func command(viewController: CommandViewController, didEnterCommand command: CommandViewController.Command)
    {
        animateDown()
        guard let zipCodeCalculator = zipCodeCalculator else
        {
            presentError(with: "Could not initalize data set.")
            return
        }
        updateLastPrompt(with: command)
        do
        {
            let response: String
            switch command
            {
            case .overTenMillion:
                response = zipCodeCalculator.greaterThanTenMillionResponse
            case .averageCityPopulation(let state):
                response = try zipCodeCalculator.averagePopulationResponse(forState: state) ?? "{}"
            case .biggestSmallestCity(let state):
                response = try zipCodeCalculator.biggestSmallestCities(forState: state) ?? "{}"
            }
            content.append(.response(response: response))
            addNewPrompt()
        }
        catch
        {
            presentError(with: error.localizedDescription)
            addNewPrompt()
        }
        
    }
}
