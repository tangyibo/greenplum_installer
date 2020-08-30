BIN_DIR=bin
PKG_BIN=greenplum6-centos7-release.bin
SRC_DIR=src
TMP_TAR_NAME=greenplum.tgz

build:
	if [ ! -d $(BIN_DIR) ]; then mkdir $(BIN_DIR) ; fi;
	tar zcf $(TMP_TAR_NAME) $(SRC_DIR)
	cat ./start.sh $(TMP_TAR_NAME) > $(BIN_DIR)/$(PKG_BIN)
	chmod +x $(BIN_DIR)/$(PKG_BIN)
	rm -f $(TMP_TAR_NAME)
	cp ./account.txt $(BIN_DIR)/
clean:
	rm -rf $(BIN_DIR)/*
	rm -f $(TMP_TAR_NAME)

all:clean build
