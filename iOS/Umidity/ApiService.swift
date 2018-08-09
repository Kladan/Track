//
//  ApiService.swift
//  Umidity
//
//  Created by Thomas Münzl on 09.08.18.
//  Copyright © 2018 Thomas Münzl. All rights reserved.
//

import Foundation
import Security

class ApiService {
	
	public let isLocal = false;
	public let baseAddress:String?
	
	var jsonDecoder = JSONDecoder()
	var jsonEncoder = JSONEncoder()
	
	init() {
		baseAddress = "http://..." // TODO!
		self.jsonDecoder.dateDecodingStrategy = .iso8601
		self.jsonEncoder.dateEncodingStrategy = .iso8601
	}
	
	
	// HTTP-METHODS
	
	public func get<T:Codable>(path:String, onSuccess:@escaping (T) -> (), onError:((Error) -> Void)?) -> Void {
		
		let p = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
		let urlObj = URL(string:baseAddress!+""+p)!
		var get = URLRequest(url:urlObj)
		get.httpMethod = "GET";
		
		URLSession.shared.dataTask(with: get, completionHandler:{
			(data,response,err) in
			if let error = err {
				if let errorHandler = onError {
					errorHandler(error as! URLError)
				}
				return
			}
				
			else if let content = data {
				do {
					let result = try self.jsonDecoder.decode(T.self, from: content)
					onSuccess(result);
				}
				catch  {
					if let errorHandler = onError {
						errorHandler(error)
					}
					return
				}
			}
			return
		}).resume();
	}
	
	
	
	public func post<T: Codable, E:Encodable>(path:String, body:E, onSuccess:@escaping (T) -> (), onError:((String) -> Void)? = nil) -> Void {
		let data = try! self.jsonEncoder.encode(body)
		var post = URLRequest(url: URL(string:baseAddress!+""+path)!);
		post.httpMethod = "POST";
		post.httpBody = data;
		post.addValue("application/json", forHTTPHeaderField: "Content-Type")
		post.addValue("application/json", forHTTPHeaderField: "Accept")
		
		URLSession.shared.dataTask(with: post, completionHandler:{ (data, response, error) in
			let httpResponse = response as? HTTPURLResponse;
			
			if(error != nil) {
				if(onError != nil) { onError!(error.debugDescription) }
				return
			}
			
			if(data != nil) {
				do {
					let result = try self.jsonDecoder.decode(T.self, from: data!)
					onSuccess(result)
				}
				catch {
					if(onError != nil) { onError!("parsing error") }
					return
				}
			}
			else {
				let errorMsg = String(data: data!, encoding: .utf8)
				if(onError != nil) {onError!(errorMsg!);}
				
			}
		}).resume();
	}
	
	
}

