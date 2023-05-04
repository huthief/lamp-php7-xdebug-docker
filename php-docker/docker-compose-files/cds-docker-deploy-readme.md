# CDS 道親文書管理系統部署說明

- 最後更新日：2021.05.01

## 目錄結構說明

- 檔案：docker-compose.yml

docker組合包，裡面包含以下服務
1. MariaDB: 資料庫
2. Nginx: Nginx服務，作爲開發環境轉址使用
3. redis: 快取服務(目前尚未開始應用)
4. cds-api: 後端API服務(Apache+PHP)
5. cds-docfile: 文書管理系統環境(Apache+PHP)
6. cds-taomember: 道親管理系統環境(Apache+PHP)

- 目錄：etc/mysql

MariaDB 客製相關檔案

- 目錄：etc/mysql/conf

MariaDB 客製設定檔位置

- 目錄：var/lib/mysql

MariaDB 資料庫檔案位置

- 目錄：etc/nginx

Nginx服務

- 目錄：etc/nginx/conf.d

Nginx服務客製設定檔位置

- 目錄：etc/php

PHP 客製相關檔案

- 目錄：etc/php/conf

PHP 客製設定檔位置

- 目錄：php-apache

Apache + PHP的 Docker 設定檔位置。目前是共用此Dockerfile

- 目錄：var/www/html/api

後端API服務程式

- 目錄：var/www/html/docfile

文書管理系統

- 目錄：var/www/html/taomember

道親管理系統

## 設定檔
### 後端API服務
- 檔案：var/www/html/api/config/env.php

1. 設定項目：$settings['db']

資料庫連線相關資訊

2. 設定項目：$settings['apikey']

呼叫此API服務時，驗證用的API KEY

3. 設定項目：$settings['url']['host']

此API服務對外的Domain Name

4. 設定項目：$settings['jwt']

此API服務驗證用的JWT憑證資訊
可修改'issuer' => 'xxx.xxx.xxx.xx'
以便錯開憑證
也可一併修改公鑰(public_key)、私鑰(private_key)資訊
備註：公私鑰產製方式

```shell
ssh-keygen -t rsa -b 2048 -m PEM -f jwtRS256.key
# Don't add passphrase
openssl rsa -in jwtRS256.key -pubout -outform PEM -out jwtRS256.key.pub
cat jwtRS256.key
cat jwtRS256.key.pub
```

### 文書管理系統
- 檔案：var/www/html/docfile/assets/env.9233c8bdba83ff66dd74.js
- 用途：設定要連線的後端API Server位置與連線用的API KEY

```javascript
    # 後端API Server URL
    window.__env.apiUrl = 'http://apidev.fycd.info';

    # 後端API Server 連線用的API KEY
    window.__env.apiKey = 'oQWDgZpChCLn694w0SORkpqNYK4F5dsg8CyKtECc2ihi7SFpzoKwoAzDmS5BY9cov33IBWMeLgq';

    # 允許連線的網域名稱。可透過逗號(,)區分
    window.__env.allowedDomains = ['apidev.fycd.info','docfiledev.fycd.info','localhost'];
```

### 資料庫管理 phpMyAdmin
- 檔案：var/www/html/api/public/phpmyadmin/config.inc.php

- 用途：設定連線的MariaDB / MySQL 所在主機。可依據實際情況進行增減

- 注意：因爲是連線Docker的資料庫，所以host選項記得要使用docker-compose.yml中設定的資料庫主機名稱(如：mariadb)。
$i++;
$cfg['Servers'][$i]['verbose'] = 'docker';
$cfg['Servers'][$i]['host'] = 'mariadb';
$cfg['Servers'][$i]['port'] = '';
$cfg['Servers'][$i]['socket'] = '';
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['user'] = 'root';
$cfg['Servers'][$i]['password'] = '';

### 道親管理系統
- 檔案：var/www/html/taomember/mainfile.php
- 用途：道親管理系統對外的網域名稱(Domain Name)

```PHP
define('XOOPS_URL', 'http://cdsdev.fycd.info');
```

- 檔案：var/www/html/taomember/xoops_data/data/secure.php
- 用途：道親管理系統連線資料庫資訊

```PHP
// 資料庫類別(不用改)
define('XOOPS_DB_TYPE', 'mysql');

// 資料庫語系(不用改)
define('XOOPS_DB_CHARSET', 'utf8');

// 資料庫前輟用字(請依據實際環境設定)(開發測試環境使用dev)
define('XOOPS_DB_PREFIX', 'dev');

// 資料庫所在主機名稱（注意：Docker中請勿使用localhost，應使用docker名稱)
define('XOOPS_DB_HOST', 'mariadb'); //修改為for docker mariadb狀態

// 資料庫連線用的資料庫使用者帳號
define('XOOPS_DB_USER', 'fycdcds');

// 資料庫連線用的資料庫使用者密碼
define('XOOPS_DB_PASS', '1qaz522wsx81');

// 資料庫名稱
define('XOOPS_DB_NAME', 'cds_dev');
```

- 資料庫資料表：dev_cds_sconf
- 用途：設定道親編號前輟字元。注意：應該每年調整，建議前兩碼使用道場編號（如：桃園39)

- 資料庫資料表：dev_config --> sslloginlink
- 用途：HTTPS連線用的網址
- 注意：可透過 XOOPS後臺進行設定 (XOOPS後臺->偏好設定->系統設定->一般設定，找「SSL 登入頁面的 URL」進行修改)

