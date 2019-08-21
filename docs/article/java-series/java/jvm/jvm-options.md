# 概述

## 可传入参数

传递给JVM的参数，不一定是JVM的配置参数。

```{.shell}
[root@localhost apache-tomcat-9.0.8]# java -help
Usage: java [-options] class [args...]
           (to execute a class)
   or  java [-options] -jar jarfile [args...]
           (to execute a jar file)
where options include:
    -d32          use a 32-bit data model if available
    -d64          use a 64-bit data model if available
    -server       to select the "server" VM
                  The default VM is server,
                  because you are running on a server-class machine.


    -cp <class search path of directories and zip/jar files>
    -classpath <class search path of directories and zip/jar files>
                  A : separated list of directories, JAR archives,
                  and ZIP archives to search for class files.
    -D<name>=<value>
                  set a system property
    -verbose:[class|gc|jni]
                  enable verbose output
    -version      print product version and exit
    -version:<value>
                  Warning: this feature is deprecated and will be removed
                  in a future release.
                  require the specified version to run
    -showversion  print product version and continue
    -jre-restrict-search | -no-jre-restrict-search
                  Warning: this feature is deprecated and will be removed
                  in a future release.
                  include/exclude user private JREs in the version search
    -? -help      print this help message
    -X            print help on non-standard options
    -ea[:<packagename>...|:<classname>]
    -enableassertions[:<packagename>...|:<classname>]
                  enable assertions with specified granularity
    -da[:<packagename>...|:<classname>]
    -disableassertions[:<packagename>...|:<classname>]
                  disable assertions with specified granularity
    -esa | -enablesystemassertions
                  enable system assertions
    -dsa | -disablesystemassertions
                  disable system assertions
    -agentlib:<libname>[=<options>]
                  load native agent library <libname>, e.g. -agentlib:hprof
                  see also, -agentlib:jdwp=help and -agentlib:hprof=help
    -agentpath:<pathname>[=<options>]
                  load native agent library by full pathname
    -javaagent:<jarpath>[=<options>]
                  load Java programming language agent, see java.lang.instrument
    -splash:<imagepath>
                  show splash screen with specified image
See http://www.oracle.com/technetwork/java/javase/documentation/index.html for more details.
[root@localhost apache-tomcat-9.0.8]#
```

https://docs.oracle.com/javame/8.0/api/meep/api/doc-files/system_properties.html

## JVM Settings

http://jvmmemory.com/  可以在线配置参数

### JDK 7

```
-Xms512m -Xmx2048m -XX:PermSize=128m -XX:MaxPermSize=256m -XX:MinHeapFreeRatio=50 -XX:MaxHeapFreeRatio=100
```

### JDK 8 

```
-Xms -Xmx -XX:MetaspaceSize -XX:MaxMetaspaceSize -XX:MinHeapFreeRation -XX:MaxHeapFreeRation -XX:NewRatio=16 -XX:SurvivorRatio=32 -XX:+UseG1GC
```

## Tomcat的常见参数

```{}
 /usr/bin/jdk1.8.0_202/bin/java 
 -Djava.util.logging.config.file=/home/test/apache-tomcat-9.0.8/conf/logging.properties 
 -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager 
 -Djdk.tls.ephemeralDHKeySize=2048 
 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources 
 -Dfile.encoding=UTF-8 
 -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 
 -Dignore.endorsed.dirs= 
 -classpath /home/test/apache-tomcat-9.0.8/bin/bootstrap.jar:/home/test/apache-tomcat-9.0.8/bin/tomcat-juli.jar 
 -Dcatalina.base=/home/test/apache-tomcat-9.0.8 
 -Dcatalina.home=/home/test/apache-tomcat-9.0.8 
 -Djava.io.tmpdir=/home/test/apache-tomcat-9.0.8/temp org.apache.catalina.startup.Bootstrap start
```