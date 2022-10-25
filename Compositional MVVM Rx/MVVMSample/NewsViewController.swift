//
//  NewsViewController.swift
//  Compositional MVVM Rx
//
//  Created by 나리강 on 2022/10/20.
//

import UIKit

class NewsViewController: UIViewController {

    var viewModel = NewsViewModel()
    
    var dataSource : UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierachy()
        configureDataSource()
        
        
        bindData()
        configureViews()
     
       

    }
    
    func bindData(){
        
      
         viewModel.pageNumber.bind { value in
             self.numberTextField.text = value
         }
        
        viewModel.sample.bind { item in
        
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
        
        
        
    }
    
    func configureViews(){
        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
    }
    
    @objc func numberTextFieldChanged(){
        guard let text = numberTextField.text else { return }
        viewModel.changePageNumberFormat(text: text)
        
        
    }
    

    @objc func resetButtonTapped(){
        viewModel.resetSample()
        
        
    }
    @objc func loadButtonTapped(){
        viewModel.loadSample()
        
    }
 

}

extension NewsViewController {
    
    func configureHierachy() {
        collectionView.collectionViewLayout = creatLayout()
        collectionView.backgroundColor = .lightGray
        
    }
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, IndexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(News.items)
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    func creatLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
        
        
    }
}
