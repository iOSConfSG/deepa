//
//  ScheduleView.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import SwiftUI

struct ScheduleView: View {
    
    @StateObject var viewModel: ScheduleViewModel
    
    init() {
        let viewModel = ScheduleViewModel {
            print("fail init")
        }
        _viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Schedule!")
        }
        .padding()
        .onAppear {
            viewModel.fetchSchedule()
        }
    }
    
    func handleGraphqlError() {
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
