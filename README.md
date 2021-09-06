# BespinGlobal Terraform Training 
> author: Changsuk Choi

> company: BespinGlobal



## What is Terraform
[Terraform](https://www.terraform.io) is an **open-source** infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files.
  
[Terragrunt](https://terragrunt.gruntwork.io/) is a thin wrapper that provides extra tools for keeping your configurations **DRY**, working with multiple Terraform modules, and managing remote state.

- Keyword of Terraform
    + open-source
    + resource lifecycle more efficient
    + able to tracking changes
    + CLI workflow: terraform init - terraform plan - terraform apply
&nbsp;
- Keyword of Terragrunt
    + Keep your Terraform code DRY
    + Execute Terraform commands on multiple modules at once
&nbsp;
- Terraform Best Practices
    + Manage multiple Terraform modules and environments easily with Terragrunt
    + Manage S3 backend for tfstate files
    + Isolation via file layout
    + Use shared modules
    + Avoid hard coding the resources
    + Use pre-installed Terraform plugins instead of downloading them with terraform init



## Terraform Versions
Releases Terraform : https://releases.hashicorp.com/terraform
Releases Terragrunt: https://github.com/gruntwork-io/terragrunt/releases

| Version | Release    | AWS Provider  |
|---------|------------|---------------|
| 1.00    | 2021-06-08 | 3.53.0 latest |
| 0.15    | 2021-04-15 | 3.53.0        |
| 0.14    | 2020-12-03 | 3.53.0        |
| 0.13    | 2020-08-11 | 3.53.0        |
| 0.12    | 2019-05-23 | 3.53.0        |
| 0.11    | 2017-11-17 | 2.70.0 latest |
| 0.10    | 2017-08-03 | 2.70.0        |
| 0.09    | 2017-03-16 | 2.70.0        |

The recommended version is above 0.12. Terraform v0.12 is incompatible with previous versions of terraform. Terraform 0.12 introduced a new type system for the Terraform language, and with it some changes to the representations of configuration, state, and plans.
Announcing HashiCorp dropped support for Terraform 0.11 and below.
Version 3.0.0 and later of the AWS Provider can only be automatically installed on Terraform 0.12 and later.

docs: https://www.terraform.io/upgrade-guides/0-12.html
docs: https://www.hashicorp.com/blog/deprecating-terraform-0-11-support-in-terraform-providers



## Install Terraform and Terragrunt
This training focuses on running terraform code for the Microsoft Windows operating system.

##### Windows
- Get specific version
    + Terraform: https://releases.hashicorp.com/terraform/1.0.5/terraform_1.0.5_windows_amd64.zip
    + Terragrunt: https://github.com/gruntwork-io/terragrunt/releases/download/v0.31.8/terragrunt_windows_amd64.exe
&nbsp;      
- Create app folder.
  Create a new folder for terraform as 'C:\Bespin\Terraform' and Go to the folder.
  ```powershell
  PS C:\> New-Item -ItemType Directory -Force -Path "C:\Bespin\Terraform"
  ```
- Install package
    + Terrform: extract the package to the folder 'C:\Bespin\Terraform'.
    + Terragrunt: terragrunt file **rename** to 'terragrunt.exe'
    + This path is used as an example. However, you can also the Terraform executable to any other location in your local system.
      The following is example of install packages.  
    ![Installing](https://bespin-terraform-training.s3.ap-northeast-2.amazonaws.com/img/install_package.png)
&nbsp;
- Update path
  Update the path environment variable to include the folder where your Terraform executable is located.
    + Command Line
      - Run Powershell as Administrator
        ```powershell
        PS C:\> $env:PATH
        C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\iCLS\; ............ C:\WINDOWS\System32\WindowsPowerShell\v1.0\;
        PS C:\> setx /M PATH "$Env:PATH;C:\Bespin\Terraform"
        ```
      - Re-open Powershell
        ```powershell
        PS C:\> $env:PATH
        C:\Program Files (x86)\Intel\Intel(R) Management Engine Components\iCLS\; ...... C:\Bespin\Terraform; ...... C:\WINDOWS\System32\WindowsPowerShell\v1.0\;
        ``` 
    + GUI
      - Open Control Panel » System » Advanced system settings » Environment Variables.
        + Type **SystemPropertiesAdvanced** and press ENTER.
      - In the **System variables** pane, click **Path** and then click **Edit**.
      - Click **New**. 
      - Add the path to the folder where your Terraform executable is located like 'C:\Bespin\Terraform'.

- Confirm version
  To verify, open another Powershell. 
  ```powershell
  PS C:\> terraform --version
  Terraform v1.0.5
  on windows_amd64

  PS C:\> terragrunt --version
  terragrunt version v0.31.8
  ``` 

##### Disadvantages of using Windows
The base environment of Terraform is UNIX. It make some trouble when running on windows.

  - 260 characters
    In the Windows, the maximum length for a path is MAX_PATH, which is defined as 260 characters.
    In the Linux has a maximum path of 4096 characters.
    When doing a terragrunt plan, Terragrunt tries to copy artifacts to the .terragrunt-cache folder which adds what I presume is the hash of the files as the folder name. Eventually, it might be exceed the maximum length of the windows.
  - state push
    On Windows, terraform state pull > terraform.tfstate results in a file with Windows (\r\n) line endings. But terraform state mv requires Unix-style (\n) line endings.
    The state push command will fail if they contain (\r\n) line endings as shown blow.
  - no color
    The Windows has no support for VT(Virtual Terminal)/ANSI escape codes. It cause that weird control characters show up in the output if you are using terragrunt or old terraform.   
    ```powershell
    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
      ←[33m~←[0m update in-place
    ←[31m-←[0m/←[32m+←[0m destroy and then create replacement
    ←[0m
    Terraform will perform the following actions:

    ←[1m  # aws_appautoscaling_target.appautoscaling_target[0]←[0m will be updated in-place←[0m←[0m
    ←[0m  ←[33m~←[0m←[0m resource "aws_appautoscaling_target" "appautoscaling_target" {
            ←[1m←[0mid←[0m←[0m                 = "service/ecs/bespin-api"
            ←[1m←[0mmax_capacity←[0m←[0m       = 30
            ←[33m~←[0m ←[0m←[1m←[0mmin_capacity←[0m←[0m       = 1 ←[33m->←[0m ←[0m4
            ←[1m←[0mresource_id←[0m←[0m        = "service/ecs/bespin-api"
            ←[1m←[0mrole_arn←[0m←[0m           = "arn:aws:iam::152021215529:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
            ←[1m←[0mscalable_dimension←[0m←[0m = "ecs:service:DesiredCount"
            ←[1m←[0mservice_namespace←[0m←[0m  = "ecs"
    ```
    Using VT/ANSI escape codes in PowerShell.
    ```powershell
    PS C:\> Set-ItemProperty HKCU:\Console VirtualTerminalLevel -Type DWORD 1
    ```

##### Linux
  - Get specific version
    ```bash
    $ wget https://releases.hashicorp.com/terraform/0.12.31/terraform_0.12.31_linux_amd64.zip
    $ wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.21.6/terragrunt_linux_amd64
    $ unzip terraform_0.12.31_linux_amd64.zip
    ```
  - Install package
  Give binary executable permissions and install (will overwrite current version)
    ```bash
    $ chmod +x terraform
    $ chmod +x terragrunt_linux_amd64
    $ sudo mv terraform /usr/local/bin/terraform
    $ sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
    ```
  - Confirm version
    ```bash
    $ terraform --version
    $ terragrunt --version
    ```



## Install AWS CLI

##### Install the AWS CLI version 2 on Windows using the MSI installer
  - Get latest version
    Download the AWS CLI MSI installer for Windows(64-bit): https://awscli.amazonaws.com/AWSCLIV2.msi 
  - Install
    Run the downloaded MSI installer and follow the on-screen instructions. By default, the AWS CLI installs to C:\Program Files\Amazon\AWSCLIV2.
  - Confirm version
    ```powershell
    PS C:\> aws --version
    ```

docs: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html

##### Configure Profile
The AWS CLI supports using any of multiple **named profiles** that are stored in the **config** and **credentials** files. You can configure additional profiles by using **aws configure** with the **--profile** option, or by adding entries to the config and credentials files.

```powershell
PS C:\> aws configure --profile bespin-training-terraform
AWS Access Key ID [None]: "your_access_key"
AWS Secret Access Key [None]: "your_secret_key"
Default region name [None]: us-west-2
Default output format [None]: json

PS C:\> aws s3api list-buckets --query "Buckets[].Name" --profile bespin-training-terraform
```
docs: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html



## What is Remote state
By default, Terraform stores state locally in a file named **terraform.tfstate**. 

- Teamwork
  When working with Terraform in a team, use of a local file makes Terraform usage complicated because each user must make sure they always have the latest state data before running Terraform and make sure that nobody else runs Terraform at the same time.
  With remote state, Terraform writes the state data to a remote data store, which can then be shared between all members of a team. 
- Locking
  For fully-featured remote backends, Terraform can also use state locking to prevent concurrent runs of Terraform against the same state.
- Sharing
  Remote state allows you to share output values with other configurations via a terraform_remote_state data source. 
  This allows your infrastructure to be decomposed into smaller components.
- S3 backend
  S3 backend stores the state as a given key in a given bucket on Amazon S3. This backend also supports state locking and consistency checking via Dynamo DB.
  | LockID                                                        | Digest                           |
  |---------------------------------------------------------------|----------------------------------|
  | state-bucket/eu-west-1/network/terraform.tfstate-md5          | 5e201f09154779adg0736459805df1ac |
  | state-bucket/us-east-1/alarm-cloudwatch/terraform.tfstate-md5 | 8ec543f37cc85c9b63dc2cf645f9254a |
  ```hcl
  remote_state {
    backend = "s3"

    config = {
      encrypt        = true
      bucket         = "bespin-terraform-state"     # S3 bucket for storing tfstate
      key            = "dev/iam/terraform.tfstate"  # Path to the state file inside the S3 Bucket
      region         = "us-east-1"                  # AWS Region of the S3 Bucket 
      dynamodb_table = "bespin-terraform-locks"     # Must have a primary key named LockID(string)
      profile        = "bespin-training-terraform"
    }
  }
  ```

docs: https://www.terraform.io/docs/language/state/remote-state-data.html
docs: https://www.terraform.io/docs/language/settings/backends/s3.html



## Useful Commands Options
  - terraform apply -auto-approve
  **-auto-approve**: Skip interactive approval of plan before applying.
  - terraform plan -no-color
  **-no-color**: Disables output with coloring. Disables output with coloring. On Windows, Default Settting no support for VT100 escape codes. -no-color flag would be help this cases.
  - terragrunt plan --terragrunt-source c:\deploy\temp\ 
  **--terragrunt-source**: Download Terraform configurations from the specified source into a temporary folder, and run Terraform in that temporary folder. 



## Pre-installed Terraform plugins
Terraform allows for plugins caching. Whenever plugin has to be downloaded and is present in the cache directory, it will be copied into the project instead. This can save some time and bandwidth.

docs: https://www.terraform.io/docs/cli/config/config-file.html

##### Windows
Run Powershell as Administrator
```powershell
PS C:\Bespin> $path = "C:\Bespin\Terraform\plugin-cache"
PS C:\Bespin> New-Item -ItemType Directory -Force -Path $path
PS C:\Bespin> [Environment]::SetEnvironmentVariable('TF_PLUGIN_CACHE_DIR', $path, 'Machine')
PS C:\Bespin> [Environment]::GetEnvironmentVariable('TF_PLUGIN_CACHE_DIR', 'Machine')
```

##### Linux
```bash
$ export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
```
