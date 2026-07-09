# omada-homelab

IaC for the Omada Software Controller, running as a Proxmox VM. Mirrors the
`nautobot-homelab` structure: Terraform provisions the VM, Ansible deploys the
controller as a Docker Compose stack.

Replaces the lost OC200 hardware appliance with a reproducible, version-controlled
software controller.

## Layout

```
terraform/   bpg/proxmox VM clone from template 9000 on grid
ansible/     Docker + Compose deployment of the controller (mbentley image)
Makefile     provision / deploy / all / destroy
```

## VM

| What      | Value             |
|-----------|-------------------|
| VMID / IP | 249 / 192.168.0.249 |
| Node      | grid              |
| Resources | 2 vCPU, 4 GB, 40 GB |
| Template  | 9000 (Ubuntu cloud-init) |

4 GB RAM because the controller bundles MongoDB.

## Build

```bash
# Terraform needs the Proxmox token. Either create terraform/terraform.tfvars
# from the example, or export:
export TF_VAR_proxmox_api_token_id='terraform@pam!t2'
export TF_VAR_proxmox_api_token_secret='...'   # from Vault: homelab/proxmox

make provision   # clone + boot the VM
make deploy      # install Docker, run the controller container
```

Then browse to `https://192.168.0.249:8043/` and complete first-run setup
(admin account, controller name). Adopt the EAPs from the Devices page.

## Networking

The container runs with `network_mode: host` so device discovery and adoption
broadcasts reach the APs directly. Ports in use: 8088 (HTTP), 8043 (HTTPS),
8843 (portal), 29810-29816 + 27001/udp (discovery/adoption).

## Notes

- Controller config + adopted-device state live in the `omada-data` Docker
  volume. Back that up before major upgrades.
- The image tag is pinned in `ansible/group_vars/all/main.yml`. Omada is picky
  about MongoDB major versions across controller releases; the bundled image
  handles that internally, which is why the Docker path is preferred over a
  native `.deb` install.
