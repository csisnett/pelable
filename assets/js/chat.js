import {Presence} from "./phoenix.js"
let Chat = {
    init(socket) {
        let path = window.location.pathname.split('/')
        let uuid = path[path.length - 1]
        let channel = socket.channel('chat:' + uuid, {})
        // let channel2 = socket.channel('presence', {typing: false})
        // channel2.join().receive("ok", resp => {console.log("Joined presence channel!")})
        
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

        document.getElementById("body").addEventListener("keydown", function(event) {
          let messagebox = document.getElementById("body")

          if(event.which === 16 && !messagebox.classList.contains("shift")) {
          messagebox.classList.add("shift");
          }
        })

        document.getElementById("body").addEventListener("keyup", function(event) {
          // Number 13 is the "Enter" key on the keyboard

          let messagebox = document.getElementById("body")
          console.log(event.which)

          if (event.which === 16) {
            
            messagebox.classList.remove("shift");
          }

          if (event.keyCode === 13 && !messagebox.classList.contains("shift")) {

            submitForm();
          }

        

        })

        let presence = new Presence(channel)

        const typingTimeout = 2000;
        var typingTimer;
        let userTyping = false;
  
        document.getElementById("body").addEventListener('keydown', () => {
          userStartsTyping()
          clearTimeout(typingTimer);
        })
  
          document.getElementById("body").addEventListener('keyup', () => {
            clearTimeout(typingTimer);
            typingTimer = setTimeout(userStopsTyping, typingTimeout);
          })
  
        const userStartsTyping = function() {
          if (userTyping) { return }
  
          userTyping = true
          channel.push('user:typing', { typing: true })
        }
  
        const userStopsTyping = function() {
          clearTimeout(typingTimer);
          userTyping = false
          channel.push('user:typing', { typing: false })
        }
    
        presence.onSync( () => {
          render_users_typing(presence.list())
          
        })

        channel.on('shout', payload => {
          let message = payload.body
          let chatBox = document.querySelector('#chat-box')
          let msgBlock = document.createElement('p')
          var datetime_string = convert_to_local_datetime(payload.inserted_at);
          msgBlock.insertAdjacentHTML('beforeend', `<message> ${datetime_string} <b>${payload.username}:</b> ${message} </message>`)
          let message_element = chatBox.appendChild(msgBlock)
          move_chatbox_down();
          let new_message = prepare_message(message_element.innerHTML)
          message_element.innerHTML = new_message
        })
      }
}
export default Chat