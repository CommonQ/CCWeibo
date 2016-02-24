//
//  String+Emoticons.swift
//  CCWeibo
//
//  Created by 徐才超 on 16/2/23.
//  Copyright © 2016年 徐才超. All rights reserved.
//

import UIKit
extension String {
    // 表情包bundle路径
    private var emoticonsBundlePath: NSString {
        return NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")! as NSString
    }
    // 表情包内配置文件所在路径
    private var emoticonsGroupListFilePath: String  {
        return emoticonsBundlePath.stringByAppendingPathComponent(self)
    }
    // 通过表情包配置文件获取表情组的id
    private func emoticonsGroupIdList() -> [String] {
        let dict = NSDictionary(contentsOfFile: emoticonsGroupListFilePath) as! [String: AnyObject]
        var groupsIdArr = [String]()
        for group in dict["packages"] as! [[String: AnyObject]] {
            groupsIdArr.append(group["id"] as! String)
        }
        return groupsIdArr
    }
    // 获取表情组对象的数组
    func emoticonGroups() -> [EmoticonGroupInfo] {
        let groupIdArr = self.emoticonsGroupIdList()
        var groups = [EmoticonGroupInfo]()
        for id in groupIdArr {
            let emoticonInfoPath = (emoticonsBundlePath.stringByAppendingPathComponent(id) as NSString).stringByAppendingPathComponent("info.plist")
            let dict = NSDictionary(contentsOfFile: emoticonInfoPath) as! [String: AnyObject]
            let groupInfo = EmoticonGroupInfo(dict: dict)
            groups.append(groupInfo)
        }
        return groups
    }
    
    // 通过code字符串获取相应的emoji表情
    func emojiText() -> String {
        let scanner = NSScanner(string: self)
        var result: UInt32 = 0
        scanner.scanHexInt(&result)
        return "\(Character(UnicodeScalar(result)))"
    }
    
    // 通过表情图片路径获取图片
    func sinaEmoticon() -> UIImage {
        let imagePath = emoticonsBundlePath.stringByAppendingPathComponent(self)
        return UIImage(contentsOfFile: imagePath)!
    }
}