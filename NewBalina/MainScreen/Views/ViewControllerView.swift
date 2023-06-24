//
//  ViewControllerView.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import UIKit

fileprivate struct Constants {
    static let COLLECTION_HEIGHT: CGFloat = 200
    static let INDICATOR_SIZE: CGFloat = 50
}

final class ViewControllerView: UIView {
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isUserInteractionEnabled = true
        collectionView.layer.masksToBounds = true
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: String(describing: ContentCell.self))
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layoutElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutElements() {
        layoutCollectionView()
        layoutActivityIndicator()
    }
    
    private func layoutCollectionView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.COLLECTION_HEIGHT)
        ])
    }
    
    private func layoutActivityIndicator() {
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicator.widthAnchor.constraint(equalToConstant: Constants.INDICATOR_SIZE),
            indicator.heightAnchor.constraint(equalToConstant: Constants.INDICATOR_SIZE)
        ])
    }
}

//MARK: - Helpers
extension ViewControllerView {
    
    func showActivityIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
        isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        indicator.isHidden = true
        indicator.stopAnimating()
        isUserInteractionEnabled = true
    }
}
