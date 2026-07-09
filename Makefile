.PHONY: provision deploy all destroy

# --- Infra ---
provision:
	cd terraform && terraform init && terraform apply -auto-approve

destroy:
	cd terraform && terraform destroy -auto-approve

# --- App ---
deploy:
	cd ansible && ansible-galaxy collection install -r requirements.yml
	cd ansible && ansible-playbook playbook.yml

all: provision deploy
