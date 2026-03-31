# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Terraform infrastructure for deploying Azure Databricks with Backend Private Link, Unity Catalog, and Network Connectivity Config (NCC) — consolidated into a single deployment root with a module-based structure.

## Prerequisites

- `az login` — Azure CLI authentication required before any Terraform commands
- Terraform CLI installed

## Commands

All commands are run from the repository root:

```bash
terraform init
terraform plan -var-file="env.tfvars"
terraform apply -var-file="env.tfvars"
terraform destroy -var-file="env.tfvars"
```

## Configuration

`env.tfvars` is gitignored. Copy from the example and fill in your values:

```bash
cp env.tfvars.example env.tfvars
```

Key variables:
- `subscription_id` — Azure subscription ID
- `databricks_account_id` — Databricks account console ID (from `accounts.azuredatabricks.net`)
- `prefix` — short identifier used to name all resources (no spaces or special chars)
- `uc_metastore_name` — name for the Unity Catalog metastore
- `enable_ncc` — toggle NCC creation (default `true`)

## Architecture

Single-root deployment composed of three modules:

### `modules/databricks-workspace/`
Provisions all Azure networking and the workspace:
- Resource group, VNet, NSGs (AAD + Azure Front Door outbound rules)
- Public, private, and private-link subnets with Databricks delegation
- Premium workspace with `no_public_ip = true`
- Private endpoint for UI/API + private DNS zone

### `modules/unity-catalog/`
Creates Unity Catalog backed by Azure managed identity:
- Access Connector with system-assigned managed identity
- ADLS Gen2 storage account + container for metastore root
- Storage Blob Data Contributor role assignment to the connector
- Databricks metastore, data access config, and metastore-to-workspace assignment

### `modules/ncc-storage/`
Network Connectivity Config for private storage access:
- Account-level NCC bound to the workspace
- Private endpoint rules for metastore storage account
- Controlled by `enable_ncc` variable (default `true`)

### Root `main.tf`
Wires the three modules together and handles NCC private endpoint auto-approval via `az network private-endpoint-connection approve` after a `time_sleep` wait.

### Provider configuration (`providers.tf`)
Three providers: `azurerm`, `databricks` (alias: `account` — for UC/NCC account-level ops), `databricks` (alias: `workspace` — for workspace-level ops). Both Databricks providers use Azure CLI auth.
