//
//  ApolloManager.swift
//  deepa
//
//  Created by Vina Melody on 17/9/22.
//

import Foundation
import Apollo
import ApolloWebSocket

class NetworkManager {
    static let shared = NetworkManager()
    let httpsEndpoint = "https://iosconfsg.herokuapp.com/v1/graphql"
    let wsEndpoint = "ws://iosconfsg.herokuapp.com/v1/graphql"
    var apolloClient: ApolloClient?
    
    private init() {
        createApolloClient()
    }
    
    func createApolloClient() {
        self.apolloClient = {            
            guard let wsEndpointUrl = URL(string: wsEndpoint) else { return nil }
            guard let httpsEndpointUrl = URL(string: httpsEndpoint) else { return nil}
            
            let request = URLRequest(url: wsEndpointUrl)
            let websocket = WebSocket(request: request, protocol: .graphql_transport_ws)
            let websocketTransport = WebSocketTransport(websocket: websocket)
            
            let store = ApolloStore(cache: InMemoryNormalizedCache())
            
            let provider = DefaultInterceptorProvider(store: store)
            let httpNetworkTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: httpsEndpointUrl)
            let splitNetworkTransport = SplitNetworkTransport(uploadingNetworkTransport: httpNetworkTransport, webSocketNetworkTransport: websocketTransport)
            
            return ApolloClient(networkTransport: splitNetworkTransport, store: store)
            
        }()
    }
}
