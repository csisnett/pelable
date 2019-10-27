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

        document.getElementById("new_message").addEventListener("click", move_chatbox_down);

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
          //let mention = current_user_mention("pelable_bot")
          let mentioned_usernames = payload.mentioned_usernames
          var datetime_string = convert_to_local_datetime(payload.inserted_at);
          console.log(mentioned_usernames)
          var message = payload.body
          var message_element_string = `<message> ${datetime_string} <b>${payload.username}:</b> ${message} </message>`
          if (typeof mentioned_usernames !== "undefined")
          {
            let mentions = mentioned_usernames.join(" ")
            message = mentioned_usernames.reduce(bold_mention, payload.body)
            message_element_string = `<message mentions="${mentions}"> ${datetime_string} <b>${payload.username}:</b> ${message} </message>`
          }
          let chatBox = document.querySelector('#chat-box')
          let msgBlock = document.createElement('p')
          
          msgBlock.insertAdjacentHTML('beforeend', message_element_string)
          let message_element = chatBox.appendChild(msgBlock)
          console.log(message_element)
          move_chatbox_down_or_not();
          let new_message = prepare_message(message_element.innerHTML)
          message_element.innerHTML = new_message
          //console.log(message_element)
          
          highlight_if_mentioned(message_element.lastChild, mention)
        })
      }
}
export default Chat