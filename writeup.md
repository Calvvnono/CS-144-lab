# Lab 0

## 1.配置环境

使用ubuntu，运行

```
sudo apt update && sudo apt install git cmake gdb build-essential clang \
clang-tidy clang-format gcc-doc pkg-config glibc-doc tcpdump tshark
```

即可

## 2.Networking by hand

根据提示一步一步体验网络的运行即可。并注意http报文的格式，后续要使用。

## 3.Writing Webget

仔细阅读 util/socket.hh 和 util/file descriptor.hh，理解代码示例并进行使用。注意要一直read到EOF为止。

## 4.Reliable Byte Stream

按需完善函数，我是使用queue为容器。没有太大的坑。

**·** 三个小细节：

​    1）pop函数当需求 len>buffer.size() 时，不是将buffer全部pop，而是直接抛出error。

​    2）peek函数要看到的是缓冲区目前的全部字节（“**bytes**”），而不是队头字符。

​    3）测试点10偶尔过不了不一定是写错了，可以再测试试。

# Lab 1

制作一个TCP段重组器 Reassembler。

## 思路

主要处理两个问题：

1. 容量——超出容量限制的段将被抛弃
2. 重复——传入的数据课程会有部分的重复，对于一个位置，只存储一次数据

TCP_Reassembler底层采用  map<  pair< int,string > > 实现，其中int表示一段字节的起始位置，string存储该段字节.

（若采用 list 双向链表，或许会有更高的效率）

### 插入：

每次有新的数据段来到时，遍历map以找到合适的位置进行插入，用待插数据段的头位置与 auto iter 的头比较，以达到此目的。插入时要对data进行substring，以保证与原有段没有重叠。当遍历到底仍没找到位置插入时，做判断：

①data超出了容量范围（只要有超出就全段丢弃）②data应该插在原有所有段的后面（map尾）。

### 输出：

当 now_index_ 来到时，边输出数据段边更新 now_index_ ，并将map输出了的段erase，直到map中的第一段数据头不再为所需的 now_index_。需要条件循环输出的原因在于：在插入的过程中，我们**并不将相连的数据段合并**，只是保持段与段间没有交集，这意味着输出时很有可能有多端连续数据可以一并输出。

## 变量含义说明：

now_index_：当前byte_stream需要的第一个字节

last_str_tail：reassembler遍历过程中当前string前一个string的尾坐标

## p.s.

犯了一个相当蠢的错误，在寻找正确位置的while循环了使用continue逻辑时忽略了迭代器的更新，导致一直死循环…………



# Lab 2

## Translating between 64-bit indexes and 32-bit seqnos

### ·wrap() 

易于实现，直接将64位数 static_cast 与零点作用即可。

### ·unwrap() 

寻找最接近 checkpoint 的模 2^32 余 res 的下标。首先确定 res 的值，如果 zero_point_ 本身处于 res 之前，那么自然res就是 raw_value_ 与零点之差。如果 res 位于零点前，说明发生了超出 2^32-1 回环，需要计算确定 res 。

然后去计算最接近 checkpoint 的 res。特判是如果 checkpoint 在 res 之前，那显然这已经是最近结果。其余的正常确定即可（注意这里最好不要太懒写循环找，大概率会在第三个测试点超时。）

### Tip

注意所有下标均是 unsigned 的，所以在写条件判定的时候不能疏漏让（单侧）运算结果有可能是负的，发生溢出。

## Implementing the TCP receiver

*sqeno(32bit输入字段编号)；absolute seqno(对应的64bit编号)；stream index(流编号，为绝对seqno+1)*

![image-20230907235427038](C:\Users\kobedai\AppData\Roaming\Typora\typora-user-images\image-20230907235427038.png)

### ·receive()

接受到 message 并实现用 reassembler 重组进输出流。

![image-20230907235154718](C:\Users\kobedai\AppData\Roaming\Typora\typora-user-images\image-20230907235154718.png)

​                                                                                **（SenderMessage）**

1.当message包含SYN标记时，说明含有起始原点，此时seqno指向ISN，因此需要重定向为有效载荷的第一个字符（seqno++）

2.reassembler insert时，要将原有的seqno序号转化为流序号，这不止需要unwrap，**<u>还需要减一</u>**

3.当带有FIN标记message到达，这说明此为最后一条子段，但不说明是最后一次输入（**输入是乱序的**），因此我们需要记录最后子端的      终位置tail，**当流的总输入字节数达到此位置**，才说明输入正式结束。

### ·send ()

![image-20230908000055947](C:\Users\kobedai\AppData\Roaming\Typora\typora-user-images\image-20230908000055947.png)

​                                                                                     **(ReceiverMessage)**

1.流总push字节数（对应流编号下当前需要的第一个字节）需要加一再wrap才能得到seqno

