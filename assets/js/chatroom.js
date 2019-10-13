import {Socket} from "./phoenix.js"
import Chat from "./chat.js";
import ChatNotification from "./chatnotification.js";
import ChatPresence from "./chatpresence.js";



window.onload = function () {
    convert_to_local_datetimes();
    prepare_rendered_messages();
    console.log("user token: ")
    console.log(get_user_token())
    let socket = new Socket("/socket", {params: {token: get_user_token()}})
    socket.connect()
    Chat.init(socket);
    ChatNotification.init(socket);
    ChatPresence.init(socket);
    };