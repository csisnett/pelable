function render_user(user) {
  user_container = document.getElementById("user-container");
  
  user_element = document.createElement('a')
  user_element.innerText = user.username
  user_container.appendChild(user_element)
}

function render_online_users(presence_list){
  let user_container = document.getElementById("user-container");
  while (user_container.firstChild) {
    user_container.removeChild(user_container.firstChild);
  }
  presence_list[0].metas.forEach(render_user)
}

function move_chatbox_down() {
  let new_message_container = document.getElementById("new_message");
  new_message_container.innerText = ""
  let chatBox = document.querySelector('#chat-box')
  chatBox.scrollTop = chatBox.scrollHeight;
}

function new_message(){
  let new_message_container = document.getElementById("new_message");
  new_message_container.innerText = "new message"
}

function move_chatbox_down_or_not() {
        let chatBox = document.querySelector('#chat-box')
        //console.log(chatBox.scrollTop);
         // console.log(chatBox.clientHeight);
         // console.log(chatBox.scrollHeight);
          
          
          if( chatBox.scrollTop + chatBox.clientHeight + 70 > chatBox.scrollHeight  ){
           // console.log("inside")
            move_chatbox_down();
          
          }
          else {
            new_message();
          }
}

function convert_to_local_datetime(datetime) {
        var str = datetime + "Z"
        let date = new Date(str)
      
                let local_time = date.toLocaleTimeString()
                let local_date = date.toLocaleDateString()
                return `${local_date} ${local_time}`
      }
function convert_to_local_datetimes() {
        var x = document.getElementsByTagName("datetime");
        for (i = 0; i < x.length; i++) {
                var date_time = convert_to_local_datetime(x[i].innerText)
               x[i].innerText = date_time
               
          }
}

function prepare_message(message){
  //console.log(message)
  return linkifyHtml(message, {})
}



function prepare_rendered_messages() {
  var x = document.getElementsByTagName("message");
  for (i = 0; i < x.length; i++) {
          var message = prepare_message(x[i].innerText)
         x[i].innerHTML = message
         
    }
}
