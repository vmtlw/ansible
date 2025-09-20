# netplan

Настройка сетевого моста `br0` через netplan (renderer: networkd).

## Описание

- Если основной интерфейс уже `br0` — ничего не делает
- Устанавливает `netplan.io` и `systemd-resolved`
- Удаляет конфликтующие сетевые пакеты (`network-manager*`, `ifupdown`,
  `dhcpcd`, `dhclient`, `resolvconf`)
- Создаёт `/etc/netplan/01-br0.yaml`: мост `br0` поверх основного интерфейса,
  DHCP, STP выключен
- Применяет конфигурацию через handler `netplan apply` (только при изменении файла)

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `netplan_iface` | текущий основной интерфейс (`default_ipv4.interface`) | Интерфейс, включаемый в мост |
| `netplan_search_domain` | `vmtlw.ru` | search-домен для DNS |

## Пример

```bash
ansible-playbook playbooks/netplan.yml
```

```yaml
- hosts: hypervisors
  roles:
    - role: netplan
      vars:
        netplan_iface: eth0
```

## Важно

Роль меняет сетевую конфигурацию хоста. При ошибке возможна потеря связности —
запускайте с доступом к консоли (IPMI/BMC/локально).
