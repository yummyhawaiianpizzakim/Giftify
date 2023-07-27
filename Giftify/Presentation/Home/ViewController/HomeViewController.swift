//
//  HomeViewController.swift
//  Giftify
//
//  Created by 김요한 on 2023/07/25.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

class HomeViewController: UIViewController {
    var viewModel: HomeViewModel?
    let disposeBag = DisposeBag()
    
    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeSection.Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeSection.Item>
    
    var dataSource: DataSource?
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout(section: .home))
        collection.register(NearSortHomeCollectionCell.self, forCellWithReuseIdentifier: NearSortHomeCollectionCell.id)
        collection.register(NearSortHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: NearSortHeaderView.id)
        collection.register(DDaySortHomeCollectionCell.self, forCellWithReuseIdentifier: DDaySortHomeCollectionCell.id)
        collection.register(DDaySortHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: DDaySortHeaderView.id)
        collection.allowsMultipleSelection = true
        return collection
    }()
    
    lazy var addGifticonButton: UIButton = {
        let button = UIButton()
        let imageSize = CGSize(width: 60, height: 60)
        button.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .orange
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(viewModel: HomeViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.setDataSource()
        self.bind()
    }
}

private extension HomeViewController {
    func configureUI() {
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view.addSubview(self.addGifticonButton)
        self.addGifticonButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-10)
            make.width.height.equalTo(60)
        }
    }
    
    func bind() {
        let input = HomeViewModel.Input(
            viewDidLoad: Observable.just(()),
            didTapAddGifticonButton: self.addGifticonButton.rx.tap.asObservable()
        )
        let output = self.viewModel?.transform(input: input)
        
        output?.dataSources.asDriver()
            .map({[weak self] dataSources in
                (self?.generateSnapshot(dataSources: dataSources))!
            })
            .drive(onNext: {[weak self] snapshot in
                self?.dataSource?.apply(snapshot)
            })
            .disposed(by: self.disposeBag)
    }
    
    func createLayout(section: CollectionLayout) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { int, layoutEnvironment -> NSCollectionLayoutSection? in
            return section.createLayout(index: int)
        }
        return layout
    }
    
    func generateSnapshot(dataSources: [MainDataSource]) -> Snapshot {
        var snapshot = Snapshot()
//        dataSources.forEach { items in
//            items.forEach { section, values in
//                if !values.isEmpty {
//                    snapshot.appendSections([section])
//                    snapshot.appendItems(values, toSection: section)
//                } else {
////                    self.placeholderView.isHidden = false
//                }
//            }
//        }
        dataSources.forEach { items in
            items.forEach { section, values in
                if !values.isEmpty {
                    snapshot.appendSections([section])
                    snapshot.appendItems(values, toSection: section)
                } 
            }
        }
        return snapshot
    }
    
    func setDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { [weak self]
            collView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
            switch item {
            case .near(let gifticon):
                guard let cell = collView.dequeueReusableCell(withReuseIdentifier: NearSortHomeCollectionCell.id, for: indexPath) as? NearSortHomeCollectionCell else { return UICollectionViewCell() }
                cell.configureCell(item: gifticon)
                return cell
            case .dDay(let gificon):
                guard let cell = collView.dequeueReusableCell(withReuseIdentifier: DDaySortHomeCollectionCell.id, for: indexPath) as? DDaySortHomeCollectionCell else { return UICollectionViewCell() }
//                cell.configureCell(item: gifticon)
                return cell
            }
           
        })
        
        self.dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            guard let self else { return UICollectionReusableView() }
            
            switch indexPath.section {
            case 0:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind, withReuseIdentifier: NearSortHeaderView.id, for: indexPath)
                        as? NearSortHeaderView else { return UICollectionReusableView() }
                return header
            case 1:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind, withReuseIdentifier: DDaySortHeaderView.id, for: indexPath)
                        as? DDaySortHeaderView else { return UICollectionReusableView() }
                return header
            default:
                return UICollectionReusableView()
            }
        }
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.interpolationQuality = .high
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
