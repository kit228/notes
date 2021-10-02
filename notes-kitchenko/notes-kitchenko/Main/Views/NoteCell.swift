//
//  NoteCell.swift
//  notes-kitchenko
//
//  Created by Вениамин Китченко on 02.10.2021.
//

import UIKit

class NoteCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(named: "noteColor")
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    private lazy var viewForTextField: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "noteColor")
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: String.init(describing: NoteCell.self))
        
        setupSubviews()
        //setupTapRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Layout
    
    private func setupSubviews() {
        contentView.backgroundColor = .brown
        contentView.addSubview(viewForTextField)
        viewForTextField.addSubview(noteTextView)
        configureConstraints()
    }
    
    private func configureConstraints() {
        
        // viewForTextField
        viewForTextField.translatesAutoresizingMaskIntoConstraints = false
        let attributesTopBottom: [NSLayoutConstraint.Attribute] = [.top, .bottom]
        NSLayoutConstraint.activate(attributesTopBottom.map {
            NSLayoutConstraint(item: viewForTextField, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 0)
        })
        let attributesLeading: [NSLayoutConstraint.Attribute] = [.leading]
        NSLayoutConstraint.activate(attributesLeading.map {
            NSLayoutConstraint(item: viewForTextField, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 50)
        })
        let attributesTrailing: [NSLayoutConstraint.Attribute] = [.trailing]
        NSLayoutConstraint.activate(attributesTrailing.map {
            NSLayoutConstraint(item: viewForTextField, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: -50)
        })
        let attributesHeight: [NSLayoutConstraint.Attribute] = [.height]
        NSLayoutConstraint.activate(attributesHeight.map {
            NSLayoutConstraint(item: viewForTextField, attribute: $0, relatedBy: .equal, toItem: nil, attribute: $0, multiplier: 1, constant: 300)
        })
        
        
        // noteTextField
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        let attributesTopLeading: [NSLayoutConstraint.Attribute] = [.top, .leading]
        NSLayoutConstraint.activate(attributesTopLeading.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: viewForTextField, attribute: $0, multiplier: 1, constant: 20)
        })
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        let attributesBottomLeading: [NSLayoutConstraint.Attribute] = [.bottom, .trailing]
        NSLayoutConstraint.activate(attributesBottomLeading.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: viewForTextField, attribute: $0, multiplier: 1, constant: -20)
        })
        
    }
    
    func configureCell(with text: String) {
        noteTextView.text = text
    }
    

}


//extension NoteCell {
//    func setupTapRecognizer() {
//        let tapGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(viewDidTapped))
//        contentView.addGestureRecognizer(tapGestureRecognizer)
//    }
//    @objc func viewDidTapped() {
//        contentView.endEditing(true)
//        noteTextView.endEditing(true)
//    }
//}
