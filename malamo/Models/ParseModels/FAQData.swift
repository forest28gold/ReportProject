//
//  FAQData.swift
//  malamo
//
//  Created by AppsCreationTech on 12/24/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import Foundation

struct FAQData {
    
    var question: String
    var answer: String
    var question_fr: String
    var answer_fr: String
    
    init(question: String, answer: String, question_fr: String, answer_fr: String) {
        self.question = question
        self.answer = answer
        self.question_fr = question_fr
        self.answer_fr = answer_fr
    }
}
