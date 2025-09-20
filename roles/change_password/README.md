# change_password

Смена пароля пользователя `root` на целевых хостах.

## Описание

Роль проверяет, что пароль задан и не пуст, хеширует его (SHA-512) и устанавливает
пользователю `root`. Пароль не попадает в лог (`no_log: true`).

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `root_password` | — (обязательна) | Новый пароль root в открытом виде |

Обычно пароль запрашивается интерактивно через `vars_prompt` в плейбуке
`playbooks/change_password.yml`. Альтернатива — хранить в ansible-vault.

## Пример

```bash
ansible-playbook playbooks/change_password.yml
```

```yaml
- hosts: all
  roles:
    - role: change_password
      vars:
        root_password: "{{ vault_root_password }}"
```
