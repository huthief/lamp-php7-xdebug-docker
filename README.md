## Docker-compose for PHP 7 with XDebug

### 一、Docker使用的版本

* php:7.1.20-apache

* mariadb:10.1

若要修改版本，請自行修改docker-compose.yml裡面的image來源

### 二、設定說明

#### 1. 指定XDebug remote_host IP

修改檔案：./etc/php/php.ini 中 xdebug.remote_host 的值。請填入Docker Host IP為docker實體機的IP

```yml
;這邊的remote_host要改為docker實體機的IP，不可用localhost
;xdebug.remote_host=docker實體機的IP
xdebug.remote_host=192.168.173.31
```

#### 2. 設定MySQL帳號密碼

修改檔案：docker-compose.yml 中 MYSQL相關參數。可指定啟動後的root密碼與要新增的帳號/密碼

```yml
MYSQL_ALLOW_EMPTY_PASSWORD: "no"
MYSQL_ROOT_PASSWORD: "SET_YOUR_MYSQL_ROOT_PASSWORD"
MYSQL_USER: 'SET_MYSQL_NEW_ACCOUNT_ID'
MYSQL_PASSWORD: 'SET_MYSQL_NEW_ACCOUNT_ACCOUNT_PASSWORD'
MYSQL_DATABASE: 'SET_MYSQL_NEW_DATABASE'
```

#### 3. 設定container啟動後，container的80,3306 port，要對定到實體機的port

目前預設80, 3306都是對應到實體機的80,33076 port
若要變更對應，請自行修改docker-compose.yml 中 port相關參數。

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

#### 5. www首頁位置

啟動後，www首頁位置是放在 ./var/www/html目錄中。請自行放置要使用的網頁檔案

#### 6. MySQL檔案位置

啟動後，MySQL檔案位置會統一在 ./var/lib/mysql。

此目錄將來若要與其他Docker共用的話，只需對應到新的Docker的 /var/lib/mysql 即可

### 三、Docker啟動使用說明

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

**注意：**

若只是單存要停掉container而不一併刪除container的話，請用傳統的docker stop <container_ID> 的方式停用

### 四、XDebug使用說明

以下以VSCode debug方式來說明。其他工具請自行參閱相關文件。

1. 開啟要除錯的php檔 (檔案應放在 ./var/www/html目錄下)

2. 設定中斷點

3. 切換VSCode到除錯Debug畫面（點左邊工具圖示第四個（有一支蟲的圖案）)

4. 最上方「偵錯Debug)」請選擇「Listen for XDebug」，並按下綠色的執行按鈕

5. 使用瀏覽器開啟要除錯的網頁，VSCode就會停在所設定的中斷點
