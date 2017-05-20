//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Sikander Zeb on 16/5/17.
//  Copyright © 2017 Sikander Zeb. All rights reserved.
//

import UIKit
import GoogleMaps

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    var camera: GMSCameraPosition!
    
    lazy var searchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    var businesses: [Business]!
    var searchBarFilters: [Business]!
    var searchActive: Bool = false
    var currentDeal: Bool!
    var currentDistance: Float!
    var currentSort: YelpSortMode!
    var currentCategories: [String]!
    var currentOffset: Int!
    var tempTableFooter: UIView!
    var loadingState: UIActivityIndicatorView!
    var noMoreResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        camera = GMSCameraPosition.camera(withLatitude: 37.785771, longitude: -122.406165, zoom: 15)
        mapView.camera = camera
        
        Business.searchWithTerm(term: "Restaurants", sort: currentSort, categories: currentCategories, deals: currentDeal, distance: currentDistance, offset: currentOffset, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            print("business downloaded are : \(String(describing: businesses)) , error : \(String(describing: error))")
            
            
            self.tableView.reloadData()
            
                if businesses != nil {
                    //UserDefaults.standard.setValue(self.businesses, forKey: "businesses")
                    self.placePins()
                }

            }
        )
    }
    
    func placePins(){
        var index = 0
        
        for b in businesses! {
            let marker = GMSMarker(position: b.coordinate!)
            marker.map = self.mapView
            marker.title = b.name!
            marker.appearAnimation = .pop
            marker.userData = index
            index += 1
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {}
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {}
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if businesses != nil {
            searchBarFilters = businesses!.filter({ (business) -> Bool in
                let tmpTitle = business.name
                let range = tmpTitle!.range(of: searchText, options: String.CompareOptions.caseInsensitive)
                return range != nil
            })
        }
        if (searchText == "" && searchBarFilters.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    func onFadedViewTap() {
        self.searchBar.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let businesses = businesses {
            if searchActive {
                return searchBarFilters!.count
            }
            return businesses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath as IndexPath) as! BusinessCell
        var business = searchActive ? searchBarFilters : businesses!
        cell.tag = indexPath.row
        cell.business = business?[indexPath.row]
        if indexPath.row == businesses.count - 1 {
            noMoreResultLabel.isHidden ? self.loadingState.startAnimating() : self.loadingState.stopAnimating()
            searchMoreBusinesses()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let index = tableView.cellForRow(at: indexPath)?.tag
        let b:Business? = businesses[index!]
        performSegue(withIdentifier: "showDetail", sender: b)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func searchMoreBusinesses() {
        var moreBusinesses: [Business]!
        currentOffset = businesses.count
        Business.searchWithTerm(term: "Restaurants", sort: currentSort, categories: currentCategories, deals: currentDeal, distance: currentDistance, offset: currentOffset, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            moreBusinesses = businesses
            if moreBusinesses.count == 0 {
                self.noMoreResultLabel.isHidden = false
            } else {
                self.noMoreResultLabel.isHidden = true
                for business in moreBusinesses {
                    self.businesses.append(business)
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
        } as! ([Business]?, Error?) -> Void)
    }

    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    
        let infoWindow = Bundle.main.loadNibNamed("CustomInfo", owner: nil, options: nil)?.first! as! CustomInfo
        
        let index = marker.userData as! Int

        infoWindow.business = businesses[index]
        
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let index = marker.userData as! Int
        let b:Business? = businesses[index]
        performSegue(withIdentifier: "showDetail", sender: b)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destVC = segue.destination as! DetailViewController
            destVC.business = sender as? Business
        }
    }
    
}
