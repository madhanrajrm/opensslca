# CONTAINERIZED CERTIFICATE AUTHORITY USING OPENSSL AND DOCKER


Cons of Using Standalone CA: - 
1.	Time taken process to bring up new CA server.
2.	Common Certificate Authority for everyone results in unforeseen deletions in environments.
3.	Unable to use latest openssl features because of OS dependencies. 
4.	Unable to start multiple responders to test simultaneously. 
5.	Virtual Machine Memory and CPUs are consumed. 

To overcome most of the above use cases. I have containerized the entire process into single docker image. 

Using this Image: - 
1.	We can bring up n-numbers of openssl CA within minutes. 
2.	Since it is containerized no need of any separate VM’s. All we need is Docker to start the container on your laptop or anywhere for that matter.
3.	Individual CA’s so no words for any overlapping or deletion of setup. 
4.	Build with latest Alma Linux 9 and Openssl 3.0 so we can use all latest features. Also, easy upgrade of OS whenever we need with just few commands rather than complete installation of OS.  

I have hosted this in  docker hub repository as public : - 
         madhanrajr/opensslca:latest

You can find my source code at:- https://github.com/madhanrajrm/opensslca




## How to start this Docker based Openssl CA :- 

        Pre-requisite: -   1. Basic Knowledge of Docker and Docker CLI Commands. 
                           2. Docker & Docker-compose should be installed either on Laptop or on any linux server. 

  Step 1:   Copy this below Docker-Compose File to you local directory. For instance, here I have created an folder and created and docker-compose.yml file with below contents: - 

```
[root@infy-security-docker OPENSSLCA]# cat  docker-compose.yml
---
version: "2.1"
services:
   opensslca:
    image: madhanrajr/opensslca:latest
    container_name: opensslca                                                  
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    ports:
      - 443:443/tcp
      - 8443:8443/tcp
    restart: unless-stopped
```
Step 2 :-  Just start the container by running Docker-compose up :- 

```
[root@infy-security-docker OPENSSLCA]# docker-compose -f docker-compose.yml up -d
Creating network "opensslca_default" with the default driver
Pulling opensslca (containers.cisco.com/madhraje/opensslca:latest)...
latest: Pulling from madhraje/opensslca
63c7cbfce3f3: Already exists
ae6d53037e13: Already exists
0e04ef583264: Pull complete
Digest: sha256:232c99b39dbe08bfab450358cce43990270c175c473fe60b7d3f0600ba743b79
Status: Downloaded newer image for containers.cisco.com/madhraje/opensslca:latest
Creating opensslca ... done
[root@infy-security-docker OPENSSLCA]#


[root@infy-security-docker OPENSSLCA]# docker ps
CONTAINER ID   IMAGE                                            COMMAND                  CREATED         STATUS         PORTS                                                                                                                         NAMES
0ae7adbe53f0   containers.cisco.com/madhraje/opensslca:latest   "/bin/sh -c 'tail -f…"   8 seconds ago   Up 6 seconds   0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:8443->8443/tcp, :::8443->8443/tcp                                              opensslca
```
## How To Access Inside container and sign your CSR’s :- 


Once the container is up we have go inside the container to access CA folders. 
```
[root@infy-security-docker OPENSSLCA]# docker-compose -f docker-compose.yml up -d
Creating network "opensslca_default" with the default driver
Creating opensslca ... done
[root@infy-security-docker OPENSSLCA] #
```
We just go inside the container as below and that’s it you can find all you 3 levels of CA there ready for issuing certs. 
```
[root@infy-security-docker OPENSSLCA]# docker exec -it opensslca bash
[root@b7675cf09f6f ~]#
[root@b7675cf09f6f ~]# ls -ltr
drwxr-xr-x. 5 root root 52 May 15 03:52 CA
drwxr-xr-x. 4 root root 95 Aug  9 21:27 SIGNCERTS

Inside CA folder you have  all CA folder structures. 

[root@b7675cf09f6f ~]# cd CA/
[root@b7675cf09f6f CA]# ls -ltr
total 0
drwxr-xr-x. 7 root root 219 Oct 16 18:56 INTERCA1
drwxr-xr-x. 6 root root 198 Oct 16 18:56 ROOTCA
drwxr-xr-x. 7 root root 209 Oct 16 18:56 INTERCA2
[root@b7675cf09f6f CA]# cd INTERCA1/
[root@b7675cf09f6f INTERCA1]# ls -ltr
total 24
-rw-r--r--. 1 root root    5 May 23  2022 serial.old
-rw-r--r--. 1 root root    0 May 23  2022 log.txt
-rw-r--r--. 1 root root    5 May 23  2022 crlnumber.old
drwxr-xr-x. 2 root root    6 May 23  2022 crl
drwx------. 2 root root   34 May 23  2022 private
drwxr-xr-x. 2 root root   34 May 23  2022 csr
drwxr-xr-x. 2 root root   35 May 23  2022 certs
-rw-r--r--. 1 root root    0 May 23  2022 index.txt.old
-rw-r--r--. 1 root root    5 May 23  2022 serial
-rw-r--r--. 1 root root   21 May 23  2022 index.txt.attr
-rw-r--r--. 1 root root 4490 Apr 12  2023 openssl.cnf
drwxr-xr-x. 2 root root    6 Oct 16 18:32 newcerts
-rw-r--r--. 1 root root    0 Oct 16 18:56 index.txt
[root@b7675cf09f6f INTERCA1]#

```
If we go to SIGNCERTS Folder it has an code base to automatically talk with any REST API Supported product in order  to generate and get CSR using  REST API’s. We should be able to enhance those more to even automate things. 

Likewise you can repeat above 2 steps just by changing the name(highlighted) in above step1 .
In Order to stop or Kill the container :- 
```
Step 3: - You can bring down the container using docker-compose down command. 
[root@infy-security-docker OPENSSLCA]# docker-compose -f docker-compose.yml down
Stopping opensslca ... done
Removing opensslca ... done
Removing network opensslca_default
[root@infy-security-docker OPENSSLCA]#

```



