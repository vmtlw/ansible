# iptables

Настройка фаервола iptables: политика `INPUT DROP`, доступ только с разрешённых
адресов, сохранение правил через iptables-persistent.

## Описание

1. (Опционально) устанавливает `iptables-persistent`
2. Временно ставит политику ACCEPT, чтобы не разорвать текущее подключение
3. (Опционально, `iptables_flush_existing`) сбрасывает все существующие правила
4. Разрешает: NTP, loopback, установленные подключения, разрешённые IP,
   multiport-правила
5. Ставит политику `INPUT DROP`
6. Сохраняет правила в `/etc/iptables/rules.v4` и включает `netfilter-persistent`

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `iptables_allowed_ips` | см. `defaults/main.yml` | Словарь «адрес/сеть: комментарий» |
| `iptables_allowed_ips_extra` | `{}` | Дополнительные адреса (удобно задавать в host_vars); объединяются с основными |
| `iptables_multiport_rules` | `[]` | Список `{ports: "80,443", comment: "web"}` для NEW-подключений |
| `iptables_flush_existing` | `false` | **Деструктивно**: сбросить все правила (`-F`/`-X`, nat, mangle) перед настройкой |
| `iptables_persist` | `true` | Сохранять правила после перезагрузки (iptables-persistent) |

## Пример

```bash
ansible-playbook playbooks/iptables.yml
```

host_vars для конкретного хоста:

```yaml
iptables_allowed_ips_extra:
  203.0.113.10: "офис"
iptables_multiport_rules:
  - ports: "80,443"
    comment: "web"
```

## Важно

Политика `INPUT DROP` применяется к концу роли. Если хост, с которого вы
подключаетесь, не входит в `iptables_allowed_ips`, SSH-доступ будет потерян.
Проверьте списки адресов перед запуском.
