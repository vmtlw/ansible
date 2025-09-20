# inotify_limits

Настройка лимитов ядра: inotify, число открытых файлов (nofile) и параметры sysctl.

## Описание

- Пишет лимит nofile в `/etc/security/limits.d/99-nofile.conf`
- Пишет лимиты inotify в `/etc/sysctl.d/98-inotify.conf`
- Пишет дополнительные параметры ядра в `/etc/sysctl.d/99-sysctl.conf`
- Применяет изменения через handler `sysctl --system`

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `inotify_max_user_instances` | `8192` | `fs.inotify.max_user_instances` |
| `inotify_max_user_watches` | `524288` | `fs.inotify.max_user_watches` |
| `inotify_nofile_limit` | `65535` | soft/hard nofile для всех пользователей |
| `inotify_sysctl_params` | см. `defaults/main.yml` | Словарь параметров для `99-sysctl.conf` |
| `inotify_reset_sysctl` | `false` | **Деструктивно**: полностью очистить `/etc/sysctl.d` и удалить `/etc/sysctl.conf` перед настройкой |

По умолчанию `99-sysctl.conf` включает `ip_forward`, лимиты kernel keys,
`panic_on_oops`, `overcommit_memory`, диапазон портов для k8s NodePort
и bridge-nf-call для iptables.

## Пример

```bash
ansible-playbook playbooks/inotify_limits.yml
```

Переопределить параметры sysctl:

```yaml
inotify_sysctl_params:
  net.ipv4.ip_forward: 1
  vm.swappiness: 10
```
