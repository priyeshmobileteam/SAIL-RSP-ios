//
//  DoctorLoginViewController.swift
//  AIIMS Bhubaneswar Swasthya
//
//  Created by sudeep rai on 21/08/20.
//  Copyright © 2020 sudeep rai. All rights reserved.
//

import UIKit
import SystemConfiguration

import CommonCrypto
class DoctorLoginViewController: UIViewController,UITextFieldDelegate, URLSessionDelegate {
    var progressBar : UIAlertController!;
    
    @IBOutlet weak var edtUsername: UITextField!
    
    
    @IBOutlet weak var edtPassword: UITextField!
    
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var exit_iv: UIImageView!
    
    @IBOutlet weak var closeImg: UIImageView!
    @IBAction func btnLoginAction(_ sender: Any) {
        
        
        jsonParsing()
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        btnLogin.layer.cornerRadius = 10
        if traitCollection.userInterfaceStyle == .light {
            print("Light mode")
            closeImg.image =  UIImage(named: "close")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            
        } else {
            print("Dark mode")
            closeImg.image =  UIImage(named: "close")?.withTintColor(.white, renderingMode: .alwaysOriginal)        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        exit_iv.isUserInteractionEnabled = true
        exit_iv.addGestureRecognizer(tapGestureRecognizer)
        
        hideKeyboardWhenTappedAround()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.edtUsername.delegate = self
        self.edtPassword.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        if (UserDefaults.standard.string(forKey: "udWhichModuleToLogin")=="doctor")
        {
//            var rootVC : UIViewController?
//            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorNavigationController") as! UINavigationController
//
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                   appDelegate.window?.rootViewController = rootVC
            
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            sceneDelegate.window!.rootViewController = UIStoryboard(name: "Doctor", bundle: nil).instantiateViewController(withIdentifier: "DoctorNavigationController") as! UINavigationController
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            
            //perform api call if any
        self.viewDidLoad()
            
        }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        // Your action
        // For Dismissing the Popup
                self.dismiss(animated: true, completion: nil)

                // Dismiss current Viewcontroller and back to ViewController B
                self.navigationController?.popViewController(animated: true)

        
    }
    
  
    
    func jsonParsing(){
        print("salt method \(ServiceUrl.doctorLoginSalt)")
        DispatchQueue.main.async {
            self.view.activityStartAnimating(activityColor: UIColor.white, backgroundColor: UIColor.black.withAlphaComponent(0.5))
        }
        
        
      
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        //testing url
        let url = URL(string: ServiceUrl.doctorLoginSalt)
        
        let task=URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                print("salt response")
                let returnData = String(data: data, encoding: .utf8)
                
                print(returnData!) //Response result
                print("\(data)")
                DispatchQueue.main.async {
                    let a=self.edtPassword.text!+self.edtUsername.text!
                    let sha=a.SHA1()
                    print("a"+sha)
                    let sha22=sha+returnData!
                    let pass=sha22.SHA1()
                    //                    print("b"+)
                    let escapedurl = returnData!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    self.loginCheck(pass: pass, salt: escapedurl!)
                }
                
        
            }
            
        }
        task.resume()
    }
    
    
    
    
    func loginCheck(pass:String,salt:String){
    print("logincheck ")
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        
        //testing url
        let url = URL(string: "\(ServiceUrl.doctorLoginUrl)\(edtUsername.text ?? "")&pass=\(pass)&salt=\(salt)&hcode=\(ServiceUrl.hospId)&role=1")
        print(url!)
        

        let task=URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
                let json = try JSON(data:data)
            print("response")
                if  json["valid"].stringValue == "1"
                {
                    let seatId=json["userseatid"].stringValue
                    let userId=json["userId"].stringValue
                    let userdisplayname=json["userdisplayname"].stringValue
                    let empCode=json["empcode"].stringValue
                    let hospCode=json["hospCode"].stringValue
                     let mobileNo=json["mobileNo"].stringValue
                     let employeeCode=json["employeeCode"].stringValue
        
                    UserDefaults.standard.set(seatId, forKey: "udSeatId")
                    UserDefaults.standard.set(userId, forKey: "udUserId")
                    UserDefaults.standard.set(userdisplayname, forKey: "udUserdisplayname")
                    UserDefaults.standard.set(empCode, forKey: "udEmpcode")
                    UserDefaults.standard.set(hospCode, forKey: "udHospCode")
                    UserDefaults.standard.set("doctor", forKey: "udWhichModuleToLogin")
                    UserDefaults.standard.set(mobileNo, forKey: "udMobileNo")
                    UserDefaults.standard.set(employeeCode, forKey: "udEmployeeCode")

                    print(seatId)
                    DispatchQueue.main.async {

//                        var rootVC : UIViewController?
//                        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorNavigationController") as! UINavigationController
//
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        appDelegate.window?.rootViewController = rootVC
                        
                      
                        let sceneDelegate = UIApplication.shared.connectedScenes
                            .first!.delegate as! SceneDelegate
                        sceneDelegate.window!.rootViewController = UIStoryboard(name: "Doctor", bundle: nil).instantiateViewController(withIdentifier: "DoctorNavigationController") as! UINavigationController
                    }
                }
                else{
                   
                    DispatchQueue.main.async {
 self.showAlert();
                    }
                }
                let returnData = String(data: data, encoding: .utf8)
                
                print("result"+returnData!) //Response result
                
                
            }catch{
                print("error")
//                self.hideProgress();
                DispatchQueue.main.async {
                    self.view.activityStopAnimating()
                }
                print("sudeep"+error.localizedDescription)
            }
        }
        task.resume()
        
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
    
    func showAlert()  {
        let alertController = UIAlertController(title: "Login failed!", message:
            "Invalid username or password.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    

}








extension Data {
    
    
    func hexString() -> String {
        let string = self.map{String(format:"%02hhx", Int($0))}.joined()
//         let string = self.map{String(format:"%02x", Int($0))}.joined()
        return string
    }
    
    
    func SHA1() -> Data {
        var result = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes {resultPtr in
            self.withUnsafeBytes {(bytes: UnsafePointer<UInt16>) in
                CC_SHA512(bytes, CC_LONG(count), resultPtr)
            }
            
        }
        return result
    }
    
}


    


