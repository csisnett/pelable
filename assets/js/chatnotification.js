let ChatNotification = {
    init(socket) {
        let chatrooms = this.get_elements_by_attribute('chatroom-uuid')
        let filtered_chatrooms = this.remove_current_chatroom(chatrooms)
        filtered_chatrooms.forEach((chatroom_element) => {
        this.join_channel(chatroom_element, socket)
        })        
        
    },

    remove_current_chatroom(chatrooms){
        let path = window.location.pathname.split('/')
        let current_chatroom_uuid = path[path.length - 1]
        let filtered_chatrooms = chatrooms.filter(chatroom => {
            let chatroom_uuid = chatroom.getAttribute('chatroom-uuid')
            return chatroom_uuid != current_chatroom_uuid
        })

        return filtered_chatrooms
    },

    join_channel(chatroom_element, socket) {
        let chat_uuid = chatroom_element.getAttribute('chatroom-uuid')
        let channel = socket.channel('chat:' + chat_uuid, {})
        channel.join()
        .receive("ok", resp => {console.log("Joined " + chat_uuid)})

        this.listenForChats(channel, chatroom_element)
    },

    get_elements_by_attribute(attribute, context) {
        var nodeList = (context || document).getElementsByTagName('*');
        var nodeArray = [];
        var iterator = 0;
        var node = null;
      
        while (node = nodeList[iterator++]) {
          if (node.hasAttribute(attribute)) nodeArray.push(node);
        }
      
        return nodeArray;
      },

    render_notification(chatroom_element) {
        console.log("inside render_notification")
        var parent_container = chatroom_element.parentElement
        var circle = document.createElement('div')
        parent_container.appendChild(circle)
    },

    listenForChats(channel, chatroom_element) {

        channel.on('shout', payload => {
          this.render_notification(chatroom_element)
          console.log(payload)
        })
      }
}
export default ChatNotification