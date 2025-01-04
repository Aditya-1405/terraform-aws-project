#!/bin/bash
sudo apt install apache2 unzip -y
sudo wget "https://www.tooplate.com/zip-templates/2130_waso_strategy.zip"
sudo unzip 2130_waso_strategy.zip
sudo mv 2130_waso_strategy/* /var/www/html/
sudo systemctl enable apache2
sudo systemctl start apache2