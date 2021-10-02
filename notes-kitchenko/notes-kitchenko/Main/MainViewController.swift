//
//  ViewController.swift
//  notes-kitchenko
//
//  Created by Вениамин Китченко on 30.09.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    
    private var notesArray: [Note] = []
    
    // MARK: - UI Elements
    
    private lazy var notesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
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
        setupNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    @objc private func addNote() {
        notesArray.append(Note(text: ""))
        reloadTableView()
    }
    
    // MARK: - Setup notes
    
    private func setupNotes() {
        if notesArray.isEmpty {
            notesArray.append(Note(text: "Это Ваша первая заметка"))
        }
        reloadTableView()
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
    
    
    // MARK: - Helpers
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.notesTableView.reloadData()
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        notesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .brown
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        headerView.addGestureRecognizer(tapRecognizer)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NoteCell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: NoteCell.self), for: indexPath) as? NoteCell else { return UITableViewCell() }
        cell.configureCell(with: notesArray[indexPath.section].text ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboard()
    }
    
    
}

