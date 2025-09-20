# debian_base

Базовая настройка Debian-серверов. Роль состоит из независимых компонентов,
каждый включается своим флагом `debian_base_<компонент>_enabled`.

## Компоненты

| Компонент | Флаг | По умолчанию | Что делает |
|---|---|---|---|
| zram | `debian_base_zram_enabled` | `true` | Отключает swap, настраивает zram (zstd, 200% RAM) |
| btrbk | `debian_base_btrbk_enabled` | `true` | Резервное копирование Btrfs-снапшотов + cron-задача + SSH-ключ |
| motd | `debian_base_motd_enabled` | `true` | Отключает PrintMotd/PrintLastLog в sshd, чистит `/etc/motd*` |
| extra packages | `debian_base_extra_packages_enabled` | `true` | Устанавливает пакеты из `debian_base_packages` |
| bashrc | `debian_base_bashrc_enabled` | `true` | Разворачивает `/etc/bash.bashrc` из шаблона |
| lesspipe | `debian_base_lesspipe_enabled` | `true` | Патчит lesspipe (просмотр .crt/.pem через less) |
| vim | `debian_base_vim_disable_mouse_enabled` | `true` | Отключает mouse в `defaults.vim` |
| clear | `debian_base_clear_enabled` | `false` | **Деструктивно**: чистит `/var/backups`, journald, кэш apt |
| fail2ban | `debian_base_fail2ban_enabled` | `false` | Устанавливает и запускает fail2ban |
| hostname | `debian_base_hostname_enabled` | `false` | Устанавливает hostname и запись в `/etc/hosts` |
| timezone | `debian_base_timezone_enabled` | `false` | Устанавливает часовой пояс |
| locale | `debian_base_locale_enabled` | `false` | Генерирует и устанавливает локаль |
| chrony | `debian_base_chrony_enabled` | `false` | Устанавливает и запускает chrony |
| resolv | `debian_base_resolv_enabled` | `false` | Переписывает `/etc/resolv.conf` |

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `debian_base_hostname` | `{{ inventory_hostname }}` | Имя хоста |
| `debian_base_timezone` | `Europe/Moscow` | Часовой пояс |
| `debian_base_locale` | `[en_US.UTF-8]` | Список локалей |
| `debian_base_language` | `en_US.UTF-8` | Системный язык |
| `debian_base_nameserver` | `8.8.8.8` | DNS для `/etc/resolv.conf` |
| `debian_base_motd_custom_enabled` | `false` | Развернуть кастомный скрипт `/etc/update-motd.d/99-mymotd` |
| `debian_base_btrbk_key_path` | `/root/.ssh/btrbk.key` | Путь к SSH-ключу btrbk |
| `debian_base_packages` | см. `defaults/main.yml` | Список устанавливаемых пакетов |

## Зависимости

Коллекции: `community.general` (modprobe, timezone, locale_gen),
`community.crypto` (openssh_keypair).

## Пример

```bash
ansible-playbook playbooks/debian_base.yml
```

Включить fail2ban и timezone для группы хостов (`group_vars/all.yml`):

```yaml
debian_base_fail2ban_enabled: true
debian_base_timezone_enabled: true
```
