# Ansible — управление домашней инфраструктурой

Набор плейбуков и ролей для настройки и обслуживания Debian-серверов:
базовая настройка ОС, Docker, HAProxy, Squid, мониторинг, фаервол, LUKS и др.

## Структура репозитория

```
.
├── ansible.cfg            # конфигурация Ansible
├── inventory/             # инвентарь
│   ├── all.yml            # основной инвентарь (группы и хосты)
│   ├── localhost.yml      # инвентарь для локального запуска
│   ├── group_vars/        # переменные групп (all.yml — общие настройки подключения)
│   └── host_vars/         # переменные отдельных хостов
├── playbooks/             # плейбуки (по одному на роль/задачу)
├── roles/                 # роли (см. README в каждой)
├── scripts/               # shell-скрипты для модуля script/raw
├── requirements.txt       # Python-зависимости (ansible)
└── requirements.yml       # Ansible-коллекции
```

## Требования

- Ansible 2.14+ (проверено на ansible-core из `requirements.txt`)
- Python 3 на управляющей машине
- SSH-доступ к целевым хостам (по умолчанию — пользователь `root`, ключ `~/.ssh/id_ed25519`)
- Python 3.8+ на целевых хостах (для хостов без Python есть fallback — см. `playbooks/ssh_copy_id.yml`)

## Установка

```bash
git clone https://github.com/vmtlw/ansible && cd ansible

python3 -m venv env
source env/bin/activate

pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml
```

## Инвентарь

Основной файл — `inventory/all.yml`. Хосты объединяются в группы,
переменные подключения лежат в `inventory/group_vars/all.yml`:

```yaml
ansible_user: root
ansible_port: 22
ansible_ssh_private_key_file: ~/.ssh/id_ed25519
```

Переменные конкретных хостов — в `inventory/host_vars/<hostname>.yml`
(например, конфигурация HAProxy для хоста `haproxy-k8s`).

Проверка инвентаря:

```bash
ansible-inventory --list
ansible all -m ping
```

### Секреты

Секреты (пароли, приватные ключи, токены) **не хранятся** в репозитории.
Используйте [ansible-vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html):

```bash
# создать зашифрованный файл (он игнорируется git — см. .gitignore)
ansible-vault create inventory/group_vars/vault.yml

# запуск с vault-файлом
ansible-playbook playbooks/luks.yml --ask-vault-pass
```

## Запуск плейбуков

Общий вид (инвентарь `inventory/all.yml` подхватывается из `ansible.cfg` автоматически):

```bash
ansible-playbook playbooks/<имя>.yml
```

Полезные флаги:

```bash
# только на группе/хосте
ansible-playbook playbooks/iptables.yml -l workers

# проверка без внесения изменений + diff
ansible-playbook playbooks/debian_base.yml --check --diff

# проверка синтаксиса
ansible-playbook --syntax-check playbooks/debian_base.yml
```

Ad-hoc команды:

```bash
# произвольная команда на всех хостах
ansible all -m shell -a "grep -E 'gateway' /etc/network/interfaces"

# хост без Python (или со старым Python)
ansible old_k8s -m raw -a "uptime"

# выполнить shell-скрипт из ./scripts
ansible all -m script -a './scripts/ping.sh'
```

## Плейбуки

| Плейбук | Назначение |
|---|---|
| `debian_base.yml` | Базовая настройка сервера (пакеты, zram, btrbk, motd, bashrc и др.) |
| `change_password.yml` | Смена пароля root (запрашивает интерактивно) |
| `check_health_server.yml` | Проверка состояния серверов, отчёты в `/tmp/reports` |
| `dev_tools.yml` | Инструменты разработчика (terraform, kubectl, helm, k9s и др.) |
| `docker.yml` | Установка Docker с nftables-бэкендом |
| `haproxy.yml` | Установка и настройка HAProxy |
| `inotify_limits.yml` | Лимиты inotify, nofile и параметры sysctl |
| `iptables.yml` | Настройка фаервола iptables |
| `kora_icons.yml` | Тема иконок Kora и настройки XFCE (для десктопа) |
| `luks.yml` | Шифрование раздела LUKS (запрашивает парольную фразу) |
| `netplan.yml` | Настройка моста br0 через netplan |
| `node_exporter.yml` | Prometheus node_exporter |
| `reboot.yml` | Перезагрузка хостов (с подтверждением) |
| `script.yml` | Пример: выполнить `scripts/main.sh` и показать вывод |
| `squid.yml` | Squid proxy с basic-аутентификацией |
| `ssh_copy_id.yml` | Установка SSH-ключей (с fallback для хостов без Python) |
| `virt_manager_nopasswd.yml` | Virt-manager без пароля для группы libvirt |

## Роли

Подробная документация — в README каждой роли:

- [change_password](roles/change_password/README.md)
- [debian_base](roles/debian_base/README.md)
- [dev_tools](roles/dev_tools/README.md)
- [docker](roles/docker/README.md)
- [haproxy](roles/haproxy/README.md)
- [inotify_limits](roles/inotify_limits/README.md)
- [iptables](roles/iptables/README.md)
- [kora_icons](roles/kora_icons/README.md)
- [luks](roles/luks/README.md)
- [netplan](roles/netplan/README.md)
- [node_exporter](roles/node_exporter/README.md)
- [squid](roles/squid/README.md)
- [ssh_copy_id](roles/ssh_copy_id/README.md)
- [virt_manager_nopasswd](roles/virt_manager_nopasswd/README.md)

## Соглашения

- Имена ролей, плейбуков и файлов — `snake_case`, расширение — только `.yml`.
- Все переменные роли имеют префикс имени роли (например, `docker_daemon_config`).
- Используются полные имена модулей (FQCN): `ansible.builtin.copy`, `community.crypto.luks_device` и т.д.
- Деструктивные операции (очистка логов, сброс firewall, пересоздание LUKS) по умолчанию
  выключены и включаются отдельными переменными — см. README соответствующей роли.
- Изменения конфигураций применяются через handlers (перезапуск служб только при изменении файла).
