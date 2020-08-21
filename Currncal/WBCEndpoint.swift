//
//  WBCEndpoint.swift
//  Currncal
//
//  Created by Tantia, Himanshu on 20/8/20.
//  Copyright © 2020 Himanshu Tantia. All rights reserved.
//

import Foundation

//This is a clean way to both manage multiple sources and multiple APIs from the same source and can be extended for multiple sources.

//https://www.westpac.com.au/bin/getJsonRates.wbc.fx.json
//usually there are 2 componenets of the url that are variable depending on the api
struct WBCEndpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension WBCEndpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.westpac.com.au"
        components.path = path
        components.queryItems = queryItems

        return components.url
    }
}

extension WBCEndpoint {
    static func rates() -> WBCEndpoint {
        return WBCEndpoint(path: "/bin/getJsonRates.wbc.fx.json", queryItems: [])
    }
}
