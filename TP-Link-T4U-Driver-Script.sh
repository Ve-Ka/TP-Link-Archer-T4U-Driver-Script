echo _________________________________
echo Download of wifi driver rtl8822bu
echo _________________________________


function update_pi ()
{
  sudo apt-get update
  sudo apt-get upgrade
  #sudo apt full-upgrade
}


function install_lshw_nload ()
{
  sudo apt-get install lshw
  sudo apt-get install nload
}


function install_rtl8822bu ()
{
  sudo apt install git dkms build-essential 
  cd /home/pi/Downloads/ 
  git clone https://github.com/jeremyb31/rtl8822bu.git
  sudo dkms add ./rtl8822bu
  sudo dkms install 8822bu/1.1
  cd /home/pi/Downloads/rtl8822bu
  sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile 
  sed -i 's/CONFIG_PLATFORM_ARM_RPI = n/CONFIG_PLATFORM_ARM_RPI = y/g' Makefile
  sudo make
  sudo make install
  cd /home/pi/Downloads
  sudo rm -rf rtl8822bu
}


function install_network_manager ()
{
  sudo apt-get install network-manager network-manager-gnome
  sudo sysremctl stop dhcpcd.service
  sudo systemctl disable dhcpcd.service
  sudo systemctl enable NetworkManager.service
  sudo systemctl start NetworkManager.service
}


while true ; do
  echo
  echo Menu
  echo 1. update pi
  echo 2. install lshw and nload
  echo 3. install rtl8822bu
  echo 4. install network manager
  echo 5. exit

  read -p "Choice: " choice
  echo

  if [ "$choice" == "1" ]; then
    update_pi

  elif [ "$choice" == "2" ]; then
    install_lshw_nload
  
  elif [ "$choice" == "3" ]; then
    install_rtl8822bu

  elif [ "$choice" == "4" ]; then
    install_network_manager  

  elif [ "$choice" == "5" ]; then
    echo programme exiting...
    echo
    break

  fi
  echo
  echo DONE
  echo
done


while true ; do
  read -p "Reboot? [y/n]: " reboot
  if [ "$reboot" == "y" ]; then
    sudo reboot	
  elif [ "$reboot" == "n" ]; then
    exit
  fi  
done	
