

import UIKit

class SimpleTableViewController: UITableViewController {
    
    let list = ["슈비버거", "프랭크", "바스버거", "다운타우너", "쉑쉑버거"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "")!
//        cell.textLabel?.text = list[indexPath.row]
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration() // 구조체
        content.text = list[indexPath.row] // textLabel
        content.secondaryText = "먹고싶다" // detailTextLabel
        cell.contentConfiguration = content
        
        return cell
    }
    
}

