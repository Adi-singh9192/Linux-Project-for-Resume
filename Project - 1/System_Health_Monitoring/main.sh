#!/bin/bash

#1. Create Variable for the store log path
LOG_FILE="/home/devops/Desktop/System_Health_Monitoring/history.log"

#Creating function for time and date store in log file
log_message(){
	echo "[$(date +'%d-%m-%Y %H:%M')] $1" >> "$LOG_FILE"
	echo "[$(date +'%d-%m-%Y %H:%M')] $1" 
}

#2. CPU Usage check ("%.0f) is to for floating number 
CPU_USAGE=$(top -bn 1 | grep "Cpu(s)" | awk '{printf "%.0f", $2}')
if [ "$CPU_USAGE" -gt 85 ]; then
	log_message "CRITICAL: CPU USUAGE IS TOO HIGH ${CPU_USAGE}%"
	exit 1
fi

#3. RAM Usage check (NR=2) use for the row number
RAM_USAGE=$(free -h | awk 'NR==2 {printf "%.0f", ($3/$2)*100}')
if [ "$RAM_USAGE" -gt 85 ]; then
	log_message "CRITICAL: RAM USAGE IS TOO HIGH ${RAM_USAGE}%"
	exit 1
fi

#4 Disk usage check (sed s/%//)
DISK_USAGE=$(df -h / | awk 'NR==2 {printf "%.0f", $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 85 ]; then
	log_message "CRITICAL: DISK USAGE IS TOO HIGH ${DISK_USAGE}%"
	exit 1
fi

#5. Log error hunting
if grep -i -q "error" "$LOG_FILE"; then
	log_message "CRITICAL: ERROR FOUND IN LOG MESSAGE"
	exit 1
fi

#6. Final message print

log_message "STATUS OKAY"
	exit 0


