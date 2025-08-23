# Guía de Terraform con AWS

## 1. Configuración inicial en AWS
### 1.1. Crear un Usuario IAM en AWS con Permisos de Admin

1. Accede a la consola de AWS: https://console.aws.amazon.com/
2. Ve al servicio **IAM (Identity and Access Management)**.
3. En el menú lateral, selecciona **Users** y haz clic en **Add users**.
4. Ingresa un nombre de usuario (por ejemplo, `tech-user`) y haz click en **Siguiente**.
5. En la sección **Permissions**, selecciona **Attach existing policies directly**.
6. Busca y selecciona la política **AdministratorAccess**.
7. Finaliza la creación y haz click en **View user**.
8. Selecciona **Create access key**, elige **Command Line Interface (CLI)**, genera las claves de acceso (Access Key ID y Secret Access Key) y guárdalas.

---
### 1.2. Crear una Key Pair para EC2

1. Accede a la consola de AWS: https://console.aws.amazon.com/
2. Ve al servicio **EC2**.
3. En el menú lateral, selecciona **Key Pairs** (o **Par de claves**).
4. Haz clic en **Create key pair** (o **Crear par de claves**).
5. Ingresa un nombre para la key, por ejemplo: `default-key-ec2-username` reemplazando `username` por tu nombre.
6. Selecciona el tipo de clave (recomendado: **RSA**) y el formato de archivo (**.pem**).
7. Haz clic en **Create key pair**.
8. Se descargará automáticamente el archivo de la clave privada. Guárdalo en un lugar seguro, ya que no podrás descargarlo nuevamente.

> **Importante:** Esta clave será necesaria para conectarte a tus instancias EC2 mediante SSH.

## 2. Instalación de herramientas
### 2.1. Instalar Terraform

Ingresa a la siguiente URL para descargar el instalador según tu sistema operativo.
```
https://developer.hashicorp.com/terraform/install
```

---

### 2.2. Instalar AWS CLI
Ingresa a la siguiente URL para descargar el instalador según tu sistema operativo.

```
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions
```

Para tener tu equipo configurado AWS con tu usuario IAM hay que ejecutar el siguiente comando y configurar los valores necesarios.

```bash
aws configure
```

Ingresa lo siguiente cuando se te solicite:

* **AWS Access Key ID**: `<tu-access-key-id>`
* **AWS Secret Access Key**: `<tu-secret-access-key>`
* **Default region name**: `us-east-1`
* **Default output format**: `json` (opcional)

## 3. Crear backend de Terraform

Terraform necesita un **bucket S3** para guardar el estado de la infraestructura y bloquear cambios simultáneos. Esto se llama **backend remoto**.

La nomenclatura de nombres será:  

- **Bucket S3:** `s3-tf-<proyecto>-<ambiente>`  

Por ejemplo, si el proyecto se llama `myapp` y el ambiente es `dev`, los nombres serán:  

- `s3-tf-myapp-dev`  

---

### Pasos para crear los recursos

1. Abre una terminal local con **AWS CLI configurado**.  
2. Ejecuta los siguientes comandos (reemplaza `myapp` y `dev` con tu caso):  

```bash
# Crear bucket S3 para el estado
aws s3api create-bucket \
  --bucket "s3-tf-myapp-dev" \
  --region "us-east-1"

# Habilitar versionado (permite recuperar estados previos)
aws s3api put-bucket-versioning \
  --bucket "s3-tf-myapp-dev" \
  --versioning-configuration Status=Enabled
```

## 4. Configurar el ambiente

Terraform necesita saber en qué bucket S3 va a guardar su estado.  
Esto se define en el archivo `backend.tfvars` de cada ambiente y requiere la siguiente configuración.


Abre el archivo `envs/dev/backend.tfvars` y coloca la siguiente configuración (cambia **myapp** y **dev** por el nombre de tu proyecto y ambiente):

```hcl
bucket         = "s3-tf-myapp-dev"
key            = "dev/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
use_lockfile   = true
```

## 5. Inicializar y aplicar Terraform

En este paso vamos a preparar Terraform para que utilice el backend remoto (S3), luego generaremos un plan de ejecución y finalmente lo aplicaremos.

---

### 5.1. Inicializar Terraform
Ubícate en la **raíz del proyecto** y ejecuta el siguiente comando para inicializar Terraform con el backend configurado:

```bash
terraform init -backend-config=envs/dev/backend.tfvars
```

Si todo está correcto, deberías ver el mensaje:

```bash
Terraform has been successfully initialized!
```

---

### 5.2. Crear un plan

El siguiente paso es generar un **plan de ejecución**, donde Terraform te mostrará qué recursos se van a crear, modificar o eliminar.
En este ejemplo lo guardamos en el archivo `dev.tfplan`:

```bash
terraform plan -var-file="envs/dev/vars.tfvars" -out="dev.tfplan"
```

El archivo `dev.tfplan` asegura que lo que se planificó sea exactamente lo que se aplicará después.

---

### 5.3. Aplicar el plan

Finalmente, aplicamos los cambios con el plan generado:

```bash
terraform apply "dev.tfplan"
```

Al terminar, Terraform mostrará un resumen como este:

```
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```

Donde `X` es el número de recursos que se crearon en este paso.

### 5.4. Destruir la infraestructura

Si deseas eliminar todos los recursos creados por Terraform en un ambiente específico, utiliza el comando `destroy`.  
Este comando usa el archivo de variables del ambiente correspondiente.

Ejemplo para **dev**:

```bash
terraform destroy -var-file="envs/dev/vars.tfvars"
```

Terraform pedirá confirmación antes de continuar. Una vez aceptada, eliminará todos los recursos gestionados.

---

### 5.5. Cambiar de ambiente

Cuando trabajamos con múltiples ambientes (`dev`, `qa`, `prd`), debemos cambiar la configuración del backend para que Terraform apunte al bucket S3 correcto.

Al hacer este cambio, Terraform puede mostrar un mensaje indicando que la configuración del backend cambió. En ese caso, se debe usar la opción `-reconfigure`.

Ejemplo: cambiar de **dev** a **qa**:

```bash
terraform init -reconfigure -backend-config=envs/qa/backend.tfvars
```

Luego, simplemente repetimos el flujo habitual para ese ambiente:

```bash
terraform plan -var-file="envs/qa/vars.tfvars" -out="qa.tfplan"
terraform apply "qa.tfplan"
```

De esta forma, cada ambiente mantiene su propio estado y configuración aislados.