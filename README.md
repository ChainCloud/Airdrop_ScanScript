# Airdrop_ScanScript
This script scans ICO address and collects investors with >1 ETH current balance. 

## Setup
1. Run **npm install**
1. Run **npm install -g livescript**

## Dump all ICO investors with >1 ETH balance 
1. Change the 'ADDRESS' variable in the **airdrop_scan.ls**
1. Run **lsc airdrop_scan.ls**

As a result you will get *result.txt* file

## Filter *result.txt* and get investors with >=5 different tokens bought
1. Run **lsc filter_addresses.ls**

As a result you will get *filtered.txt* file
