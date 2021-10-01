//
//  ViewController.swift
//  notes-kitchenko
//
//  Created by Вениамин Китченко on 30.09.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        //tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        confugureSubViews()
        configureConstraints()
    }
    
    private func confugureSubViews() {
        view.addSubview(notesTableView)
    }
    
    private func configureConstraints() {
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: notesTableView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0)
        })
    }

}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "makak"
        return cell
    }
    
    
}

