# luks

Шифрование раздела LUKS2 (argon2id), создание файловой системы и монтирование.

## Описание

- Устанавливает `cryptsetup`
- Создаёт (если отсутствует) и открывает LUKS2-контейнер
- Создаёт файловую систему (по умолчанию Btrfs с `--metadata dup`)
- Подбирает опции монтирования в зависимости от типа диска (SSD/HDD)
- Монтирует раздел и прописывает его в fstab

Роль идемпотентна: существующий контейнер и файловая система не пересоздаются,
если явно не включить `luks_force_recreate`.

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `luks_device` | `/dev/sda1` | Шифруемое устройство |
| `luks_name` | `crypto_data` | Имя контейнера в `/dev/mapper` |
| `luks_label` | `crypto_data` | Метка LUKS |
| `luks_fs_type` | `btrfs` | Тип файловой системы |
| `luks_passphrase` | — (обязательна*) | Парольная фраза |
| `luks_keyfile` | `/root/keyfile` | Файл ключа (используется, если парольная фраза не задана) |
| `luks_mount` | `/mnt` | Точка монтирования |
| `luks_force_recreate` | `false` | **Деструктивно**: отмонтировать, закрыть и полностью пересоздать контейнер и ФС. Все данные будут потеряны |

\* Задайте либо `luks_passphrase`, либо `luks_keyfile`.

## Секреты

Парольная фраза **не хранится** в репозитории. Плейбук `playbooks/luks.yml`
запрашивает её интерактивно (`vars_prompt`). Для unattended-запуска используйте
ansible-vault:

```yaml
# inventory/group_vars/vault.yml (зашифрован)
luks_passphrase: "очень-секретная-фраза"
```

## Зависимости

Коллекции: `community.crypto` (luks_device), `community.general` (filesystem),
`ansible.posix` (mount).

## Пример

```bash
ansible-playbook playbooks/luks.yml -l backup-server
```

```yaml
- hosts: backup
  roles:
    - role: luks
      vars:
        luks_device: /dev/sdb1
        luks_mount: /mnt/backup
```
