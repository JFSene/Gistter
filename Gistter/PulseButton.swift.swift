/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class PulseButton {
	public var filename : String?
	public var type : String?
	public var language : String?
	public var raw_url : String?
	public var size : Int?
	public var truncated : Bool?
	public var content : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let pulseButton.swift_list = PulseButton.swift.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of PulseButton.swift Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [PulseButton]
    {
        var models:[PulseButton] = []
        for item in array
        {
            models.append(PulseButton(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let pulseButton.swift = PulseButton.swift(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: PulseButton.swift Instance.
*/
	required public init?(dictionary: NSDictionary) {

		filename = dictionary["filename"] as? String
		type = dictionary["type"] as? String
		language = dictionary["language"] as? String
		raw_url = dictionary["raw_url"] as? String
		size = dictionary["size"] as? Int
		truncated = dictionary["truncated"] as? Bool
		content = dictionary["content"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.filename, forKey: "filename")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.language, forKey: "language")
		dictionary.setValue(self.raw_url, forKey: "raw_url")
		dictionary.setValue(self.size, forKey: "size")
		dictionary.setValue(self.truncated, forKey: "truncated")
		dictionary.setValue(self.content, forKey: "content")

		return dictionary
	}

}
