//
//  Model.swift
//  copinapp
//
//  Created by Rockteki on 2021/03/08.
//

import Foundation

struct Response: Codable {
    var checkVersionResult: CheckVersion
    var confirmResult: Confirm
    var getMeResult: GetMe
    var retLoginResult: RetLogin
}

struct CheckVersion: Codable {
    var head: HeaderContext?
    var body: BodyCheckVersion?
}

struct HeaderContext: Codable {
    var status: String
    var msg: String
}

struct BodyCheckVersion: Codable {
    var ANDROIDMIN: String
    var ANDROIDWARNING: String
    var IOSMIN: String
    var ANDROIDRECENT: String
    var IOSWEB: String
    var IOSRECENT: String
    var ANDROIDWEB: String
    var IOSWARNING: String
    var APIURL11: String
    var ENTRYURL11: String
    var DEFAULTAPIURL: String
    var DEFAULTENTRYURL: String
}

struct CoinItem: Codable {
    var id: String
    var name: String
    var category: String
    var variant: String
    var brand: String
    var price: Double
}

struct Confirm: Codable {
    var head: HeaderContext
    var body: BodyConfirm
}

struct BodyConfirm: Codable {
    var result: String
}

struct GetMe: Codable {
    var head: HeaderContext
    var body: BodyGetMe
}

struct BodyGetMe: Codable {
    var nick: String
    var isadult: String
    var c: String
    var t: String
    var d: String
    var v: String
    var kind: String
    var type: String
    var profileimg: String
    var email: String
    var coins: String
    var apkey: String
}

struct RetLogin: Codable {
    var head: HeaderContext
    var body: BodyRetLogin
}

struct BodyRetLogin: Codable {
    var t2: String
    var userinfo: UserInfoForm
    var token: String
}

struct UserInfoForm: Codable {
    var nick: String
    var kind: String
    var accesstoken: String
    var deviceid: String
    var newlogintoken: String
    var status: String
    var accountpkey : String
}
