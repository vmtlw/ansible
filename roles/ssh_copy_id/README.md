# ssh_copy_id

Установка публичных SSH-ключей и усиление конфигурации sshd.

## Описание

- Добавляет ключи из `ssh_copy_id_keys` в `authorized_keys` пользователя
- Отключает аутентификацию по паролю (`PasswordAuthentication no`)
- Запрещает вход root по паролю (`PermitRootLogin prohibit-password`)
- Перезапускает sshd только при изменении конфигурации (handler)

Для хостов без Python 3.8+ используйте плейбук `playbooks/ssh_copy_id.yml` —
он автоматически переключается на shell-скрипт
`scripts/ssh_copy_id_raw_module.sh` (модуль script, Python не нужен).

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `ssh_copy_id_user` | `root` | Пользователь, которому ставятся ключи |
| `ssh_copy_id_keys` | `[]` | Список публичных ключей (обязателен, не должен быть пустым) |
| `ssh_copy_id_restart_sshd` | `true` | Перезапускать sshd после изменений |

## Секреты

Ключи задаются в `group_vars`/`host_vars` или в зашифрованном vault-файле:

```yaml
# inventory/group_vars/all.yml
ssh_copy_id_keys:
  - "ssh-ed25519 AAAA... user@host1"
  - "ssh-ed25519 AAAA... user@host2"
```

## Пример

```bash
ansible-playbook playbooks/ssh_copy_id.yml
```

## Зависимости

Коллекция `ansible.posix` (модуль authorized_key).
