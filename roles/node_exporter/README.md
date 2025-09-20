# node_exporter

Установка [Prometheus node_exporter](https://github.com/prometheus/node_exporter)
из бинарного релиза с systemd-юнитом.

## Описание

- Создаёт системного пользователя `node_exporter`
- Скачивает и устанавливает бинарный файл (повторная установка пропускается,
  если версия уже совпадает)
- Разворачивает systemd-юнит и запускает службу
- Обновление: задайте новую `node_exporter_version` — бинарный файл обновится,
  служба перезапустится (handlers)

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `node_exporter_version` | `1.9.1` | Версия релиза |
| `node_exporter_listen_address` | `0.0.0.0:9100` | Адрес и порт прослушивания |
| `node_exporter_allowed_network` | `0.0.0.0/0` | Разрешённая сеть (зарезервировано для ACL) |
| `node_exporter_install_dir` | `/usr/local/bin` | Каталог установки |
| `node_exporter_user` / `node_exporter_group` | `node_exporter` | Пользователь и группа службы |
| `node_exporter_web_config` | `{basic_auth_users: {}}` | Конфигурация web (basic auth) |

## Пример

```bash
ansible-playbook playbooks/node_exporter.yml
```

Проверка после установки:

```bash
curl http://<host>:9100/metrics
```
