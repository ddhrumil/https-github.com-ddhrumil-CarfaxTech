//
//  ViewController.swift
//  Carfax
//
//  Created by Dhrumil Desai on 2021-11-18.
//

import UIKit

struct Response: Decodable {
    let listings: [MyListings]
}

struct MyListings: Decodable {
    let year: Int
    let make: String
    let trim: String
    let model: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonString = "https://carfax-for-consumers.firebaseio.com/assignment.json"
        guard let url = URL(string: jsonString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                print(result)
            }
            catch {
                print("Couldn't fetch data")
            }
        }.resume()
        
    }


}


