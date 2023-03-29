# Trên Centos 7
#--Login với quyền root

#1 Vô hiệu hóa Selinux
vim /etc/sysconfig/selinux
#-- Sửa dòng SELINUX=enforcing thành =disabled
reboot
#2 Kiểm tra firewall
firewall-cmd --state
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https

#3 Cài đặt Apache
yum install httpd -y
systemctl start httpd
systemctl enable httpd
systemctl status httpd

#4 Cài đặt PHP
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm

yum --disablerepo="*" --enablerepo="remi-safe" list php[7-9][0-9].x86_64

yum-config-manager --enable remi-php74

yum install php php-mysqlnd php-fpm -y

systemctl start php-fpm
systemctl enable php-fpm
systemctl status php-fpm

#5 Cài đặt một số thư viện
yum install gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release perl-Net-SNMP

#6 cài đặt Nagios
#--tạo user và group để Nagios có thể hoạt động
useradd nagios
useradd apache
groupadd nagcmd

usermod -G nagcmd nagios
usermod -G nagcmd apache

mkdir ~/nagios

cd ~/nagios

wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.5.tar.gz

wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz

tar xzf nagios-4.4.5.tar.gz

tar zxf nagios-plugins.tar.gz

cd nagios-4.4.5

./configure

make all

make install

make install-init

make install-daemoninit

make install-config

make install-commandmode

make install-webconf

systemctl restart httpd

#--Tạo user để đăng nhập vào web quản lý của Nagois
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

cd ..

cd nagios-plugins-release-2.2.1/

./tools/setup

./configure

make

make install

nagios-plugins-release-2.2.1]# /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg 

systemctl restart httpd

systemctl start nagios

systemctl status nagios

#-- Mở trình duyệt http//ip máy centos7/nagios
#-- Cấu hình file /usr/local/nagios/etc/objects/contacts.cfg
vim /usr/local/nagios/etc/objects/contacts.cfg
#-- đổi Email để nhận thông báo

#-- Cấu hình lớp mạng --> Allow From 127.0.0.1 "192.168.80.0/24" (thay lớp mạng)

#7 Cài đặt dịch vụ postfix
yum -y install postfix cyrus-sasl-plain mailx

vim /etc/postfix/main.cf
# -- Thêm vào cuối file /etc/postfix/main.cf

relayhost = [smtp.gmail.com]:587

smtp_use_tls = yes

smtp_sasl_auth_enable = yes

smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt

smtp_sasl_security_options = noanonymous

smtp_sasl_tls_security_options = noanonymous

systemctl start postfix

systemctl enable postfix
# Tạo file sasl_passwd trong /etc/postfix/
vim /etc/postfix/sasl_passwd

[smtp.gmail.com]:587 username:password
#== Tạo mật khẩu ứng dụng cho gmail và thay vào password/ username là địa chỉ gmail

#-- Phân quyền cho file sasl_passwd và reload dịch vụ postfix
postmap /etc/postfix/sasl_passwd

chown root:postfix /etc/postfix/sasl_passwd*

chmod 640 /etc/postfix/sasl_passwd*

systemctl reload postfix
# -- test dịch vụ
echo "Send successfully" | mail -s "Mail test" <email_nhận> (nếu không thực hiện bước tùy chọn trên)
#8 Cài đặt Nagios NRPE

cd ~/nagios
 
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz

tar xzf nrpe-3.2.1.tar.gz

cd xzf nrpe-3.2.1
./configure

make check_nrpe

make install-plugin

./fullinstall

Allow from "ip"

vim /usr/local/nagios/etc/objects/commands.cfg 
 #-- thêm vào cuối
 define command {

    command_name    check_nt
    command_line    $USER1$/check_nt -H $HOSTADDRESS$ -p 12489 -v $ARG1$ $ARG2$
}

#9 Cài đặt openssl-devel
cd ~

yum install openssl-devel -y

# Trên Ubuntu
sudo su

apt install autoconf automake gcc libc6 libmcrypt-dev unzip -y

apt install apt-file -y

apt-file update

apt-file search libssl | grep libssl-dev

sudo apt-get install openssl libssl-dev

useradd nagios

wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz

tar xzf nrpe-3.2.1.tar.gz

cd linux-nrpe-agent

./configure

make all

make install-configure

make install

make install-init



