# squid

Установка и настройка Squid proxy с basic-аутентификацией (htpasswd, bcrypt).

## Описание

- Устанавливает `squid` и `apache2-utils`
- Интерактивно запрашивает пароль и записывает его в `/etc/squid/passwd` (bcrypt)
- Разворачивает `/etc/squid/squid.conf` из шаблона с валидацией
  (`squid -k parse`) до перезапуска
- Перезапуск службы — только при изменении конфигурации или пароля (handler)

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `squid_http_port` | `3128` | Порт прокси |
| `squid_proxy_username` | `squid` | Пользователь для аутентификации |
| `squid_proxy_prompt_password` | `true` | Запрашивать пароль интерактивно |
| `squid_password_file` | `/etc/squid/passwd` | Файл паролей htpasswd |
| `squid_restrict_client_ips` | `true` | Ограничить клиентов по IP |
| `squid_allowed_client_ips` | список | Разрешённые IP клиентов |
| `squid_restrict_domains` | `false` | Ограничить целевые домены |
| `squid_allowed_domains` | `[]` | Разрешённые домены |
| `squid_ssl_ports` | `[443]` | Порты, разрешённые для CONNECT |
| `squid_access_log` | `/var/log/squid/access.log` | Лог доступа |
| `squid_cache_log` | `/var/log/squid/cache.log` | Лог кэша |
| `squid_cache_enabled` | `false` | Включить кэширование |

Для unattended-запуска задайте `squid_proxy_prompt_password: false` и передайте
пароль заранее (например, через vault) — тогда htpasswd-файл не перезаписывается.

## Пример

```bash
ansible-playbook playbooks/squid.yml
```

```yaml
- hosts: proxy
  roles:
    - role: squid
      vars:
        squid_restrict_client_ips: true
        squid_allowed_client_ips:
          - "10.0.0.0/24"
        squid_restrict_domains: true
        squid_allowed_domains:
          - ".example.com"
```

Проверка:

```bash
curl -x http://squid:password@<host>:3128 https://example.com
```
