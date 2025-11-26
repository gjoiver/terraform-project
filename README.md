# WordPress en AWS con Terraform

Este proyecto automatiza el despliegue de WordPress en AWS usando Terraform. Básicamente, con unos cuantos comandos se puede tener todo corriendo.

## ¿Qué hace este proyecto?

Crea toda la infraestructura necesaria para tener un WordPress en AWS. No hace falta hacer nada manual, Terraform se encarga de todo. Lo bueno es que queda escalable y con buenas prácticas.

## Componentes que se crean

**Networking:**
- Una VPC propia con dos subnets en diferentes zonas (para que si una zona falla, la otra sigue funcionando)
- Internet Gateway para salida a internet
- Rutas configuradas

**Servidores:**
- Grupo de Auto Scaling que crea entre 1 y 3 servidores según la carga
- Amazon Linux 2023 con PHP 8.2 y Apache ya instalado
- WordPress se instala solo al crear las instancias

**Base de datos:**
- RDS MySQL 8.0 (administrada por AWS, olvídate del mantenimiento)
- Backups automáticos cada día que se guardan 7 días
- Datos cifrados

**Load Balancer:**
- ALB que distribuye el tráfico entre los servidores
- Revisa cada 30 segundos que los servidores funcionen bien

**Seguridad:**
- Security groups configurados para que solo se permita el tráfico necesario
- La base de datos solo acepta conexiones desde los servidores web
- Todo el almacenamiento cifrado

## Estructura de carpetas

```
.
├── main.tf                      # Aquí está la configuración principal
├── variables.tf                 # Todas las variables
├── outputs.tf                   # Los valores que se muestran al final
├── providers.tf                 # Configuración de AWS y el backend S3
├── terraform.tfvars             # Valores personalizados (no subir a Git!)
└── modules/                     # Los módulos separados
    ├── VPC/                     # Todo lo de red
    ├── SecurityGroups/          # Reglas de firewall
    ├── RDS/                     # Base de datos
    ├── EC2/                     # Servidores WordPress
    └── ALB/                     # Load Balancer
```

## Antes de empezar se necesita

**1. Terraform instalado**
```bash
terraform version
```
Debería mostrar la versión. Si no, hay que descargarlo de terraform.io

**2. AWS CLI configurado**
```bash
aws configure
```
Aquí van las credenciales de AWS.

**3. Un SSH Key Pair en AWS**

Para ver cuáles hay disponibles:
```bash
aws ec2 describe-key-pairs --region us-east-1
```

Este proyecto usa "vockey", pero se puede usar cualquiera que exista o crear uno nuevo.

**4. Bucket S3 para el state**

El proyecto está configurado para usar `joiangon.tfstates2025` en us-east-1. Si se quiere usar otro, hay que cambiar el nombre en `providers.tf`.

## Cómo usarlo

### Paso 1 - Ir a la carpeta

```bash
cd c:\Users\Usuario\Documents\aws\.terraform
```

### Paso 2 - Configurar variables

Copiar el archivo de ejemplo:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Editarlo y poner los datos necesarios:
```hcl
aws_region  = "us-east-1"
aws_profile = "default"

db_name     = "wordpressdb"
db_username = "admin"
db_password = "TuPasswordSegura123!"  # Cambiar esto

key_name = "vockey"  # O el key pair que se tenga
```

**Importante:** La password de la BD no puede tener `/`, `@`, `"` ni espacios. AWS es muy estricto con esto.

### Paso 3 - Inicializar

```bash
terraform init
```

Esto descarga todo lo necesario. Solo se hace una vez.

### Paso 4 - Workspace (ambiente)

```bash
# Ver qué workspaces hay
terraform workspace list

# Crear uno nuevo (opcional)
terraform workspace new dev

# Seleccionar uno
terraform workspace select dev
```

Se recomienda usar "dev" para pruebas y "default" para producción.

### Paso 5 - Ver qué va a crear

```bash
terraform plan
```

Hay que leer bien lo que dice. Debería crear como 20 recursos.

### Paso 6 - Crear todo

```bash
terraform apply
```

Escribir `yes` cuando lo pida.

Esto tarda entre 10 y 15 minutos. La RDS es la que más se tarda.

### Paso 7 - Acceder a WordPress

Cuando termine, ejecutar:
```bash
terraform output wordpress_url
```

Dará algo como:
```
http://alb-itm-wordpress-dev-217460736.us-east-1.elb.amazonaws.com
```

Abrir esa URL en el navegador. Puede tardar unos minutos más en cargar la primera vez porque WordPress se está instalando.

## Datos importantes

