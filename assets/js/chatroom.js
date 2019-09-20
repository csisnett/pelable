function get_user_token() {
    var x = document.getElementsByTagName("META");
      var txt = "";
      var i;
    for (i = 0; i < x.length; i++) {
          if (x[i].name=="channel_token")
          {
               return x[i].content;
           }
  
      }
    }

    function move_chatbox_down(msgBlock) {
        var top_position = msgBlock.offsetTop
          window.last_message_position = top_position
          //console.log(chatBox.scrollTop)
          //console.log(top_position)
          if(top_position - chatBox.scrollTop <= 560){
            chatBox.scrollTop = top_position
          
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
      window.onload = function() {
        convert_to_local_datetimes();
      }
      
