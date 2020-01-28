//
//  Observable.swift
//  Contacts
//
//  Created by Nowfal E Salam on 08/07/19.
//  Copyright © 2019 Nowfal E Salam. All rights reserved.
//

import Foundation
class Observable<T>{
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value:T{
        didSet{
            listener?(value)
        }
    }
    init(_value:T){
        self.value = _value
        
    }
    func bind(listener:Listener?){
        self.listener = listener
        listener?(value)
    }
}