### URLs

```bash
# Ver todo
terraform output

# Solo la URL de WordPress
terraform output wordpress_url

# URL del admin
terraform output wordpress_admin_url
```

### Conectar WordPress a la BD

Cuando WordPress pida los datos de la base de datos:

```bash
# Ver el endpoint
terraform output db_instance_endpoint
```

Luego usar:
- **Database Name:** wordpressdb
- **Username:** admin
- **Password:** La que se puso en terraform.tfvars
- **Database Host:** El endpoint que mostró el comando de arriba

## Ambientes

Hay dos configurados:

**Default (producción):**
- VPC: 192.168.16.0/24
- Subnets en us-east-1a y us-east-1b

**Dev (desarrollo):**
- VPC: 192.168.16.0/24
- Subnets en us-east-1b y us-east-1c

Se pueden cambiar estos valores en `variables.tf` si hace falta.

## Comandos útiles

**Ver el estado de los servidores:**
```bash
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names ec2_itm_wordpress_dev-asg \
  --region us-east-1
```

**Ver si el load balancer ve los servidores como healthy:**
```bash
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)
```

**Conectarse por SSH a un servidor:**

Primero conseguir la IP:
```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=ec2_itm_wordpress_dev" \
  --query "Reservations[*].Instances[*].[PublicIpAddress]" \
  --output text \
  --region us-east-1
```

Luego conectarse (se necesita el .pem file):
```bash
ssh -i vockey.pem ec2-user@<IP-PUBLICA>
```

## Troubleshooting

**WordPress no carga:**

Hay que darle tiempo, a veces tarda 10-15 minutos después del apply. Verificar que los targets estén healthy:
```bash
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)
```

**No se conecta a la base de datos:**

Revisar que el endpoint sea correcto:
```bash
terraform output db_instance_endpoint
```

Verificar usuario/password en terraform.tfvars. El nombre de la BD debe ser exactamente `wordpressdb`.

**Errores al hacer apply:**

Validar primero:
```bash
terraform validate
```

Verificar que las credenciales AWS funcionen:
```bash
aws sts get-caller-identity
```

Leer el error, Terraform normalmente dice bien qué está mal.

## Mantenimiento

**Actualizar WordPress:**

Conectarse por SSH a un servidor y ejecutar:
```bash
cd /var/www/html
sudo -u apache wp core update
sudo -u apache wp plugin update --all
```

**Actualizar la infraestructura:**

1. Modificar los archivos .tf
2. Ejecutar `terraform plan` para ver qué cambia
3. Si todo se ve bien, ejecutar `terraform apply`

## Backups

Los backups de RDS son automáticos, se crean todos los días a las 3 AM UTC y se guardan 7 días.

Para crear un backup manual:
```bash
aws rds create-db-snapshot \
  --db-instance-identifier vpc-itm-wordpress-dev-db \
  --db-snapshot-identifier wordpress-backup-manual-$(date +%Y%m%d)
```

## Eliminar todo

Cuando se termine y se quiera borrar todo:

```bash
terraform destroy
```

**OJO:** Esto borra TODO. No hay vuelta atrás. Hay que escribir `yes` cuando lo pida.

Se va a borrar:
- Todos los servidores
- El load balancer
- La base de datos (crea un snapshot final por si acaso)
- La VPC completa

El bucket S3 del state NO se borra, ese queda.

## Seguridad

Ya tiene varias cosas implementadas:
- Base de datos cifrada
- Backups automáticos
- Security groups bien configurados
- Solo se abren los puertos necesarios

Mejoras que se podrían hacer:
- Agregar un certificado SSL (HTTPS)
- Restringir SSH solo a IPs específicas
- Activar logs de VPC
- Configurar alarmas en CloudWatch

## Notas

- Este proyecto usa workspaces de Terraform para manejar diferentes ambientes
- El state se guarda en S3, así que si se trabaja en equipo todos ven lo mismo
- Los servidores tienen health checks cada 30 segundos
- La RDS tiene backups de 7 días y logs en CloudWatch

## Versión

**v1.0.0 (2025)**
Primera versión funcional con VPC, EC2 Auto Scaling, RDS MySQL y ALB.

## Autores

- Joiver Andres Gonzalez Coronado
- Carlos Felipe Caro Arroyave

## Soporte

Si hay problemas:
- Revisar los logs de CloudWatch
- Leer la documentación de Terraform: https://www.terraform.io/docs
- Documentación de AWS: https://docs.aws.amazon.com
- Conectarse por SSH y revisar /var/log/cloud-init-output.log

---

**Actualizado:** 2025
