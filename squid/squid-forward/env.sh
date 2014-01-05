 1.临时通过http代理使用apt-get

            在使用apt-get之前，在终端中输入以下命令（根据您的实际情况替换yourproxyaddress和proxyport）。
            export http_proxy=http://yourproxyaddress:proxyport
            取消代理使用
            export http_proxy=""

       2.设置apt-get永久使用http代理

             sudo gedit /etc/apt/apt.conf在您的apt.conf文件中加入下面这行（根据你的实际情况替换yourproxyaddress和proxyport）。
             Acquire::http::Proxy "http://yourproxyaddress:proxyport";
             保存apt.conf文件即可

        3.设置全局代理上网(apt-get, wget 等等)

              gedit ~/.bashrc在您的.bashrc文件末尾添加如下内容（根据你的实际情况替换

yourproxyaddress和proxyport）。
             export http_proxy=“http://yourproxyaddress:proxyport ”
             保存文件，重新开启终端。
-pt-get

            在使用apt-get之前，在终端中输入以下命令（根据您的实际情况替换yourproxyaddress和proxyport）。
            export http_proxy=http://yourproxyaddress:proxyport
            取消代理使用
            export http_proxy=""

       2.设置apt-get永久使用http代理

             sudo gedit /etc/apt/apt.conf在您的apt.conf文件中加入下面这行（根据你的实际情况替换yourproxyaddress和proxyport）。
             Acquire::http::Proxy "http://yourproxyaddress:proxyport";
             保存apt.conf文件即可

        3.设置全局代理上网(apt-get, wget 等等)

              gedit ~/.bashrc在您的.bashrc文件末尾添加如下内容（根据你的实际情况替换

yourproxyaddress和proxyport）。
             export http_proxy=“http://yourproxyaddress:proxyport ”
             保存文件，重新开启终端。bash: ipr: command not found
