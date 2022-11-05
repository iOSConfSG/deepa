//
//  NewsView.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"

    private let webContent = """
    <a class="twitter-timeline" href="https://twitter.com/iosconfsg?ref_src=twsrc%5Etfw">Tweets by iosconfsg</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
    """
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(headerString + webContent, baseURL: nil)
    }
}

struct NewsView: View {
    var body: some View {
        NavigationView {
            WebView()
                .navigationTitle("News")
        }
    }
}
