
default: deploy

terraforminit: 
	terraform init
	touch terraforminit

buildvms: terraforminit Makefile
	terraform apply
	sleep 60
	touch buildvms

deploy: buildvms Makefile
	ansible-playbook -i generate_inventory.py full.yaml
	touch deploy

clean:
	rm -rf .generated/ terraforminit buildvms deploy
	terraform destroy

.PHONY: clean 