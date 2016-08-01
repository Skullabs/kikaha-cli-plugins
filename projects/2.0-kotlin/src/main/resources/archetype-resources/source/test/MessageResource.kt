package test

import kikaha.core.modules.websocket.WebSocketSession
import kikaha.urouting.api.OnMessage
import kikaha.urouting.api.WebSocket
import javax.inject.Singleton

/**
 *
 */
@Singleton
@WebSocket("message")
class MessageResource {

    @OnMessage
    fun onMessage( session: WebSocketSession, message:Message ) {
        session.broadcast( message )
    }
}
