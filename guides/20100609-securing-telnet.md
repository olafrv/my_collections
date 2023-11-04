# Securing Telnet using OpenSSL

Telnet is the most ancient and insecure remote terminal connection protocol, 
but today there are many improved version such as: 

  * MIT Kerberos Authentication (not secured) server and client sides
  * SSL secured telnet server and client sides.
 
Because always we need security we are going to choose the SSL secured 
one over the MIT Kerberos Authentication. 

**How the standard (INSECURED) telnet**

**Debian**

like systems (with apt-get): 

```bash
    apt-get install xinetd telnetd telnet
```

**Red Hat** 

like systems (with yum): 

```bash
    yum -y install xinetd telnetd telnet
```

Restart the superserver daemon: 

```bash
    /etc/init.d/xinetd restart
```

Connect insecurely to localhost: 

```bash
    telnet localhost
```

**How to install SSL SECURED telnet (Recommended)**

The secured version (at least in Debian like systems) just do the following steps: Install the needed packages:

```bash
    apt-get install xinetd openssl
    apt-get install telnetd-ssl telnet-ssl
```

Configure a valid self signed certificate: 

```bash
    cd /etc/ssl
    openssl req -new -x509 -nodes -out telnetd.pem -keyout telnetd.pem
    ln -s telnetd.pem `openssl x509 -noout -hash < telnetd.pem`.0
    openssl verify /etc/ssl/certs/telnetd.pem
    cd /etc/telnetd-ssl
    rm telnetd.pem 
    ln -s /etc/ssl/certs/telnetd.pem
```

Restart the superserver daemon: 

```bash
    /etc/init.d/xinetd restart
```

Connect securely to localhost:

```bash
    telnet-ssl -z secure localhost
```

**TELNET, INETD and XINETD** 

After installing (telnetd-ssl and telnet-ssl) the following line will be added to your** /etc/inetd.conf** file:

> telnet stream tcp nowait telnetd /usr/sbin/tcpd /usr/sbin/in.telnetd

If you are indeed using xinetd and **you have disabled (for security reasons) inetd compatibility mode** on **/etc/default/xinetd** specifying this line:

> INETD_COMPAT=No

You will have to** convert the above into /etc/xinetd.conf format**, and add it manually. See /usr/share/doc/xinetd/README.Debian for more information. Suggested entry (automatically converted using itox command) for xinetd.conf or /etc/xinetd.d/telnet is: 

> service telnet { socket_type = stream protocol = tcp wait = no user = telnetd } 

You must use option **-daemon_dir** if you use tcpd instead of **protocol = tcpd**, see **man xinetd.conf **for more information.

