# 🐧 Linux OS Management Script Suite

## 📌 Project Overview
This repository contains a **Linux Operating System Management Script Suite** developed as part of the **SYST44288 – Operating Systems Design & Systems Programming** course.

The project consists of **five Bash scripts** designed to help monitor and manage system resources such as **processes, CPU usage, memory, file systems, and network activity**.

This is a **group project**, and each script demonstrates practical use of Linux system commands, scripting logic, logging, and user interaction.

---

## 👥 Group Members
- **Faith Aikhionbare**
- **Gautam Kannan**

---

## 📚 Course Information
- **Course:** SYST44288 – Operating Systems Design & Systems Programming  
- **Instructor:** Gurdeep Gill  
- **Submission Date:** November 27, 2025  

---

## 🧰 Scripts Included

### 1️⃣ `process_manager_tool.sh`
Manages running processes on the system.

**Features:**
- Kill a process using its PID
- Display processes run by a specific user
- Show the top 5 processes using the most CPU and memory
- Schedule process status checks every minute and log results

---

### 2️⃣ `cpu_manager_tool.sh`
Monitors and analyzes CPU usage.

**Features:**
- Display current CPU usage percentage
- Track CPU usage over a specified time period and log results
- Set CPU affinity for a specific process
- Generate alerts when CPU usage exceeds a user-defined threshold

---

### 3️⃣ `memory_manager_tool.sh`
Tracks and manages system memory usage.

**Features:**
- Display current memory statistics
- List processes consuming high amounts of memory
- Clear system cache and buffers
- Generate alerts when available memory drops below 500MB

---

### 4️⃣ `file_system_monitor_tool.sh`
Monitors disk usage and manages files.

**Features:**
- Display current disk usage
- List the largest files in a directory
- Show files modified within the last 24 hours
- Clean temporary files exceeding 1MB

---

### 5️⃣ `network_monitor_tool.sh`
Monitors network activity and connections.

**Features:**
- Display network configuration and interfaces
- Monitor bandwidth usage per interface
- Check active connections to/from a specific IP
- Log network traffic activity to a file

---

## ▶️ How to Run the Scripts

1. Make the script executable:
```bash
chmod +x script_name.sh
```
Run the script:

````bash
./script_name.sh
````

## ⚠️ Note:
Some scripts require sudo for actions such as:
- Killing system processes
- Setting CPU affinity
- Clearing memory cache
- Monitoring network traffic

Example:
````bash
sudo ./cpu_manager_tool.sh
````

## 📝 Logs & Output
Several scripts generate log files to store system monitoring data over time. These logs allow users to review historical activity such as:
- CPU usage alerts
- Process monitoring
- Network traffic tracking

## 🎯 Learning Outcomes
Through this project, we gained hands-on experience with:
- Linux process, CPU, memory, file system, and network management
- Bash scripting and automation
- System monitoring and logging
- Using /proc system files
- Writing user-friendly CLI tools