.PHONY: init plan apply destroy

reconfigure:
	terraform -chdir=infra init -reconfigure

init:
	terraform -chdir=infra init

plan: init
	terraform -chdir=infra plan

apply: init
	terraform -chdir=infra apply #-auto-approve

destroy: init
	terraform -chdir=infra destroy