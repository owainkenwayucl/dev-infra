
terraforminit: 
	terraform init
	touch terraforminit

buildvms: terraforminit
	terraform apply
	touch buildvms

deploy: buildvms
	ansible-playbook -i generate_inventory.py full.yaml
	touch deploy

clean:
	rm -rf .generated/ terraforminit buildvms deploy
	terraform destroy

.PHONY: clean 