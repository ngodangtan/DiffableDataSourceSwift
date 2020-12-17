//
//  ViewController.swift
//  DiffableDatasource
//
//  Created by Ngo Dang tan on 17/12/2020.
//

import UIKit

class ViewController: UIViewController {

    private let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    enum Section: Hashable {
        case first
    }
    struct Fruit:Hashable {
        let title:String
    }
    var fruits = [Fruit]()
    private var dataSource: UITableViewDiffableDataSource<Section,Fruit>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = model.title
            return cell
        })
        title = "My Fruits"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(didTapAdd))
    }
    @objc func didTapAdd(){
        let actionSheet = UIAlertController(title: "Select Fruit", message: nil, preferredStyle: .actionSheet)
        for x in 0...100{
            actionSheet.addAction(UIAlertAction(title: "Fruit \(x+1)", style: .default, handler: { [weak self] _ in
                let fruit = Fruit(title: "Fruit \(x+1)")
                self?.fruits.append(fruit)
                self?.updateDatasource()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section,Fruit>()
        snapshot.appendSections([.first])
        snapshot.appendItems(fruits)
        
        dataSource.apply(snapshot,animatingDifferences: true,completion: nil)
    }

}
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let fruit = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        print(fruit.title)
    }
}

