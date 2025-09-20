# virt_manager_nopasswd

Доступ к virt-manager без пароля для обычных пользователей через polkit.

## Описание

- Создаёт группу `virt_manager_nopasswd_group` (по умолчанию `libvirt`)
- Добавляет в неё всех обычных пользователей системы (UID 1000–65533)
- Создаёт правило polkit `/etc/polkit-1/rules.d/50-libvirt-nopasswd.rules`,
  разрешающее группе действие `org.libvirt.unix.manage` без аутентификации
- Перечитывает правила polkit при изменении файла (handler)

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `virt_manager_nopasswd_group` | `libvirt` | Группа с доступом без пароля |

## Пример

```bash
ansible-playbook playbooks/virt_manager_nopasswd.yml
```

```yaml
- hosts: workstations
  roles:
    - role: virt_manager_nopasswd
      vars:
        virt_manager_nopasswd_group: virt
```
