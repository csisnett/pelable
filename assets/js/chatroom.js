import socket from "./socket.js";
import Chat from "./chat.js";
import ChatNotification from "./chatnotification.js";
import ChatPresence from "./chatpresence.js";


Chat.init(socket);
ChatNotification.init(socket);
ChatPresence.init(socket);