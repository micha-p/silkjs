ARCH := $(shell getconf LONG_BIT)

RELEASE := $(shell lsb_release -sr)

GROUP = admin
ifeq ($(RELEASE),12.04)
	GROUP=sudo
endif
ifeq ($(RELEASE),12.10)
	GROUP=sudo
endif
ifeq ($(RELEASE),13.04)
	GROUP=sudo
endif
ifeq ($(RELEASE),14)
	GROUP=sudo
endif

CORE=	main.o base64.o global.o console.o process.o net.o fs.o buffer.o v8.o http.o md5.o popen.o linenoise.o async.o time.o watchdog.o

OBJ=	mysql.o memcached.o gd.o ncurses.o sem.o logfile.o sqlite3.o xhrhelper.o curl.o ssh2.o sftp.o ftp.o ftplib.o editline.o cairo.o expat.o
#OBJ=	memcached.o gd.o ncurses.o sem.o logfile.o sqlite3.o xhrhelper.o curl.o ssh2.o sftp.o ftp.o ftplib.o editline.o cairo.o expat.o

V8LIBS = -lv8

INCDIRS=    -I/usr/include/mysql

LIBDIRS=    

CFLAGS = -fexceptions -fomit-frame-pointer -fdata-sections -ffunction-sections -fno-strict-aliasing -fvisibility=hidden -Wall -W -Wno-ignored-qualifiers -Wno-unused-function -Wno-unused-parameter -Wnon-virtual-dtor -m$(ARCH) -O3 -fomit-frame-pointer -fdata-sections -ffunction-sections -ansi -fno-strict-aliasing -DNEW_MEMCACHED

%.o: %.cpp SilkJS.h 
	g++ $(CFLAGS) -c $(INCDIRS) -o $*.o $*.cpp

silkjs: deps $(V8) $(CORE) $(OBJ) SilkJS.h Makefile
	g++ -o silkjs $(CORE) $(OBJ) $(V8LIBS) -lmysqlclient -lmm -lgd -lncurses -lssl -lpthread -lsqlite3 -lcurl -lssh2 -lmemcached -lcairo -ldl -lexpat -Wl,-rpath=/usr/local/silkjs/src/v8 

deps: 
	if [ ! "`dpkg-query -s libmm-dev`" ]; then sudo apt-get -y install libmm-dev; fi 
	if [ ! "`dpkg-query -s libmysqlclient-dev`" ]; then sudo apt-get -y install libmysqlclient-dev; fi 
	if [ ! "`dpkg-query -s libmemcached-dev`" ]; then sudo apt-get -y install libmemcached-dev; fi 
	if [ ! "`dpkg-query -s libgd2-dev`" ]; then sudo apt-get -y install libgd2-dev; fi 
	if [ ! "`dpkg-query -s libncurses5-dev`" ]; then sudo apt-get -y install libncurses5-dev; fi 
	if [ ! "`dpkg-query -s libsqlite3-dev`" ]; then sudo apt-get -y install libsqlite3-dev; fi 
	if [ ! "`dpkg-query -s libcurl4-openssl-dev`" ]; then sudo apt-get -y install libcurl4-openssl-dev; fi 
	if [ ! "`dpkg-query -s libssh2-1-dev`" ]; then sudo apt-get -y install libssh2-1-dev; fi 
	if [ ! "`dpkg-query -s libcairo2-dev`" ]; then sudo apt-get -y install libcairo2-dev; fi 

$(V8):
	if [ ! "`dpkg-query -s libv8-dev`" ]; then sudo apt-get -y install libv8-dev; fi 

debug:	    CFLAGS += -g
debug:	    silkjs
	
bootstrap:  CFLAGS += -DBOOTSTRAP_SILKJS

bootstrap:  $(V8) $(CORE) SilkJS.h Makefile
	g++ $(CFLAGS) -o bootstrap-silkjs $(CORE) $(V8LIBS)

perms:
	sudo chgrp $(GROUP)  /usr/local /usr/local/bin 
	sudo chmod g+rwx /usr/local /usr/local/bin

install:	silkjs perms
	@rm -rf /usr/local/silkjs/builtin /usr/local/silkjs/bin /usr/local/silkjs/httpd /usr/local/silkjs/lib /usr/local/silkjs/modules /usr/local/silkjs/walkthrough /usr/local/silkjs/src
	@mkdir -p /usr/local/bin /usr/local/silkjs /usr/local/silkjs/src/v8 /usr/local/silkjs/projects /usr/local/silkjs/contrib
	cp -rp ../builtin ../examples ../httpd ../lib ../modules ../walkthrough /usr/local/silkjs
	cp ../src/*.cpp ../src/*.h /usr/local/silkjs/src
	cp -rp $(V8DIR)/include $(V8) /usr/local/silkjs/src/v8
	mv /usr/local/silkjs/examples /usr/local/silkjs/bin
	chmod 755 /usr/local/silkjs/bin/* /usr/local/silkjs/httpd/main.js
	cp silkjs /usr/local/silkjs/bin
	ln -sf /usr/local/silkjs/bin/silkjs /usr/local/bin
	ln -sf /usr/local/silkjs/httpd/main.js /usr/local/bin/httpd-silk.js
		
clean:
	rm -rf silkjs *.o

realclean:
	rm -rf silkjs *.o

release: silkjs
	tar czvfp ~/SilkJS.tgz silkjs examples httpd lib

$(OBJ): SilkJS.h Makefile

$(CORE): SilkJS.h Makefile
