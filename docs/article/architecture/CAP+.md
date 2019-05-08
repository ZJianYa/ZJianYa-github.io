# 概述

CAP 只是列出一个简单场景，并描述了一个简单的解决思路。  
我们需要做的是克服 CAP，这就有了[CAP 演化](https://www.infoq.cn/article/cap-twelve-years-later-how-the-rules-have-changed )
  

## CAP

- 数据一致性 Consistency  
  主备一致  
  事务一致性  
  这是在强调可靠性  

- 系统可用性 Availability  
  主备切换   
  这时候，也许主备数据并非一致  

- 分区容忍性 Partition Tolerance  
  分区容错性是指，当节点之间的网络出现问题之后，系统依然能正常提供服务。  
  分布式系统，往往有多个节点，每个节点之间，都不是完全独立的，需要相互通信，当发生节点无法联通时，数据是否还能保持一致，系统要如何进行容错处理，是需要考虑的。  
  也就是要进行所谓的降级处理，或者熔断。  

## CA

CA 是负相关的。  
分布式系统理论上是不可能有CA组合的：  
当发生节点间网络故障时，为了保证 C（一致性），那么就必须将系统锁住，不允许任何写入操作，否者就会出现节点之间数据不一致了。  
但是锁住了系统，就意味着当有写请求进来的时候，系统是不可用的，这一点又违背了 A（可用性）原则。  

## CP

[图例](https://mmbiz.qpic.cn/mmbiz_png/jgOJKOvxkeM1xYqU1DZUTkjVNnpbcKianvic2GOY09llGRsyoJShKEKvOC4MuCKIUKCUbvkMO6gmCxiaLNiadQCTag/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如上图，由于网络问题，节点A和节点B之前不能互相通讯。当有客户端（上图Actor）向节点A进行写入请求时（准备写入Message 2），节点A会不接收写入操作，导致写入失败，这样就保证了节点A和节点B的数据一致性，即保证了Consisteny（一致性）。  

## AP

[图例](https://mmbiz.qpic.cn/mmbiz_png/jgOJKOvxkeM1xYqU1DZUTkjVNnpbcKianwWIicOyJSwhZTg5je9lCNRv4yFIH9BI85XcnFQycK57hOgjN1yeG03Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如上图，由于网络问题，节点A和节点B之前不能互相通讯。  
当有客户端（上图Actor）向节点A进行写入请求时（准备写入Message 2），节点A允许写入，请求操作成功。但此时，由于A和B节点之前无法通讯，所以B节点的数据还是旧的（Message 1）。  
当有客户端向B节点发起读请求时候，读到的数据是旧数据，与在A节点读到的数据不一致。但由于系统能照常提供服务，所以满足了Availability（可用性）要求。  

因此，这种情况下，就是保障了AP架构，但其放弃了 Consisteny（一致性）。

## FAQ

- 分区容忍性