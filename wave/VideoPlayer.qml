import QtQuick 2.0
import QtWebKit 3.0

Rectangle {
    id: videoplayer
    width: 640
    height: 480
    color: "blue"

    WebView{
        title: webview
        url: "https://youtube.com/embed/6fBZBntjEOA"
    }

}



