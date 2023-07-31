//
//  AddGifticonViewController.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/26.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PhotosUI

class AddGifticonViewController: UIViewController {
    var viewModel: AddGifticonViewModel?
    let disposeBag = DisposeBag()

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
   
    var dataSource: DataSource?
    
    private lazy var imagePicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images
        configuration.selection = .ordered
        var imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        return imagePicker
    }()
    
    lazy var scrollView = UIScrollView()
    
    lazy var placeHolder = AddGifticonPlaceHolderView()
    
    lazy var addGifticonTextView = AddGiftiTextView()
    
    lazy var imageCollectionView: UICollectionView = {
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: self.generateAddGifticonLayout())
        collectView.register(AddGifticonImageCollectionCell.self, forCellWithReuseIdentifier: AddGifticonImageCollectionCell.id)
        collectView.register(AddGifticonCollectionButtonCell.self, forCellWithReuseIdentifier: AddGifticonCollectionButtonCell.id)
        return collectView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: AddGifticonViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    // 이름 바코드 브랜드 유효기간
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.configureUI()
//        self.setDataSource()
        self.applyDataSource()
        self.bindUI()
    }
}

private extension AddGifticonViewController {
    func configureUI() {
//        self.view.addSubview(self.imageCollectionView)
//        self.view.addSubview(self.addGifticonTextView)
        self.view.addSubview(self.scrollView)
        [self.imageCollectionView, self.addGifticonTextView].forEach { self.scrollView.addSubview($0) }
        
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.width.equalToSuperview()
        }
        
        self.imageCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalToSuperview()
        }
        
        self.addGifticonTextView.snp.makeConstraints { make in
            make.top.equalTo(self.imageCollectionView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    func bindUI() {
        let input = AddGifticonViewModel.Input(
//            didTapAddButton: self.addbutton.rx.tap.asObservable()
//            pickedImages: self.pickedGificonImages.asObservable()
        )
        let output = self.viewModel?.transform(input: input)
        self.viewModel?.imageData
            .subscribe(onNext: { items in
                self.applySnapshot(items: items)
            })
            .disposed(by: self.disposeBag)
        
        self.imageCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if self?.imageCollectionView.cellForItem(at: indexPath) is AddGifticonCollectionButtonCell {
                    print("tap addBuGifti")
                    self?.checkAccessForPHPicker()
                } else {
//                    print(indexPath.item, indexPath.row)
                    self?.viewModel?.tapImage.accept(indexPath.item)
                }
            })
            .disposed(by: disposeBag)

        output?.strings.asDriver(onErrorJustReturn: [])
            .drive(onNext: {[weak self] strings in
                if !strings.isEmpty {
                    self?.addGifticonTextView.titleTextField.text = strings[2]
                    self?.addGifticonTextView.brandTextField.text = strings[0]
                }
            })
            .disposed(by: self.disposeBag)
        
        output?.expiredDate.asDriver(onErrorJustReturn: Date())
            .drive(onNext: {[weak self] date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let string = formatter.string(from: date)
                self?.addGifticonTextView.expiredDateTextField.text = string
            })
            .disposed(by: self.disposeBag)
        
        output?.barcodeNym.asDriver(onErrorJustReturn: "")
            .drive(onNext: {[weak self] string in
                self?.addGifticonTextView.barCodeTextField.text = string
            })
            .disposed(by: self.disposeBag)
        
    }
    
    func createLayout(section: CollectionLayout) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { int, layoutEnvironment -> NSCollectionLayoutSection? in
            return section.createLayout(index: int)
        }
        return layout
    }
    
    func generateAddGifticonLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func applyDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.imageCollectionView, cellProvider: { collectionView, indexPath, item in
            
            switch item {
            case .addButton:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddGifticonCollectionButtonCell.id, for: indexPath) as? AddGifticonCollectionButtonCell else { return UICollectionViewCell() }
                
                return cell
            
            case .image:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddGifticonImageCollectionCell.id, for: indexPath) as? AddGifticonImageCollectionCell,
                      let itemData = item.data else { return UICollectionViewCell() }
                
                cell.configureCell(item: itemData)
                return cell
            }
        })
        
    }
    
    func applySnapshot(items: [AddGifticonViewController.Cell]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        self.dataSource?.apply(snapshot)
    }

}

extension AddGifticonViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let dispatchGroup = DispatchGroup()
        var dataDict: [Int: Data] = [:]
        
        results
            .map { $0.itemProvider }
            .enumerated()
            .forEach { index, itemProvider in
                dispatchGroup.enter()
                
                guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
                    return
                }
                
                itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                    guard let selectedImage = image as? UIImage,
                          let data = selectedImage.jpegData(compressionQuality: 0.2) else {
                        dispatchGroup.leave()
                        return
                    }
                    
                    dataDict[index] = data
                    dispatchGroup.leave()
                }
            }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            let orderedData = dataDict
                .sorted(by: { $0.key < $1.key })
                .compactMap { $0.value }
            
            self?.viewModel?.addImage(orderedData: orderedData)
        }
        
    }
    
    private func checkAccessForPHPicker() {
        
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            present(self.imagePicker, animated: true)
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                switch status {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self?.present(self!.imagePicker, animated: true)
                    }
                case .notDetermined, .restricted, .denied:
                    print("앨범 접근이 필요합니다.")
                @unknown default:
                    print("\(#function) unknown error")
                }
            }
            
        case .denied, .restricted:
            print("앨범 접근이 필요합니다.")
        @unknown default:
            print("\(#function) unknown error")
        }
    }
    
}

extension AddGifticonViewController {
    typealias Item = AddGifticonViewController.Cell
    
    enum Section {
        case main
    }
    
    enum Cell: Hashable {
        case image(data: Data)
        case addButton
        
        var data: Data? {
            switch self {
            case let .image(data):
                return data
            case .addButton:
                return nil
            }
        }
    }
}
