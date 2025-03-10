# PIN2403-Grupo12

## Pasos para el deploy

### 1. Clonación del repositorio

```
git clone https://github.com/ssuarezarg/PIN2403-Grupo12.git
cd PIN2403-Grupo12

```
Este paso descarga el código fuente del repositorio y se mueve al directorio del proyecto. Es la base para el resto de operaciones.

### 2. Instalación de Terraform

```
sudo apt update
sudo apt install -y wget
sudo apt install -y lsb-release
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
```

Aquí se instala Terraform, una herramienta para infraestructura como código (IaC). El proceso incluye:
1. Actualizar los repositorios
2. Instalar dependencias (wget, lsb-release)
3. Agregar la clave GPG de HashiCorp
4. Configurar el repositorio oficial de HashiCorp
5. Instalar Terraform

### 3. Instalación de MicroK8s

```
sudo apt install snapd -y
sudo snap install microk8s --classic
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
source ~/.bashrc
```

Se instala MicroK8s, una versión ligera de Kubernetes para desarrollo local o entornos pequeños:
1. Instala snapd (el gestor de paquetes para snaps)
2. Instala MicroK8s con la opción '--classic'
3. Agrega el directorio de snap al PATH

### 4. Configuración de permisos para MicroK8s

```
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s
```

Estos comandos:
1. Agregan el usuario actual al grupo 'microk8s'
2. Asignan los permisos correctos para el directorio .kube
3. Cambian al nuevo grupo sin necesidad de reiniciar la sesión

### 5. Habilitación de complementos de MicroK8s
```
microk8s enable dns storage ingress helm3
```

Activa componentes esenciales:
1. dns: resolución de nombres dentro del clúster
2. storage: almacenamiento persistente
3. ingress: controlador para exponer servicios al exterior
4. helm3: gestor de paquetes para Kubernetes

### 6. Configuración de kubectl

```
mkdir -p ~/.kube
microk8s config > ~/.kube/config
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
source ~/.bashrc
```

Configura la herramienta kubectl para interactuar con el clúster:
1. Crea el directorio .kube si no existe
2. Genera el archivo de configuración
3. Crea un alias para simplificar comandos

### 7. Despliegue con Terraform

```
terraform init
terraform plan
terraform apply -auto-approve
```

Inicializa y despliega la infraestructura definida en archivos Terraform:
1. init: descarga plugins y módulos necesarios
2. plan: muestra los cambios que se aplicarán
3. apply: implementa los cambios

### 8. Verificación del clúster

```
kubectl get nodes
```
Verifica que el clúster esté funcionando correctamente mostrando los nodos disponibles.



## DESDE ACA NO VA
### 9. Instalación de Jenkins

```
microk8s helm3 repo add jenkins https://charts.jenkins.io
microk8s helm3 repo update
microk8s helm3 install jenkins jenkins/jenkins -f offline-jenkins-values.yaml -n jenkins
```

Instala Jenkins para integración continua/entrega continua:
Agrega el repositorio Helm oficial
Actualiza los repositorios
Instala Jenkins usando valores personalizados del archivo offline-jenkins-values.yaml

### 10. Despliegue de Nginx

```
kubectl apply -f nginx-deployment.yaml
```

Despliega un servidor Nginx definido en el archivo yaml.

### 11. Instalación de Prometheus y Grafana

```
microk8s helm3 repo add prometheus-community https://prometheus-community.github.io/helm-charts
microk8s helm3 repo update
microk8s helm3 install prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring -f monitoring-values.yaml
```

Configura herramientas de monitoreo:
Prometheus: recolección de métricas
Grafana: visualización de métricas

### 12. Configuración del monitoreo para Nginx

```
kubectl apply -f nginx-monitor.yaml
```

Aplica la configuración para que Prometheus monitoree el servicio Nginx.

### 13. Obtención de credenciales de Grafana

```
kubectl get secret -n monitoring prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

### 14. Validaciones

1. Probar Jenkins
```
curl -I http://localhost:32000
```
2. Probar Nginx
```
curl -I http://localhost:30080
```
3. Probar Grafana
```
curl -I http://localhost:31000
```
