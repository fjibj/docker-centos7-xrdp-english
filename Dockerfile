FROM centos:7.6.1810
ENV container docker

RUN yum update -y
RUN yum groupinstall -y "Minimal Install"
RUN yum install -y epel-release
RUN yum groupinstall -y "Xfce"
RUN yum groupinstall -y "Development Tools"
RUN yum install -y R firefox bwa samtools xrdp tigervnc-server vlgothic-fonts ipa-mincho-fonts ipa-gothic-fonts ipa-pmincho-fonts ipa-pgothic-fonts net-tools zsh libevent ibus-kkc file bind-utils vcftools bedtools supervisor vlgothic-p-fonts libxml2 mock gcc rpm-build rpm-devel rpmlint make python bash coreutils diffutils patch rpmdevtools traceroute vim wget gedit

RUN yum remove -y NetworkManager ctags
ADD rpms/emacs25-25.2-1.el7.centos.x86_64.rpm /
RUN yum install -y ./emacs25-25.2-1.el7.centos.x86_64.rpm

RUN yum -y install kde-l10n-Chinese && yum -y reinstall glibc-common #安装中文支持 
RUN localedef -v -c -i zh_CN -f UTF-8 zh_CN.UTF-8; echo "";  #配置显示中文

#修改root用户密码
RUN echo "root:qwe123!@#" | chpasswd   

#install 安装支持中文的字体
ADD chinese-font.sh /
RUN /bin/bash -xe /chinese-font.sh

#RUN yum install -y cjkuni-uming-fonts.noarch fcitx* #安装输入法
RUN yum install -y ibus ibus-libpinyin ibus-gtk2 ibus-gtk3 im-chooser gtk2-immodule-xim gtk3-immodule-xim
#RUN mkdir -p /home/user/.config/autostart && mkdir -p /home/user/.config/fcitx && mkdir -p /home/user/Desktop
#RUN mkdir -p /home/user/.config/autostart && mkdir -p /home/user/Desktop && mkdir -p /home/user/.vnc

#安装chrome
ADD rpms/google-chrome-stable_current_x86_64.rpm /
RUN yum localinstall -y ./google-chrome-stable_current_x86_64.rpm

RUN echo "UseDNS no" >> /etc/ssh/sshd_config && sed -i 's#GSSAPIAuthentication yes#GSSAPIAuthentication no#g' /etc/ssh/sshd_config


#设置远程桌面
ADD setupcontainer.sh /
RUN /bin/bash -xe  /setupcontainer.sh

RUN yum clean all && rm -fr /var/cache/yum/* /tmp/*

#删除安装包
RUN rm -rf /chinese-font.sh
RUN rm -rf /setupcontainer.sh
RUN rm -rf /emacs25-25.2-1.el7.centos.x86_64.rpm
RUN rm -rf /google-chrome-stable_current_x86_64.rpm
RUN rm -rf /wqy-microhei-0.2.0-beta.tar.gz
RUN rm -rf /wqy-microhei

#设置用户与xfce桌面
ADD xfce4-panel.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/
#ADD autostart/fcitx.desktop /home/user/.config/autostart/
#ADD fcitx/config  /home/user/.config/fcitx/
#ADD fcitx/profile /home/user/.config/fcitx/
ADD Chrome.desktop /
ADD pinyin.desktop /
ADD entrypoint.sh /
EXPOSE 3389 
VOLUME /home
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
