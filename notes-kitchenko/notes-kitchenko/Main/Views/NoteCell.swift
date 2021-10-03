//
//  NoteCell.swift
//  notes-kitchenko
//
//  Created by Вениамин Китченко on 02.10.2021.
//

import UIKit

final class NoteCell: UITableViewCell, UITextViewDelegate {
    
    // MARK: - Private
    
    private var textForComparisonBeforeSaving = ""
    private var indexPath: IndexPath?
    
    weak var mainViewControler: MainViewControllerProtocol?
    
    // MARK: - UI Elements
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
//        button.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(deleteNote))
        tap.numberOfTapsRequired = 2
        button.addGestureRecognizer(tap)
        return button
    }()
    
    private lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    private lazy var noteImageView: UIImageView = {
        let imageView = UIImageView(frame: contentView.bounds)
        imageView.image = #imageLiteral(resourceName: "note")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: String.init(describing: NoteCell.self))
        
        setupSubviews()
        addDoneButton()
        noteTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Keyboard
    
    @objc func dismissKeyboard() {
        contentView.endEditing(true)
    }
    
    private func addDoneButton() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        noteTextView.inputAccessoryView = toolbar
    }
    
    // MARK: - Layout
    
    private func setupSubviews() {
        self.backgroundColor = .clear
        contentView.addSubview(noteImageView)
        noteImageView.addSubview(noteTextView)
        noteImageView.isUserInteractionEnabled = true
        noteImageView.addSubview(deleteButton)
        configureConstraints()
    }
    
    // MARK: - Configure cell
    
    func configureCell(with text: String, indexPath: IndexPath) {
        textForComparisonBeforeSaving = text
        noteTextView.text = text
        self.indexPath = indexPath
        print("Создана ячейка с indexPath.section = \(indexPath.section)")
    }
    
    // MARK: - Helpers
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveText()
    }
    
    func saveText() {
        guard let indexPathSection = indexPath?.section else { return }
        if noteTextView.text != textForComparisonBeforeSaving  && !noteTextView.text.isEmpty {
            print("Нужно сохранить текст ячейки")
            mainViewControler?.saveTextNote(text: noteTextView.text, at: indexPathSection)
        }
    }
    
    @objc func deleteNote() {
        guard let indexPathSection = indexPath?.section else { return }
        mainViewControler?.deleteNote(at: indexPathSection)
    }
}



extension NoteCell {
    
    // MARK: - Constraints
    
    private func configureConstraints() {
        setNoteImageViewConstraints()
        setNoteTextViewConstraints()
        setDeleteButtonConstrains()
    }
    
    func setNoteImageViewConstraints() {
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        let attributesTopBottom: [NSLayoutConstraint.Attribute] = [.top, .bottom]
        NSLayoutConstraint.activate(attributesTopBottom.map {
            NSLayoutConstraint(item: noteImageView, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 0)
        })
        let attributesLeading: [NSLayoutConstraint.Attribute] = [.leading]
        NSLayoutConstraint.activate(attributesLeading.map {
            NSLayoutConstraint(item: noteImageView, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 70)
        })
        let attributesTrailing: [NSLayoutConstraint.Attribute] = [.trailing]
        NSLayoutConstraint.activate(attributesTrailing.map {
            NSLayoutConstraint(item: noteImageView, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: -50)
        })
        let attributesHeight: [NSLayoutConstraint.Attribute] = [.height]
        NSLayoutConstraint.activate(attributesHeight.map {
            NSLayoutConstraint(item: noteImageView, attribute: $0, relatedBy: .equal, toItem: nil, attribute: $0, multiplier: 1, constant: 300)
        })
    }
    
    func setNoteTextViewConstraints() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        let attributesTop: [NSLayoutConstraint.Attribute] = [.top]
        NSLayoutConstraint.activate(attributesTop.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: noteImageView, attribute: $0, multiplier: 1, constant: 50)
        })
        let attributesLeading: [NSLayoutConstraint.Attribute] = [.leading]
        NSLayoutConstraint.activate(attributesLeading.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: noteImageView, attribute: $0, multiplier: 1, constant: 25)
        })
        let attributesTrailing: [NSLayoutConstraint.Attribute] = [.trailing]
        NSLayoutConstraint.activate(attributesTrailing.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: noteImageView, attribute: $0, multiplier: 1, constant: -25)
        })
        let attributesBottom: [NSLayoutConstraint.Attribute] = [.bottom]
        NSLayoutConstraint.activate(attributesBottom.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: noteImageView, attribute: $0, multiplier: 1, constant: -20)
        })
    }
    
    func setDeleteButtonConstrains() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        let attributesHeightWidth: [NSLayoutConstraint.Attribute] = [.height, .width]
        NSLayoutConstraint.activate(attributesHeightWidth.map {
            NSLayoutConstraint(item: deleteButton, attribute: $0, relatedBy: .equal, toItem: nil, attribute: $0, multiplier: 1, constant: 40)
        })
        NSLayoutConstraint.activate([deleteButton.centerXAnchor.constraint(equalTo: noteImageView.centerXAnchor)])
    }
}


