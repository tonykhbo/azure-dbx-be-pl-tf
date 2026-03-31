# Azure Databricks Backend Private Link with Unity Catalog and NCC

Terraform for deploying an Azure Databricks workspace with Backend Private Link, Unity Catalog (metastore), and Network Connectivity Config (NCC) for private storage access — in a single deployment.

## Architecture

```
modules/
├── databricks-workspace/   # VNet, NSGs, subnets, workspace, private endpoint + DNS
├── unity-catalog/          # Access connector, ADLS Gen2 storage, metastore, assignment
└── ncc-storage/            # Network Connectivity Config bound to workspace + PE rules
```

All three modules are wired together from the root and deployed in a single `terraform apply`.

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated
- [Terraform CLI](https://developer.hashicorp.com/terraform/install) installed

## Setup

**1. Authenticate with Azure:**
```bash
az login
```

**2. Configure variables:**
```bash
cp env.tfvars.example env.tfvars
```

Edit `env.tfvars` and fill in:
| Variable | Description |
|---|---|
| `prefix` | Short identifier used to name all resources |
| `location` | Azure region (e.g. `centralus`) |
| `subscription_id` | Your Azure subscription ID |
| `databricks_account_id` | Databricks account console ID (from `accounts.azuredatabricks.net`) |
| `uc_metastore_name` | Name for the Unity Catalog metastore |
| `email` / `remove_date` / `description` | Resource tags |

**3. Deploy:**
```bash
terraform init
terraform plan -var-file="env.tfvars"
terraform apply -var-file="env.tfvars"
```

## What Gets Created

- **Resource group**, VNet, NSGs, and subnets (public, private, private-link)
- **Databricks workspace** (Premium, no public IP) with private endpoint and DNS zone
- **Unity Catalog metastore** backed by ADLS Gen2 with managed identity data access
- **Network Connectivity Config (NCC)** bound to the workspace with private endpoint rules for metastore storage, auto-approved via Azure CLI

## Clean Up

```bash
terraform destroy -var-file="env.tfvars"
```
