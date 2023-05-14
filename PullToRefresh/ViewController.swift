//
//  ViewController.swift
//  PullToRefresh
//
//  Created by Nazar Kopeika on 14.05.2023.
//

import UIKit

struct APIResponse: Codable { /* 27 */
    let results: APIResponseResults /* 28 */
    let status: String /* 28 */
}

struct APIResponseResults: Codable { /* 29 */
    let sunrise: String /* 30 */
    let sunset: String /* 30 */
    let solar_noon: String /* 30 */
    let day_length: Int /* 30 */
    let civil_twilight_begin: String /* 30 */
    let civil_twilight_end: String /* 30 */
    let nautical_twilight_begin: String /* 30 */
    let nautical_twilight_end: String /* 30 */
    let astronomical_twilight_begin: String /* 30 */
    let astronomical_twilight_end: String /* 30 */
}



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate { /* 6 2 protocols */

    private var tableData = [String]() /* 37 */
    
    private let table: UITableView = { /* 1 */
       let table = UITableView() /* 2 */
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell") /* 3 */
        return table /* 4 */
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self /* 19 */
        table.dataSource = self /* 20 */
        view.addSubview(table) /* 13 */
        
        fetchData() /* 46 */
        
        table.refreshControl = UIRefreshControl() /* 48 */
        table.refreshControl?.addTarget(self,
                                        action: #selector(didPullToRefresh),
                                        for: .valueChanged) /* 49 */
    }
    @objc private func didPullToRefresh() { /* 50 */
        //Re-fetch data
//        print("Start refresh") /* 53 */
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) { /* 51 */
//            self.table.refreshControl?.endRefreshing() /* 52 */
//        }
        fetchData() /* 54 */
    }
    
    override func viewDidLayoutSubviews() { /* 14 */
        super.viewDidLayoutSubviews() /* 15 */
        table.frame = view.bounds /* 16 */
    }
    
    private func fetchData() { /* 5 */
        tableData.removeAll() /* 55 */
        
        if table.refreshControl?.isRefreshing == true { /* 57 */
            print("refreshing data") /* 58 */
        }
        else { /* 59 */
            print("fetching data") /* 60 */
        }
        
        guard let url = URL(string: "https://api.sunrise-sunset.org/json?date=2020-8-1&lng=37.3230&lat=-122.0322&formatted=0") else { /* 21 */
            return /* 22 */
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, error in /* 23 */ /* 42 add weak self */
            guard let strongSelf = self, let data = data, error == nil else { /* 24 */ /* 43 add strongSelf */
                return /* 25 */
            }
            
            var result: APIResponse? /* 31 */
            do { /* 32 */
                result = try JSONDecoder().decode(APIResponse.self, from: data) /* 33 */
            }
            catch { /* 34 */
                //handle error
            }
            
            guard let final = result else { /* 35 */
                return /* 36 */
            }
            
            strongSelf.tableData.append("Sunrise: \(final.results.sunrise)") /* 40 */
            strongSelf.tableData.append("Sunset: \(final.results.sunset)") /* 41 */
            strongSelf.tableData.append("Day length: \(final.results.day_length)") /* 44 */
            
            DispatchQueue.main.async { /* 47 */
                strongSelf.table.refreshControl?.endRefreshing() /* 56 */
                strongSelf.table.reloadData() /* 45 */
            }
        })
        
        task.resume() /* 26 */
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 7 */
        tableData.count /* 8 */ /* 39 change 10 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 9 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 10 */
        cell.textLabel?.text = tableData[indexPath.row] /* 11 */ /* 38 change "Hello" */
        return cell /* 12 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 17 */
        tableView.deselectRow(at: indexPath, animated: true) /* 18 */
    }


}

