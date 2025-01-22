# khoroshavinaa

## Проект мониторинга и агрегации логов
Этот репозиторий содержит Ansible playbook для настройки полного стека мониторинга и агрегации логов с использованием контейнеров Docker. 

![Static Badge](https://img.shields.io/badge/khoroshavinaa-tst-ansible)
![GitHub top language](https://img.shields.io/github/languages/top/khoroshavinaa/tst)
![GitHub](https://img.shields.io/github/license/khoroshavinaa/tst)
![GitHub Repo stars](https://img.shields.io/github/stars/khoroshavinaa/tst)
![GitHub issues](https://img.shields.io/github/issues/khoroshavinaa/tst)

Стек включает:

- **Nginx** (с GeoIP и пользовательским форматом логов).
- **Apache с PHP 7.2** (в качестве backend).
- **Node Exporter, Nginx Exporter, MySQL Exporter, cAdvisor** (для метрик Prometheus).
- **Prometheus** (сбор метрик).
- **Grafana** (визуализация метрик).
- **Fluentd** (агрегация логов).
- **MySQL** (хранилище агрегированных журналов).

## Структура проекта

```
.
ansible-docker-monitoring-stack/
├── apache2/                  # Исходники для сборки Apache2
│   ├── Dockerfile            # Dockerfile для сборки Apache2
│   ├── httpd.conf            # Кофигурационный файл Apache2
│   └── conf/                 # Конфигурации виртуальных хостов
│       ├── first.vhost/      # Кофигурации первого виртуального хоста
│       └── second.vhost/     # Кофигурации второго виртуального хоста
├── nginx/                    # Исходники для сборки Nginx
│   ├── conf/                 # Кофигурационные файлы Nginx
│   ├── Dockerfile            # Dockerfile для сборки Nginx
│   └── nginx.conf            # Кофигурационный файл Nginx
├── files/                    # Внешние конфигурации и скрипты
│   ├── grafana/              # Grafana
│   │   ├── dashboards/       # Дашборды Grafana
│   │   └── datasource/       # Конфигурационный файл источников данных
│   ├── mysql_exporter/       # Конфигурация MySQL Exporter
│   ├── public/               # Файлы для доступа из внешней сети
│   │   ├── firsts.tst/       # Файлы первого виртуального хоста
│   │   └── second.tst/       # Файлы второго виртуального хоста
│   └── test.sh               # Скрипт тестирования запуска сервисов
├── fluentd/                  # Fluentd
│   ├── conf/                 # Кофигурации Fluentd
│   └── Dockerfile            # Dockerfile для сборки Fluentd
├── requirements.yml          # Зависимости/Коллекции проекта
├── playbook.yml              # Главный Ansible Playbook
├── LICENSE                   # Лицензия
└── README.md                 # Документация проекта
```
## Установка и настройка
## Требования

- **Linux Ubuntu** (>= 22.12)
- **Ansible** (core >= 2.15)
  - Коллекция `community.docker`.
  - Коллекция `community.mysql`.
- **Python**

Если ваша система не поддерживает ядро Ansible версии >=2.15 то коллекция `community.docker` может не работать. 

## Настройка

### 1. Клонирование репозитория
```bash
git clone https://github.com/khoroshavinaa/tst.git
```

### 2. Установка Ansible и зависимостей
Установка Ansible:
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

Переход в директорию с проектом:
```bash
cd /<DIR>
```

Установка Коллекций:
```bash
ansible-galaxy collection install -r requirements.yml
```

### 3. Запуск сценария
Выполните сценарий настройки стека:
```bash
ansible-playbook playbook.yml
```

## Компоненты

### Nginx
- Работает как реверс прокси-сервер для двух виртуальных хостов:
 - `first.tst` → бэкэнд Apache.
 - `second.tst` → бэкэнд Apache.
- Пользовательский формат журнала включает:
 - `timestamp`, `request_time`, `upstream_time`, `remote_addr`, `remote_user`, `time_local`, `request`, `status`, `body_bytes_sent`, `http_referer`, `http_user_agent`, `geoip_country_code`

Мониторинг
- **Prometheus** собирает метрики из:
 - Node Exporter.
 - Nginx Exporter.
 - MySQL Exporter.
 - cAdvisor.
- **Grafana** визуализирует показатели с помощью предварительно настроенных панелей мониторинга.

### Агрегация логов
- **Fluentd** собирает логи Nginx и отправляет их в базу данных MySQL.
- Grafana отображает последние 100 записей запросов к Nginx и статистику запросов по виртуальным хостам.

Тестирование

### 1. Добавление доменов в `/etc/hosts` (Linux) `\Windows\System32\drivers\etc\hosts` (Windows)
Сопоставьте домены с IP-адресом виртуальной машины:
```
<IP-VM> first.tst
<IP-VM> second.tst
<IP-VM> grafana.tst
<IP-VM> prometheus.tst
```

### 2. Сайты
- Посетите `http://first.tst` и `http://second.tst`, чтобы протестировать виртуальные хосты.
- Посетите `http://grafana.tst` для просмотра панелей инструментов Grafana.
- Посетите `http://prometheus.tst` для Prometheus.

## Примечания
- Журналы и конфигурации будут установлены на хост-сервере в каталоге `/srv/`.
- Рекомендуется скачивать файлы проекта в отличный от каталога `/srv/` директории. Например в `opt` или `home`. 

## Поиск неисправностей

- Используйте `docker logs <container_name>` для проверки журналов любого контейнера.
- Убедитесь, что все необходимые порты открыты и не заблокированы брандмауэром.