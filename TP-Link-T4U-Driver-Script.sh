echo _________________________________
echo Download of wifi driver rtl8822bu
echo _________________________________


function update_pi ()
{
  sudo apt-get update
  sudo apt-get upgrade
}


function install_lshw ()
{
  sudo apt-get install lshw
}


function update_dkms_with_driver ()
{
  sudo apt install git dkms build-essential
  sudo dkms add ./rtl8822bu
  sudo dkms install 8822bu/1.1 
}


function install_rtl8822bu ()
{
  cd /home/pi/Downloads/
  git clone https://github.com/jeremyb31/rtl8822bu.git
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
  sudo enable NetworkManager.service
  sudo start NetworkManager.service
}


while true ; do
  echo
  echo Menu
  echo 1. update pi
  echo 2. install lshw
  echo 3. update dkms with rtl8822bu
  echo 4. install rtl8822bu 
  echo 5. install network manager
  echo 6. execute all above
  echo e. exit

  read -p "Choice: " choice
  echo

  if [ "$choice" == "1" ]; then
    update_pi

  elif [ "$choice" == "2" ]; then
    install_lshw

  elif [ "$choice" == "3" ]; then
    update_dkms_with_driver

  elif [ "$choice" == "4" ]; then
    install_rtl8822bu

  elif [ "$choice" == "5" ]; then
    install_network_manager 

  elif [ "$choice" == "6" ]; then
    update_pi
    install_lshw
    update_dkms_with_driver
    install_rtl8822bu
    install_network_manager 

  elif [ "$choice" == "e" ]; then
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
