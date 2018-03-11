//
//  Networking.swift
//  Genio
//
//  Created by Luigi Pepe on 3/11/18.
//  Copyright © 2018 Luigi Pepe. All rights reserved.
//

import Foundation
import UIKit






/******************************** VALIDATION EMAIL/PASSWORD ***************************************/
func isValidUserName(userName: String) -> Bool {
    if userName != ""  { return true }
    else { return false }
}

func isValidEmail(testStr:String) -> Bool {
    print("validate emilId: \(testStr)")
    let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
    return result
}

func isPswLenth(password: String) -> Bool {
    if password.count > 7 {
        return true
    }
    else{
        return false
    }
}

func isPswSame(password: String , confirmPassword : String) -> Bool {
    if password == confirmPassword{
        return true
    }
    else{
        return false
    }
}
/******************************************************************************************/


/******************************************************************************************/
func logInRequest(insertedEmail: String, insertedPassword: String) -> NSMutableURLRequest {
    
    let loginString = NSString(format: "%@:%@", insertedEmail, insertedPassword)
    let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
    let base64LoginString = loginData.base64EncodedString(options: [])
    let baseURL = UserDefaults.standard.string(forKey: "myURL")! + "token"
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = ["all"]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch { }
    request.httpMethod = "POST"
    return request
}
/******************************************************************************************/


/******************************************************************************************/
func signUpRequest(instertedUserName: String, insertedEmail: String, insertedPassword: String, insertedFullName: String,  profileImage: UIImage?, facebookID: String?, iOSDeviceToken: String?) -> NSMutableURLRequest? {
    
    let baseURL = UserDefaults.standard.string(forKey: "myURL")! + "register"
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    request.httpMethod = "POST"
    
    
    let boundary = generateBoundaryString()
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.addValue("multipart/form-data", forHTTPHeaderField: "Accept")
    
    if (profileImage == nil)
    {
        return nil
    }
    
    let image_data = UIImagePNGRepresentation(profileImage!)
    
    
    if(image_data == nil)
    {
        return nil
    }
    
    let body = NSMutableData();
    
    let parameters = [ "username": instertedUserName,
                       "fullname": insertedFullName,
                       "email": insertedEmail,
                       "password": insertedPassword,
                       "avatar": image_data  ?? 0,
                       "facebook_id": facebookID  ?? "",
                       "ios_device_token": iOSDeviceToken  ?? ""] as [String : Any]
    
    let imageType = "image/jpg"
    let filename = "th_immagine.jpg"
    
    for (key, value) in parameters {
        
        if key == "avatar" {
            
            var string = "--\(boundary)\r\n"
            var data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            body.append(data!)
            
            string = "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n"
            data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            body.append(data!)
            
            string = "Content-Type: \(imageType)\r\n\r\n"
            data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            body.append(data!)
            
            body.append(image_data!)
            string = "\r\n"
            data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            body.append(data!)
        }
            
        else {
            var string = "--\(boundary)\r\n"
            var data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            body.append(data!)
            
            string = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            body.append(data!)
            
            string = "\(value)\r\n"
            data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            body.append(data!)
        }
    }
    
    let string = "--\(boundary)\r\n"
    let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    request.httpBody = body as Data
    
    return request
}
/******************************************************************************************/




/***************************************************************************************/
func pswPutRequest(baseURL: String, oldPsw: String, newPsw: String, confirmPsw: String) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PUT"
    
    let body = [ "old_password": oldPsw,
                 "password": newPsw,
                 "confirm_password": confirmPsw ] as [String : String]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("JSON serialization failed")
        return nil
    }
    
    return request
}
/***************************************************************************************/




/***************************************************************************************/
func profilePutRequest(baseURL: String, privateSwitch: Bool, instertedUserName: String, insertedEmail: String, insertedFullName: String) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PUT"
    
    var privateStatus: Int = 0
    
    if privateSwitch == true {
        privateStatus = 1
    }
    
    let userName = instertedUserName
    let email = insertedEmail
    let fullName = insertedFullName
    
    let body = [ "username": userName,
                 "fullname": fullName,
                 "email": email,
                 "private": privateStatus] as [String : Any]
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("JSON serialization failed")
        return nil
    }
    
    return request
}
/***************************************************************************************/

/***************************************************************************************/
func iOSTokenDevicePutRequest(baseURL: String, tokenDevice: String) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "PUT"
    
    let body = [ "ios_device_token": tokenDevice]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("JSON serialization failed")
        return nil
    }
    
    return request
}
/***************************************************************************************/







