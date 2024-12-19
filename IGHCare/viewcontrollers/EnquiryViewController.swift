
import UIKit
import Foundation
import SystemConfiguration
class EnquiryViewController: UIViewController,URLSessionDelegate, UISearchBarDelegate,UISearchControllerDelegate{

    
    @IBOutlet weak var btnGeneral: UIButton!
    
    @IBOutlet weak var btnSpecial: UIButton!
    
    @IBOutlet weak var btnAll: UIButton!
    
    var arrData = [EnquiryModel]()
    var generalData=[EnquiryModel]()
    var specialData=[EnquiryModel]()
    var allData=[EnquiryModel]()

    let searchController=UISearchController(searchResultsController: nil)
    var isGeneral=false
    var isSpecial=false
    var isAll=false
    
    @IBOutlet weak var enquiryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "OPD Enquiry"
        searchController.loadViewIfNeeded()
        showAlert()
        //enquiryTableView.rowHeight = UITableView.automaticDimension
        //enquiryTableView.estimatedRowHeight = 44
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
     
        jsonParsing()
        searchBarSetup()

    }
    @IBAction func btnAll(_ sender: Any) {
        btnAll.isSelected=true
        btnGeneral.isSelected=false
        btnSpecial.isSelected=false
        arrData=allData
        enquiryTableView.reloadData()
            }
    
    @IBAction func btnGeneral(_ sender: Any) {
        btnAll.isSelected=false
        btnGeneral.isSelected=true
        btnSpecial.isSelected=false
       arrData=generalData
        print("general button clicked")
        enquiryTableView.reloadData()
    }
    @IBAction func btnSpecial(_ sender: Any) {
        btnAll.isSelected=false
        btnGeneral.isSelected=false
        btnSpecial.isSelected=true
        arrData=specialData
        enquiryTableView.reloadData()
    }
    
    func jsonParsing(){
       
        
       // let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let url = URL(string: ServiceUrl.enquiryUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                print(data)
                //                print(data)
                //                let results = json["results"]
                
               

                for arr in json.arrayValue{
                    self.allData.append(EnquiryModel(json: arr))
                  
                    if arr["rosterType"].stringValue=="General"
                    {
                    self.generalData.append(EnquiryModel(json: arr))
                        
                    }
                    if arr["rosterType"].stringValue=="Special"
                    {
                    self.specialData.append(EnquiryModel(json: arr))
                    }
                    
//                    print(arr["rosterType"].stringValue)
                
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
                 self.arrData=self.generalData
                DispatchQueue.main.async {
                    self.enquiryTableView.reloadData()
                    
                }
            
            }catch{
                
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
                
                
                print(error.localizedDescription)
            }
            }.resume()
    }
    
   
    
    private func searchBarSetup(){
        searchController.searchResultsUpdater=self
        searchController.searchBar.delegate=self
        //searchController.searchBar.backgroundColor = .sys
        
     //  self.searchController.dimsBackgroundDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController=searchController
        } else {
            
            searchController.hidesNavigationBarDuringPresentation = false
            enquiryTableView.tableHeaderView = searchController.searchBar
        }
       
        
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
 
    
    
}



extension EnquiryViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText=searchController.searchBar.text else{return}
        if searchText==""
        {
            if btnGeneral.isSelected==true{
                arrData=generalData
            }
            else if btnSpecial.isSelected==true
            {
                arrData=specialData
            }
            else{
                arrData=allData
            }
//             arrData=allData
        }
        else{
            if btnGeneral.isSelected==true{
                arrData=generalData
            }
            else if btnSpecial.isSelected==true
            {
                arrData=specialData
            }
            else{
                arrData=allData
            }
            arrData=arrData.filter{
                $0.deptName.lowercased().contains(searchText.lowercased()) ||
                $0.unitName.lowercased().contains(searchText.lowercased())
            }
        }
        enquiryTableView.reloadData()
    }
}

extension EnquiryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EnquiryTableViewCell
        

            cell.lblDeptName.text = arrData[indexPath.row].deptName+" - "+arrData[indexPath.row].unitName

            //cell.lblUnitName.text = "Unit Name :  "+arrData[indexPath.row].unitName
            
            cell.lblLocation.text = "Building/Block :  "+arrData[indexPath.row].location+"/"+arrData[indexPath.row].room
            
            
            let days = "Unit Days :\n  "+arrData[indexPath.row].unitDays
            
            cell.lblUnitDays.text=days.replacingOccurrences(of: ")", with: ")\n", options: .literal, range: nil)
        
        

        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}



