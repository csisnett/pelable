import {Presence} from "./phoenix.js"
let ChatPresence = {
    init(socket) {
        let channel = socket.channel('chat_presence', {})
        channel.join().receive("ok", resp => {console.log("Joined presence channel!")})
        this.handle_presence(channel)
    },


    handle_presence(channel) {
       
        let presence = new Presence(channel)
    
        presence.onSync( () => {
          render_online_users(presence.list())
          
        })

      }
}
export default ChatPresence