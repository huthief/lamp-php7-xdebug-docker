## Docker-compose for CDS Develop (PHP 7 with XDebug)

- 最後更新日：2021.02.23

#### ID/PWD

- cdstest.fycd.info
fycdadmin / 5281fycd

- docfiletest.fycd.info
fycdadmin / 5281fycd

- mysql db
root / !QAZ2wsx
fycdcds / 1qaz522wsx81

### 一、Docker使用的版本

* php:7.4.13-apache
* mariadb:10.4.17
* traefik
* nginx-proxy:lastest (請使用有nginx的yml檔案)
* redis:amd64/redis:6.0.10

若要修改版本，請自行修改docker-compose.yml裡面的image來源
注意：若使用traefik版本，請自行另外搭配traefik-docker使用

#### 附註
````bash
docker network create -d bridge reverse-proxy
````

### 二、前置作業

#### 1. 說明
為了更加符合部署後情況，故採用 traefik / nginx進行reverse proxy作業
請自行於本機hosts加入以下三個設定，修改時請留意檔案權限
Windows系統，位置在 C:/Windows/System32/drivers/etc/hosts 
Mac系統，位置在 /private/etc/hosts

````bash
#add for fycd test
127.0.0.1 docfiledev.fycd.info cdsdev.fycd.info apidev.fycd.info
````

#### 2. 各系統對應網址
1. 道親系統
http://cdsdev.fycd.info

2. 文書系統
http://docfiledev.fycd.info

3. 後端API服務
http://apidev.fycd.info

### 三、設定說明

#### 1. 指定XDebug remote_host IP

修改檔案:./etc/php/php.ini 中 xdebug.remote_host 的值。請填入Docker Host IP為docker實體機的IP

```yml
;這邊的remote_host要改為docker實體機的IP，不可用localhost
;xdebug.remote_host=docker實體機的IP
xdebug.remote_host=192.168.173.31
```

#### 2. 設定MySQL帳號密碼

修改檔案:docker-compose.yml 中 MYSQL相關參數。可指定啟動後的root密碼與要新增的帳號/密碼

```yml
MYSQL_ALLOW_EMPTY_PASSWORD: "no"
MYSQL_ROOT_PASSWORD: "SET_YOUR_MYSQL_ROOT_PASSWORD"
MYSQL_USER: 'SET_MYSQL_NEW_ACCOUNT_ID'
MYSQL_PASSWORD: 'SET_MYSQL_NEW_ACCOUNT_ACCOUNT_PASSWORD'
MYSQL_DATABASE: 'SET_MYSQL_NEW_DATABASE'
```

#### 3. 設定container啟動後，container的80,3306 port，要對定到實體機的port

目前預設80, 3306都是對應到實體機的80,33076 port
若要變更對應，請自行修改docker-compose.yml中port相關參數。

```yml
ports:
    #網站對應的網址。目前是直接對應實體機的80 port
    #若要對應實體機的8080 port，要改為 - 8080:80
     - 80:80

ports:
    #MySQL連線的埠號。目前是直接對應實體機的3306 port
    #若要對應實體機的3307 port，要改為 - 3307:3306
     - 3306:3306
```

#### 4. 依據需求調整php.ini

啟動後，會使用到的php.ini檔，是放在./etc/php/php/ini檔案中。請自行依據需求調整

#### 5. www 首頁位置

啟動後，www首頁位置是放在 ./var/www/html目錄中。請自行放置要使用的網頁檔案

#### 6. MySQL檔案位置

啟動後，MySQL檔案位置會統一在 ./var/lib/mysql。

此目錄將來若要與其他Docker共用的話，只需對應到新的Docker的 /var/lib/mysql 即可

### 四、Docker啟動使用說明

#### 1. 安裝與啟動

開啟終端機，切換到本目錄，執行以下指令以啟動Docker container

```bash
$ docker-compose up -d
```

#### 2. 停止並刪除container

開啟終端機，切換到本目錄，執行以下指令以停止並刪除container

```bash
$ docker-compose down
```

**注意(一)**

若只是單存要停掉container而不一併刪除container的話，請用傳統的docker stop <container_ID> 的方式停用

**注意(二)**
若是啟動後可以執行，卻無法順利登入，請檢查一下以下目錄權限是否為777
/var/www/html/api/logs
/var/www/html/api/tmp

### 五、XDebug使用說明

以下以VSCode debug方式來說明。其他工具請自行參閱相關文件。

1. 開啟要除錯的php檔 (檔案應放在 ./var/www/html目錄下)

2. 設定中斷點

3. 切換VSCode到除錯Debug畫面（點左邊工具圖示第四個（有一隻蟲的圖案）)

4. 最上方「偵錯Debug)」請選擇「Listen for XDebug」，並按下綠色的執行按鈕

5. 使用瀏覽器開啟要除錯的網頁，VSCode就會停在所設定的中斷點

### 六、附錄

#### MySQL相關作業

1. 設定新增的帳號可以連線

```shell
//$GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' IDENTIFIED BY '!QAZ2wsx';
$GRANT ALL PRIVILEGES ON *.* TO 'SET_MYSQL_NEW_ACCOUNT_ID'@'localhost' IDENTIFIED BY 'SET_MYSQL_NEW_ACCOUNT_ACCOUNT_PASSWORD';
$FLUSH PRIVILEGES;
```

2. 授權新增的帳號可以進行資料庫管理
```shell
$#docker exec -it <container_id> bash
root@<container_id>:/# mysql -u root -p
<輸入root密碼>
MariaDB [(none)]> use mysql
//update user set grant_priv='Y' where user='phpmyadmin';
//讓phpmyadmin可以進行授權
MariaDB [mysql]>update user set grant_priv='Y' where user='SET_MYSQL_NEW_ACCOUNT_ID';
//授權phpmyadmin所有權限
MariaDB [mysql]>GRANT ALL PRIVILEGES ON *.* TO 'SET_MYSQL_NEW_ACCOUNT_ID'@'localhost' IDENTIFIED BY 'SET_MYSQL_NEW_ACCOUNT_ACCOUNT_PASSWORD';
//重新整理權限
MariaDB [mysql]>FLUSH PRIVILEGES;
```

3. 使用phpmyadmin進行MySQL管理

在docker-compose.yml最後面，我們加入的phpmyadmin的docker image，使得管理MySQL更為方便
只要連線到 [http://localhost:8088/phpmyadmin](http://localhost:8088/phpmyadmin) 即可

或 可自行下載 phpMyAdmin的原始檔，並將之放到以下目錄即可 
**{cds-docker目錄}/var/www/html/api/public**


