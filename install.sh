#!/bin/bash
# @author: Gia Tuáº¥n
# @website: https://wptangtoc.com
# @email: giatuan@wptangtoc.com
# @since: 2022

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

read -p "Nháº­p domain hoáº·c subdomain báº¡n muá»‘n thÃªm 
    (vÃ­ dá»¥: wptangtoc.com, abc.wptangtoc.com ...) : " NAME

#chuyá»ƒn Ä‘á»•i viáº¿t hoa thÃ nh chá»¯ thÆ°á»ng Ä‘iá»u kiá»‡n
NAME=$(echo $NAME | tr '[:upper:]' '[:lower:]')

check_root=$(who | awk -F ' ' '{print $1}'| head -1)
if [[ "$check_root" != "root" ]]; then
	if [[ -f /home/$check_root/.bashrc ]]; then
		check_root_2=$(whoami)
		if [[ $check_root_2 != 'root' ]];then
			echo "Vui lÃ²ng sá»­ dá»¥ng tÃ i khoáº£n root Ä‘á»ƒ cÃ i Ä‘áº·t chÆ°Æ¡ng trÃ¬nh WPTangToc OLS"
			echo "Vui lÃ²ng chuyá»ƒn sang user Root. Vui lÃ²ng cháº¡y láº¡i lá»‡nh cÃ i Ä‘áº·t."
			echo "HÆ°á»›ng dáº«n login tÃ i khoáº£n root: https://wptangtoc.com/wptangtoc-ols-cau-hoi-thuong-gap/#Yeu_cau_tai_khoan_root_moi_cai_duoc_wptangtoc_ols"
			echo "Khi hoÃ n táº¥t thÃ¬ hÃ£y cháº¡y láº¡i lá»‡nh:"
			echo "curl -sO https://wptangtoc.com/share/wptangtoc-ols && bash wptangtoc-ols"
			rm -f wptangtoc-ols
			exit
		fi
	fi
fi

check_phan_vung_home_gioi_han=$(df -TH | grep '/dev/mapper/centos-home')
if [[ $check_phan_vung_home_gioi_han ]];then
	echo "Vui lÃ²ng liÃªn há»‡ vá»›i nhÃ  cung cáº¥p VPS, mÃ¡y chá»§ cá»§a báº¡n cÃ i há»‡ Ä‘iá»u hÃ nh linux theo dáº¡ng nhÃ¡nh gá»‘c /"
	echo "Hiá»‡n táº¡i há»‡ Ä‘iá»u hÃ nh cá»§a báº¡n Ä‘ang Ä‘Æ°á»£c phÃ¢n quyá»n theo dáº¡ng home dung lÆ°á»£ng lá»›n vÃ  nhÃ¡nh gá»‘c / dung lÆ°á»£ng nhá»"
	echo "KhÃ´ng phÃ¹ há»£p vá»›i cáº¥u trÃºc WPTangTocOLS"
	rm -f wptangtoc-ols
	exit
fi

wordpress=$1
if [ "$NAME" = '' ]; then
  clear
  echo "Báº¡n chÆ°a nháº­p tÃªn miá»n, vui lÃ²ng nháº­p tÃªn miá»n cá»§a báº¡n."
  exit
fi

if [ "$NAME" = "${NAME/./}" ]; then
  clear
  echo "Domain báº¡n nháº­p khÃ´ng Ä‘Ãºng Ä‘á»‹nh dáº¡ng. hÃ£y nháº­p vÃ­ dá»¥: wptangtoc.com, abc.wptangtoc.com, wptangtoc.xyz..."
rm -f wptangtoc-ols
  exit
fi

if [[ $(echo $NAME | grep '://') ]];then
    NAME=$(echo $NAME | cut -f3 -d '/')
fi

if [[ $(echo $NAME | grep 'www.') ]];then
    NAME=$(echo $NAME | sed 's/^www.//g')
fi



#check CPU ARM bÃ¡o lá»—i
if [[ $(uname -m | grep 'arm') ]];then
echo "Hiá»‡n táº¡i wptangtoc ols chá»‰ há»— trá»£ CPU x86_64 khÃ´ng há»— trá»£ CPU ARM"
echo "Äá»ƒ sá»­ dá»¥ng WPTangToc OLS hÃ£y lá»±a chá»n CPU x86_64"
rm -f wptangtoc-ols
exit
fi

if [ -f /var/cpanel/cpanel.config ]; then
  clear
  echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t WHM/Cpanel, náº¿u muá»‘n sá»­ dá»¥ng WPTangToc OLS"
  echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
  rm -f wptangtoc-ols
  exit
fi

if [[ -d /usr/local/lscp ]];then
  echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t Cyberpanel, náº¿u muá»‘n sá»­ dá»¥ng WPTangToc OLS"
  echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
  rm -f wptangtoc-ols
  exit
fi

if [ -f /etc/psa/.psa.shadow ]; then
  clear
  echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t Plesk, náº¿u muá»‘n sá»­ dá»¥ng WPTangToc OLS"
  echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
  rm -f wptangtoc-ols
  exit
fi

if [ -f /etc/wptt/.wptt.conf ]; then
  clear
  echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t WPTangToc OLS trÆ°á»›c Ä‘Ã³ rá»“i"
  echo "Cáº£m Æ¡n báº¡n Ä‘Ã£ lá»±a chá»n sá»­ dá»¥ng WPTangToc OLS"
  echo "YÃªu cáº§u há»— trá»£: Gia Tuáº¥n - Email: giatuan@wptangtoc.com"
  rm -f wptangtoc-ols
  exit
fi

if [ -f /etc/init.d/directadmin ]; then
  clear
  echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t DirectAdmin, náº¿u muá»‘n sá»­ dá»¥ng WPTangToc OLS"
  echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
  rm -f wptangtoc-ols
  exit
fi

if [ -f /etc/init.d/webmin ]; then
  clear
  echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t webmin, náº¿u muá»‘n sá»­ dá»¥ng WPTangToc OLS"
  echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
  rm -f wptangtoc-ols
  exit
fi

sentora="/root/passwords.txt"
hocvps="/etc/hocvps/scripts.conf"
eev3="/usr/local/bin/ee"
wordops="/usr/local/bin/wo"
kusanagi="/home/kusanagi"
cwpsrv="/usr/local/cwpsrv"
vestacp="/usr/local/vesta/"
eev4="/opt/easyengine"
vpssim="/home/vpssim.conf"
larvps="/etc/larvps/.larvps.conf"
tino="/opt/tinopanel"
hostvn="/var/hostvn/hostvn.conf"

if [ -f "${larvps}" ]; then
	echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t Larvps, náº¿u muá»‘n sá»­ dá»¥ng WPTangToc OLS"
	echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
	rm -f wptangtoc-ols
	exit
fi

if [[ -f "${sentora}" || -f "${hocvps}" || -f "${eev3}" || -f "${wordops}" || -f "${kusanagi}" || -f "${cwpsrv}" || -f "${vestacp}" || -f "${eev4}" || -f "${vpssim}" || -f "${tino}" || -f "${hostvn}" ]]; then
echo "Báº¡n Ä‘Ã£ sá»­ dá»¥ng cÃ¡c báº£ng Ä‘iá»u khiá»ƒn khÃ¡c vui lÃ²ng reintall láº¡i VPS Ä‘á»ƒ cÃ³ thá»ƒ sá»­ dá»¥ng WPTANGTOC OLS"
  echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
  rm -f wptangtoc-ols
  exit
fi

if [[ -d /usr/local/lsws || -d /home/lsws ]]; then
	echo "webserver cá»§a báº¡n Ä‘Ã£ Ä‘Æ°á»£c cÃ i Ä‘áº·t LiteSpeed Webserver, náº¿u muá»‘n sá»­ dá»¥ng WPTangToc OLS"
	echo "HÃ£y reinstall láº¡i há»‡ Ä‘iá»u hÃ nh CentOS 7 - 64 bit, rá»“i má»›i cÃ³ thá»ƒ cÃ i Ä‘áº·t WPTangToc OLS"
	rm -f wptangtoc-ols
	exit
fi

work_cpucore=$(ulimit -n)
cpucore=$(grep -c ^processor /proc/cpuinfo)
max_client=$(expr $work_cpucore \* $cpucore \* 2)
max_client_max=$(expr $work_cpucore \* $cpucore \* 3)
max_client_php=$(expr $work_cpucore \* $cpucore \/ 8)
tong_ram_byte=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
rong_ram_mb=$(echo "scale=0;${tong_ram_byte}/1024" | bc)
if [[ "$rong_ram_mb" = "" ]]; then
  rong_ram_mb="2048"
fi
tong_ram_mb_db=$(echo "scale=0;${rong_ram_mb}/4" | bc)

if [[ $tong_ram_mb_db = '' ]];then
  tong_ram_mb_db="2048"
fi

