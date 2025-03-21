## 1. Provision the VM

```bash
provision_vm.sh
```

## 2. SSH into the VM

```bash
ssh azureuser@<ip>
```

## 3. Install the runner as a service

Detta måste göras manuellt via Github. Följ stegen som visas i Github Actions.
Istället för att köra ./run kör:

```bash
sudo ./svc.sh install azureuser
```

```bash
sudo ./svc.sh start
```
