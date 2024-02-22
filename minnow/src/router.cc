#include "router.hh"

#include <iostream>
#include <limits>

using namespace std;

// route_prefix: The "up-to-32-bit" IPv4 address prefix to match the datagram's destination address against
// prefix_length: For this route to be applicable, how many high-order (most-significant) bits of
//    the route_prefix will need to match the corresponding bits of the datagram's destination address?
// next_hop: The IP address of the next hop. Will be empty if the network is directly attached to the router (in
//    which case, the next hop address should be the datagram's final destination).
// interface_num: The index of the interface to send the datagram out on.
void Router::add_route( const uint32_t route_prefix,
                        const uint8_t prefix_length,
                        const optional<Address> next_hop,
                        const size_t interface_num )
{
  cerr << "DEBUG: adding route " << Address::from_ipv4_numeric( route_prefix ).ip() << "/"
       << static_cast<int>( prefix_length ) << " => " << ( next_hop.has_value() ? next_hop->ip() : "(direct)" )
       << " on interface " << interface_num << "\n";
  routingTable.push_back ( {route_prefix, prefix_length, next_hop, interface_num} );
}
// Add a route (a forwarding rule)

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

    if ( ( it.route_prefix >> len ) == ( ip >> len ) && ( !res.has_value() || it.prefix_length > res->prefix_length ) )
      res = it;
  }
  return res;
}
// implement the “longest-prefix-match” logic of an IP

void Router::route()
{
  for ( auto& in : interfaces_ ) {
    auto optional_dgram = in.maybe_receive();
    if ( !optional_dgram.has_value() )
      continue;
    InternetDatagram& datagram = optional_dgram.value();
    IPv4Header& head = datagram.header;
    // stupid mistake: missing '&' makes datagram.header.ttl unchanged!

    if ( head.ttl <= 1 )
      continue;
    head.ttl--;
    head.compute_checksum();
    // missing line

    auto entry = longestPrefixMatch ( routingTable, datagram.header.dst );
    if ( !entry.has_value() )
      continue;

    interface( entry->interface_num ).send_datagram ( datagram, entry->next_hop.value_or( Address::from_ipv4_numeric( datagram.header.dst ) ) );
  }
}
// Route packets between the interfaces. For each interface, use the
// maybe_receive() method to consume every incoming datagram and
// send it on one of interfaces to the correct next hop. The router
// chooses the outbound interface and next-hop as specified by the
// route with the longest prefix_length that matches the datagram's
// destination address.
