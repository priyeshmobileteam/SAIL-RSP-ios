//
//  GuarntorViewController.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 21/11/23.
//

import UIKit

class GuarntorViewController: UIViewController,UISearchControllerDelegate, UISearchBarDelegate  {
    let searchController=UISearchController(searchResultsController: nil)
    
    var filterData=[GuarnorModel]()
    var arrData = [GuarnorModel]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        self.navigationItem.title = "Guarntor List"
        showInernetAlert()
        // delegate and data source
               tableView.delegate = self
               tableView.dataSource = self

               // Along with auto layout, these are the keys for enabling variable cell height
               tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        super.viewDidLoad()
        jsonParsing()
        searchBarSetup()
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
            tableView.tableHeaderView = searchController.searchBar
        }
        
    }
    
    func jsonParsing(){
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
//        let strUrl = "http://10.226.30.125:8380/HISServices/service/webServices/getGuarantorDtl?modeval=1&hospCode=20101&empId=773102"
        let strUrl = "\(ServiceUrl.getGuarantorDtl)\(obj!.hospCode)&empId=\(obj!.umidNo.prefix(6))"
        let url = URL(string: strUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                print(json)
        
            let status = json["status"].stringValue
                if (status == "1"){
                    
                let jarr=json["data"]
                    print("json- \(jarr)")
                    if jarr.count==0
                    {
                        self.alert(title: "No Record Found!", message: "No Guarantor List found for the selected patient.")
                    }else{
                    for arr in jarr.arrayValue{
                        self.arrData.append(GuarnorModel(json: arr))
                        self.filterData = self.arrData
                   }
                }
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                    self.tableView.reloadData()
                }
                
            }catch{
                print("error:: "+error.localizedDescription)
            }
            }.resume()
    }
    func showInernetAlert() {
        if !AppUtilityFunctions.isInternetAvailable() {
            alert(title: "Warning",message: "The Internet is not available")
        }
    }
    func alert(title:String,message:String)
    {
        DispatchQueue.main.async {
           
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action: UIAlertAction!) in
            //                print("Handle Ok logic here")
            self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
}
extension GuarntorViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GuarntorTableViewCell
      
       // cell.MyImage.image=UIImage.init(named: "referral_cert")
      //  cell.phone_iv.image =  UIImage(named: "call")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        print("array_data -\(arrData[indexPath.row].patientName)")
        cell.nameLbl.text = ""+arrData[indexPath.row].patientName
        cell.crLbl.text = ""+arrData[indexPath.row].cr
        cell.guarantorStatusLbl.text = ""+arrData[indexPath.row].guarntor_status
        cell.admNoLbl.text = ""+arrData[indexPath.row].adm
        cell.billAmtLbl.text = ""+arrData[indexPath.row].bill_amt
        if(arrData[indexPath.row].guarntor_status == "Active"){
            cell.guarantorStatusLbl.textColor = UIColor.green
        }else{
            cell.guarantorStatusLbl.textColor = UIColor.red
        }
    
        
        return cell
    }
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected cell \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension GuarntorViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText=searchController.searchBar.text else{return}
        if searchText==""
        {
            self.arrData=self.filterData
        }
        else{
            self.arrData=self.filterData
              arrData=arrData.filter{
                  $0.patientName.lowercased().contains(searchText.lowercased())
                  || $0.cr.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
