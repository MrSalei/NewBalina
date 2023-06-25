//
//  ViewController.swift
//  NewBalina
//
//  Created by Илья Салей on 24.06.23.
//

import UIKit
import AVFoundation
import Combine

fileprivate struct Constants {
    static let CELL_HEIGHT: CGFloat = 200
}

final class ViewController: UIViewController {
    
    private let viewModel: ViewControllerViewModel
    private let imagePicker = UIImagePickerController()
    private var items = [CollectionItem]()
    private var subscribers = Set<AnyCancellable>()
    private var pressedId: Int?
    
    var onShowAlert: ((String)->(Void))?
    
    private var contentView: ViewControllerView {
        view as! ViewControllerView
    }
    
    init(viewModel: ViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ViewControllerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupImagePicker()
        setupDelegates()
        contentView.showActivityIndicator()
        viewModel.requestItems()
    }
    
    private func bindViewModel() {
        viewModel.itemsReceiver.sink { [weak self] items in
            self?.contentView.hideActivityIndicator()
            self?.items = items
            self?.contentView.collectionView.reloadData()
        }.store(in: &subscribers)
        viewModel.alertReceiver.sink { [weak self] msg in
            self?.contentView.hideActivityIndicator()
            self?.onShowAlert?(msg)
        }.store(in: &subscribers)
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }
    
    private func setupDelegates() {
        contentView.collectionView.delegate = self
        contentView.collectionView.dataSource = self
    }
}

//MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ContentCell.self), for: indexPath) as? ContentCell else { return UICollectionViewCell() }
        
        let item = items[indexPath.row]
        cell.setupCell(urlString: item.urlString, name: item.name)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let bounds = contentView.window?.windowScene?.screen.bounds else { return .zero }
        return CGSize(width: bounds.width, height: Constants.CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pressedId = items[indexPath.row].id
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                DispatchQueue.main.async { [weak self] in
                    guard let imagePicker = self?.imagePicker else { return }
                    self?.present(imagePicker, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.onShowAlert?("Allow access to camera in settings.")
                }
            }
        }
    }
}

//MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            var imageData: Data?
            if let selectedImage = info[.editedImage] as? UIImage {
                imageData = selectedImage.jpegData(compressionQuality: 0.8)
            } else if let selectedImage = info[.originalImage] as? UIImage {
                imageData = selectedImage.jpegData(compressionQuality: 0.8)
            }
            guard let id = self?.pressedId, let imageData else { return }
            let item = StoredContent(id: id, name: "Saley Ilya Igorevich", image: imageData)
            self?.contentView.showActivityIndicator()
            self?.viewModel.upload(item: item)
        }
    }
}
