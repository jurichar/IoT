En premier nous faisons un vagrantfile comme dans la partie une mais avec uniquement la partie server.

On va ensuite copier les fichiers vers la VM.

On va attribuer les spec a la VM.

Puis lancer le script.

Dans ce script on va installer k3s puis appliquer les differents services app1, app2 et app3 ainsi que qu'un ingress controller.

Pour tester on peut utiliser kubectl get all et on voit les differents services qui tournent.

On peut aussi tester un service plus specifiquement avec :
`curl -H "Host:app1.com" 192.168.56.110`

Ici on utilise l'host app1.com mais cela fonctionne avec app2.com.

Si l'on utilise pas d'host, on est alors rediriger vers app3, comme le demande le sujet.