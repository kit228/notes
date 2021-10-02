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
    
    private lazy var viewForTextField: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: String.init(describing: NoteCell.self))
        
        setupSubviews()
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
        self.backgroundColor = .clear
        contentView.addSubview(viewForTextField)
        viewForTextField.addSubview(noteImageView)
        noteImageView.addSubview(noteTextView)
        noteImageView.isUserInteractionEnabled = true
        configureConstraints()
    }
    
    // MARK: - Constraints
    
    private func configureConstraints() {
        setViewForTextFieldConstraints()
        setNoteTextViewConstraints()
        setNoteImageViewConstraints()
    }
    
    func setViewForTextFieldConstraints() {
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
    }
    
    func setNoteTextViewConstraints() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        let attributesTop: [NSLayoutConstraint.Attribute] = [.top]
        NSLayoutConstraint.activate(attributesTop.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: viewForTextField, attribute: $0, multiplier: 1, constant: 40)
        })
        let attributesLeading: [NSLayoutConstraint.Attribute] = [.leading]
        NSLayoutConstraint.activate(attributesLeading.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: viewForTextField, attribute: $0, multiplier: 1, constant: 20)
        })
        let attributesBottomLeading: [NSLayoutConstraint.Attribute] = [.bottom, .trailing]
        NSLayoutConstraint.activate(attributesBottomLeading.map {
            NSLayoutConstraint(item: noteTextView, attribute: $0, relatedBy: .equal, toItem: viewForTextField, attribute: $0, multiplier: 1, constant: -20)
        })
    }
    
    func setNoteImageViewConstraints() {
        noteImageView.translatesAutoresizingMaskIntoConstraints = false
        let attributesTopBottom: [NSLayoutConstraint.Attribute] = [.top, .bottom]
        NSLayoutConstraint.activate(attributesTopBottom.map {
            NSLayoutConstraint(item: noteImageView, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 0)
        })
        let attributesLeading: [NSLayoutConstraint.Attribute] = [.leading]
        NSLayoutConstraint.activate(attributesLeading.map {
            NSLayoutConstraint(item: noteImageView, attribute: $0, relatedBy: .equal, toItem: contentView, attribute: $0, multiplier: 1, constant: 50)
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
    
    // MARK: - Configure cell
    
    func configureCell(with text: String) {
        noteTextView.text = text
    }
    

}