tong_ram_gb=$(expr ${rong_ram_mb} / 1024)
db_table_size=$(expr $tong_ram_gb \* 64 )
buffer_db=$(expr $rong_ram_mb / 6)
wptangtocols_version=$(curl -s https://wptangtoc.com/share/version-wptangtoc-ols.txt?domain-install=$NAME)

if [[ $wptangtocols_version = "" ]];then
wptangtocols_version=$(curl -s https://github.com/wptangtoc/wptangtoc-ols/blob/main/version-wptangtoc-ols.txt | grep 'LC1' | cut -f2 -d '>' | sed 's:</td::g')
fi

Server_OS_Version=$(grep VERSION_ID /etc/os-release | awk -F[=,] '{print $2}' | tr -d \" | head -c2 | tr -d .)
if [[ "$Server_OS_Version" != "7" ]]; then
  echo "Pháº§n má»m nÃ y hiá»‡n táº¡i chá»‰ phÃ¡t triá»ƒn trÃªn centos 7 vui lÃ²ng sá»­ dá»¥ng há»‡ Ä‘iá»u hÃ nh linux centos 7"
  rm -f wptangtoc-ols
  exit
fi

clear
#chon version php cho function luu tru
function chon_version_php(){
echo "Báº¡n hÃ£y lá»±a chá»n phiÃªn báº£n PHP muá»‘n sá»­ dá»¥ng: "
prompt="Nhap vao lua chon cua ban [1-4]: "
php_version="8.1"
options=("Phien ban PHP 8.1" "Phien ban PHP 8.0" "Phien ban PHP 7.4" "Phien ban PHP 7.3")
PS3="$prompt"
select opt in "${options[@]}"; do

  case "$REPLY" in
  1)
   php_version="8.1"
    break
    ;;

  2)
    php_version="8.0"
    break
    ;;
  3)
    php_version="7.4"
    break
    ;;

  4)
    php_version="7.3"
    break
    ;;

  $((${#options[@]} + 1)))
    printf "\nHe thong se cai dat PHP 7.4\n"
    break
    ;;
  *)
    printf "Ban nhap sai, he thong cai dat PHP 7.4\n"
    break
    ;;
  esac

done
}

#set máº·c Ä‘á»‹nh php 8.1 lÃ  WordPress máº·c Ä‘á»‹nh
php_version="8.1"

clear

echo "Báº¡n hÃ£y lá»±a chá»n phiÃªn báº£n Maria Database muá»‘n sá»­ dá»¥ng: "
prompt="Nháº­p vÃ o lá»±a chá»n cá»§a báº¡n [1-4]: "
mariadb_version="10.6"
options=("Phien ban: 10.7" "Phien ban: 10.6" "Phien ban: 10.5" "Phien ban: 10.4")
PS3="$prompt"
select opt in "${options[@]}"; do

	case "$REPLY" in
		1)
			mariadb_version="10.7"
			break
			;;

		2)
			mariadb_version="10.6"
			break
			;;
		3)
			mariadb_version="10.5"
			break
			;;

		4)
			mariadb_version="10.4"
			break
			;;

		$((${#options[@]} + 1)))
			printf "\nHe thong se cai dat maria database 10.5\n"
			break
			;;
		*)
			printf "Ban nhap sai, he thong cai dat maria database 10.5\n"
			break
			;;
	esac

done
clear


# tuong thich vps há»‡ thá»‘ng nhá» dÆ°á»›i 1GB
if (( $rong_ram_mb  > 1024 ));then
echo "Báº¡n hÃ£y lá»±a chá»n object cache báº¡n muá»‘n sá»­ dá»¥ng: "
prompt="Nháº­p vÃ o lá»±a chá»n cá»§a báº¡n [1-4]: "
object_cache="lsmemcached"
options=("Redis" "Lsmemcached" "Memcached" "Khong su dung")
PS3="$prompt"
select opt in "${options[@]}"; do

	case "$REPLY" in
		1)
			object_cache="redis"
			break
			;;
		2)
			object_cache="lsmemcached"
			break
			;;

		3)
			object_cache="memcache"
			break
			;;

		4)
			object_cache="khong_su_dung_object_cache"
			break
			;;


		$((${#options[@]} + 1)))
			printf "\nHe thong se cai dat lsmemcached\n"
			break
			;;
		*)
			printf "Ban nhap sai, he thong cai dat lsmemcached\n"
			break
			;;
	esac

done
clear
else
object_cache="khong_su_dung_object_cache"
fi


if [[ $php_version = "" ]];then
	php_version="7.4"
fi

if [[ $mariadb_version = "" ]];then
	mariadb_version="10.6"
fi

if [[ $object_cache = "" ]];then
	object_cache="khong_su_dung_object_cache"
fi


echo "Báº¡n cÃ³ muá»‘n thay Ä‘á»•i Port SSH? Ä‘á»ƒ nÃ¢ng cao báº£o máº­t"
read -p "Nháº­p port SSH má»›i, bá» qua nháº¥n (Enter): " port_ssh

if [[ "$wordpress" = "wp" ]]; then
	clear
	read -p "Xac nhan ban muon thiet lap wp-config ngay tai day khong. (y/n): " dongyconfig
	if [[ "$dongyconfig" = "y" ]]; then
		read -p "1. Ten tieu de Website wordpress cua ban muon : " SiteTitle
		read -p "2. Nhap id dang nhap wordpress: " idusername
		read -sp "3. Nhap password wordpress:
		Luu y: hay nhap wordpress it nhat 26 ky tu de nang cao bao mat (Password khi gÃµ sáº½ áº©n): " mypassword
		echo ""
		read -p "4. Nhap Email ban cua website $NAME
		vi du abc@gmail.com, giatuan@wptangtoc.com: " emailwp
		if [ "$emailwp" = "${emailwp/@/}" ]; then
			clear
			echo "Email khong dung dinh dang."
			echo
			exit
		fi
		tien_to_db=$(
		date +%s | sha256sum | base64 | head -c 6
		echo
	)
	fi
fi
RED='\033[0;31m'
NC='\033[0m'
echo -e "${RED}
     .:..........................             
      .::::::::::::::::::::::::::::..         
        ..:::::::::::::::::::::::::::::.      
                             ...:::::::::.    
                                  .:::::::.   
          .:::::::.         .       .:::::::  
         .::::::::::::::::::::..      ::::::: 
         ::::::::::::::::::::::::.     ::::::.
        .::::::::::::::::::::::::::.   .:::::.
        .::::::::::::::::::::::::::::  .:::::.
        .::::::::::::::::::::::::::.   .:::::.
         ::::::::::::::::::::::::.     ::::::.
.::::::  .:::::::::::::::::::::.      ::::::. 
          .:::::::.                 .:::::::  
       ::::::::::::.              .:::::::.   
       ......:::::::::...    ...:::::::::.    
               .:::::::::::::::::::::::.      
   ..............::::::::::::::::::..         
  .:::::::::::::................. ${NC}"

echo ""
echo -e "${RED}-------------------------------------------------------------------------"
echo ""
echo " 0     0 000000  0000000                         0000000 "
echo " 0  0  0 0     0    0       00    0    0   0000     0      0000    0000 "
echo " 0  0  0 0     0    0      0  0   00   0  0    0    0     0    0  0    0 "
echo " 0  0  0 000000     0     0    0  0 0  0  0         0     0    0  0 "
echo -e "${NC} 0  0  0 0          0     000000  0  0 0  0  000    0     0    0  0 "
echo " 0  0  0 0          0     0    0  0   00  0    0    0     0    0  0    0 "
echo "  00 00  0          0     0    0  0    0   0000     0      0000    0000 "
echo ""
echo "  00000   0       00000 "
echo " 0     0  0      0     0 "
echo " 0     0  0      0 "
echo -e "${RED} 0     0  0       00000 "
echo " 0     0  0            0 "
echo " 0     0  0      0     0 "
echo "  00000   000000  00000 "
echo -e "--------------------------------------------------------------------------${NC}"
sleep 2
clear
function box_out() {
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w < ${#l})) && {
      b="$l"
      w="${#l}"
    }
  done
  tput setaf 7
  echo " -${b//?/-}-
| ${b//?/ } |"
  for l in "${s[@]}"; do
    printf '| %s%*s%s |\n' "$(tput setaf 7)" "-$w" "$l" "$(tput setaf 3)"
  done
  echo "| ${b//?/ } |
 -${b//?/-}-"
  tput sgr 0
}

box_out "Xin chÃ o $NAME" "ChÃ o má»«ng báº¡n Ä‘áº¿n vá»›i WPTANGTOC OLS version $wptangtocols_version"
sleep 2
clear
echo ""
echo "Äang chuáº©n bá»‹ tiáº¿n hÃ nh cÃ i Ä‘áº·t WPTangToc OLS $wptangtocols_version"
sleep 1
echo ""
echo "Cáº£m Æ¡n báº¡n Ä‘Ã£ lá»±a chá»n sá»­ dá»¥ng WPTangToc OLS ..."
sleep 2

echo "
                                  .:..              
                             ..:-------.            
                          .:::.......:::::.         
                         :--. ..........:::.        
                        :::..    ........:::.       
                       ...--::..........:.:::       
                        :=+++=-:........:::::       
                       :+*****==:... ......:.       
                       ==+*###***=-===+=:.:         
                       =-::=********###%*==         
                      -*+=-=+*+=-:-=*##%*+#=        
                      +####*####*+++*##%***.        
                      +*+**#%%###%%%%##%#+.         
                      :+=++*###**####%#-:           
                       ==-+++***++*###:             
       .-====----:::::--+==++++++***#.              
     .-===------==-----:=**++*##***#+               
    :-----=------==----:-+++*******##.              
  .-----=---------------==+=++******+-:             
 :----------=--------:.:+******+++=--==-            
----------------------:::=***+===--====--:          
----:------------------::-:-::..-===-===-==:        
---::--------------------=-:---::-=-====--=++-:.  
"
echo ""
echo "Pháº§n má»m phÃ¡t triá»ƒn bá»Ÿi Gia Tuáº¥n"
sleep 4
clear
yum install epel-release -y
yum clean all && yum update -y


function kernel_tcp_toi_uu(){
LIMITSCONFCHECK=$(grep '* hard nofile 524288' /etc/security/limits.conf)
if [[ -z $LIMITSCONFCHECK ]]; then #check LIMITSCONFCHECK
	# Set VPS hard/soft limits
	echo "* soft nofile 524288" >>/etc/security/limits.conf
	echo "* hard nofile 524288" >>/etc/security/limits.conf

if [[ ! -f /etc/rc.d/rc.local ]]; then #check khong co rc.local
	cat > /usr/lib/systemd/system/rc-local.service <<EOF
# This unit gets pulled automatically into multi-user.target by
# systemd-rc-local-generator if /etc/rc.d/rc.local is executable.
[Unit]
Description=/etc/rc.d/rc.local Compatibility
ConditionFileIsExecutable=/etc/rc.d/rc.local
After=network.target
[Service]
Type=forking
ExecStart=/etc/rc.d/rc.local start
TimeoutSec=0
RemainAfterExit=yes
EOF

cat > /etc/rc.d/rc.local <<EOF
#!/bin/bash
# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
#
# It is highly advisable to create own systemd services or udev rules
# to run scripts during boot instead of using this file.
#
# In contrast to previous versions due to parallel execution during boot
# this script will NOT be run after all other services.
#
# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
# that this script will be executed during boot.
touch /var/lock/subsys/local
EOF

# remove non-standard centos 7 service file if detected
if [ -f /etc/systemd/system/rc-local.service ]; then
	echo "cat /etc/systemd/system/rc-local.service"
	cat /etc/systemd/system/rc-local.service
	echo
	rm -rf /etc/systemd/system/rc-local.service
	rm -rf /var/lock/subsys/local
	systemctl daemon-reload
	systemctl stop rc-local.service
fi

chmod +x /etc/rc.d/rc.local
pushd /etc; ln -s rc.d/rc.local /etc/rc.local; popd
systemctl daemon-reload
systemctl start rc-local.service
systemctl status rc-local.service

fi #check khong co rc.local

ulimit -n 524288
echo "ulimit -n 524288" >> /etc/rc.local

fi #check LIMITSCONFCHECK


if [[ -f /etc/security/limits.d/20-nproc.conf ]]; then
	cat > "/etc/security/limits.d/20-nproc.conf" <<EOF
# Default limit for number of user's processes to prevent
# accidental fork bombs.
# See rhbz #432903 for reasoning.
*          soft    nproc     8192
*          hard    nproc     8192
nobody     soft    nproc     32278
nobody     hard    nproc     32278
root       soft    nproc     unlimited
EOF
fi

if [[ ! -f /proc/user_beancounters ]]; then #check dieu kien ao hoa 1 phan skip
	if [ -d /etc/sysctl.d ]; then #check kernel toan phan
		if [[ "$(grep 'wptangtoc-ols' /etc/sysctl.d/101-sysctl.conf >/dev/null 2>&1; echo $?)" != '0' ]]; then #check da add wptangtoc ols mod kernel
			touch /etc/sysctl.d/101-sysctl.conf
			echo 65536 > /sys/module/nf_conntrack/parameters/hashsize
			if [[ "$(grep 'hashsize' /etc/rc.local >/dev/null 2>&1; echo $?)" != '0' ]]; then
				echo "echo 65536 > /sys/module/nf_conntrack/parameters/hashsize" >> /etc/rc.local
			fi
			cat >> "/etc/sysctl.d/101-sysctl.conf" <<EOF
# wptangtoc-ols
kernel.pid_max=65536
kernel.printk=4 1 1 7
fs.nr_open=12000000
fs.file-max=9000000
net.core.wmem_max=16777216
net.core.rmem_max=16777216
net.ipv4.tcp_rmem=8192 87380 16777216                                          
net.ipv4.tcp_wmem=8192 65536 16777216
net.core.netdev_max_backlog=65536
net.core.somaxconn=65535
net.core.optmem_max=8192
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_probes=3
net.ipv4.tcp_keepalive_time=240
net.ipv4.tcp_max_syn_backlog=65536
net.ipv4.tcp_sack=1
net.ipv4.tcp_syn_retries=3
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_max_tw_buckets = 1440000
vm.swappiness=10
vm.min_free_kbytes=65536
net.ipv4.ip_local_port_range=1024 65535
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_limit_output_bytes=65536
net.ipv4.tcp_rfc1337=1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.log_martians = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.netfilter.nf_conntrack_helper=0
net.nf_conntrack_max = 524288
net.netfilter.nf_conntrack_tcp_timeout_established = 28800
net.netfilter.nf_conntrack_generic_timeout = 60
net.ipv4.tcp_challenge_ack_limit = 999999999
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_base_mss = 1024
net.unix.max_dgram_qlen = 4096
EOF


if [[ "$(grep -o 'AMD EPYC' /proc/cpuinfo | sort -u)" = 'AMD EPYC' ]]; then #check cpu amd
	echo "kernel.watchdog_thresh = 20" >> /etc/sysctl.d/101-sysctl.conf
fi #check cpu amd

if [[ -f /usr/lib/tuned/virtual-guest/tuned.conf ]];then
sed -i '/vm.swappiness/d' /usr/lib/tuned/virtual-guest/tuned.conf
echo 'vm.swappiness = 10' >> /usr/lib/tuned/virtual-guest/tuned.conf
fi

/sbin/sysctl --system

		fi #check da add wptangtoc ols mod kernel
	fi #check kernel toan phan

#Ã©p xung, xung nhá»‹p Ä‘Æ¡n nhÃ¢n cpu lÃªn tá»‘i Ä‘a high performance for centos 7 vÃ  táº¯t cÆ¡ cháº¿ tiáº¿t kiá»‡m Ä‘iá»‡n ktune, tá»‘i Æ°u i/o
if [[ $(which tuned-adm) ]];then
tuned-adm profile latency-performance
fi
# tuned-adm profile throughput-performance

fi #check dieu kien ao hoa 1 phan skip
}
kernel_tcp_toi_uu


function kernel_update(){
echo "Cap nhat update kernel linux core"
echo ':::::::::::::.     ..:::::::::::::
::::::::::::       :  ::::::::::::
:::::::::::.           :::::::::::
::::::::::: -+- .++*.  .::::::::::
:::::::::::.+.*-+* *=  .::::::::::
::::::::::- -**%%#*#.  .::::::::::
::::::::::-.:*******: : :-::::::::
::::::::::: =#++*#%@%:   :::::::::
:::::::::. +@@@%@@@@@@    .:::::::
::::::::  -@@@@@@@@@%@+     ::::::
:::::::  .%@@@@@@@@@@@@* .   :::::
::::::. .%@@@@@@@@@@@@@@+ ..  ::::
::::-:  *@@@@@@@@@@@@@@@%  .  .:::
----:  .@@@@@@@@@@@@@@@@@  .   :::
:::::==-#@@@@@@@@@@@@@@@#   ...-::
-===*###-:*@@@@@@@@@@@%*#.   =*::-
-########=  +@@@@@@@@@#*#*=+*##+-:
-*########+:+@@@@@@@@*:+########*=
=##########*##%%%%#=. .*#####**+=-
-=++****###*:  ..     :+***+=--:::
::::----===-:-::::--::::----::::--
'
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
yum --enablerepo=elrepo-kernel install -y kernel-lt
grub2-set-default 0
grub2-mkconfig -o /boot/grub2/grub.cfg
echo "Hoan tat qua trinh update kernel LTS linux core"
}

#tat selinux

if [[ -f /etc/sysconfig/selinux ]];then
setenforce 0
sed -i 's/=enforcing/=disabled/g' /etc/sysconfig/selinux
fi

rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install nano wget zip unzip curl git certbot bind-utils firewalld gcc gcc-c++ make autoconf glibc rcs -y
yum remove postfix chrony acpid Sendmail Xfs Autofs Isdn Nfslock Apmd nginx yum-cron -y
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/'$mariadb_version'/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >/etc/yum.repos.d/MariaDB.repo
yum clean all
yum update -y
echo '@@@@@@@@@@@@@@@@@@@@@@@@@#*+=:#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@=.    -@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@%.    +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@*     =@@@#=@@@@*=@@@@@@@@@@@@@@%+@@@@@@@@@+*****@@%+#*#*#@
@@@@@@@@@@@@@@@@%#=.      @@@@  :@@*  +@%==++=%@=++**:@%==++=%@.*@@%#:%*.###*.@
@@@@@@@@@@%#+=:.         +@@@= @::# #+ @ .@@* #% =%@= @ :@@+ #@.%@@@@.*#:###*:#
@@@@@@@@+:              -@@@@.+@@: *@@.+*:+*= %% #@@* *+:+*= %@:+#**=+@*:####-#
@##%%%+          ..  :-*@@@@@@@@@@@@@@@@@@%%@@@@@@@@@@@@@%%@@@@@%%%%@@@@@%%%%@@
@+    .=#%@@@%%##=  =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@#:-+#@@@@@@@@@@#-+%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
box_out "Tiáº¿n hÃ nh cÃ i Ä‘áº·t Maria Database $mariadb_version"

yum install MariaDB-server MariaDB-client -y
systemctl start mariadb.service
systemctl enable mariadb.service
echo "Chung minh thay database user root bang wordpressadmin de nang cao bao mat"
db_root_password=$(
  date +%s | sha256sum | base64 | head -c 32
  echo
)

mysql <<EOF
use mysql;
FLUSH PRIVILEGES;
CREATE USER 'wordpressadmin'@'localhost' IDENTIFIED BY '$db_root_password';
GRANT ALL PRIVILEGES ON *.* TO 'wordpressadmin'@'localhost' WITH GRANT OPTION;
DROP USER 'root'@'localhost';
FLUSH PRIVILEGES;
EOF

box_out "HoÃ n táº¥t quÃ¡ trÃ¬nh cÃ i Ä‘áº·t Maria database"

systemctl restart mariadb.service


systemctl start firewalld
systemctl enable firewalld
systemctl stop httpd
systemctl disable httpd
systemctl mask httpd


# chuyen doi tuong thich iptables sang firewalld
checktuonglua=$(systemctl status firewalld | grep "masked")
if [[ "$checktuonglua" ]];then
systemctl unmask firewalld
systemctl start firewalld
systemctl enable firewalld
systemctl mask ip6tables
systemctl mask iptables
systemctl disable iptables
systemctl disable ip6tables
systemctl stop iptables
systemctl stop ip6tables
fi

mkdir -p /etc/wptt/
mkdir -p /etc/wptt/vhost
mkdir -p /etc/wptt-user

rpm -Uvh http://rpms.litespeedtech.com/centos/litespeed-repo-1.1-1.el7.noarch.rpm

echo '[litespeed]
name=LiteSpeed Tech Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/centos/$releasever/$basearch/
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed

[litespeed-update]
name=LiteSpeed Tech Update Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/centos/$releasever/update/$basearch/
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed

[litespeed-edge]
name=LiteSpeed Tech Edge Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/edge/centos/$releasever/$basearch/
failovermethod=priority
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed

[litespeed-edge-update]
name=LiteSpeed Tech Edge Update Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/edge/centos/$releasever/update/$basearch/
failovermethod=priority
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed
' >/etc/yum.repos.d/litespeed.repo

echo '                         -#-                  
                       -#@@-                  
                     -#@@%%-    -.            
                   -#@@%@@@: :+*-             
                 -#@@@@@%*==*%+               
               -#@@@@@#+=+#%*:.               
             -#@@@@%*==*#%%-.=++:             
           -#@@@%#==+#%%%*:-+++++=:           
         -#@@@%@*.#%%%%%- :++++++++=:         
       -#@@@@@@@%--#%%%%+   -++++++++=:       
      +@@%@@@@@@-  .*##%%#:   -+++++++++:     
      .=%@@%@@@@%=.  =####%= .=++++++++=.     
        .+%@@%@@@@%=. -#####*.=++++++=.       
          .+%@@@@%@@-:*####+=:=++++=.         
            .+%@@@*:=###*=--=++++=.           
              .+#--###+---+++++=.             
                .+#*=--=+++++=.               
               =#+:.=++++++=.                 
             .+=.  :+++++=.                   
                   :+++=.                     
                   :+=.                       
                   .:                         
'
yum install openlitespeed -y

box_out "HoÃ n táº¥t cÃ i Ä‘áº·t OpenLiteSpeed"

USER=${NAME//[-._]/wp}
check_ky_tu=$(echo $USER | wc -c)
if (( $check_ky_tu > 32 ));then
	USER=$(echo $USER | cut -c 1-30)
fi

# useradd $USER -p -m -d /home/$USER >/dev/null 2>&1
useradd -p -m -d /usr/local/lsws/$NAME $USER >/dev/null 2>&1

if [[ $(cat /etc/passwd | cut -f1 -d ':' | grep -w $USER) = '' ]];then
	random=$(
	date +%s | sha256sum | base64 | head -c 2
	echo
)

USER=${NAME//[-._]/$random}
check_ky_tu2=$(echo $USER | wc -c)
if (( $check_ky_tu2 > 32 ));then
	USER=$(echo $USER | cut -c 1-30)
fi
# useradd "$USER" -p -m -d /home/"$USER" >/dev/null 2>&1
useradd -p -m -d /usr/local/lsws/$NAME $USER >/dev/null 2>&1
fi


groupadd wptangtoc-ols >/dev/null 2>&1

php_ver_chon=${php_version//[-._]/}

yum install lsphp${php_ver_chon} lsphp${php_ver_chon}-json lsphp${php_ver_chon}-common lsphp${php_ver_chon}-gd lsphp${php_ver_chon}-imagick lsphp${php_ver_chon}-process lsphp${php_ver_chon}-mbstring lsphp${php_ver_chon}-mysqlnd lsphp${php_ver_chon}-xml lsphp${php_ver_chon}-opcache lsphp${php_ver_chon}-mcrypt lsphp${php_ver_chon}-pdo lsphp${php_ver_chon}-imap lsphp${php_ver_chon}-bcmath lsphp${php_ver_chon}-pecl-memcache lsphp${php_ver_chon}-intl -y

#centos7 khong ho tro zip truc tiep cai he dieu hanh moi hon thi them zip vao thang lscache

# yum install lsphp${php_ver_chon}-zip -y


ln -sf /usr/local/lsws/lsphp${php_ver_chon}/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp${php_ver_chon}
ln -sf /usr/local/lsws/lsphp${php_ver_chon}/bin/lsphp /usr/local/lsws/fcgi-bin/lsphp5
ln -sf /usr/local/lsws/lsphp${php_ver_chon}/bin/php /usr/bin/php

#cai dat zip theo cach khac]
# yum install lsphp${php_ver_chon}-pear lsphp${php_ver_chon}-devel -y
# yum install -y http://packages.psychotic.ninja/7/plus/x86_64/RPMS/libzip-0.11.2-6.el7.psychotic.x86_64.rpm
# yum install -y http://packages.psychotic.ninja/7/plus/x86_64/RPMS/libzip-devel-0.11.2-6.el7.psychotic.x86_64.rpm
# /usr/local/lsws/lsphp${php_ver_chon}/bin/pecl install zip
# echo "extension=zip.so" > /usr/local/lsws/lsphp${php_ver_chon}/etc/php.d/20-zip.ini

blue='\033[1;34m'
NC='\033[0m'
echo -e "${blue}                                              
                           ...::::--------------:::...                          
                  .:--===++++===========================--:..                  
             :-=+++++++===========+++++++===========+++=======-:.              
         .-+++++=============+===+*.   *+=========+===============-:.          
      .=+*++====++++++++++++===+=*-   :#=+++++===+=+++++++++++++==+==-:        
    :+*++====+=++===========+++==*    :======+++==*+===========+++==++=-:      
   =*+===++==+=#.            .=*++             -*+*             .-*====++=.    
 .++==++======++    +=====:    -%.   -+=+=+-    =#=    +=====:    -*=+===++:   
 ++==+======+=*:   :#=+++=#:   .#    *+++=+*    *#.   -#=++++#.   .#=+=====+:  
:+===========+*    ++====+*    =-   :*=++=*:   :#+    ++====+*    =*=+=====+=  
:+=========+=*=    #++++++.   :#    ++===+*    =#-   :#++++++.   :*========+=  
 =+========+=*     :....    .=#=   .#=++=*=    **     :....    .=*=========+:  
  ==========++    .......:-+*+*:...+*=++=#:...-#=    .......:-+*+========++:   
   :==+===+=#:   =*+++++++++==++++++=====++++++#:   -#+++++++++==+=====++=.    
    .-===+=+*    *+=========++================+*    *+=========+====++=-:      
       :-==++---=*=+===++=====++++++=====++++=+*---=*=+=========+++==-:        
          :-=++++=+============================+++++========++====-:.          
              .:-=======+++=========================+++=======-:.              
                   .::--===============================--::.                   
                           ...:::-------------::::..                           
     

${NC}"
box_out "HoÃ n táº¥t cÃ i Ä‘áº·t LSPHP phiÃªn báº£n $php_version"

echo ""
box_out "KÃ­ch hoáº¡t LiteSpeed webserver"
systemctl enable lsws
systemctl start lsws
/usr/local/lsws/bin/lswsctrl start

firewall-cmd --zone=public --add-service=http --add-service=https --permanent
firewall-cmd --zone=public --add-port=443/udp --permanent
firewall-cmd --reload

function Post_Install_Regenerate_Webadmin_Console_Passwd() {
  Webadmin_Pass=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 36
    echo ''
  )
  id_ols_admin=$(
    date +%s | sha256sum | base64 | head -c 24
    echo
  )
  Encrypt_string=$(/usr/local/lsws/admin/fcgi-bin/admin_php -q /usr/local/lsws/admin/misc/htpasswd.php "${Webadmin_Pass}")
  echo "" >/usr/local/lsws/admin/conf/htpasswd
  echo "$id_ols_admin:$Encrypt_string" >/usr/local/lsws/admin/conf/htpasswd
  echo "tai khoan ols webgui username/password da cap nhat thanh cong!"
}
Post_Install_Regenerate_Webadmin_Console_Passwd

echo "#
# PLAIN TEXT CONFIGURATION FILE
#
#It not set, will use host name as serverName
serverName                
httpdWorkers              $cpucore
user                      nobody
group                     nobody
priority                  0
autoRestart               1
chrootPath                /
cpuAffinity               $cpucore
enableLVE                 0
inMemBufSize              60M
swappingDir               /tmp/lshttpd/swap
autoFix503                1
gracefulRestartTimeout    300
mime                      conf/mime.properties
showVersionNumber         0
adminEmails               root@localhost

errorlog logs/error.log {
  logLevel                ERROR
  debugLevel              0
  rollingSize             10M
  keepDays                30
  compressArchive         1
  enableStderrLog         0
}

accesslog logs/access.log {
  rollingSize             10M
  keepDays                10
  compressArchive         0
}

indexFiles                index.html, index.php

expires  {
  enableExpires           1
  expiresByType           image/*=A31536000, text/css=A31536000, application/x-javascript=A31536000, application/javascript=A31536000, font/*=A31536000, application/x-font-ttf=A31536000
}
autoLoadHtaccess          1

tuning  {
  maxConnections          $max_client_max
  maxSSLConnections       $max_client_max
  connTimeout             300
  maxKeepAliveReq         $max_client_max
  keepAliveTimeout        10
  sndBufSize              0
  rcvBufSize              0
  maxReqURLLen            32768
  maxReqHeaderSize        65536
  maxReqBodySize          2047M
  maxDynRespHeaderSize    32768
  maxDynRespSize          2047M
  maxCachedFileSize       4096
  totalInMemCacheSize     20M
  maxMMapFileSize         256K
  totalMMapCacheSize      40M
  useSendfile             1
  fileETag                28
  enableGzipCompress      1
  compressibleTypes       default
  enableDynGzipCompress   1
  gzipCompressLevel       2
  gzipAutoUpdateStatic    1
  gzipStaticCompressLevel 2
  brStaticCompressLevel   6
  gzipMaxFileSize         10M
  gzipMinFileSize         300

  quicEnable              1
  quicShmDir              /dev/shm
}

fileAccessControl  {
  followSymbolLink        1
  checkSymbolLink         0
  requiredPermissionMask  000
  restrictedPermissionMask 000
}

perClientConnLimit  {
  staticReqPerSec         0
  dynReqPerSec            0
  outBandwidth            0
  inBandwidth             0
  softLimit               10000
  hardLimit               10000
  gracePeriod             15
  banPeriod               300
}

CGIRLimit  {
  maxCGIInstances         20
  minUID                  11
  minGID                  10
  priority                0
  CPUSoftLimit            10
  CPUHardLimit            50
  memSoftLimit            1460M
  memHardLimit            1470M
  procSoftLimit           400
  procHardLimit           450
}

accessDenyDir  {
  dir                     /
  dir                     /etc/*
  dir                     /dev/*
  dir                     conf/*
  dir                     admin/conf/*
}

accessControl  {
  allow                   ALL
}

extprocessor lsphp {
  type                    lsapi
  address                 uds://tmp/lshttpd/lsphp.sock
  maxConns                $max_client_php
  env                     PHP_LSAPI_CHILDREN=$max_client_php
  env                     LSAPI_AVOID_FORK=200M
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      15
  respBuffer              0
  autoStart               2
  path                    /usr/local/lsws/lsphp74/bin/lsphp
  backlog                 100
  instances               1
  memSoftLimit            ${rong_ram_mb}M
  memHardLimit            ${rong_ram_mb}M
  procSoftLimit           $max_client
  procHardLimit           $max_client
}

scripthandler  {
  add                     lsapi:lsphp wordpress
}

railsDefaults  {
  maxConns                1
  env                     LSAPI_MAX_IDLE=60
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      60
  respBuffer              0
  backlog                 50
  runOnStartUp            3
  extMaxIdleTime          300
  priority                3
  memSoftLimit            2047M
  memHardLimit            2047M
  procSoftLimit           500
  procHardLimit           600
}

wsgiDefaults  {
  maxConns                5
  env                     LSAPI_MAX_IDLE=60
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      60
  respBuffer              0
  backlog                 50
  runOnStartUp            3
  extMaxIdleTime          300
  priority                3
  memSoftLimit            2047M
  memHardLimit            2047M
  procSoftLimit           500
  procHardLimit           600
}

nodeDefaults  {
  maxConns                5
  env                     LSAPI_MAX_IDLE=60
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      60
  respBuffer              0
  backlog                 50
  runOnStartUp            3
  extMaxIdleTime          300
  priority                3
  memSoftLimit            2047M
  memHardLimit            2047M
  procSoftLimit           500
  procHardLimit           600
}

module cache {
  internal                1
checkPrivateCache   1
checkPublicCache    1
maxCacheObjSize     10000000
maxStaleAge         200
qsCache             1
reqCookieCache      1
respCookieCache     1
ignoreReqCacheCtrl  1
ignoreRespCacheCtrl 0

enableCache         0
expireInSeconds     3600
enablePrivateCache  0
privateExpireInSeconds 3600
  ls_enabled              1
}

virtualhost $NAME {
  vhRoot                  /usr/local/lsws/$NAME/
  configFile              /usr/local/lsws/conf/vhosts/$NAME/$NAME.conf
  allowSymbolLink         1
  enableScript            1
  restrained              1
  maxKeepAliveReq         1000
  setUIDMode              2
  user                    $USER
  group                   $USER
}

listener http {
  address                 *:80
  secure                  0
  map                     $NAME $NAME
}

listener https {
  address                 *:443
  secure                  1
  keyFile                 /etc/letsencrypt/live/$NAME/privkey.pem
  certFile                /etc/letsencrypt/live/$NAME/cert.pem
  certChain               0
  CACertFile              /etc/letsencrypt/live/$NAME/chain.pem
  sslProtocol             24
  renegProtection         1
  sslSessionCache         1
  sslSessionTickets       1
  enableSpdy              15
  enableQuic              1
  map                     $NAME $NAME
}

vhTemplate centralConfigLog {
  templateFile            conf/templates/ccl.conf
  listeners               http
}

vhTemplate EasyRailsWithSuEXEC {
  templateFile            conf/templates/rails.conf
  listeners               http
}" >/usr/local/lsws/conf/httpd_config.conf

mkdir /usr/local/lsws/conf/vhosts/"$NAME"/
touch /usr/local/lsws/conf/vhosts/"$NAME"/"$NAME".conf

NAMEPHP=${NAME//[-._]/}

echo "docRoot                   /usr/local/lsws/$NAME/html
vhDomain                  $NAME
enableGzip                1
cgroups                   0


index  {
  useServer               0
  indexFiles              index.html index.php
  autoIndex               0
}

scripthandler  {
  add                     lsapi:$NAMEPHP php
}

accessControl  {
  allow                   *
}

lsrecaptcha  {
  enabled                 1
  type                    0
}

extprocessor $NAMEPHP {
  type                    lsapi
  address                 uds://tmp/lshttpd/$NAMEPHP.sock
  maxConns                $max_client_php
  env                     PHP_LSAPI_CHILDREN=$max_client_php
  env                     LSAPI_AVOID_FORK=200M
  initTimeout             60
  retryTimeout            0
  pcKeepAliveTimeout      25
  respBuffer              0
  autoStart               2
  path                    /usr/local/lsws/lsphp74/bin/lsphp
  backlog                 100
  instances               1
  extUser                 $USER
  extGroup                $USER
  runOnStartUp            2
  priority                0
  memSoftLimit            ${rong_ram_mb}M
  memHardLimit            ${rong_ram_mb}M
  procSoftLimit           $max_client
  procHardLimit           $max_client
}

context / {
  location                /usr/local/lsws/$NAME/html
  allowBrowse             1
  extraHeaders            <<<END_extraHeaders
X-XSS-Protection 1;mode=block
X-Frame-Options SAMEORIGIN
Referrer-Policy strict-origin-when-cross-origin
X-Content-Type-Options nosniff
X-Powered-By Litespeed
permissions-policy accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=()
  END_extraHeaders


  rewrite  {

  }
  addDefaultCharset       off

  phpIniOverride  {

  }
}

rewrite  {
  enable                  1
  autoLoadHtaccess        1
/usr/local/lsws/$NAME/html/.htaccess
}

vhssl  {
  keyFile                 /etc/letsencrypt/live/$NAME/privkey.pem
  certFile                /etc/letsencrypt/live/$NAME/cert.pem
  certChain               0
  CACertFile              /etc/letsencrypt/live/$NAME/chain.pem
  sslProtocol             24
  renegProtection         1
  sslSessionCache         1
  sslSessionTickets       1
  enableSpdy              15
  enableQuic              1
  enableStapling          1
  ocspRespMaxAge          86400
  ocspResponder           http://cert.int-x3.letsencrypt.org/
  ocspCACerts             /etc/letsencrypt/live/$NAME/chain.pem
}

module cache {
checkPrivateCache   1
checkPublicCache    1
maxCacheObjSize     10000000
maxStaleAge         200
qsCache             1
reqCookieCache      1
respCookieCache     1
ignoreReqCacheCtrl  1
ignoreRespCacheCtrl 0
storagePath /usr/local/lsws/$NAME/luucache
enableCache         0
expireInSeconds     3600
enablePrivateCache  0
privateExpireInSeconds 3600
  ls_enabled              1
}" >/usr/local/lsws/conf/vhosts/"$NAME"/"$NAME".conf

chown -R lsadm:nobody /usr/local/lsws/conf/vhosts/"$NAME"
chmod -R 750 /usr/local/lsws/conf/vhosts/"$NAME"

mkdir /usr/local/lsws/"$NAME"
mkdir /usr/local/lsws/"$NAME"/html
mkdir /usr/local/lsws/"$NAME"/backup-website
mkdir /usr/local/lsws/"$NAME"/luucache
chown -R "$USER":"$USER" /usr/local/lsws/"$NAME"/html
chown -R "$USER":"$USER" /usr/local/lsws/"$NAME"/backup-website
chmod 755 /usr/local/lsws/"$NAME"
chmod 755 /usr/local/lsws/"$NAME"/html
chmod 700 /usr/local/lsws/$NAME/backup-website

/usr/local/lsws/bin/lswsctrl restart

#add user vao Group

usermod -a -G wptangtoc-ols $USER

# khong cho login quyen tai khoan trá»±c tiáº¿p chá»‰ sá»­ dá»¥ng Ä‘á»ƒ lÃ m sá»­ dá»¥ng php exec
usermod $USER -s /sbin/nologin

if [[ $object_cache = "lsmemcached" ]];then
box_out 'Cai dat object cache LSMEMCACHED'
yum install lsphp${php_ver_chon}-pecl-memcached -y
yum groupinstall "Development Tools" -y
yum install autoconf automake zlib-devel openssl-devel expat-devel pcre-devel libmemcached-devel cyrus-sasl* -y
git clone https://github.com/litespeedtech/lsmcd.git
cd lsmcd
./fixtimestamp.sh
./configure CFLAGS=" -O3" CXXFLAGS=" -O3"
make
sudo make install
echo 'Repl.HeartBeatReq=30
Repl.HeartBeatRetry=3000
Repl.MaxTidPacket=2048000
Repl.GzipStream=YES
Repl.LbAddrs=127.0.0.1:12340
Repl.ListenSvrAddr=127.0.0.1:12340
REPL.DispatchAddr=127.0.0.1:5501
RepldSockPath=/tmp/repld.usock
CACHED.PRIADDR=127.0.0.1:11000

#CACHED.ADDR=127.0.0.1:11211
CACHED.ADDR=UDS:///tmp/lsmcd.sock
#default is 8, it can be bigger depending on cache data amount
Cached.Slices=8
Cached.Slice.Priority.0=100
Cached.Slice.Priority.1=100
Cached.Slice.Priority.2=100
Cached.Slice.Priority.3=100
Cached.Slice.Priority.4=100
Cached.Slice.Priority.5=100
Cached.Slice.Priority.6=100
Cached.Slice.Priority.7=100

Cached.ShmDir=/dev/shm/lsmcd
#If you change the UseSasl or DataByUser configuration options you need to remove the ShmDir folder and contents.
#Cached.UseSasl=true
#Cached.DataByUser=true
#Cached.Anonymous=false
#Cached.UserSize=1000
#Cached.HashSize=500000
#CACHED.MEMMAXSZ=0
#CACHED.NOMEMFAIL=false

##this is the global setting, no need to have per slice configuration. 
User=nobody
Group=nobody
#depends CPU core
CachedProcCnt=4
CachedSockPath=/tmp/cached.usock.
#TmpDir=/tmp/lsmcd
LogLevel=notice
#LogLevel=dbg_medium
LogFile=/tmp/lsmcd.log
' >/usr/local/lsmcd/conf/node.conf
echo '                               .:---::::::::::
                          .:-=+++++++=::::::::
                       .-++++++++++++*+=::::::
                    .-+++++++****++++++*+=::::
                  .=++++++#%@@@@@@%*+++++*+=::
                .=++++++*@@@%%%%%@@@%*+++++*+.
               -+++++++*@@%########@@%++++++= 
         .:::-+++++++++#@@#########%@@*+++++. 
      ::---:-++++++++++*@@%########@@@+++++:  
    :-----:-*+++++++++++#@@@%###%%@@@*++++-   
  .------:-++++++++++++++*#@@@@@@@%#+++++-    
 .----::::+++++++++*++++++++******++++++:     
.-:.     -++++++*++=--++++++++++++++++-       
.      :=****+*+=--:=+++++++++++++++=.        
     :*##%%%%%+-::-+*+++++++++++++=.          
    =##%%%%%#=::=++*+++++++++*++-.            
   :##%%%%%*--+*%%*+++++***++=-:              
   *#####%#+*#%%%%#*++++==--::-.              
   :=##%%%%%%%%%%##=:..-::----:               
    *#%%####%%%##*:   :------.                
   -###*+*####*=:    .-----:                  
    ..   :-::.      .---:.                    
                   .::.                       
'
echo "HoÃ n táº¥t cÃ i Ä‘áº·t object cache LSmemcached"
systemctl start lsmcd
systemctl enable lsmcd
/usr/local/lsmcd/bin/lsmcdctrl start
systemctl restart lsws

box_out "KÃ­ch hoáº¡t object cache LSmemcached"
fi

# cai dat memcached
if [[ $object_cache = "memcache" ]];then
box_out 'Tiáº¿n hÃ nh cÃ i Ä‘áº·t object cache memcached'
yum install memcached -y
yum install lsphp${php_ver_chon}-pecl-memcached -y

#táº¡o thÆ° má»¥c lÆ°u trá»¯ file unix stocket
mkdir -p /usr/local/lsws/memcached
chown -R memcached:memcached /usr/local/lsws/memcached

#config memcached unix socket
echo "USER=\"memcached\"
MAXCONN=\"10240\"
CACHESIZE=\"128\"
OPTIONS=\"-s '/usr/local/lsws/memcached/memcached.sock' -a 0766\"" > /etc/sysconfig/memcached

semanage permissive -a memcached_t
systemctl enable memcached.service
systemctl start memcached.service
box_out "HoÃ n táº¥t cÃ i Ä‘áº·t object memcached cache"

fi

# cai dat redis object cache
if [[ $object_cache = "redis" ]];then
box_out 'CÃ i Ä‘áº·t object cache Redis'
yum install redis -y
yum install lsphp${php_ver_chon}-pecl-redis -y
echo "unixsocket /var/run/redis/redis.sock
unixsocketperm 777
maxmemory 128mb
maxmemory-policy allkeys-lru" >> /etc/redis.conf
mkdir -p /var/run/redis
chmod 700 /var/lib/redis
chown redis:redis /var/run/redis
chown redis:redis /etc/redis.conf
chmod 600 /etc/redis.conf
echo '                               .:---::::::::::
                          .:-=+++++++=::::::::
                       .-++++++++++++*+=::::::
                    .-+++++++****++++++*+=::::
                  .=++++++#%@@@@@@%*+++++*+=::
                .=++++++*@@@%%%%%@@@%*+++++*+.
               -+++++++*@@%########@@%++++++= 
         .:::-+++++++++#@@#########%@@*+++++. 
      ::---:-++++++++++*@@%########@@@+++++:  
    :-----:-*+++++++++++#@@@%###%%@@@*++++-   
  .------:-++++++++++++++*#@@@@@@@%#+++++-    
 .----::::+++++++++*++++++++******++++++:     
.-:.     -++++++*++=--++++++++++++++++-       
.      :=****+*+=--:=+++++++++++++++=.        
     :*##%%%%%+-::-+*+++++++++++++=.          
    =##%%%%%#=::=++*+++++++++*++-.            
   :##%%%%%*--+*%%*+++++***++=-:              
   *#####%#+*#%%%%#*++++==--::-.              
   :=##%%%%%%%%%%##=:..-::----:               
    *#%%####%%%##*:   :------.                
   -###*+*####*=:    .-----:                  
    ..   :-::.      .---:.                    
                   .::.                       
'

sed -i 's/tcp-keepalive 300/tcp-keepalive 0/g' /etc/redis.conf
sed -i 's/rdbcompression yes/rdbcompression no/g' /etc/redis.conf
sed -i 's/rdbchecksum yes/rdbchecksum no/g' /etc/redis.conf

box_out "HoÃ n táº¥t cÃ i Ä‘áº·t object Redis cache"
systemctl enable redis.service
systemctl start redis.service
fi


# set thoi gian ve viet nam
timedatectl set-timezone Asia/Ho_Chi_Minh


# set cau hinh maria database
max_conect_db=$(expr $max_client / 8 )

max_connections=$(expr 64 \* ${tong_ram_gb})

#cau hinh query cache set up optimize
if (( $cpucore > 2 ));then
query_cache_type=0
query_cache_size=0
else
query_cache_type=1
query_cache_size='50M'
fi

if [[ $query_cache_type = '' ]];then
query_cache_type=0
query_cache_size=0
fi


# set gia tri mini tá»‘i Æ°u cho server ram nhá» dÆ°á»›i 1GB
if (( $rong_ram_mb  < 1024 ));then
tong_ram_mb_db=48
buffer_db=32
db_table_size=32
max_connections=300
fi


echo "key_buffer_size = ${buffer_db}M
table_cache = 2000
innodb_buffer_pool_size = ${tong_ram_mb_db}M
max_connections = $max_connections
query_cache_type = $query_cache_type
query_cache_limit = 2M
query_cache_min_res_unit = 2k
query_cache_size = $query_cache_size
tmp_table_size = ${db_table_size}M
max_heap_table_size = ${db_table_size}M
thread_cache_size = 81
max_allowed_packet = 64M
wait_timeout=60" >>/etc/my.cnf.d/server.cnf
sed -i '/\[mysqld\]/a skip-log-bin' /etc/my.cnf.d/server.cnf

systemctl restart mariadb.service

# set cau hinh opcache
echo '
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=100
opcache.fast_shutdown=1
opcache.enable_cli=1' >>/usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini

sed -i '/realpath_cache_size/d' /usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini
sed -i '/realpath_cache_ttl/d' /usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini
echo 'realpath_cache_size = 1M
realpath_cache_ttl = 300' >> /usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini

sed -i "s/expose_php = On/expose_php = off/g" /usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 8M/g" /usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 120/g" /usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini

sed -E -i "s/lsphp[0-9]+/lsphp$php_ver_chon/g" /usr/local/lsws/conf/httpd_config.conf
sed -E -i "s/lsphp[0-9]+/lsphp$php_ver_chon/g" /usr/local/lsws/conf/vhosts/"$NAME"/"$NAME".conf

# cai dat menu wptangtoc ols root
cd
wget http://wptangtoc.com/share/wptangtoc-ols.zip --no-check-certificate
#link du phong
if [[ ! -f wptangtoc-ols.zip ]];then
wget https://github.com/wptangtoc/wptangtoc-ols/raw/main/wptangtoc-ols.zip
fi

#phan quyen thu muc wptangtoc-ols
unzip -oq wptangtoc-ols.zip
mv tool-wptangtoc-ols/* /etc/wptt/
chmod -R 700 /etc/wptt
chown root:wptangtoc-ols /etc/wptt
chown root:wptangtoc-ols /etc/wptt/vhost
chmod 750 /etc/wptt
chmod 750 /etc/wptt/vhost


# cai dat menu wptangtoc ols user
cd
wget http://wptangtoc.com/share/wptangtoc-ols-user.zip --no-check-certificate
#link du phong
if [[ ! -f wptangtoc-ols-user.zip ]];then
wget https://github.com/wptangtoc/wptangtoc-ols/raw/main/wptangtoc-ols-user.zip
fi
unzip -oq wptangtoc-ols-user.zip
mv tool-wptangtoc-ols-user/* /etc/wptt-user/
chown -R root:wptangtoc-ols /etc/wptt-user
chmod -R 750 /etc/wptt-user


cat <(crontab -l) <(echo '0 0,12 * * * /usr/bin/certbot renew --quiet') | crontab -
cat <(crontab -l) <(echo '10 0 * * * /etc/wptt/ssl/auto-reset-ssl >/dev/null 2>&1') | crontab -
cat <(crontab -l) <(echo '*/3 * * * * if ! find /usr/local/lsws/*/html/ -maxdepth 2 -type f -newer /usr/local/lsws/cgid -name '.htaccess' -exec false {} +; then /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1; fi') | crontab -

if [[ "$wordpress" = "1" ]];then
echo "Gia Tuan"
else
cat <(crontab -l) <(echo '*/6 * * * * if ! find /usr/local/lsws/*/html/ -maxdepth 2 -type f -newer /usr/local/lsws/cgid -name 'wp-config.php' -exec false {} +; then /etc/wptt/wptt-phan-quyen-all >/dev/null 2>&1; fi') | crontab -
fi

service crond restart

#thiet lap tuc dong cron check version

if [[ -f /usr/bin/shuf ]];then
gio=$(shuf -i0-7 -n1)
gio2=$(shuf -i8-15 -n1)
gio3=$(shuf -i16-23 -n1)

if [[ $gio ]];then
	while [ $gio = $gio2 ] || [ $gio = $gio3 ] || [ $gio3 = $gio2 ];do
		gio=$(shuf -i0-7 -n1)
		gio2=$(shuf -i8-15 -n1)
		gio3=$(shuf -i16-23 -n1)
	done
fi

phut=$(shuf -i0-59 -n1)

fi


if [[ $gio = '' || $gio2 = '' || $gio3 = '' || $phut = '' ]];then
	gio='0'
	gio2='8'
	gio3='16'
	phut='30'
fi

cat >"/etc/cron.d/check-version-wptangtoc-ols.cron" <<END
$phut $gio,$gio2,$gio3 * * * root /etc/wptt/update/wptt-check-cron-version-update 
END

systemctl restart crond.service

touch /usr/local/lsws/"$NAME"/html/.htaccess

echo '
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress' > /usr/local/lsws/"$NAME"/html/.htaccess

chown $USER:$USER /usr/local/lsws/"$NAME"/html/.htaccess
if [[ -f /usr/local/lsws/$NAME/html/index.html ]];then
sed -i "s/domain.com/$NAME/g" /usr/local/lsws/"$NAME"/html/index.html
chown $USER:$USER /usr/local/lsws/"$NAME"/html/index.html
chown 644 /usr/local/lsws/"$NAME"/html/index.html
fi

ip=$(curl -s myip.directadmin.com)
if [[ "$ip" = "" ]]; then
  ip=$(curl -s ifconfig.me)
fi

name_db=${NAME//[-._]/}
ramdom_db=$(
  date +%s | sha256sum | base64 | head -c 18
  echo
)
sleep 2
database123=${name_db}_${ramdom_db}_dbname
username123=${name_db}_${ramdom_db}_username
password123=$(
  date +%s | sha256sum | base64 | head -c 36
  echo
)

echo "Äang tiáº¿n hÃ nh thÃªm database má»›i cho website $NAME..."
mysql -u wordpressadmin -p"$db_root_password" -e "CREATE DATABASE IF NOT EXISTS ${database123}"
mysql -u wordpressadmin -p"$db_root_password" -e "CREATE USER IF NOT EXISTS '${username123}'@'localhost' IDENTIFIED BY '${password123}'"
mysql -u wordpressadmin -p"$db_root_password" -e "GRANT ALL PRIVILEGES ON ${database123}.* TO '${username123}'@'localhost' WITH GRANT OPTION"
mysql -u wordpressadmin -p"$db_root_password" -e "FLUSH PRIVILEGES"
clear
box_out "Da them databse danh cho $NAME thanh cong"

if [ "$port_ssh" = '' ]; then
  port_ssh=22
fi

if (( "$port_ssh" > 40000 )); then
echo "port ssh ban muon chuyen > 40000 he thong khong cho phep doi"
  port_ssh=22
fi

echo "Xac nhan port_ssh la: $port_ssh"

if [[ "$port_ssh" != "22" ]]; then
yum -y install policycoreutils-python
  sed -i "/Port/d" /etc/ssh/sshd_config
  sed -i "1 i Port $port_ssh" /etc/ssh/sshd_config
semanage port -a -t ssh_port_t -p tcp $port_ssh
  systemctl reload sshd.service
fi

port_ssh=$(cat /etc/ssh/sshd_config | grep "Port " | cut -f2 -d" ")
if [[ $port_ssh = "" ]];then
port_ssh=22
fi

firewall-cmd --zone=public --add-port=${port_ssh}/tcp --permanent
firewall-cmd --reload

touch /usr/local/lsws/conf/disablewebconsole

yum install fail2ban fail2ban-systemd fail2ban-firewalld -y

cp -pf /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
cat >"/etc/fail2ban/jail.d/sshd.local" <<END
[sshd]
enabled = true
port = ${port_ssh}
logpath = %(sshd_log)s
maxretry = 5
bantime = 3600
END

sed -i "/Subsystem/d" /etc/ssh/sshd_config
# cat >>"/etc/ssh/sshd_config" <<END
# Subsystem sftp internal-sftp
# END

echo 'Subsystem sftp internal-sftp' >> /etc/ssh/sshd_config

systemctl enable fail2ban
systemctl start fail2ban

# cai dat wp cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#cai dat wp cli tuong thich vá»›i aws amazon, tÃ¡i táº¡o biáº¿n mÃ´i trÆ°á»ng
if [[ ! $(which wp) ]];then
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp
fi


sed -i "s/7080/19019/g" /usr/local/lsws/admin/conf/admin_config.conf
/usr/local/lsws/bin/lswsctrl restart

swapoff -a -v
rm -rf /var/swap.1
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1
sed -i '/swap.1/d' /etc/fstab
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo '/var/swap.1 none swap defaults 0 0' >>/etc/fstab

echo '[litespeed]
name=LiteSpeed Tech Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/centos/$releasever/$basearch/
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed

[litespeed-update]
name=LiteSpeed Tech Update Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/centos/$releasever/update/$basearch/
failovermethod=priority
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed

[litespeed-edge]
name=LiteSpeed Tech Edge Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/edge/centos/$releasever/$basearch/
failovermethod=priority
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed

[litespeed-edge-update]
name=LiteSpeed Tech Edge Update Repository for CentOS $releasever - $basearch
baseurl=http://rpms.litespeedtech.com/edge/centos/$releasever/update/$basearch/
failovermethod=priority
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-litespeed
' >/etc/yum.repos.d/litespeed.repo

mkdir -p /wptangtoc-ols

thoi_gian_cai_dat_phan_mem=$(date +%d"-"%m"-"%Y)

## lÆ°u file cáº¥u hÃ¬nh
echo "port_ssh=$port_ssh
database_admin_username=wordpressadmin
database_admin_password=$db_root_password
Ten_dang_nhap_ols_webgui=$id_ols_admin
Password_OLS_webgui=$Webadmin_Pass
version_wptangtoc_ols=$wptangtocols_version
php_version_check=$php_version
Website_chinh=$NAME
thoi_gian_cai_dat_phan_mem=$thoi_gian_cai_dat_phan_mem" >/etc/wptt/.wptt.conf


touch /etc/wptt/vhost/."$NAME".conf


echo "Website_main=$NAME
DB_Name_web=$database123
DB_User_web=$username123
DB_Password_web=$password123
Duong_Dan_thu_muc_web=/usr/local/lsws/$NAME/html
User_name_vhost=$USER
phien_ban_php_domain=$php_version
" >/etc/wptt/vhost/.$NAME.conf

chown $USER:$USER /etc/wptt/vhost/.$NAME.conf

#add alias root

#tuong thich rsync voi .bashrc

echo '[[ $- != *i* ]] && return' >> /root/.bashrc
echo ". /etc/wptt/wptt-status" >>/root/.bashrc
echo ". /etc/wptt/wptt-check" >>/root/.bashrc


if [[ $1 != 1 ]];then
echo "cd /wptangtoc-ols" >>/root/.bashrc
fi

echo "alias 1='wptangtoc'" >>/root/.bashrc
echo "alias 11='wptangtoc'" >>/root/.bashrc
echo "alias 99='. /etc/wptt/wptt-update'" >>/root/.bashrc
echo "alias 999='. /etc/wptt/wptt-update2'" >>/root/.bashrc

#add alias user
# echo '[[ $- != *i* ]] && return' >> /home/$USER/.bashrc
# echo ". /etc/wptt-user/wptt-status" >> /home/$USER/.bashrc
# echo "alias 1='wptangtoc-user'" >> /home/$USER/.bashrc
# echo "alias 11='wptangtoc-user'" >> /home/$USER/.bashrc

echo '[[ $- != *i* ]] && return' >> /usr/local/lsws/$NAME/.bashrc
echo ". /etc/wptt-user/wptt-status" >> /usr/local/lsws/$NAME/.bashrc
echo "alias 1='wptangtoc-user'" >> /usr/local/lsws/$NAME/.bashrc
echo "alias 11='wptangtoc-user'" >> /usr/local/lsws/$NAME/.bashrc


mkdir -p /usr/local/backup-website
mkdir -p /usr/local/backup-website/"$NAME"
chmod 700 /usr/local/backup-website/"$NAME"

mkdir -p /wptangtoc-ols/"$NAME"
mkdir -p /wptangtoc-ols/"$NAME"/backup-website
ln -s /usr/local/lsws/"$NAME"/html /wptangtoc-ols/"$NAME"
ln -s /usr/local/backup-website/"$NAME"/ /wptangtoc-ols/"$NAME"/backup-website


#tao anh xa
ln -s /usr/local/lsws/$NAME /home/$NAME


#tao anh xa username
# mkdir -p /home/$USER/$NAME
# ln -s /usr/local/lsws/$NAME/html /home/$USER/$NAME/public_html
# ln -s /usr/local/lsws/$NAME/backup-website /home/$USER/$NAME/backup-website


mv /etc/wptt/wptangtoc /usr/bin
mv /etc/wptt/wptt /usr/bin
mv /etc/wptt-user/wptangtoc-user /usr/bin
chown root:wptangtoc-ols /usr/bin/wptangtoc-user
chmod 750 /usr/bin/wptangtoc-user

systemctl daemon-reload

if [[ $wordpress = '1' ]];then
echo 'wptangtoc_ols_giatuan=1' >> /etc/wptt/.wptt.conf

echo '
opcache.validate_timestamps=0
opcache.file_update_protection=0' >>/usr/local/lsws/lsphp${php_ver_chon}/etc/php.ini
yum install vim pigz -y
sed -i '/totalInMemCacheSize/d' /usr/local/lsws/conf/httpd_config.conf
sed -i '/maxCachedFileSize/a  	totalInMemCacheSize 	   64M' /usr/local/lsws/conf/httpd_config.conf

fi

if [[ "$wordpress" = "wp" ]]; then
blue='\033[1;34m'
NC='\033[0m'
echo -e "${blue}               ...:..........:...              
           .:..      ....      ..:.           
        .:.   .::------------::.   .:.        
      ::.  .:---------------------:  .::      
    .:.  :------------------------.    .:.    
   ::  :-------------------------        ::   
  ::       . .--:.        . :----         ::  
 ::        :-------:      -------:      .  :: 
 -  -:      --------:      --------     :-  - 
:. .--.     .--------.     .-------:    --. .:
-  :---      :--------      --------.  .--:  -
-  :----      --------       -------   ---:  -
-  :----:     .------. .     .------  ----:  -
:. .-----.     :----- .-      -----. :----. .:
 -  :-----      ----  ---      ---: .----:  - 
 ::  -----:     .--. ----:     .--  -----  :: 
  ::  -----:     :- .-----.     -. :----  ::  
   ::  :----.       -------       .---:  ::   
    .:.  :---      --------:      --:  .:.    
      ::.  .-:    :---------:    :.  .::      
        .:.       -----------      .:.        
           .:...     ....     ...:.           
              ...:..........:...     ${NC}"
  cd /usr/local/lsws/"$NAME"/html/
  rm -rf /usr/local/lsws/"$NAME"/html/*
  echo "tien hanh tai ma nguon WordPress"
  wget http://wordpress.org/latest.tar.gz
  tar -zxvf latest.tar.gz
  mv wordpress/* /usr/local/lsws/"$NAME"/html && rm -rf wordpress && rm -f latest.tar.gz
  if [[ "$dongyconfig" = "y" ]]; then
    wp core config --dbname="$database123" --dbuser="$username123" --dbpass="$password123" --dbhost=localhost --dbprefix="${tien_to_db}"_ --allow-root --extra-php <<PHP
define( 'WP_DEBUG_LOG', false );
PHP
    echo "Dang cau hinh wp-config cho website $NAME"
    wp core install --url=http://"${NAME}" --title="$SiteTitle" --admin_user="$idusername" --admin_password="$mypassword" --admin_email="$emailwp" --allow-root >/dev/null 2>&1
    wp language core install vi --path=/usr/local/lsws/"$NAME"/html --activate --allow-root
    wp option update timezone_string "Asia/Ho_Chi_Minh" --path=/usr/local/lsws/"$NAME"/html --allow-root
    wp rewrite structure '/%postname%/' --path=/usr/local/lsws/"$NAME"/html --allow-root
    else
    cp -f /etc/wptt/index.html /usr/local/lsws/$NAME/html
	sed -i "s/domain.com/$NAME/g" /usr/local/lsws/$NAME/html/index.html
  fi

echo '# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteRule .* - [E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress' > /usr/local/lsws/"$NAME"/html/.htaccess

  chown -R "$USER":"$USER" /usr/local/lsws/"$NAME"/html
  /usr/local/lsws/bin/lswsctrl restart >/dev/null 2>&1
  cd
  echo "HoÃ n táº¥t cÃ i Ä‘áº·t mÃ£ nguá»“n WordPress cho website $NAME"
fi


echo "$wptangtocols_version" > /tmp/wptangtoc-ols-version-main


Caidat_Time="$((Time_Count / 3600)) gio $(((SECONDS / 60) % 60)) phut $((Time_Count % 60)) giay"
clear
RED='\033[0;31m'
NC='\033[0m'
port_checkssh_status=$(cat /etc/ssh/sshd_config | grep "Port " | cut -f2 -d" ")
echo -e "${RED}
     .:..........................             
      .::::::::::::::::::::::::::::..         
        ..:::::::::::::::::::::::::::::.      
                             ...:::::::::.    
                                  .:::::::.   
          .:::::::.         .       .:::::::  
         .::::::::::::::::::::..      ::::::: 
         ::::::::::::::::::::::::.     ::::::.
        .::::::::::::::::::::::::::.   .:::::.
        .::::::::::::::::::::::::::::  .:::::.
        .::::::::::::::::::::::::::.   .:::::.
         ::::::::::::::::::::::::.     ::::::.
.::::::  .:::::::::::::::::::::.      ::::::. 
          .:::::::.                 .:::::::  
       ::::::::::::.              .:::::::.   
       ......:::::::::...    ...:::::::::.    
               .:::::::::::::::::::::::.      
   ..............::::::::::::::::::..         
  .:::::::::::::................. ${NC}"

echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo -e "${RED}-------------------------------------------------------------------------"
echo "  	     Cai dat thanh cong WPTangToc OLS $wptangtocols_version	"
echo "-------------------------------------------------------------------------"
echo -e "--------------------------------------------------------------------------${NC}"
echo "Disk			: $(df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}')                        "
echo "RAM			: $(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')                         "
echo "Tong thoi gian cai dat	: $Caidat_Time               			 "
echo "-------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------"
echo "              Luu lai thong tin ben duoi de truy cap ve sau              "
echo "-------------------------------------------------------------------------"
echo "1.Port SSH                            : $port_checkssh_status                                             		  "
echo "2.Truy cap ssh tren terminal          : ssh -p $port_checkssh_status $check_root@$ip             	 "
echo "3.Truy cap sftp tren terminal         : sftp -oPort=$port_checkssh_status $check_root@$ip             	 "
echo "4.password database                   : $db_root_password                			 "
echo "5.login maria database                : mysql -u wordpressadmin -p$db_root_password                	"
echo "6.Ten dang nhap OLS webgui            : $id_ols_admin                        		   "
echo "7.Password OLS webgui                 : $Webadmin_Pass                    	        	 "
echo "8.Thu muc website                     : /usr/local/lsws/$NAME/html             	 "
echo "9.Thu muc website rut gon             : /wptangtoc-ols/$NAME             	 "
echo "10.Xem moi thong tin tai khoan lenh   : wptt taikhoan       	 "
echo "-------------------------------------------------------------------------"
echo "De goi menu cac cong cu WPTangToc OLS hay an phim: 1  		        	 "
echo "Thá»±c thi lá»‡nh khÃ´ng cáº§n vÃ o menu thÃ¬ gÃµ lá»‡nh: wptt    		        	 "
echo "-------------------------------------------------------------------------"
echo "Thong tin database tao danh cho website $NAME"
echo "1.DB_Name			: $database123                                               	 "
echo "2.DB_User			: $username123                                               	 "
echo "3.DB_Password			: $password123      			"
echo "-------------------------------------------------------------------------"
echo "Cong cu WPTangToc OLS phat trien boi: Gia Tuan"
echo "Yeu Cau Ho tro		: https://wptangtoc.com/lien-he/"
echo "Giup chung toi luon giu WPTangToc OLS co the su dung mien phi bang cach dong gop vao"
echo "Tai tro phat trien	: https://wptangtoc.com/donate/"
echo "Huong dan		: https://wptangtoc.com/wptangtoc-ols-huong-dan"
echo "-------------------------------------------------------------------------"
echo "Dang kiem tra he thong cua ban..."
sleep 1

if [[ ! -d /var/lib/mysql ]]; then
  echo "ThÃ´ng bÃ¡o lá»—i"
  echo "Báº¡n chÆ°a cÃ i Ä‘áº·t maria database"
fi

if [[ ! -d /usr/local/lsws ]]; then
  echo "ÄÃ£ cÃ³ váº¥n Ä‘á» xáº£y ra báº¡n chÆ°a cÃ i Ä‘Æ°á»£c Ä‘Æ°á»£c LiteSpeed webserver..."
  echo "Vui lÃ²ng thá»­ láº¡i sau"
  echo "NguyÃªn nhÃ¢n lá»—i: lÃ  mÃ¡y chá»§ repo LiteSpeed Ä‘Ã£ gáº·p sá»± cá»‘ trong lÃºc báº¡n cÃ i Ä‘áº·t WPTangToc OLS"
  echo "VÃ¬ váº­y báº¡n hÃ£y thá»­ cÃ i láº¡i trong thá»i gian sau khi mÃ¡y chá»§ LiteSpeed khÃ´i phá»¥c láº¡i Ä‘Æ°á»£c"
fi

if [[ -d /usr/local/lsws ]]; then
  checkhoatdong=$(curl -Is "$ip" | head -n 1 | grep -c "404")
  if [[ "$checkhoatdong" = "0" ]]; then
    echo "ThÃ´ng bÃ¡o Ä‘Ã£ cÃ³ váº¥n Ä‘á» xáº£y ra"
vang='\033[1;33m'
NC='\033[0m'
echo -e "${vang}                                              
                   .:::....                   
                 .--=+++=-::.                 
                :--*%%%%%%+::.                
               :--*%%%%%%%%*:::               
              ---#%%%%%#%%%%*:::              
            .--=#%%%#=--=#%%%#-::             
           .--=%%%%%*:-:.*%%%%#-::.           
          .--+%%%%%%*---:*%%%%%#=::.          
         :--*%%%%%%%*--::*%%%%%%#+::.         
        :--*%%%%%%%%*--::*%%%%%%%#+:::        
       ---#%%%%%%%%%*--::*%%%%%%%%#*:::       
      --=#%%%%%%%%%%*---:*%%%%%%%%%#*-::      
    .--=%%%%%%%%%%%%#--::#%%%%%%%%%%##-::     
   .--+%%%%%%%%%%%%%%#*+#%%%%%%%%%%%%##=::.   
  :--+%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##=::.  
 :--*%%%%%%%%%%%%%%%#=-:-#%%%%%%%%%%%%%##+::. 
:--*%%%%%%%%%%%%%%%%#--::#%%%%%%%%%%%%%%##+::.
--=%%%%%%%%%%%%%%%%%%%##%%%%%%%%%%%%%%%%###-::
:--*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##+::.
 :--=++***************++++++++++++++++++=-::. 
   .:::::::::::::::::::....................  
${NC}"
    echo "Há»‡ thá»‘ng xÃ¡c nháº­n ráº±ng: mÃ¡y chá»§ cá»§a báº¡n chÆ°a Ä‘Æ°á»£c kÃ­ch hoáº¡t má»Ÿ port máº¡ng cÃ³ váº¥n Ä‘á» vá» tÆ°á»ng lá»­a firewall"
    echo "Báº¡n khÃ´ng thá»ƒ sá»­ dá»¥ng tÆ°á»Ÿng lá»«a firewall kÃ­ch hoáº¡t tá»« terminal ssh, cÃ³ thá»ƒ há»‡ thá»‘ng cá»§a báº¡n sá»­ dá»¥ng firewal cloud hÃ£y má»Ÿ firewall cloud tá»« nhÃ  cung cáº¥p dá»‹ch vá»¥ mÃ¡y chá»§"
    echo "Báº¡n hÃ£y tá»± má»Ÿ port 80 vÃ  port 443 trong trang quáº£n lÃ½ mÃ¡y chá»§ cá»§a nhÃ  cung cáº¥p dá»‹ch vá»¥ VPS,mÃ¡y chá»§ Ä‘á»ƒ cÃ³ thá»ƒ sá»­ dá»¥ng Ä‘Æ°á»£c wptangtoc ols"
    echo "-------------------------------------------------------------------------"
    echo "webserver sáº½ khá»Ÿi Ä‘á»™ng láº¡i."
  else
    box_out "ÄÃ£ kiáº¿m tra há»‡ thá»‘ng cá»§a báº¡n má»i thá»© hoáº¡t Ä‘á»™ng tá»‘t" "CÃ i Ä‘áº·t thÃ nh cÃ´ng WPTangToc OLS $wptangtocols_version" "" "Há»‡ thá»‘ng sáº½ khá»Ÿi Ä‘á»™ng láº¡i vÃ  táº­n hÆ°á»Ÿng"
  fi
fi

sleep 2
cd && rm -f wptangtoc-ols.zip
cd && rm -f wptangtoc-ols-user.zip
cd && rm -rf tool-wptangtoc-ols
cd && rm -rf tool-wptangtoc-ols-user
cd && rm -f wptangtoc-ols
reboot
1
