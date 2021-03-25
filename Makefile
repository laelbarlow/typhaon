# Makefile for facilitating common operations on this code repository.

SHELL=/bin/bash

install:
	bash scripts/install.sh

dry_run:
	bash scripts/dry_run.sh

touch:
	bash scripts/touch_intermediate_files.sh

run_fasttree:
	nohup bash scripts/run_superfast_fasttree.sh & echo $$! > pid_nohup.txt

run_ml_search_iqtree:
	nohup bash scripts/run_ml_search_iqtree.sh & echo $$! > pid_nohup.txt

run_au_test_iqtree:
	nohup bash scripts/run_au_test_iqtree.sh & echo $$! > pid_nohup.txt

run_ultrafast_iqtree:
	nohup bash scripts/run_ultrafast_iqtree.sh & echo $$! > pid_nohup.txt

run_standard_iqtree:
	nohup bash scripts/run_standard_iqtree.sh & echo $$! > pid_nohup.txt

run:
	nohup bash scripts/run_workflow.sh & echo $$! > pid_nohup.txt

archive:
	nohup bash scripts/archive_workflow.sh & echo $$! > pid_nohup.txt

killall:
	kill -9 `cat pid_nohup.txt`
	rm pid_nohup.txt
	killall -TERM snakemake
	echo Jobs may still be running on the cluster. Cancel those manually, if necessary.

clean:
	-rm nohup.out
	-rm pid_nohup.txt
	-rm slurm*

clean_results:
	rm -rf results/*

clean_virtualenvs:
	bash scripts/clean_virtualenvs.sh

unlock:
	bash scripts/unlock_workflow.sh

uninstall:
	bash scripts/uninstall.sh



.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


