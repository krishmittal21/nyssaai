//
//  NSUser.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import Foundation

struct NSUser: Codable {
  var addressLine1: String?
  var addressLine2: String?
  var age: Int?
  var avatar: String?
  var bio: String?
  var category: [String]?
  var city: String?
  var country: String?
  var createdBy: String?
  var dateCreated: String?
  var dateEdited: String?
  var deviceType: String?
  var dob: String?
  var editedBy: String?
  var email: String?
  var emailVerificationDate: String?
  var emailVerified: Bool?
  var emailVerifiedDate: String?
  var firstName: String?
  var gender: String?
  var ipAddress: String?
  var isValidatedEmail: Bool?
  var isValidatedPhone: Bool?
  var keywords: [String]?
  var lastLogin: String?
  var lastName: String?
  var phoneNumber: String?
  var phoneVerificationDate: String?
  var phoneVerified: Bool?
  var phoneVerifiedDate: String?
  var role: String?
  var state: String?
  var type: String?
  var userId: String?
  var zipcode: String?
  
  func asDictionary() -> [String: Any] {
    return [
      UserModelName.addressLine1: addressLine1 ?? "",
      UserModelName.addressLine2: addressLine2 ?? "",
      UserModelName.age: age ?? 0,
      UserModelName.avatar: avatar ?? "",
      UserModelName.bio: bio ?? "",
      UserModelName.category: category ?? [],
      UserModelName.city: city ?? "",
      UserModelName.country: country ?? "",
      UserModelName.createdBy: createdBy ?? "",
      UserModelName.dateCreated: dateCreated ?? ISO8601DateFormatter().string(from: Date()),
      UserModelName.dateEdited: dateEdited ?? ISO8601DateFormatter().string(from: Date()),
      UserModelName.deviceType: deviceType ?? "",
      UserModelName.dob: dob ?? "",
      UserModelName.editedBy: editedBy ?? "",
      UserModelName.email: email ?? "",
      UserModelName.emailVerificationDate: emailVerificationDate ?? ISO8601DateFormatter().string(from: Date()),
      UserModelName.emailVerified: emailVerified ?? false,
      UserModelName.emailVerifiedDate: emailVerifiedDate ?? ISO8601DateFormatter().string(from: Date()),
      UserModelName.firstName: firstName ?? "",
      UserModelName.gender: gender ?? "",
      UserModelName.ipAddress: ipAddress ?? "",
      UserModelName.isValidatedEmail: isValidatedEmail ?? false,
      UserModelName.isValidatedPhone: isValidatedPhone ?? false,
      UserModelName.keywords: keywords ?? [],
      UserModelName.lastLogin: lastLogin ?? ISO8601DateFormatter().string(from: Date()),
      UserModelName.lastName: lastName ?? "",
      UserModelName.phoneNumber: phoneNumber ?? "",
      UserModelName.phoneVerificationDate: phoneVerificationDate ?? ISO8601DateFormatter().string(from: Date()),
      UserModelName.phoneVerified: phoneVerified ?? false,
      UserModelName.phoneVerifiedDate: phoneVerifiedDate ?? ISO8601DateFormatter().string(from: Date()),
      UserModelName.role: role ?? "",
      UserModelName.state: state ?? "",
      UserModelName.type: type ?? "",
      UserModelName.userId: userId ?? "",
      UserModelName.zipcode: zipcode ?? ""
    ]
  }
  
