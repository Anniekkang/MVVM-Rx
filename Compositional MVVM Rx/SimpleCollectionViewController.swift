

import UIKit



struct User: Hashable {
    let id = UUID().uuidString
    let name: String
    let age: Int
}

class SimpleCollectionViewController: UICollectionViewController {
    
//    var list = ["뿌링클", "슈프림", "황금올리브", "볼케이노", "푸라닭"]
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "뽀로로", age: 3),
        User(name: "해리포터", age: 33),
        User(name: "도라에몽", age: 5)
    ]
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = setLayout()
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            var backGroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
            backGroundConfiguration.backgroundColor = .lightGray
            backGroundConfiguration.cornerRadius = 15
            backGroundConfiguration.strokeWidth = 2
            backGroundConfiguration.strokeColor = .green
            
            cell.backgroundConfiguration = backGroundConfiguration
            
            content.text = itemIdentifier.name
            content.textProperties.color = .magenta
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
            
//            content.image = indexPath.item < 2 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            content.image = itemIdentifier.age < 8 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            content.imageProperties.tintColor = .orange
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension SimpleCollectionViewController {
    
    private func setLayout() -> UICollectionViewLayout {
        // iOS 14+ 부터 컬렉션뷰를 테이블뷰 처럼 사용 가능(List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = true
        configuration.backgroundColor = .systemPink
        configuration.separatorConfiguration.color = .green
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
}

