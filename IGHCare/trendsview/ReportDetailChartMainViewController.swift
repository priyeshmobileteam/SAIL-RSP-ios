//
//  SmartReportMainViewController.swift
//  SAIL Bokaro
//
//  Created by HICDAC on 15/02/24.
//

import UIKit
import SwiftUI
import Charts
struct ValuesModel: Codable {
    var testName: String = ""
    var entryDate: String = ""
    var value: String = ""
    var range: String = ""
    var isOutOfRange: String = ""
}
struct TestDetails: Codable {
    let TESTNAME: String
    let ENTRYDATE: String
    let VALUE: String
    let isOutOfRange: String
    let RANGE: String
}

struct Parameter: Codable {
    let PARAMETERNAME: String
    let DETAILS: [TestDetails]
}

class ReportDetailChartMainViewController: UIViewController , ChartViewDelegate, URLSessionDelegate {
    var selectedIndices = Set<Int>()
    
    
    @IBOutlet weak var valueTableView: UITableView!
    var arrValue: [ValuesModel] = []
    //Chart start
    @IBOutlet weak var lineCharts: LineChartView!
    var arrDataChartlist=[ChartModel]()
    //ChartEnd
    
    @IBOutlet weak var valueView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var tab_stack: UIStackView!
    @IBOutlet weak var tab_lbl1: UILabel!
    @IBOutlet weak var tab_lbl2: UILabel!
    
    @IBOutlet weak var smartReportView: UIView!
    @IBOutlet weak var TrackDownloadReportView: UIView!
    ///Smart report start
    @IBOutlet weak var sampleWiseTableView: UITableView!
    @IBOutlet weak var parametersLbl: UILabel!
    
    @IBOutlet weak var trendsLbl: UILabel!
    
    @IBOutlet weak var trendsValueSwitch: UISwitch!
    
    @IBOutlet weak var valueLbl: UILabel!
    
    
    
    var list=[SmartDetailModel]()
    ///Smart report end
    ///Track start
    var crno=""
    var hospCode=""
    var sampleNo=""
    var isSampleNoEmpty=""
    var arrData=[TrackerModel]()
    ///Track end
    
