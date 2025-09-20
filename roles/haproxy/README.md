# haproxy

Установка и настройка HAProxy на Debian/Ubuntu с логированием через rsyslog,
ротацией логов и поддержкой множественных listen-секций.

## Описание

- Устанавливает пакеты `haproxy` и `rsyslog`
- Настраивает rsyslog (`/etc/rsyslog.d/49-haproxy.conf`) и каталог `/var/log/haproxy`
- Настраивает logrotate (`/etc/logrotate.d/haproxy`)
- Генерирует `/etc/haproxy/haproxy.cfg` из шаблона с валидацией
  (`haproxy -c -f`) до перезапуска
- Перезапуск служб — только при изменении конфигурации (handlers)

## Переменные

### Основные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `haproxy_package` | `haproxy` | Имя пакета |
| `haproxy_service` | `haproxy` | Имя службы |
| `haproxy_config_file` | `/etc/haproxy/haproxy.cfg` | Путь к конфигурации |
| `haproxy_user` / `haproxy_group` | `haproxy` | Пользователь и группа |

### Секции global и defaults

```yaml
haproxy_global:
  log: "/dev/log local0 err"
  chroot: "/var/lib/haproxy"
  stats: "socket /run/haproxy/admin.sock mode 660 level admin"
  stats_timeout: "30s"
  user: "{{ haproxy_user }}"
  group: "{{ haproxy_group }}"
  daemon: true

haproxy_defaults:
  mode: "http"
  log: "global"
  option: ["tcplog", "dontlognull", "redispatch"]
  timeout:
    connect: "5000"
    client: "50000"
    server: "50000"
  maxconn: "3000"
```

### Backend-серверы

Группы серверов задаются в host_vars:

```yaml
haproxy_server_groups:
  default:
    - { name: "node1", ip: "172.16.30.120", check: true }
    - { name: "node2", ip: "172.16.50.63", check: true }
```

### Listen-секции

```yaml
haproxy_listen_sections:
  - name: "k8s-cluster.example.ru"
    bind: ":443"
    mode: "tcp"
    balance: "roundrobin"
    port: 443
    server_group: "default"
    use_allowed_ip: true
    tcp_request:
      - "connection reject if !allowed_ip"
```

Поля секции: `name`, `bind`, `mode`, `balance`, `port`, `server_group`,
`use_allowed_ip`, `acl`, `http_request`, `tcp_request`, `option`, `timeout`.

### Общий ACL

```yaml
haproxy_common_acl:
  allowed_ip: "src 10.0.0.0/24 10.1.0.0/24"
```

Используется listen-секциями с `use_allowed_ip: true` и для ограничения
доступа к метрикам Prometheus.

### Статистика и метрики

| Переменная | По умолчанию | Описание |
|---|---|---|
| `haproxy_stats_enabled` | `false` | Включить страницу статистики |
| `haproxy_stats_bind` | `:8404` | Порт статистики |
| `haproxy_stats_uri` | `/stats` | URI статистики |
| `haproxy_stats_refresh` | `30s` | Интервал обновления |
| `haproxy_prometheus_enabled` | `true` | Включить метрики Prometheus |
| `haproxy_prometheus_bind` | `:8404` | Порт метрик |
| `haproxy_prometheus_uri` | `/metrics` | URI метрик |

## Пример

```bash
ansible-playbook playbooks/haproxy.yml
```

Рабочий пример конфигурации — `inventory/host_vars/haproxy-k8s.yml`.

## Handlers

- `Restart haproxy` — перезапуск службы (после успешной валидации конфига)
- `Reload haproxy` — перечитать конфигурацию
- `Restart rsyslog` — перезапуск rsyslog
