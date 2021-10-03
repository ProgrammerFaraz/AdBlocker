//
//  Note.swift
//  Notes
//
//  Created by John Royal on 7/10/21.
//

import Foundation

struct Note: Hashable, Identifiable, Codable {
  let id: UUID
  var title: String
  var content: String
}
