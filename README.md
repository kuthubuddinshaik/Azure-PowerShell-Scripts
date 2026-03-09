Azure PowerShell Automation Scripts

This repository contains a collection of Azure infrastructure automation scripts written using Azure PowerShell modules. The scripts are designed to help automate common cloud administration tasks such as resource discovery, security auditing, monitoring, and backup operations across Azure environments.

The goal of this repository is to demonstrate practical experience working with Azure Resource Manager (ARM), Azure Compute, Networking, Storage, and Azure Monitor through automation.

Features

These scripts help automate several common cloud operations tasks:

• Azure Resource Discovery – Retrieve and report Azure resources such as virtual machines, disks, and networking components.

• Security Auditing – Identify potentially insecure configurations such as NSG rules allowing unrestricted internet access (0.0.0.0/0).

• Infrastructure Monitoring – Query Azure Monitor metrics to analyze virtual machine performance metrics such as CPU utilization.

• Backup Automation – Automate managed disk snapshot creation with timestamp-based naming conventions.

• Multi-Subscription Management – Enumerate and analyze resources across multiple Azure subscriptions.

Example Scripts Included
Script	Description
VM Resource Discovery	Retrieves virtual machines and their power state across subscriptions
NSG Security Audit	Identifies NSG rules that allow inbound traffic from 0.0.0.0/0
Managed Disk Snapshot Automation	Creates snapshots for all managed disks in a resource group
Azure Monitor Metrics Query	Retrieves CPU metrics for virtual machines over a defined time range
Technologies Used

PowerShell

Azure PowerShell (Az Module)

Azure Resource Manager (ARM)

Azure Monitor

Azure Compute

Azure Networking

Azure Storage

Prerequisites

Before running these scripts, ensure the following:

Install the Azure PowerShell Az Module

Install-Module Az -Scope CurrentUser

Authenticate to Azure

Connect-AzAccount

Set the desired subscription

Set-AzContext -Subscription "<SubscriptionName>"
Purpose of This Repository

This project was created as part of hands-on practice with Azure cloud administration and automation. It demonstrates how PowerShell can be used to manage and audit Azure resources programmatically.

Author

Kuthubuddin Shaik

Master’s in Computer Science | Cloud & Infrastructure Enthusiast

GitHub: https://github.com/kuthubuddinshaik

Future Improvements

Add automation scripts for cost analysis and unused resource detection

Implement Azure tagging audits

Integrate scripts with Azure Automation Runbooks

Add CI/CD pipelines for script testing
