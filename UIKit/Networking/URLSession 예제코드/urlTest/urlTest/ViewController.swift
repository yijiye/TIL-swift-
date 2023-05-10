//
//  ViewController.swift
//  urlTest
//
//  Created by jiye Yi on 2023/03/20.
//

import UIKit

final class ViewController: UIViewController {
    
    private let url: [URL] = [
        URL(string: "https://wallpaperaccess.com/download/europe-4k-1369012")!,
        URL(string: "https://wallpaperaccess.com/download/europe-4k-1318341")!,
        URL(string: "https://wallpaperaccess.com/download/europe-4k-1379801")!
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewTableViewCell
        
        if indexPath.section < 5 {
            cell.cellLabel.text = "(\(indexPath.section), \(indexPath.row))"
        } else {
            cell.cellLabel.text = ""
        }
        
        if indexPath.row == 2 {
            cell.backgroundColor = UIColor.red
        }
        // 1
        let url = URL(string: Image.init(rawValue: indexPath.row % 3)!.urlString)!
        
        // 2
        let task = URLSession.shared.dataTask(with: url) {/* 4 closure의 값 캡쳐*/ data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("httpResponse 오류")
                return
            }
            guard let data = data,
                  let webImage = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                if indexPath == tableView.indexPath(for: cell) { // 포인트! indexPath가 tableView의 indexPath와 동일하면 이미지를 띄우도록 조건을 걸어줌
                    cell.imageView?.image = webImage
                }
            }
        }
        // 3
        task.resume()

        return cell
    }
}


enum Image: Int {
    case zero = 0, one, two
    
    var urlString: String {
        switch self {
        case .zero:
            return "https://wallpaperaccess.com/download/europe-4k-1369012"
        case .one:
            return "https://wallpaperaccess.com/download/europe-4k-1318341"
        case .two:
            return "https://wallpaperaccess.com/download/europe-4k-1379801"
        }
    }
}


//            let url = url[indexPath.row]
//            let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                if let error = error {
//                    return
//                }
//                guard let httpResponse = response as? HTTPURLResponse,
//                    (200...299).contains(httpResponse.statusCode) else {
//                    return
//                }
//                if let mimeType = httpResponse.mimeType, mimeType == "application/octet-stream", //breakpoint 걸어서
//                    let data = data,
//                    let webImage = UIImage(data: data) {
//
//                    DispatchQueue.main.async {
//                        cell.imageView?.image = webImage
//                    }
//                }
//            }
//            task.resume()
//        } else {
//            cell.imageView?.image = UIImage(systemName: "person.fill")


//    } else {
//        cell.imageView?.image = UIImage(systemName: "person.fill")
//