    @IBOutlet var lblNoReportsFound: UILabel!
    var obj : PatientDetails!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "udCrno") != nil  {
            self.crno=(UserDefaults.standard.object(forKey: "udCrno") as! String)
            self.hospCode=(UserDefaults.standard.object(forKey: "udHospCode") as! String)
        }else{
            obj = UserDefaults.standard.retrieve(object: PatientDetails.self, fromKey: "patientDetails")
            self.crno=obj!.crno
            self.hospCode=obj!.hospCode
        }
        valueTableView.dataSource = self
        valueTableView.delegate = self
        
        trendsBlue()
        trendsLbl.isUserInteractionEnabled = true
        let trendsGesture = UITapGestureRecognizer(target: self, action: #selector(trendsTapped(_:)))
        trendsLbl.addGestureRecognizer(trendsGesture)
        
        valueLbl.isUserInteractionEnabled = true
        let valueGesture = UITapGestureRecognizer(target: self, action: #selector(valueTapped(_:)))
        valueLbl.addGestureRecognizer(valueGesture)
        
        // Enable single selection
        collectionView.allowsMultipleSelection = false
        trendsValueSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // Set up your collection view's horizontal scroll direction
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        tab_stack.translatesAutoresizingMaskIntoConstraints = false
        tab_stack.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        tab_stack.isLayoutMarginsRelativeArrangement = true
        tab_stack.spacing = 2
        
        tab_lbl1.isUserInteractionEnabled = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(smartReportTapped))
        tab_lbl1.addGestureRecognizer(tapGesture1)
        
        tab_lbl2.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(trackDownloadTapped))
        tab_lbl2.addGestureRecognizer(tapGesture2)
        reportSummaryDefault()
        
        // Set up your collection view's horizontal scroll direction
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        self.sampleWiseDataDetailsMobile()
        
        
    }
    @objc func trendsTapped(_ sender: UITapGestureRecognizer) {
        trendsBlue()
    }
    @objc func valueTapped(_ sender: UITapGestureRecognizer) {
        valueBlue()
    }
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            valueBlue()
        } else {
            trendsBlue()
        }
        
    }
    func valueBlue(){
        valueLbl.font = UIFont.boldSystemFont(ofSize: 16)
        trendsLbl.font = UIFont.systemFont(ofSize: 16)
        valueLbl.textColor = UIColor.systemBlue
        trendsLbl.textColor = UIColor.lightGray
        lineCharts.isHidden = true
        valueView.isHidden = false
        trendsValueSwitch.isOn = true
        
    }
    func trendsBlue(){
        valueLbl.textColor = UIColor.lightGray
        trendsLbl.textColor = UIColor.systemBlue
        
        valueLbl.font = UIFont.systemFont(ofSize: 16)
        trendsLbl.font = UIFont.boldSystemFont(ofSize: 16)
        lineCharts.isHidden = false
        valueView.isHidden = true
        trendsValueSwitch.isOn = false
    }
    @objc func smartReportTapped() {
        reportSummaryDefault()
    }
    @objc func trackDownloadTapped() {
        reportTrends()
    }
    
    func reportSummaryDefault(){
        smartReportView.isHidden = false
        TrackDownloadReportView.isHidden = true
        
        tab_lbl1.clipsToBounds = true
        tab_lbl1.backgroundColor = UIColor.blue
        tab_lbl1.textColor = UIColor.white
        tab_lbl1.layer.cornerRadius = 16
        tab_lbl1.layer.borderWidth = 1
        
        tab_lbl2.layer.cornerRadius = 0
        tab_lbl2.layer.borderWidth = 0
        tab_lbl2.backgroundColor = UIColor.white
        tab_lbl2.textColor = UIColor.blue
        trendsBlue()
        
        
    }
    func reportTrends(){
        smartReportView.isHidden = true
        TrackDownloadReportView.isHidden = false
        
        tab_lbl2.clipsToBounds = true
        tab_lbl2.backgroundColor = UIColor.blue
        tab_lbl2.textColor = UIColor.white
        tab_lbl2.layer.cornerRadius = 16
        tab_lbl2.layer.borderWidth = 1
        
        tab_lbl1.layer.cornerRadius = 0
        tab_lbl1.layer.borderWidth = 0
        tab_lbl1.backgroundColor = UIColor.white
        tab_lbl1.textColor = UIColor.blue
        reportTrendFunction()
    }
    
    func reportTrendFunction(){
        collectionView.reloadData()
        scrollToFirstItem()
    }
    func scrollToFirstItem() {
        if collectionView.numberOfItems(inSection: 0) > 0 {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
            
            // Deselect the previously selected cell
            if let selectedIndexPath = selectedIndexPath {
                collectionView.deselectItem(at: selectedIndexPath, animated: false)
            }
            
            // Update the selectedIndexPath
            selectedIndexPath = indexPath
            
            // Select the new cell
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            
            // Update the cell's state
            updateCell(at: indexPath)
            // Scroll to the selected index, keeping it centered
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.getChart(paraCode: self.list[0].parametercode)
        }
    }
    func sampleWiseDataDetailsMobile(){
        self.list.removeAll()
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        let strUrl = "\(ServiceUrl.sampleWiseDataDetails)\(crno)&hospCode=\(hospCode)&sampleno=\(self.sampleNo)&isSampleNoEmpty=\(self.isSampleNoEmpty)"
        let url = URL(string: strUrl)
        print("url "+strUrl)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{ let json = try JSON(data:data)
                if json.count == 0
                {
                    DispatchQueue.main.async {
                        self.sampleWiseTableView.backgroundView=self.lblNoReportsFound
                        self.sampleWiseTableView.separatorStyle = .none
                        self.sampleWiseTableView.reloadData()
                    }
                }
                else{
                    for arr in json.arrayValue{
                        self.list.append(SmartDetailModel(json: arr))
                    }
                    DispatchQueue.main.async {
                        self.sampleWiseTableView.backgroundView=nil
                        self.sampleWiseTableView.separatorStyle = .singleLine
                        self.sampleWiseTableView.reloadData()
                        self.parametersLbl.text = "\(String(self.list.count)) Parameter(s)"
                    }
                }
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
            }catch{
                print("Sudeep"+error.localizedDescription)
            }
        }.resume()
        
    }
    
    func getChart(paraCode:String) {
        // Your URL
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        var values: [ChartDataEntry] = []
        var values2: [ChartDataEntry] = []
        var circleColors: [NSUIColor] = []
        let urlString = "\(ServiceUrl.paraRawData)\(crno)&hosCode=\(hospCode)&paraCode=\(paraCode)"
        print("urlString-\(urlString)")
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                guard let data = data else {
                    print("No data received")
                    return
                }
                do {
                    // Decode JSON data directly as an array of Parameter
                    let parameters = try JSONDecoder().decode([Parameter].self, from: data)
                    
                    // Access the parsed data
                    var index:Int=0
                    self.arrValue.removeAll()
                    for parameter in parameters {
                        print("Parameter Name: \(parameter.PARAMETERNAME)")
                        for detail in parameter.DETAILS {
                            self.arrValue.append(ValuesModel(testName: detail.TESTNAME, entryDate: detail.ENTRYDATE, value: detail.VALUE, range: detail.RANGE, isOutOfRange: detail.isOutOfRange))
                            
                            var entry:ChartDataEntry
                            if(detail.VALUE != "--" && detail.VALUE != ""){
                                if(detail.isOutOfRange == "1"){
                                    entry = ChartDataEntry(x: Double(index), y: Double(detail.VALUE)!,data: UIColor.red)
                                }else{
                                    entry = ChartDataEntry(x: Double(index), y: Double(detail.VALUE)!,data: UIColor.green)
                                }
                                let circleColor = (detail.isOutOfRange == "1") ? NSUIColor.red : NSUIColor.systemGreen
                                circleColors.append(circleColor)
                                values.append(entry)
                                values2.append(entry)
                            }
                            index+=1
                        }
                    }
                    DispatchQueue.main.async {
                        self.view.activityStopAnimating()
                        self.arrValue.reverse()
                        self.valueTableView.reloadData()
                        
                        let dataSet = LineChartDataSet(entries: values, label: "Normal")
                        dataSet.colors = [NSUIColor.systemGreen]
                        dataSet.lineWidth = 0
                        dataSet.circleColors = circleColors
                        
                        let dataSet2 = LineChartDataSet(entries: values2, label: "Abnormal")
                        dataSet2.colors = [NSUIColor.red]
                        dataSet2.circleColors = circleColors
                        dataSet2.lineWidth = 0
                        
                        let chartData = LineChartData(dataSets: [dataSet, dataSet2])
                        
                        self.lineCharts.data = chartData
                        
                        
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    if let decodingError = error as? DecodingError {
                           switch decodingError {
                           case .keyNotFound(let key, _):
                               print("Key not found: \(key.stringValue)")
                               self.alert(title: "Info!", message: "Value Not found")
                           default:
                               print("Decoding error: \(decodingError.localizedDescription)")
                           }
                       } else {
                           print("Unexpected error: \(error.localizedDescription)")
                       }
                    
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
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
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard challenge.previousFailureCount == 0 else {
            challenge.sender?.cancel(challenge)
            // Inform the user that the user name and password are incorrect
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Within your authentication handler delegate method, you should check to see if the challenge protection space has an authentication type of NSURLAuthenticationMethodServerTrust
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust
            // and if so, obtain the serverTrust information from that protection space.
            && challenge.protectionSpace.serverTrust != nil
            && challenge.protectionSpace.host == ServiceUrl.hostName {
            let proposedCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, proposedCredential)
        }
    }
    
}


extension ReportDetailChartMainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.valueTableView {
            return arrValue.count
        }else{
            return list.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.valueTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ValueTableViewCell
            cell.layer.borderColor = UIColor.systemBlue.cgColor
            cell.layer.borderWidth = 1.0
            cell.layer.cornerRadius = 0
            if(indexPath.row == 0){
                cell.stack1.isHidden = false
            }else{
                cell.stack1.isHidden = true
            }
            cell.testDateLbl.text = self.arrValue[indexPath.row].entryDate
            cell.resultLbl.text = self.arrValue[indexPath.row].value
            cell.bioRefRangeLbl.text = self.arrValue[indexPath.row].range
            
            if (self.arrValue[indexPath.row].isOutOfRange == "1") {
                cell.resultLbl.textColor = UIColor.red
            } else {
                cell.resultLbl.textColor = UIColor.systemGreen
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReportDetailChartTableViewCell
            cell.separatorInset = UIEdgeInsets.zero
            cell.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            if(list[indexPath.row].testname == list[indexPath.row].parametername) {
                cell.lblTestNAme.text = list[indexPath.row].parametername
            } else {
                cell.lblTestNAme.text = "\(list[indexPath.row].parametername) \(" (" + list[indexPath.row].testname + ") ")"
            }
            cell.lblReportDate.text = "Range: " + list[indexPath.row].standardrange
            
            cell.tvOutOfRange.text = list[indexPath.row].value
            if (list[indexPath.row].isOutOfRange == "1") {
                cell.lblTestNAme.textColor = UIColor.red
                cell.tvOutOfRange.textColor = UIColor.red
            } else {
                cell.lblTestNAme.textColor = UIColor.systemGreen
                cell.tvOutOfRange.textColor = UIColor.systemGreen
            }
            cell.isHighOrLow.frame = CGRect(x:  cell.isHighOrLow.frame.origin.x, y:  cell.isHighOrLow.frame.origin.y, width: 30, height: 30)
            if (list[indexPath.row].isHighOrLow == "1") {
                // Set the image to the UIImageView
                cell.isHighOrLow.image = UIImage(systemName: "arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            } else if (list[indexPath.row].isHighOrLow == "2") {
                cell.isHighOrLow.image = UIImage(systemName: "arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
            } else {
                cell.isHighOrLow.image = UIImage(systemName: "")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath {
            collectionView.deselectItem(at: selectedIndexPath, animated: false)
        }
        selectedIndexPath = indexPath
        // Select the new cell
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        // Scroll to the selected index, keeping it centered
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        // Update the cell's state
        self.updateCell(at: indexPath)
    }
    
}
extension ReportDetailChartMainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust the width and height of each cell
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CenteredLabelCollectionViewCell
        // Configure the cell
        cell.label.text = list[indexPath.row].parametername
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Deselect the previously selected cell
        if let selectedIndexPath = selectedIndexPath {
            collectionView.deselectItem(at: selectedIndexPath, animated: false)
        }
        // Update the selectedIndexPath
        selectedIndexPath = indexPath
        
        // Select the new cell
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        // Update the cell's state
        updateCell(at: indexPath)
        // Scroll to the selected index, keeping it centered
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Deselect the cell if it was previously selected
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        }
        // Update the cell's state
        updateCell(at: indexPath)
    }
    func updateCell(at indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CenteredLabelCollectionViewCell {
            if indexPath == selectedIndexPath {
                cell.setSelectedState()
                self.getChart(paraCode: self.list[indexPath.row].parametercode)
            } else {
                cell.setDeselectedState()
            }
        }
    }
}



