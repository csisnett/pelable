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
    
        channel.push('shout', {body: userMsg})
          setTimeout(function() {document.getElementById('body').value = ""}, 500);
        }
    
        document.getElementById('chat-form').addEventListener('submit', function(e){
          e.preventDefault()
          submitForm();
        })

        document.getElementById("body").addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    // Cancel the default action, if needed
  
    // Trigger the button element with a click
    let userMsg = document.getElementById('body').value
    userMsg = userMsg.trim();
    if (userMsg === "") {
    //console.log("empty");
  }
  else {
    //console.log(userMsg);
    submitForm();
  }
}
})
    
        channel.on('shout', payload => {
          let chatBox = document.querySelector('#chat-box')
          let msgBlock = document.createElement('p')
          
          msgBlock.insertAdjacentHTML('beforeend', `<b>${payload.username}:</b> ${payload.body}`)
          chatBox.appendChild(msgBlock)
          /*Moves the chatbox down for any new message */
          var top_position = msgBlock.offsetTop
          window.last_message_position = top_position
          console.log(top_position);
          console.log(chatBox.scrollTop);
          if(top_position - chatBox.scrollTop <= 560){
            chatBox.scrollTop = top_position
          
          }
        })
      }
}
export default Chat