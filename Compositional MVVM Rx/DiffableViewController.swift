

import UIKit
import Kingfisher


class DiffableViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = DiffableViewModel()
    
    var list = ["아이폰", "아이패드", "에어팟", "맥북", "아이맥", "애플워치"]
    
//    private var cellRegisteration: UICollectionView.CellRegistration<UICollectionViewListCell, String>!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>! // <Section, DataType>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        collectionView.collectionViewLayout = setLayout()
        configureDataSource()//초기화코드
        collectionView.delegate = self
        searchBar.delegate = self
        
        //순서중요
        viewModel.photoList.bind { photo in
           
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo.results)
            self.dataSource.apply(snapshot)
        }
        
        
    }
    
}

extension DiffableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
//        let alert = UIAlertController(title: item, message: "사고싶다!", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "확인", style: .cancel)
//        alert.addAction(ok)
//        present(alert, animated: true)
    }
}

extension DiffableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.requestSearchPhoto(query: searchBar.text!)
    }
}

extension DiffableViewController {
    
    private func setLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            //string > URL > Data > Image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
                
                
            }
          
          
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .orange
            cell.backgroundConfiguration = background
        }
        
        // collectionView.dataSource = self 역할
        // numberOfItemsInSection과 cellForItemAt 역할도 대신함.
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
       
    }
}
