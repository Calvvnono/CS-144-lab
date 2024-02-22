#include "network_interface.hh"
#include "arp_message.hh"
#include "ethernet_frame.hh"

using namespace std;

// ethernet_address: Ethernet (what ARP calls "hardware") address of the interface
// ip_address: IP (what ARP calls "protocol") address of the interface
NetworkInterface::NetworkInterface( const EthernetAddress& ethernet_address, const Address& ip_address )
  : ethernet_address_( ethernet_address )
  , ip_address_( ip_address )
  , hashTmp()
  , ready_ones()
  , hashTime()
  , ips()
  , time( 0 )
{
  cerr << "DEBUG: Network interface has Ethernet address " << to_string( ethernet_address_ ) << " and IP address "
       << ip_address.ip() << "\n";
}

// dgram: the IPv4 datagram to be sent
// next_hop: the IP address of the interface to send it to (typically a router or default gateway, but
// may also be another host if directly connected to the same network as the destination)

void NetworkInterface::pushFrame ( uint16_t opcode, uint32_t target_ip, EthernetAddress target_eth )
{
  Serializer serializer;
  EthernetHeader header;
  header.type = EthernetHeader::TYPE_ARP;
  header.src = ethernet_address_;
  header.dst = target_eth;

  ARPMessage payload;
  payload.opcode = opcode;
  payload.sender_ethernet_address = ethernet_address_;
  payload.sender_ip_address = ip_address_.ipv4_numeric();
  if ( target_eth == ETHERNET_BROADCAST ) {
    payload.target_ethernet_address = {};
  } else {
    payload.target_ethernet_address = target_eth;
  }

  payload.target_ip_address = target_ip;
  header.serialize( serializer );
  payload.serialize( serializer );
  Parser parser( serializer.output() );
  EthernetFrame frame_to_send;
  frame_to_send.parse( parser );
  ready_ones.push_front( frame_to_send );
}

// Note: the Address type can be converted to a uint32_t (raw 32-bit IP address) by using the
// Address::ipv4_numeric() method.
void NetworkInterface::send_datagram( const InternetDatagram& dgram, const Address& next_hop )
{
  uint32_t ip32 = next_hop.ipv4_numeric();
    
  if ( hashTmp.find(ip32) == hashTmp.end() ) {
    pushFrame( ARPMessage::OPCODE_REQUEST, next_hop.ipv4_numeric(), ETHERNET_BROADCAST );
    hashTime [ ip32 ] = time;   // time when ARP request was first sent
    hashTmp [ ip32 ] = ETHERNET_BROADCAST;
  }

  // Queue the IP datagram
  EthernetHeader header;
  Serializer serializer;
  header.src = ethernet_address_;
  // destination ethernet address will be filled when sending
  header.type = EthernetHeader::TYPE_IPv4;
  header.serialize( serializer );
  dgram.serialize( serializer );
  Parser parser( serializer.output() );
  EthernetFrame frame;
  frame.parse( parser );
  ready_ones.push_back( frame );
  ips.push( ip32 );
}

// frame: the incoming Ethernet frame
optional<InternetDatagram> NetworkInterface::recv_frame( const EthernetFrame& frame )
{
  EthernetHeader mark = frame.header;
  EthernetAddress des = mark.dst;

  if ( des!=ethernet_address_ && des!=ETHERNET_BROADCAST ) {
    return { };
  }

  if ( mark.type == EthernetHeader::TYPE_IPv4 ) {
    InternetDatagram now;
    if ( !parse( now, frame.payload ) ) {
      return { };
    } else {
      return now;
    }
  }

  else if ( mark.type == EthernetHeader::TYPE_ARP ) {
    ARPMessage now;
    if( parse( now, frame.payload ) && now.target_ip_address == ip_address_.ipv4_numeric() ) {
      hashTmp [ now.sender_ip_address ] = now.sender_ethernet_address;
      // if new, record the time when this hashTmp record becomes valid
      if ( hashTime.find( now.sender_ip_address ) == hashTime.end() ) 
        hashTime [ now.sender_ip_address ] = time;
      // if it's an ARP request, we send an appropriate ARP reply.
      if ( now.opcode == ARPMessage::OPCODE_REQUEST ) {
        pushFrame ( ARPMessage::OPCODE_REPLY, now.sender_ip_address, mark.src );
      }
    }
  }
  return { };
}

// ms_since_last_tick: the number of milliseconds since the last call to this method
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




  