2.如经计算所需ackno恰好为FIN位置（先前记录的tail），则此为特殊情况，**<u>ackno应加一跳过tail</u>**



# Lab 3

**实现 TCPSender**

## 变量声明

```cpp
  Wrap32 isn;                                    // Wrap 32的零点
  bool _isSent_ISN;                              // 流开始标签
  bool _isSent_FIN;                              // 流结束标签
  uint64_t initial_RTO;
  int cur_RTO;                                   // 现在的RTO
  bool isStartTimer;                             // 是否启动计时器
  TCPReceiverMessage receivedMsg;                // 记录现在接收器返回给发送器的消息(确认号、窗口大小)
  uint64_t abs_seqno;                            // 记录当前push到的绝对seqno，相对序列号会溢出
  uint16_t capacity;                             // 记录可能变化的窗口的原始值
  std::deque<TCPSenderMessage> outstanding_ones; // 记录所有已发送未确认的段
  std::deque<TCPSenderMessage> ready_ones;       // 记录所有准备好发送的段
  uint64_t outstanding_bytes;                    // 已发送未确认的字节数
  uint64_t consecutive_retransmissions_nums;     // 重传次数
```

## 函数细节

### ·push()

push函数从流中不断提取段，直到ready_ones集合容量超过限制（给未发送段预留的空间）OR 流结束。

push生成一段一段消息，push进 outstanding_ones 集合。

push同时也会把消息复制一份放进ready集合，发送就是用ready集合直接pop出来发送。



### ·maybe_send()

一次只发送一段（ready中最新的） OR 不发（ready为空）



### ·receive()

收到返回的ackno，将outstanding_ones中所有右端点在ackno之前的段全部pop

有未完成的段被确认时，(即outstanding集合发生pop)才会设置RTO

outstanding集合为空(全部未完成的段都完全确认)，则停止计时，重置计时器;**否则仍有没确认的段，继续计时**



### ·send_empty_message()

设置seqno(abs_seqno)即可



### ·tick( const    size_t     ms_since_last_tick )

用来模拟时间流逝，**只有调用tick时间才变化**，否则当作时间不变。给的参数指定了上一次调用该方法过了多久。

计时减少的操作：***cur_RTO -= ms_since_last_tick***; 

若 cur_RTO < 0 就意味着要超时重传了



# Lab 4

实现 network_interface ，实现 InternetDatagram（IP数据报） 和 EthernetFrame（以太网帧） 之间的转换，进而连接两个层次。

## 变量声明

```cpp
EthernetAddress ethernet_address_     // 主机的以太网地址
uint32_t ip_address_                  // 主机的IP地址
map<uint32_t,EthernetAddress> hashTmp // 暂时保存目标IP到目标以太网地址的映射
deque<EthernetFrame> ready_ones       // 存储要发送的EthernetFrame，包括广播求目标地址的ARP request
map<uint32_t,uint16_t> hashTime       // 存储保存的IP-Ethernet映射的时间
queue<uint32_t> ips                   // 存储deque ready_ones中IPV4 message的目标IP（便于操作）
int16_t time                          // 存储“现在”的时间
```



## 函数细节

### ·void pushFrame ( uint16_t *opcode*, uint32_t *target_ip*, EthernetAddress *target_eth* )

​	在进行ARP request（广播获取目标以太网地址）和ARP reply时，由于要多次进行push EthernetFrame 进 ready_ones 中的操作，集成编写该作用函数。参数用于编写 ARPmessage 并写入 EthernetFrame 的 payload 中。

#### （*）注

parse() 和 serialize() 函数的具体使用方法。



### ·void send_datagram ( const InternetDatagram& *dgram*, const Address& *next_hop* )

​	当TCPConnection或路由器想要将出站Internet(IP)数据报发送到下一跳时，调用此函数。工作就是将此数据报转换为以太网帧并(最终)发送它。如果目标以太网地址已知，立即发送。创建以太网帧（type=EthernetHeader::TYPE_lPv4)，将dgram设置为序列化数据报,并设置源地址和目标地址。
​	如果目标以太网地址未知，则广播下一跳以太网地址的ARP request。用 hashTIme 记录本次发送的时间点，并将 hashTmp 中对应的IP映射到广播地址。同时将IP数据报排队，以便在收到ARP答复后发送。不想让ARP请求淹没网络，如果网络接口在过去五秒内已发送有关同一IP地址的ARP请求，则不发送第二个请求只需等待第一个请求的答复。



### ·optional<InternetDatagram>  recv_frame( const EthernetFrame& *frame* )