  static func asObject(dict: [String: Any]) -> NSUser {
    
    return NSUser(
      addressLine1: dict[UserModelName.addressLine1] as? String,
      addressLine2: dict[UserModelName.addressLine2] as? String,
      age: dict[UserModelName.age] as? Int,
      avatar: dict[UserModelName.avatar] as? String,
      bio: dict[UserModelName.bio] as? String,
      category: dict[UserModelName.category] as? [String],
      city: dict[UserModelName.city] as? String,
      country: dict[UserModelName.country] as? String,
      createdBy: dict[UserModelName.createdBy] as? String,
      dateCreated: dict[UserModelName.dateCreated] as? String,
      dateEdited:  dict[UserModelName.dateEdited] as? String,
      deviceType: dict[UserModelName.deviceType] as? String,
      dob: dict[UserModelName.dob] as? String,
      editedBy: dict[UserModelName.editedBy] as? String,
      email: dict[UserModelName.email] as? String,
      emailVerificationDate: dict[UserModelName.emailVerificationDate] as? String,
      emailVerified: dict[UserModelName.emailVerified] as? Bool,
      emailVerifiedDate: dict[UserModelName.emailVerifiedDate] as? String,
      firstName: dict[UserModelName.firstName] as? String,
      gender: dict[UserModelName.gender] as? String,
      ipAddress: dict[UserModelName.ipAddress] as? String,
      isValidatedEmail: dict[UserModelName.isValidatedEmail] as? Bool,
      isValidatedPhone: dict[UserModelName.isValidatedPhone] as? Bool,
      keywords: dict[UserModelName.keywords] as? [String],
      lastLogin: dict[UserModelName.lastLogin] as? String,
      lastName: dict[UserModelName.lastName] as? String,
      phoneNumber: dict[UserModelName.phoneNumber] as? String,
      phoneVerificationDate: dict[UserModelName.phoneVerificationDate] as? String,
      phoneVerified: dict[UserModelName.phoneVerified] as? Bool,
      phoneVerifiedDate: dict[UserModelName.phoneVerifiedDate] as? String,
      role: dict[UserModelName.role] as? String,
      state: dict[UserModelName.state] as? String,
      type: dict[UserModelName.type] as? String,
      userId: dict[UserModelName.userId] as? String,
      zipcode: dict[UserModelName.zipcode] as? String
    )
  }
  
  static func asObject(id: String,dict: [String: Any]) -> NSUser {
    
    return NSUser(
      addressLine1: dict[UserModelName.addressLine1] as? String,
      addressLine2: dict[UserModelName.addressLine2] as? String,
      age: dict[UserModelName.age] as? Int,
      avatar: dict[UserModelName.avatar] as? String,
      bio: dict[UserModelName.bio] as? String,
      category: dict[UserModelName.category] as? [String],
      city: dict[UserModelName.city] as? String,
      country: dict[UserModelName.country] as? String,
      createdBy: dict[UserModelName.createdBy] as? String,
      dateCreated: dict[UserModelName.dateCreated] as? String,
      dateEdited:  dict[UserModelName.dateEdited] as? String,
      deviceType: dict[UserModelName.deviceType] as? String,
      dob: dict[UserModelName.dob] as? String,
      editedBy: dict[UserModelName.editedBy] as? String,
      email: dict[UserModelName.email] as? String,
      emailVerificationDate: dict[UserModelName.emailVerificationDate] as? String,
      emailVerified: dict[UserModelName.emailVerified] as? Bool,
      emailVerifiedDate: dict[UserModelName.emailVerifiedDate] as? String,
      firstName: dict[UserModelName.firstName] as? String,
      gender: dict[UserModelName.gender] as? String,
      ipAddress: dict[UserModelName.ipAddress] as? String,
      isValidatedEmail: dict[UserModelName.isValidatedEmail] as? Bool,
      isValidatedPhone: dict[UserModelName.isValidatedPhone] as? Bool,
      keywords: dict[UserModelName.keywords] as? [String],
      lastLogin: dict[UserModelName.lastLogin] as? String,
      lastName: dict[UserModelName.lastName] as? String,
      phoneNumber: dict[UserModelName.phoneNumber] as? String,
      phoneVerificationDate: dict[UserModelName.phoneVerificationDate] as? String,
      phoneVerified: dict[UserModelName.phoneVerified] as? Bool,
      phoneVerifiedDate: dict[UserModelName.phoneVerifiedDate] as? String,
      role: dict[UserModelName.role] as? String,
      state: dict[UserModelName.state] as? String,
      type: dict[UserModelName.type] as? String,
      userId: dict[UserModelName.userId] as? String ?? id,
      zipcode: dict[UserModelName.zipcode] as? String
    )
  }
}