/***************************************************************************************/
func wishPicPutRequest(baseURL: String, wishImage: UIImage?) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    request.httpMethod = "POST"
    
    let boundary = "Boundary-\(NSUUID().uuidString)"
    
    let imageData = UIImageJPEGRepresentation(wishImage!, 1)
    let body = NSMutableData()
    
    let filename = "th_immagine.jpg"
    let mimetype = "image/jpg"
    let key = "filename"
    
    var string = "--\(boundary)\r\n"
    var data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    string = "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    string = "Content-Type: \(mimetype)\r\n\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    body.append(imageData!)
    string = "\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    string = "--\(boundary)\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.addValue("multipart/form-data", forHTTPHeaderField: "Accept")
    request.httpBody = body as Data
    
    return request
}
/***************************************************************************************/

/***************************************************************************************/
func genericPutRequest(baseURL: String) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")
    
    if token != nil {
        request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
    }
    
    return request
}
/***************************************************************************************/

/***************************************************************************************/
func genericDeleteRequest(baseURL: String) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")
    
    if token != nil {
        request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
    }
    
    return request
}
/***************************************************************************************/

/******************************************************************************************/
func genericGetRequest(baseURL: String) -> NSMutableURLRequest? {
    
    if let url = NSURL(string: baseURL) {
        
        let request = NSMutableURLRequest(url: url as URL)
        let token  =  UserDefaults.standard.string(forKey: "token")
        
        if token != nil {
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
        }
        return request
    }
    
    return nil
}
/***************************************************************************************/

/***************************************************************************************/
func genericPostRequest(baseURL: String) -> NSMutableURLRequest?  {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    return request
}
/***************************************************************************************/



/***************************************************************************************/
func followUserRequest(baseURL: String) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    
    return request
}
/***************************************************************************************/

/***************************************************************************************/
func unfollowUserRequest(baseURL: String) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "DELETE"
    
    return request
}
/***************************************************************************************/


/***************************************************************************************/
func picturePutRequest(baseURL: String, profileImage: UIImage?) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token  =  UserDefaults.standard.string(forKey: "token")!
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    request.httpMethod = "POST"
    
    let boundary = "Boundary-\(NSUUID().uuidString)"
    
    
    let imageData = UIImageJPEGRepresentation(profileImage!, 1)
    let body = NSMutableData()
    
    
    let filename = "th_immagine.jpg"
    let mimetype = "image/jpg"
    let key = "avatar"
    
    var string = "--\(boundary)\r\n"
    var data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    string = "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    string = "Content-Type: \(mimetype)\r\n\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    body.append(imageData!)
    string = "\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    string = "--\(boundary)\r\n"
    data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
    body.append(data!)
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.addValue("multipart/form-data", forHTTPHeaderField: "Accept")
    request.httpBody = body as Data
    
    return request
}
/***************************************************************************************/










/******************************************************************************************/
func httpRequest(request: NSMutableURLRequest!, handler: @escaping (Data?, Error?, URLResponse?) -> Void) {
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest){
        (data, response, error) -> Void in
        if error != nil { handler(nil,  error!, response) }
        else  { handler(data!,  nil, response) }
    }
    task.resume()
}
/******************************************************************************************/




/**********************************************************************************/
func askToken(handler: @escaping (String?) -> Void) {

    var email_user: String?
    if let email = UserDefaults.standard.string(forKey: "email") {
        email_user = email
    } else if let user = UserDefaults.standard.string(forKey: "userName") {
        email_user = user
    } else {
        email_user = nil
    }
    
    if email_user != nil {
        if let psw = UserDefaults.standard.string(forKey: "psw") {
        
            let request = logInRequest(insertedEmail: email_user!, insertedPassword: psw)
            httpRequest(request: request) { (data, error, response) -> Void in
                
                let httpResponse = response as? HTTPURLResponse
                if error != nil  || data == nil ||
                    (httpResponse?.statusCode)! >= 400 ||
                    (httpResponse?.statusCode)! < 200  {
                    
                    handler("error")
                } else {
                    
                    if let myJSON = readData(data: data) {
                        
                        let status = myJSON["status"] as! String
                        let token  = myJSON["token"] as! String
                        if status == "ok" {
                            print("status = ok, token ", token)
                            UserDefaults.standard.set(token, forKey: "token")
                            handler("ok")
                        } else { handler("error") }
                    }
                }
            }
        }
    } else { handler("error") }
}
/**********************************************************************************/





















/******************************************************************************************/
func generateBoundaryString() -> String
{
    return "Boundary-\(NSUUID().uuidString)"
}
/******************************************************************************************/

/******************************************************************************************/
func createAlert(title: String, message: String) -> UIAlertController {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
    alert.addAction(cancelAction)
    
    return alert
}
/******************************************************************************************/






/******************************************************************************************/
func readData(data: Data?) -> Dictionary<String, AnyObject>? {
    
    var jsonObject: Dictionary<String, AnyObject>?
    
    do {
        jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String,AnyObject>
    } catch {
        print("errore Error with JSON serialization")
        return nil
    }
    
    return jsonObject
}
/******************************************************************************************/






