#!/bin/bash
echo '== 1. Install ords'
sudo yum install ords -y
echo '== 2. Install sqlcl'
sudo yum install sqlcl -y
echo '== 3. Verify ords and sqlcl'
#sudo yum info ords
#sudo yum info sqlcl
echo '== 4. Open Firewall and starting HTTPD'
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload
echo '== 5. Move Wallet*.zip to oracle account and change ownership'
sudo mv /home/opc/${ATP_tde_wallet_zip_file} /home/oracle/${ATP_tde_wallet_zip_file}
sudo chown oracle:oinstall /home/oracle/${ATP_tde_wallet_zip_file}
echo '== 6. Move ords_config.zip to oracle account, change ownership to oracle and unzip'
sudo mv /home/opc/ords_conf.zip /opt/oracle/ords/
sudo chown oracle:oinstall /opt/oracle/ords/ords_conf.zip
sudo su - oracle -c 'unzip -q /opt/oracle/ords/ords_conf.zip -d /opt/oracle/ords/'
echo '== 7. configdir for ords'
sudo su - oracle -c 'java -jar /opt/oracle/ords/ords.war configdir /opt/oracle/ords/conf'
echo '== 8. create ords/rest data user'
sudo sed -i s/{password}/${ATP_password}/g /home/opc/create_ord_user.sql
sudo mv /home/opc/create_ord_user.sql /home/oracle/create_ord_user.sql
sudo chown oracle:oinstall /home/oracle/create_ord_user.sql
sudo su - oracle -c 'sql -cloudconfig /home/oracle/${ATP_tde_wallet_zip_file} admin/${ATP_password}@${ATP_database_db_name}_high @/home/oracle/create_ord_user.sql'
echo '== 9. create rest data by connecting TOSSBRINK'
sudo mv /home/opc/create_data_for_rest.sql /home/oracle/create_data_for_rest.sql
sudo chown oracle:oinstall /home/oracle/create_data_for_rest.sql
sudo su - oracle -c 'sql -cloudconfig /home/oracle/${ATP_tde_wallet_zip_file} TOSSBRINK/${ATP_password}@${ATP_database_db_name}_high @/home/oracle/create_data_for_rest.sql'
echo '== 10. Start rest service'
sudo sed -i s/{password}/${ATP_password}/g /home/oracle/apex_pu.xml
sudo sed -i s/{wallet_file}/${ATP_tde_wallet_zip_file}/g /home/oracle/apex_pu.xml
sudo sed -i s/{db_name}/${ATP_database_db_name}/g /home/oracle/apex_pu.xml
sudo mv /home/opc/apex_pu.xml /home/oracle/apex_pu.xml
sudo chown oracle:oinstall /home/oracle/apex_pu.xml
sudo su - oracle -c 'mv /home/oracle/apex_pu.xml /opt/oracle/ords/conf/ords/conf/apex_pu.xml'
#sudo su - oracle -c 'java -jar -Duser.timezone=UTC /opt/oracle/ords/ords.war standalone &' >> /home/opc/ords-'date +"%Y""%m""%d"'.log 


Config:SQL Client
sudo yum info oracle-instantclient18.3-basic
sudo yum install oracle-instantclient18.3-basic -y
sudo yum info oracle-instantclient18.3-sqlplus
sudo yum install oracle-instantclient18.3-sqlplus -y