​	当以太网帧到达时调用此方法。忽略任何不是发往当前网络接口的帧（这意味以太网目的地是广播地址或存储在以太网地址成员变量中的接口自己的以太网地址）。
​	如果入站帧是IPv4信息，则将有效负载解析为 InternetDatagram ，只要成功(parse()方法返回true) ,则将生成的 InternetDatagram 返回给调用者。
​	如果入站帧是ARP信息，则将有效负载解析为 ARPMessage ，成功则用 hashTmp 记录发送者的IP地址和以太网地址之间的映射，并用 hashTime 记录保存此映射的时间点（超过30秒的记录在tick()）中清楚。此外，如果这是一个要求我们的IP地址的ARP请求，要进行ARP回复 pushFrame ( ARPMessage::OPCODE_REPLY, now.sender_ip_address, frame.header.src );。



### ·void tick( const size_t *ms_since_last_tick* )

​	①记录时间的流逝，每次调用 tick() “当前时间点”time 加上参数*ms_since_last_tick* 。

​	②遍历 hashTmp 并清除过期的记录。

​	③遍历 hashTmp 中目标为广播地址的记录(ARP Request)，若超时，重新 push 请求帧。

```cpp
void NetworkInterface::tick( const size_t ms_since_last_tick )
{
  time += ms_since_last_tick;
  for ( auto it : hashTime ) {
    if ( hashTmp[it.first] == ETHERNET_BROADCAST && time - it.second >= 5000 ) {
    // Resend ARP requests if timeout
      pushFrame ( ARPMessage::OPCODE_REQUEST, it.first, ETHERNET_BROADCAST );
      hashTime[it.first] = time;
    } else if ( time - it.second >= 30000 ) {
    // clear the expired record in hashTime
      hashTmp.erase( it.first );
    }
  } 
}
```



### ·optional<EthernetFrame> maybe_send()

```cpp
optional<EthernetFrame> NetworkInterface::maybe_send()
{
  if( ready_ones.empty() ) {
    return { };
  } else {
    EthernetFrame thisone = ready_ones.front();
    if ( thisone.header.type == EthernetHeader::TYPE_ARP ) {
      ready_ones.pop_front();
      return thisone;
    } else if ( thisone.header.type == EthernetHeader::TYPE_IPv4 ) {
      if ( hashTmp.find( ips.front() ) == hashTmp.end() || hashTmp[ips.front()] == ETHERNET_BROADCAST )
        return { };
      // process the IPv4 message that the Ethernet address was not clear before but got ARP reply after
      thisone.header.dst = hashTmp[ips.front()];
      ready_ones.pop_front();
      ips.pop();
      return thisone;
    }
  }
  return { };
}
```

#### （*）注

​	不要忘记将 **先前发送ARP请求得到回应**，现在知道了IP对应的以太网地址的帧参数中**目标地址进行更新**。

# Lab 5

在现有网络接口之上实现 IP路由器。

## 变量声明

```cpp
// 实现路由表的结构和路由表
struct Route
{
    uint32_t route_prefix {};
    uint8_t prefix_length {};
    std::optional<Address> next_hop {};
    size_t interface_num {};
};
std::vector<Route> routingTable {};

// 该节点（路由器）具有的网络接口
std::vector<AsyncNetworkInterface> interfaces_ {};
```

## 函数细节

### · void add_route ( uint32_t route_prefix,
                  uint8_t prefix_length,
                  std::optional<Address> next_hop,
                  size_t interface_num );

向 routingTable 插入对应的 route 记录即可。



### · optional<Route> longestPrefixMatch ( vector<Route> table, uint32_t ip ) 

执行“最长前缀匹配算法”。

```cpp
optional<Route> longestPrefixMatch ( vector<Route> table, uint32_t ip ) 
{
  optional<Route> res = nullopt;
  for ( auto it: table ) {
    uint8_t len = 32u - it.prefix_length;
    // default route
    if ( it.prefix_length > 32 )
      continue;
    if ( len == 32 && !res.has_value() ) {
      res = it;
      continue;
    }

    if ( ( it.route_prefix >> len ) == ( ip >> len ) && 
         ( !res.has_value() || it.prefix_length > res->prefix_length ) )
      res = it;
  }
  return res;
}
```



### · void Router::route()

```cpp
void Router::route()
{
  for ( auto& in : interfaces_ ) {
    auto optional_dgram = in.maybe_receive();
    if ( !optional_dgram.has_value() )
      continue;
    InternetDatagram& datagram = optional_dgram.value();
    IPv4Header& head = datagram.header;
    // 愚蠢的错误：忘加‘&’致使 datagram.header.ttl 没有改变

    if ( head.ttl <= 1 )
      continue;
    head.ttl--;
    head.compute_checksum();
    // 一开始忘记checksum导致不过

    auto entry = longestPrefixMatch ( routingTable, datagram.header.dst );
    if ( !entry.has_value() )
      continue;

    interface( entry->interface_num ).send_datagram ( datagram, entry->next_hop.value_ or
                                                    (  Address::from_ipv4_numeric( datagram.header.dst ) ) );
  }
}
```

