# DNS Performance Testing Tools

# https://www.dns-oarc.net/tools/dnsperf
# https://github.com/DNS-OARC/sample-query-data
apt-get install -y bind9utils libbind-dev gnuplot libkrb5-dev libssl-dev libcap-dev libxml2-dev libgeoip-dev
wget ftp://ftp.nominum.com/pub/nominum/dnsperf/2.1.0.0/dnsperf-src-2.1.0.0-1.tar.gz
tar -zxvf dnsperf-src-2.1.0.0-1.tar.gz
cd dnsperf-src-2.1.0.0-1/
./configure
make
make install  # dnsperf and resperf are now installed in /usr/local/bin

dnsperf -s 8.8.8.8 -d sample-query-data-main/queryfile-example-10million-201202_part10 -S 1 -Q 512
dnsperf -s 8.8.8.8 -d sample-query-data-main/queryfile-example-10million-201202_part10 -S 1 -Q 1024

# https://linux.die.net/man/1/resperf

# Ramp up from 0 to 100.000 req/sec over a period of 60 seconds (default test):
resperf-report -s 8.8.8.8 -d queryfile-example-current

# Test with 1000 req/sec for 10 minuttes (600 sec) with a 5 second ramp up:
resperf-report -s 8.8.8.8 -d queryfile-example-current -c 600 -m 1000 -r 5

# resperf will stop the test when one of these conditions are met: 
# 1) server successfully replying to all requests, 
# 2) exceeding 65,536 outstanding queries or 
# 3) resperf falling 1000 queries behind what it expected to send
