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
    
    /// A web socket transport to use for subscriptions
    private lazy var webSocketTransport: WebSocketTransport = {
        let url = URL(string: wsEndpoint)!
        let webSocketClient = WebSocket(url: url, protocol: .graphql_transport_ws)
        return WebSocketTransport(websocket: webSocketClient)
    }()
    
    /// An HTTP transport to use for queries and mutations
    
    private lazy var normalTransport: RequestChainNetworkTransport = {
        let url = URL(string: httpsEndpoint)!
        return RequestChainNetworkTransport(interceptorProvider: DefaultInterceptorProvider(store: self.store), endpointURL: url)
    }()
    
    
    /// A split network transport to allow the use of both of the above
    /// transports through a single `NetworkTransport` instance.
    private lazy var splitNetworkTransport = SplitNetworkTransport(
        uploadingNetworkTransport: self.normalTransport,
        webSocketNetworkTransport: self.webSocketTransport
    )
    
    /// Create a client using the `SplitNetworkTransport`.
    private(set) lazy var client = ApolloClient(networkTransport: self.splitNetworkTransport, store: self.store)
    
    /// A common store to use for `normalTransport` and `client`.
    private lazy var store = ApolloStore()
}
