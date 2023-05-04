# CDS 道親文書管理系統部署說明

- 最後更新日：2022.02.13

## 部署設定
### nginx
1. 手動在 /etc/nginx目錄下加入一個 DomainName的子目錄
2. 修改 default.conf裡面的DomainName與Docker-Compose設定對應的 php-fpm container name
```conf
server_name apidev.fycd.info; # 你的 domain
fastcgi_pass api-php-fpm:9000; # 這邊就是上面說呼叫 fastcgi 的界面
```
