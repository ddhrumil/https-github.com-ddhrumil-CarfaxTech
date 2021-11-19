//
//  ViewController.swift
//  Carfax
//
//  Created by Dhrumil Desai on 2021-11-18.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}



//struct Response: Decodable {
//    let listings: [MyListings]
//}
//
//struct MyListings: Decodable {
//    let year: Int
//    let make: String
//    let trim: String
//    let model: String
//    let mileage: Float
//    let listPrice: Float
//
//}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   // var result: Response?
    
    var listings: Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
        
        
        
        
        let jsonString = "https://carfax-for-consumers.firebaseio.com/assignment.json"
        guard let url = URL(string: jsonString) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode != 200) {
                    print("error")
                }
            }
            
            if let myData = data {
                if let json = try? JSONSerialization.jsonObject(with: myData, options: []) as! Dictionary<String,Any> {
                    if let myListings = json["listings"] as? Array<Dictionary<String,Any>> {
                        self.listings = myListings
                        //(self.listings)
                        DispatchQueue.main.sync {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        session.resume()
//        URLSession.shared.dataTask(with: url) { [self] data, response, error in
//            guard let data = data else { return }
//
//            do {
//                self.result = try JSONDecoder().decode(Response.self, from: data)
//                //print(result!.listings[0].year)
//            }
//            catch {
//                print("Couldn't fetch data")
//            }
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }.resume()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = listings[indexPath.row]
        //print(row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        if let make = row["make"] as? String {
            cell.makeOutlet.text = make
        }
        
        if let model = row["model"] as? String {
            cell.modelOutlet.text = model
        }
        if let year = row["year"] as? Int {
            cell.yearOutlet.text = String(year)
        }
       
        if let trim = row["trim"] as? String {
            cell.trimOutlet.text = trim
        }
        
        if let price = row["currentPrice"] as? Float {
            cell.priceOutlet.text = "$" + String(price)
        }
        
        if let mileage = row["mileage"] as? Float {
            cell.mileageOutlet.text = String(mileage) + " Mi"
        }

        if let dealer = row["dealer"] as? Dictionary<String,Any> {
            let phoneNumber = dealer["phone"] as? String
            cell.phoneOutlet.text = phoneNumber
            
            let stateLocation = dealer["state"] as? String
            let cityLocation = dealer["city"] as? String
            //print(cityLocation)
            cell.locationOutlet.text = (cityLocation ?? "") + " | " + (stateLocation ?? "")
            
        }
        
        if let images = row["images"] as? Dictionary<String,Any> {
            //print(images)
            print(images["baseUrl"])
            let defaultUrl = (images["baseUrl"] as? String)
            
            //print(defaultUrl)
            
            cell.imageOutlet.downloaded(from: defaultUrl! + "/7/640x480")
            cell.imageOutlet.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.size.width
        return CGSize(width: cellWidth, height: cellWidth*0.8)
    }


}


