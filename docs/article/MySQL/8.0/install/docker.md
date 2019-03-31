https://hub.docker.com/_/mysql/ 

## Using a custom MySQL configuration file
The default configuration for MySQL can be found in `/etc/mysql/my.cnf`, which may !includedir additional directories such as /etc/mysql/conf.d or /etc/mysql/mysql.conf.d. Please inspect the relevant files and directories within the mysql image itself for more details.

MySQL的默认配置可在/etc/mysql/my.cnf中找到，它可能包含其他目录，如/etc/mysql/conf.d或/etc/mysql/mysql.conf.d。 请检查mysql映像本身内的相关文件和目录以获取更多详细信息。

If /my/custom/config-file.cnf is the path and name of your custom configuration file, you can start your mysql container like this (note that only the directory path of the custom config file is used in this command):

如果/my/custom/config-file.cnf是自定义配置文件的路径和名称，那么可以像这样启动你的mysql容器（注意在这个命令中只使用了自定义配置文件的目录路径）：

`$ docker run --name some-mysql -v /my/custom:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag`

This will start a new container some-mysql where the MySQL instance uses the combined startup settings from /etc/mysql/my.cnf and /etc/mysql/conf.d/config-file.cnf, with settings from the latter taking precedence.

这将启动一个新的容器some-mysql，其中MySQL实例使用来自/etc/mysql/my.cnf和/etc/mysql/conf.d/config-file.cnf的组合启动设置，后者的设置优先。

Note that users on host systems with SELinux enabled may see issues with this. The current workaround is to assign the relevant SELinux policy type to your new config file so that the container will be allowed to mount it:

请注意，启用了SELinux的主机系统上的用户可能会遇到问题。 目前的解决方法是将相关的SELinux策略类型分配给您的新配置文件，以便容器可以挂载它：

```
$ chcon -Rt svirt_sandbox_file_t /my/custom
```

## Configuration without a cnf file

Many configuration options can be passed as flags to mysqld. This will give you the flexibility to customize the container without needing a cnf file. For example, if you want to change the default encoding and collation for all tables to use UTF-8 (utf8mb4) just run the following:

许多配置选项可以作为标志传递给mysqld。 这将使您可以灵活地自定义容器而不需要cnf文件。 例如，如果您想要更改所有表的默认编码和归类以使用UTF-8（utf8mb4），请运行以下命令：

```{.shell}
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```

If you would like to see a complete list of available options, just run:

如果你想看一个完整的可用选项，可以执行下面的命令：

```{}
$ docker run -it --rm mysql:tag --verbose --help
```

## Environment Variables

## Docker Secrets

## Where to Store Data
Important note: There are several ways to store data used by applications that run in Docker containers. We encourage users of the mysql images to familiarize themselves with the options available, including:

- Let Docker manage the storage of your database data by writing the database files to disk on the host system using its own internal volume management. This is the default and is easy and fairly transparent to the user. The downside is that the files may be hard to locate for tools and applications that run directly on the host system, i.e. outside containers.

- Create a data directory on the host system (outside the container) and mount this to a directory visible from inside the container. This places the database files in a known location on the host system, and makes it easy for tools and applications on the host system to access the files. The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.

The Docker documentation is a good starting point for understanding the different storage options and variations, and there are multiple blogs and forum postings that discuss and give advice in this area. We will simply show the basic procedure here for the latter option above:

Docker文档是理解不同存储选项和变体的好起点，并且有多个博客和论坛帖子可以讨论和提供这方面的建议。 我们将简单地在上面显示后面的选项的基本过程：

1. Create a data directory on a suitable volume on your host system, e.g. /my/own/datadir.  
在主机上创建一个数据目录

2. Start your mysql container like this:  
启动你的mysql容器： 

```
$ docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag
```

The `-v /my/own/datadir:/var/lib/mysql` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/lib/mysql` inside the container, where MySQL by default will write its data files.

命令中的`-v /my/own/datadir:/var/lib/mysql`部分把基础主机的`/my/own/datadir`目录作为`/var/lib/mysql`挂载到了容器内部，用来存放MySQL的数据文件。

Note that users on host systems with SELinux enabled may see issues with this. The current workaround is to assign the relevant SELinux policy type to the new data directory so that the container will be allowed to access it:

请注意，启用了SELinux的主机系统上的用户可能会遇到问题。 目前的解决方法是将相关的SELinux策略类型分配给新的数据目录，以便允许容器访问它：

```
$ chcon -Rt svirt_sandbox_file_t /my/own/datadir
```