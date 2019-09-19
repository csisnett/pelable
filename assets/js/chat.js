let Chat = {
    init(socket) {
        let path = window.location.pathname.split('/')
        let uuid = path[path.length - 1]
        let channel = socket.channel('chat:' + uuid, {})
        channel.join()
        .receive("ok", resp => {console.log("Joined successfully")})
        this.listenForChats(channel)
    },

    listenForChats(channel) {
        function submitForm(){
        let userMsg = document.getElementById('body').value

        userMsg = userMsg.trim();
        if (userMsg === "") {
        //console.log("empty");
      }
      else {
        //console.log(userMsg);
    
        channel.push('shout', {body: userMsg})
          setTimeout(function() {document.getElementById('body').value = ""}, 50);
      }
        }
    
        document.getElementById('chat-form').addEventListener('submit', function(e){
          e.preventDefault()
          submitForm();
        })

        document.getElementById("body").addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    submitForm();
  }

})
    
        channel.on('shout', payload => {
          let chatBox = document.querySelector('#chat-box')
          let msgBlock = document.createElement('p')
          var datetime_string = convert_to_local_datetime(payload.inserted_at);
          msgBlock.insertAdjacentHTML('beforeend', `${datetime_string} <b>${payload.username}:</b> ${payload.body}`)
          chatBox.appendChild(msgBlock)
          /*Moves the chatbox down for any new message */
          var top_position = msgBlock.offsetTop
          window.last_message_position = top_position
          if(top_position - chatBox.scrollTop <= 560){
            chatBox.scrollTop = top_position
          
          }
        })
      }
}
export default Chat