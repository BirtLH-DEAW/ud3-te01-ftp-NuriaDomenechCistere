FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y proftpd proftpd-mod-crypto openssl


RUN mkdir -p /srv/deaw && \
    chown -R 1000:1000 /srv/deaw && \
    chmod 777 /srv/deaw

COPY ./Recursos_Contenedor_2 /srv/deaw
RUN useradd -m -d /srv/deaw -s /usr/sbin/nologin deaw && \
    echo "deaw:1234" | chpasswd

RUN echo "<IfModule mod_tls.c>\n\
TLSEngine on\n\
TLSLog /var/log/proftpd/tls.log\n\
TLSProtocol TLSv1 TLSv1.1 TLSv1.2\n\
TLSRSACertificateFile /etc/ssl/certs/proftpd.crt\n\
TLSRSACertificateKeyFile /etc/ssl/private/proftpd.key\n\
TLSVerifyClient off\n\
TLSRequired on\n\
</IfModule>" > /etc/proftpd/tls.conf
RUN echo "PassivePorts 50000 50030" >> /etc/proftpd/proftpd.conf && \
    echo "Include /etc/proftpd/tls.conf" >> /etc/proftpd/proftpd.conf && \
    echo "DefaultRoot /srv/deaw deaw" >> /etc/proftpd/proftpd.conf && \
    echo "RequireValidShell off" >> /etc/proftpd/proftpd.conf && \
    echo "MasqueradeAddress 192.168.0.13" >> /etc/proftpd/proftpd.conf && \
    echo "<Directory /srv/deaw>\n  Umask 022\n  AllowOverwrite on\n  <Limit LOGIN>\n    DenyAll\n  </Limit>\n  <Limit READ WRITE>\n    AllowUser deaw\n  </Limit>\n</Directory>" >> /etc/proftpd/proftpd.conf
RUN echo "LoadModule mod_tls.c" >> /etc/proftpd/modules.conf
RUN openssl req -new -x509 -days 365 -nodes -newkey rsa:4096 -keyout /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt \
    -subj "/C=ES/ST=Araba/L=Vitoria/O=Birt/OU=Deaw/CN=ndomenech@birt.eus"
RUN chmod 0600 /etc/ssl/private/proftpd.key && \
    chmod 0644 /etc/ssl/certs/proftpd.crt
EXPOSE 21 50000-50030

CMD ["proftpd", "--nodaemon"]


