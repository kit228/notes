//
//  ViewController.swift
//  notes-kitchenko
//
//  Created by Вениамин Китченко on 30.09.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var notesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: String.init(describing: NoteCell.self))
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    private lazy var addNoteButton = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self,
        action: #selector(addNote))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    @objc private func addNote() {
        print("kek")
    }
    
    // MARK: - NavigationController
    
    private func configureNavigationBar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.barTintColor = UIColor(named: "noteColor")
        //navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = .black
        title = "Notes"
        navigationItem.rightBarButtonItem = addNoteButton
    }
    
    // MARK: - Layout
    
    private func setupSubviews() {
        view.addSubview(notesTableView)
        UITableView.appearance().backgroundColor = .brown
    }
    
    private func configureConstraints() {
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: notesTableView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
        })
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .brown
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteCell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: NoteCell.self), for: indexPath) as! NoteCell
        return cell
    }
    
    
}

