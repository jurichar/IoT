# PART I

## To begin, you have to set up 2 machines

Write your first Vagrantfile using the latest stable version of the distribution of your choice as your operating system.

It is STRONGLY advised to allow only the bare minimum in terms of resources:

1 CPU, 512 MB of RAM (or 1024). The machines must be run using Vagrant.

## Here are the expected specifications:

* The machine names must be the login of someone of your team. The hostname
of the first machine must be followed by the capital letter S (like Server).

The hostname of the second machine must be followed by SW (like ServerWorker).

* Have a dedicated IP on the eth1 interface.

The IP of the first machine (Server) will be 192.168.56.110, and the IP of the second machine (ServerWorker) will be 192.168.56.111.

* Be able to connect with SSH on both machines with no password.

> You will set up your Vagrantfile according to modern practices.

## You must install K3s on both machines:

• In the first one (Server), it will be installed in controller mode.

• In the second one (ServerWorker), in agent mode.

> You will have to use kubectl (and therefore install it too).

## Here is an example basic Vagrantfile:

```bash
$> cat Vagrantfile
Vagrant.configure(2) do |config|
    [...]
    config.vm.box = REDACTED
    config.vm.box_url = REDACTED

    config.vm.define "wilS" do |control|
            control.vm.hostname = "wilS"
            control.vm.network REDACTED, ip: "192.168.56.110"
            control.vm.provider REDACTED do |v|
                v.customize ["modifyvm", :id, "--name", "wilS"]
                [...]
        end
        config.vm.provision :shell, :inline => SHELL
            [...]
        SHELL
            control.vm.provision "shell", path: REDACTED
    end
    config.vm.define "wilSW" do |control|
            control.vm.hostname = "wilSW"
            control.vm.network REDACTED, ip: "192.168.56.111"
            control.vm.provider REDACTED do |v|
                v.customize ["modifyvm", :id, "--name", "wilSW"]
                [...]
            end
            config.vm.provision "shell", inline: <<-SHELL
                [..]
            SHELL
            control.vm.provision "shell", path: REDACTED
    end
end
```

## Here is an example when the virtual machines are launched:

```bash
$> p1 vagrant up
Bringing machine 'wils' up with 'virutalbox' provider...
Bringing machine 'wilsw' up with 'virutalbox' provider...
[...]
$> p1 vagrand ssh wils
$> p1 vagrand ssh wilsw
```

## When the machines are setup correctly:

```bash
$> k get nodes -o wide
NAME  STATUS ROLES [...]
wils  Ready [...]
wilsw Ready [...]
