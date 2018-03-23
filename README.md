# MySQL Database, User/Password Creator

This Script helps you to create MySQL database, user & password with just one command.


## INSTALL
To install, simply download the script file and give it the executable permission.
```
curl -O mysql-db-user-creator.sh https://raw.githubusercontent.com/MagePsycho/mysql-user-db-creator-bash-script/master/src/mysql-db-user-creator.sh
chmod +x mysql-db-user-creator.sh
```

To make it system wide command
```
sudo mv mysql-db-user-creator.sh /usr/local/bin/mysql-db-user-creator
```

## USAGE
### To display help
```
sudo ./mysql-db-user-creator.sh --help
```

In General, basic usage
```
./mysql-db-user-creator.sh [--host="<host-name>"] --database="<db-name>" [--user="<db-user>"] [--pass="<user-password>"]
```
**Notes**:  
- The only required parameter is `database` name. 
- In the case of empty values for other parameters:
    - `host` becomes localhost
    - `user` takes value from database name
    - `password` is randomly generated

### To Create Db along with User/Pass (By passing all parameters explicitly)
```
./mysql-db-user-creator.sh --host=192.168.1.55 --database=new-db-name --user=new-user --pass=some-random-pass
```

### To Create Db along with User/Pass (By passing only required parameter)
```
./mysql-create-db-user.sh --database=bash_db2
```
**Notes**  
In this case MySQL connector user/pass will be taken from the config file `~/.my.cnf`

The command will output as:

![MySQL DB, User/Password Creator Result](https://github.com/MagePsycho/mysql-user-db-creator-bash-script/raw/master/docs/mysql-user-db-creator-bash-script-result.png "Nginx Virtual Host Creator Result")
Screentshot - MySQL DB, User/Password Creator Result