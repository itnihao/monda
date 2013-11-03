
# Monda Makefile
-include config.mk
ifneq ($(C),)
include config-$(C).mk
endif
include lib.mk

all analyze: _test $(foreach host,$(HOSTS),$(host))

_test: _testconf _testtools _config.inc.php

_testconf:
ifeq ($(ZABBIX_USER),)
	@echo "\nYou must define all variables in config.mk before use!\nYou can use 'cp config.mk.dist config.mk' for start but edit your values to fit your setup!\n"
	@exit 2
endif
ifeq ($(ZABBIX_USER),somewebuser)
	@echo "\nYou cannot use distribution config file! Edit config.mk first!\n"
endif

_testtools:
	$(call testtool,octave,Install GNU Octave first and do not forget signaling toolkit!)
	$(call testtool,php,Install PHP first!)

_config.inc.php config:
	@echo "<?php \
	define('ZABBIX_USER','$(ZABBIX_USER)'); \
	define('ZABBIX_PW','$(ZABBIX_PW)'); \
	define('ZABBIX_URL','$(ZABBIX_URL)'); \
	define('ZABBIX_DB_TYPE','$(ZABBIX_DB_TYPE)'); \
	define('ZABBIX_DB_SERVER','$(ZABBIX_DB_SERVER)'); \
	define('ZABBIX_DB_PORT',$(ZABBIX_DB_PORT)); \
	define('ZABBIX_DB','$(ZABBIX_DB)'); \
	define('ZABBIX_DB_USER','$(ZABBIX_DB_USER)'); \
	define('ZABBIX_DB_PASSWORD','$(ZABBIX_DB_PASSWORD)'); \
	" >config.inc.php
	@mkdir -p out

info:
	@echo Hosts: $(foreach host,$(HOSTS),$(host))
	@echo TIME_START=$(TIME_START)
	@echo TIME_TO=$(TIME_TO)
	@echo TIME_STEP=$(TIME_STEP)
	@echo Starts: $(START_DATES_NICE)
	@echo Intervals: $(INTERVALS) 

clean:	$(foreach host,$(HOSTS),$(host)-clean)
	rm -f config.inc.php *.out
	$(MAKE) config

%.az:	%.m
	./analyze.m $< $@
	
patchdb:
	$(ZSQL) <sql_triggers_backuptables.sql

reorderdb:
	$(ZSQLC) 'alter table history_uint_backup order by clock,itemid'
	$(ZSQLC) 'alter table history_backup order by clock,itemid'
	$(ZSQLC) 'alter table trends_uint_backup order by clock,itemid'
	$(ZSQLC) 'alter table trends_backup order by clock,itemid'

query:
	$(ZSQLC) '$(Q)'

# Create all targets
$(foreach host,$(HOSTS),$(eval $(call analyze/host,$(host))))
