
## Create namespace
```bash
kubectl create namespace nupic
```
if you use a name other than nupic, carry that adjustment througout this document.

## Create model repository
### deploy model repository as persistent volume within the cluster
```bash
kubectl -n nupic apply -f pv.yaml
kubectl -n nupic apply -f pvc.yaml
```
- open `f5xc-triton/values.yaml`
- set *loadmodels -> enabled* to true
```yaml
loadmodels:
  enabled: true
```
### deploy elsewhere 
- open `f5xc-triton/values.yaml`
- set *loadmodels -> enabled* to false
```yaml
loadmodels:
  enabled: false
```
and replace the *models* volume as appropriate for your alternate location 
```yaml
volumes: 
  - name: models
    persistentVolumeClaim:
      claimName: nupic-models
```


## Deploy the triton inference server
This assumes a helm release name of *nupic*. If you want to change it there are many, currently undocumented, locations you'll have to adjust.
```bash
helm -n nupic install nupic ./f5xc-triton/
```


## Deploy the prometheus server pointing to the triton server

```bash
helm -n nupic install nupic-metrics ./f5xc-prometheus/
```
### verify that the prometheus server is scraping the metrics of the triton server
This is very manual. A better solution will come around eventually.
- forward the prometheus service to a port on localhost
```bash
kubectl port-forward -n nupic svc/nupic-metrics-f5xc-prometheus 9090
```
which should respond with 
```bash
Forwarding from 127.0.0.1:9090 -> 9090
Forwarding from [::1]:9090 -> 9090
Handling connection for 9090
Handling connection for 9090
```
- open a browser to `http://localhost:9090` and you should see the prometheus application.
- navigate to Status -> Targets
- verify that all target endpoints are *UP*
- use `ctrl-C` to end the port forwarding


## Deploy the grafana server to point to the prometheus server

```bash
helm -n nupic install nupic-dashboard ./f5xc-grafana/
```

### configure the prometheus datasource 

The kubernetes service for prometheus is at `http://nupic-metrics-f5xc-prometheus:9090`

### import a simple dashboard for the triton metrics

using the dashboard import features of Grafana, import the content of [dashboard.json](./dashboard.json)

## Configure HTTP Load Balancers
Currently manual steps which will ultimately be automated.
### ... for the inference server
TBD
### ... for the dashboard
TBD