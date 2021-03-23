# MySQL Database, User/Password Creator

This Script helps you to create a new MySQL database with specific user & password with just a single command.


## INSTALL
To install, simply download the script file and give it the executable permission.
```
curl -0 https://raw.githubusercontent.com/MagePsycho/mysql-user-db-creator-bash-script/master/src/mysql-db-user-creator.sh -o mysql-db-user-creator.sh
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
- Default parameter values:  

| Parameter | Default Value |
|-|-|
| `host` | localhost |
| `user` | same as database name |
| `password` | randomly generated |

And MySQL credentials for new db/user creation will be taken from the MySQL config file `~/.my.cnf`.  
If you don't have one, you can simply create a `.my.cnf` file in home directory, with
```
[client]
host=localhost
user=[your-db-user]
password=[your-db-pass]
```
*If `~/.my.cnf` doesn't exist, you will be prompted for the root password. For an automated enviroment it's recommended to make use of MySQL config file.*


### To Create Db along with specified User & Pass (By passing all parameters explicitly)
```
./mysql-db-user-creator.sh --host=192.168.1.55 --database=new-db-name --user=new-user --pass=some-strong-pass
```

### To Create Db with User & Pass (By passing only required parameter)
```
./mysql-create-db-user.sh --database=bash_db2
```
*In this case default values will be used for missing parameters (see above)*

## Output Sample
![MySQL DB, User/Password Creator Result](https://github.com/MagePsycho/mysql-user-db-creator-bash-script/raw/master/docs/mysql-user-db-creator-bash-script-result.png "Nginx Virtual Host Creator Result")
Screentshot - MySQL DB, User/Password Creator Result
