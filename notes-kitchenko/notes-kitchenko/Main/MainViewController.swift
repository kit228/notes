//
//  ViewController.swift
//  notes-kitchenko
//
//  Created by Вениамин Китченко on 30.09.2021.
//

import UIKit

protocol MainViewControllerProtocol: AnyObject {
    func saveTextNote(text: String, at element: Int)
    func deleteNote(at element: Int)
}

let kMaxNotes: Int = 10

final class MainViewController: UIViewController {
    
    private var notesArray: [Note] = []
    private let userDefaultHelper = UserDefaultsService()
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotesFromUserDefaults()
        setupSubviews()
        configureConstraints()
        setupNotes()
        addKeyboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObservers()
    }
    
    // MARK: - Setup notes
    
    private func setupNotes() {
        if notesArray.isEmpty {
            notesArray.append(Note(text: "Это Ваша первая заметка"))
        }
        reloadTableView()
    }
    
    @objc private func addNote() {
        if notesArray.count == kMaxNotes {
            showAlert()
        } else {
            notesArray.append(Note(text: ""))
            reloadTableView()
        }
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
        UITableView.appearance().backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "woodBoard"))
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
    
    // MARK: - User defaults
    
    private func loadNotesFromUserDefaults() {
        notesArray = userDefaultHelper.loadNotesFromUserDefaults()
    }
    
    private func saveToUserDefaults() {
        userDefaultHelper.saveNotesToUserDefaults(notes: notesArray)
    }
    
    private func deleteNotesFromUserDefaults() {
        userDefaultHelper.deleteAllNotesFromUserDefaults()
    }
    
    // MARK: - Alert
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "Это максимальное количество заметок", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Keyboard
    
    @objc func dismissKeyboardAndStopMovingNotes() {
        view.endEditing(true)
        stopMovingNotes()
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        defaultCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            notesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        notesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    
    func saveTextNote(text: String, at element: Int) {
        notesArray[element].text = text
        print("Сохраняем текст заметки = \(text)")
        saveToUserDefaults()
    }
    
    func deleteNote(at element: Int) {
        print("Удаляем ячейку с номером: \(element)")
        notesArray.remove(at: element)
        if notesArray.isEmpty {
            deleteNotesFromUserDefaults()
        } else {
            saveToUserDefaults()
        }
        reloadTableView()
    }
    
    // MARK: - Setup moving notes
    
    @objc func startMovingNotes() {
        notesTableView.isEditing = true
    }
    
    private func stopMovingNotes() {
        if notesTableView.isEditing {
            notesTableView.isEditing = false
        }
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
        headerView.backgroundColor = .clear
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndStopMovingNotes))
        headerView.addGestureRecognizer(tapRecognizer)
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(startMovingNotes))
        headerView.addGestureRecognizer(longTap)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NoteCell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: NoteCell.self), for: indexPath) as? NoteCell else { return UITableViewCell() }
        cell.mainViewControler = self
        cell.configureCell(with: notesArray[indexPath.section].text ?? "", indexPath: indexPath)
        cell.selectionStyle = .none // чтобы не подсвеивалась при нажатии
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(startMovingNotes))
        cell.addGestureRecognizer(longTap)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissKeyboardAndStopMovingNotes()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        notesArray.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        stopMovingNotes()
        saveToUserDefaults()
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}