/********************************************************************************/
func logOut(handler: @escaping (String?) -> Void) {
    
    
    var baseURL = UserDefaults.standard.string(forKey: "myURL")!
    baseURL = baseURL + "users/logout"
    
    let request = genericGetRequest(baseURL: baseURL)
    
    httpRequest(request: request) {
        
        (data, error, response) -> Void in
        
        let httpResponse = response as? HTTPURLResponse
        
        if error != nil  || data == nil || (httpResponse?.statusCode)! >= 400 || (httpResponse?.statusCode)! < 200  {
            
            print(httpResponse?.statusCode ?? 0)
            
            handler("error")
        }
            
        else {
            
            handler("ok")
        }
    }
    
}
/********************************************************************************/



/********************************************************************************/
func addNewWishRequest(baseURL: String, myTitle: String, myDescription: String, myLink: String, myNotify: Int) -> NSMutableURLRequest? {
    
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    let token = UserDefaults.standard.string(forKey: "token")!
    
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = ["title":"\(myTitle)",
        "state_type_id": 1,
        "description":"\(myDescription)",
        "notify": myNotify,
        "link": "\(myLink)"] as [String : Any]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        
        print("errore")
        
    }
    
    request.httpMethod = "POST"
    
    return request
}
/********************************************************************************/

/********************************************************************************/
func editNewWishRequest(baseURL: String, myTitle: String, myDescription: String, myLink: String, myStatus: Int = 1, notify: Bool) -> NSMutableURLRequest? {
    
    let token = UserDefaults.standard.string(forKey: "token")!
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ["title":"\(myTitle)",
        "description":"\(myDescription)",
        "link":"\(myLink)",
        "state_type_id":myStatus,
        "notify":notify] as [String : Any]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("errore")
    }
    
    request.httpMethod = "PUT"
    
    return request
}
/********************************************************************************/







/**********************************************************************************/
func editWishStateRequest(baseURL: String, myStatus: Int = 1) -> NSMutableURLRequest? {
    
    let token = UserDefaults.standard.string(forKey: "token")!
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = ["state_type_id":myStatus] as [String : Any]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("errore")
    }
    
    request.httpMethod = "PUT"
    
    return request
}
/**********************************************************************************/

/**********************************************************************************/
func editWishNotifyRequest(baseURL: String, notify: Bool) -> NSMutableURLRequest? {
    
    let token = UserDefaults.standard.string(forKey: "token")!
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    var not: Int
    if notify == true {
        not = 1
    }
    else {
        not = 0
    }
    let body = ["notify":not] as [String : Any]
    print(body)
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("errore")
    }
    
    request.httpMethod = "PUT"
    
    return request
}
/**********************************************************************************/

/**********************************************************************************/
func editWishTitleRequest(baseURL: String, myTitle: String) -> NSMutableURLRequest? {
    
    let token = UserDefaults.standard.string(forKey: "token")!
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body = ["title":"\(myTitle)"] as [String : Any]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("errore")
    }
    
    request.httpMethod = "PUT"
    
    return request
}
/**********************************************************************************/

/**********************************************************************************/
func editWishLink_DescrRequest(baseURL: String, myDescription: String, myLink: String) -> NSMutableURLRequest? {
    
    let token = UserDefaults.standard.string(forKey: "token")!
    let request = NSMutableURLRequest(url: NSURL(string: baseURL)! as URL)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ["description":"\(myDescription)",
        "link":"\(myLink)"] as [String : Any]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
    } catch {
        print("errore")
    }
    
    request.httpMethod = "PUT"
    
    return request
}
/**********************************************************************************/


/**********************************************************************************/
func errorHandling(response: URLResponse?, message: String? = nil) -> UIAlertController {
    
    let httpResponse = response as? HTTPURLResponse
    var myMessage: String?
    var alert = UIAlertController()
    
    if httpResponse == nil {
        if message == nil {
            myMessage = "You are not connected to the internet"
        }
        else {
            myMessage = message
        }
        alert = UIAlertController(title: "Error", message: myMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        alert.addAction(cancelAction)
    }
        
    else if httpResponse!.statusCode >= 400 && httpResponse!.statusCode < 500 {
        
        if message == nil {
            myMessage = "Invalid request"
        }
        else {
            myMessage = message
        }
        
        alert = UIAlertController(title: "Error", message: myMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        alert.addAction(cancelAction)
    }
        
    else if httpResponse!.statusCode >= 500 {
        
        if message == nil {
            myMessage = "Internal server error"
        }
        else {
            myMessage = message
        }
        
        alert = UIAlertController(title: "Error", message: myMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        alert.addAction(cancelAction)
    }
        
    else {
        
        if message == nil {
            myMessage = "An error occurred"
        }
        else {
            myMessage = message
        }
        
        alert = UIAlertController(title: "Error", message: myMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        alert.addAction(cancelAction)
    }
    
    
    return alert
}
/**********************************************************************************/




