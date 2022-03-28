centos7-support-chinese with xrdp and xfce desktop

添加了ibus-libpinyin中文拼音输入法、Chrome浏览器（及桌面快捷方式）

（含R、中文输入法、chrome/firefox、sudo、sshd，使用非root用户user/user，不支持重启和关机）

# 需要先在rpms目录下放置google-chrome-stable_current_x86_64.rpm文件
```
docker build .  \  
  --build-arg  http_proxy=http://xx.xx.xx.xx:yy  \
  --build-arg  https_proxy=http://xx.xx.xx.xx:yy \    
  -t centos7-xrdp-nopri:20220328
启动容器无须特权模式，即不需要--privileged=true
docker run -d --name ggg -p 43000:3389 -p 43002:22  centos7-xrdp-nopri:20220328
```
