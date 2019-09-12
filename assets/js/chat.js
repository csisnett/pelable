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
        let userName = document.getElementById('user-name').value
        let userMsg = document.getElementById('body').value
    
        channel.push('shout', {username: userName, body: userMsg})
          document.getElementById('user-name').value = userName
          setTimeout(function() {document.getElementById('body').value = ''}, 1700);
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