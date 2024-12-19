

import UIKit
import Foundation
class LabEnquiryViewController: UIViewController,UISearchBarDelegate,UISearchControllerDelegate {
   
    
    let searchController=UISearchController(searchResultsController: nil)

    
    var arrData = [LabEnquiryModel]()
    var allData=[LabEnquiryModel]()
    @IBOutlet weak var LabEnquiryTableView: UITableView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Lab Enquiry"
        showAlert()
        
        LabEnquiryTableView.rowHeight = UITableView.automaticDimension
        LabEnquiryTableView.estimatedRowHeight = 44
        
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        
        jsonParsing()
        searchBarSetup()
       
        //self.enquiryTableView.rowHeight = 44.0
    }
    func jsonParsing(){
      //  let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let url = URL(string: ServiceUrl.labEnquiryUrl)
   
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                print(data)
//                                print(data)
                //                let results = json["results"]
                
                
                for arr in json.arrayValue{
                   if arr.count==1
                   {
                    continue
                    }
                        self.arrData.append(LabEnquiryModel(json: arr))
                    
                }
                self.allData=self.arrData
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
                DispatchQueue.main.async {
                    self.LabEnquiryTableView.reloadData()
                    
                }
                
            }catch{
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    
    
    
    
  
    func showAlert() {
        if !AppUtilityFunctions.isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "The Internet is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action: UIAlertAction!) in
                //                print("Handle Ok logic here")
                self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    

    
    private func searchBarSetup(){
        searchController.searchResultsUpdater=self
        searchController.searchBar.delegate=self
        
        //self.searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
              navigationItem.searchController=searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            searchController.hidesNavigationBarDuringPresentation = true
            LabEnquiryTableView.tableHeaderView = searchController.searchBar
        }
        
    }
    
    
    
    
    
}
extension LabEnquiryViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText=searchController.searchBar.text else{return}
        if searchText==""
        {
            self.arrData=self.allData
        }
        else{
            self.arrData=self.allData
            arrData=arrData.filter{
                $0.testName.lowercased().contains(searchText.lowercased()) ||
                $0.labName.lowercased().contains(searchText.lowercased())
                
            }
        }
        LabEnquiryTableView.reloadData()
    }
}

extension LabEnquiryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LabEnquiryTableViewCell
        
        
        cell.lblTestName.text = arrData[indexPath.row].testName
        
        cell.lblLabName.text = "Lab Name :  "+arrData[indexPath.row].labName
        
        if arrData[indexPath.row].testPrice=="0"
        {
            cell.lblTestPrice.text = "₹ NA"
        }
        else
        {
            cell.lblTestPrice.text = "₹  "+arrData[indexPath.row].testPrice
        }
        
//        cell.lblIsApptBased.text = "Rs.  "+arrData[indexPath.row].isApptMandatory

        let isApptMandatory = arrData[indexPath.row].isApptMandatory
        if isApptMandatory=="1"
        {
            cell.isApptMandatory.text="*Appointment Mandatory."
        }
        else{
            cell.isApptMandatory.text=""

        }
//        print("days"+days)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
