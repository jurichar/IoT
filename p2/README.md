En premier nous faisons un vagrantfile comme dans la partie une mais avec uniquement la partie server.

ensuite nous allons deployer nos 3 applications.

Chaque une sera accessible en fonction du HOST utiliser.

a l'adresse 192.186.20.110.

Nous avons des sous dossier de chaque services dans le dossier files que nous allons copier dans la VM server.

Usefull commands :

vagrant up -> pour demarrer la VM
vagrant global-status -> lister toutes les VMs
vagrant halt -> pour arreter la VM
kubectl describe <pod>
kubectl get all