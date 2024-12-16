FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y proftpd nano

RUN mkdir -p /srv/ftp

COPY ./Recursos_Contenedor_1 /srv/ftp

RUN chown -R ftp /srv/ftp && \
    chmod -R 755 /srv/ftp


RUN echo "RequireValidShell off" >> /etc/proftpd/proftpd.conf && \
    echo "DefaultRoot /srv/ftp" >> /etc/proftpd/proftpd.conf && \
    echo "<Anonymous ~ftp>" >> /etc/proftpd/proftpd.conf && \
    echo "  User ftp" >> /etc/proftpd/proftpd.conf && \
    echo "  Group ftp" >> /etc/proftpd/proftpd.conf && \
    echo "  UserAlias anonymous ftp" >> /etc/proftpd/proftpd.conf && \
    echo "  MaxClients 10" >> /etc/proftpd/proftpd.conf && \
    echo "  RequireValidShell off" >> /etc/proftpd/proftpd.conf && \
    echo "    <Limit WRITE>" >> /etc/proftpd/proftpd.conf && \
    echo "      DenyAll" >> /etc/proftpd/proftpd.conf && \
    echo "    </Limit>" >> /etc/proftpd/proftpd.conf && \
    echo "    <Limit READ>" >> /etc/proftpd/proftpd.conf && \
    echo "      AllowAll" >> /etc/proftpd/proftpd.conf && \
    echo "    </Limit>" >> /etc/proftpd/proftpd.conf && \
    echo "</Anonymous>" >> /etc/proftpd/proftpd.conf && \
    echo "PassivePorts 50000 50030" >> /etc/proftpd/proftpd.conf && \
    echo "MasqueradeAddress 192.168.0.13" >> /etc/proftpd/proftpd.conf && \
    echo "Port 21" >> /etc/proftpd/proftpd.conf

EXPOSE 21 50000-50030


CMD ["proftpd", "--nodaemon"]