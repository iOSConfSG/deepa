//
//  InfoView.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import SwiftUI
import SafariServices

struct AboutMenu: Identifiable {
    var id = UUID()
    var title: String
    var link: String
}

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}

struct InfoView: View {
    @State var menuList: Array<AboutMenu> = [
        AboutMenu(title: "Code of Conduct", link: "https://iosconf.sg/coc"),
        AboutMenu(title: "Sponsors", link: "https://iosconf.sg/#sponsors"),
        AboutMenu(title: "Software", link: "https://iosconf.sg/software"),
        AboutMenu(title: "FAQ", link: "https://iosconf.sg/faq")]
    @State private var showSafari: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(menuList) { menu in
                        Button(action: {
                            showSafari.toggle()
                        }) {
                            Text("\(menu.title)")
                        }.fullScreenCover(isPresented: $showSafari, content: {
                            SFSafariViewWrapper(url: URL(string: "\(menu.link)")!).ignoresSafeArea(.all)
                        })
                    }
                }
                Section {
                    Link("Open iOSConfSG Slack", destination: URL(string: "www.slack.com")!)
                }
            }
            .listStyle(.grouped)
            .navigationTitle("About")
        }
    }
}
