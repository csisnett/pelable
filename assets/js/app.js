
import css from "../css/app.css"
import "phoenix_html"
import socket from "./socket"
import Chat from "./chat"
Chat.init(socket)
// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.


// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//


// Import local files
//
// Local files can be imported directly using relative paths, for example:
