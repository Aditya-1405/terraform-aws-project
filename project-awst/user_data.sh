#!/bin/bash
sudo apt install apache2 unzip -y
sudo wget "https://www.tooplate.com/zip-templates/2137_barista_cafe.zip"
sudo unzip 2137_barista_cafe.zip
sudo mv 2137_barista_cafe/* /var/www/html/
sudo systemctl enable apache2
sudo systemctl start apache2