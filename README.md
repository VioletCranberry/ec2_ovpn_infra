
#### Simple and expandable `EC2` `OpenVPN` infra managed by `Ansible` and `Terraform`.   
Prerequisites per region (`terraform`):
```
1. Configure TF provider based on your AWS credentials
   - infra/<region>/provider.tf
2. Have SSH and SSH.pub keys ready
   - modules/openvpn-instance/files/<region>
```
Execute:
```
cd /helpers 
./setup.sh -a && ./setup.sh -c
```
`.ovpn` config file will be automatically generated and placed under `helpers` directory,  
`OpenVpn` related keys and certificates both for `server` and `client` will be placed under `config` directory.  

Destroy:
```
./setup.sh -d
```
