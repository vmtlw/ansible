# docker

Установка Docker официальным скриптом `get.docker.com` и настройка демона.

## Описание

- Скачивает и запускает официальный установочный скрипт Docker (идемпотентно —
  повторный запуск пропускается по `creates: /usr/bin/docker`).
- Устанавливает и включает nftables.
- Разворачивает `/etc/docker/daemon.json` из переменной `docker_daemon_config`
  (с валидацией JSON и бэкапом). При изменении — перезапуск Docker (handler).

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `docker_daemon_config` | `{firewall-backend: nftables, data-root: /srv/docker-data}` | Содержимое `daemon.json` (конвертируется в JSON) |

## Пример

```bash
ansible-playbook playbooks/docker.yml
```

Переопределить конфигурацию демона:

```yaml
docker_daemon_config:
  firewall-backend: nftables
  data-root: /srv/docker-data
  log-driver: json-file
  log-opts:
    max-size: 10m
```
