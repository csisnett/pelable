let Chat = {
    init(socket) {
        let path = window.location.pathname.split('/')
        let uuid = path[path.length - 1]
        let channel = socket.channel('chat:' + uuid, {})
        channel.join()
        .receive("ok", resp => {console.log("Joined successfully")})
        .receive("error", resp => {console.log("An error connecting to the chat")})
        this.listenForChats(channel)
    },

    listenForChats(channel) {
        function submitForm(){
        let userName = document.getElementById('user-name').value
        let userMsg = document.getElementById('user-msg').value
    
        channel.push('shout', {username: userName, body: userMsg})
          document.getElementById('user-name').value = userName
          document.getElementById('user-msg').value = ''
        }
    
        document.getElementById('chat-form').addEventListener('submit', function(e){
          e.preventDefault()
          submitForm();
        })
    
        channel.on('shout', payload => {
          let chatBox = document.querySelector('#chat-box')
          let msgBlock = document.createElement('p')
    
          msgBlock.insertAdjacentHTML('beforeend', `${payload.username}: ${payload.body}`)
          chatBox.appendChild(msgBlock)
        })
      }
}
export default Chat