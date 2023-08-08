# Part 3 ARGOCD + K3D

## Setup

launch `setup.sh`

you have to `port-forward` manually :

`sudo kubectl port-forward -n argocd service/argocd-server 8080:443` : for ARGOCD
`sudo kubectl port-forward -n dev service/wil-service 8888:8888` : for wil-application

you can delete App folder and :

`git clone https://github.com/m3L4n/mpochard-config.git App`

and switch between versions in file :

`App/app-deploy.yaml` at `image: wil42/playground:[version]`.