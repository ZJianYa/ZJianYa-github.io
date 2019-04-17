# 概述

jstat -gc PID interval

```{}
[root@localhost ~]# ps -ef | grep java
root     14664     1 14 09:11 pts/1    00:20:02 /usr/bin/jdk1.8.0_202/bin/java -Djava.util.logging.config.file=/home/test/apache-tomcat-9.0.8/conf/logging.properties -Djava.tls.ephemeralDHKeySize=2048 -Djava.rmi.server.hostname=192.168.1.200 -Dcom.sun.management.jmxremote.port=8099 -Dcom.sun.management.jmxremote.rmi.port=8099 -Dcom.sun.managemee=false -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dfile.encoding=UTF-8 -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Dignore.endorsed.dirsme/test/apache-tomcat-9.0.8/bin/tomcat-juli.jar -Dcatalina.base=/home/test/apache-tomcat-9.0.8 -Dcatalina.home=/home/test/apache-tomcat-9.0.8 -Djava.io.tmpdir=/home/test/apa
root     16704 16659  0 11:31 pts/4    00:00:00 grep --color=auto java
[root@localhost ~]# jstat -gc 14664 5000
 S0C    S1C    S0U    S1U      EC       EU        OC         OU       MC     MU         CCSC    CCSU    YGC     YGCT    FGC    FGCT     GCT
1024.0 1024.0 768.0   0.0   345600.0 283085.6  696320.0   384054.5  134744.0 131736.9 16768.0 16084.0   1948   12.293   4      0.436   12.729
1024.0 1024.0 768.0   0.0   345600.0 285612.9  696320.0   384054.5  134744.0 131736.9 16768.0 16084.0   1948   12.293   4      0.436   12.729
```

S0C:年轻代中第一个survivor（幸存区）的容量 (字节)  
S1C:年轻代中第二个survivor（幸存区）的容量 (字节)  
S0U:年轻代中第一个survivor（幸存区）目前已使用空间 (字节)  
S1U:年轻代中第二个survivor（幸存区）目前已使用空间 (字节)  
EC:年轻代中Eden（伊甸园）的容量 (字节)  
EU:年轻代中Eden（伊甸园）目前已使用空间 (字节)  
OC:Old代的容量 (字节)  
OU:Old代目前已使用空间 (字节)  
PC:Perm(持久代)的容量 (字节)  
PU:Perm(持久代)目前已使用空间 (字节)  
YGC:从应用程序启动到采样时年轻代中gc次数  
YGCT:从应用程序启动到采样时年轻代中gc所用时间(s)  
FGC:从应用程序启动到采样时old代(全gc)gc次数  
FGCT:从应用程序启动到采样时old代(全gc)gc所用时间(s)  
GCT:从应用程序启动到采样时gc用的总时间(s)  

NGCMN:年轻代(young)中初始化(最小)的大小 (字节)  
NGCMX:年轻代(young)的最大容量 (字节)  
NGC:年轻代(young)中当前的容量 (字节)  
OGCMN:old代中初始化(最小)的大小 (字节)  
OGCMX:old代的最大容量 (字节)  
OGC:old代当前新生成的容量 (字节)  
PGCMN:perm代中初始化(最小)的大小 (字节)  
PGCMX:perm代的最大容量 (字节)  
PGC:perm代当前新生成的容量 (字节)  
S0:年轻代中第一个survivor（幸存区）已使用的占当前容量百分比  
S1:年轻代中第二个survivor（幸存区）已使用的占当前容量百分比  
E:年轻代中Eden（伊甸园）已使用的占当前容量百分比  
O:old代已使用的占当前容量百分比  
P:perm代已使用的占当前容量百分比  
S0CMX:年轻代中第一个survivor（幸存区）的最大容量 (字节)  
S1CMX :年轻代中第二个survivor（幸存区）的最大容量 (字节)  
ECMX:年轻代中Eden（伊甸园）的最大容量 (字节)  
DSS:当前需要survivor（幸存区）的容量 (字节)（Eden区已满）  
TT: 持有次数限制  
MTT : 最大持有次数限制  
