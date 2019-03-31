
```{}
\> mysqld --defaults-file="D:\Program Files\MySQL\mysql-5.7.20-winx64\config.txt" --initialize --user=mysql  

\> mysqld -install  
\> mysqld -remove
```

安装出错  
https://answers.microsoft.com/en-us/windows/forum/windows_7-performance/missing-msvcp120dll-file/f0a14d55-73f0-4a21-879e-1cbacf05e906?auth=1  

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的新密码';
alter user 'root'@'localhost' identified by '123';  
set password for 'root'@'localhost'=password('123');  
update mysql.user set authentication_string=password('123qwe') where user='root' and Host = 'localhost';