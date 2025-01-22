#!/bin/bash

check_status() {
    local status=$1
    local name=$2

    if [[ $status -ge 200 && $status -lt 300 ]]; then
        echo "${name} статус: ${status}"
    elif [[ $status -ge 300 && $status -lt 400 ]]; then
        echo "${name} статус: ${status}"
    else
        echo "${name} статус: ${status}"
        exit 1
    fi
}

check_mysql_status() {
    if docker exec -i mysql mysqladmin ping -h127.0.0.1 --user=root --password=fluentd &>/dev/null; then
        echo "MySQL статус: Запущен"
    else
        echo "MySQL статус: Отключен"
        exit 1
    fi
}

start_time=$(date +%s)

check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:8081)" "First хост"
check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:8082)" "Second хост"
check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:9090)" "Prometheus"
check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:3000)" "Grafana"

check_mysql_status

check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:9100/metrics)" "Node Exporter"
check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:9113/metrics)" "Nginx Exporter"
check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:9104/metrics)" "MySQL Exporter"
check_status "$(curl -s --max-time 10 -o /dev/null -w "%{http_code}" http://localhost:8080/metrics)" "cAdvisor"

end_time=$(date +%s)
execution_time=$((end_time - start_time))

echo "Общее время выполнения проверки: ${execution_time} секунд."
