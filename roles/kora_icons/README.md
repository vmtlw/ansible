# kora_icons

Установка темы иконок [Kora](https://github.com/bikass/kora) и настройка
внешнего вида рабочего стола (GNOME/XFCE) для локального пользователя.

## Описание

- Клонирует репозиторий kora и копирует темы в `/usr/share/icons/`
- Применяет тему иконок и GTK-тему через `gsettings`
- Настраивает `xfce4-terminal` (цвета, отключение диалога небезопасной вставки)
  и панель XFCE через `xfconf-query`

Настройки применяются от имени пользователя `kora_icons_user` в его
графической сессии (`DISPLAY=:0`, DBus).

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `kora_icons_user` | `vladimir` | Пользователь графической сессии |
| `kora_icons_gtk_theme` | `Adwaita-dark` | GTK-тема |
| `kora_icons_repo_version` | `master` | Ветка репозитория kora |

## Зависимости

Коллекция `ansible.posix` (модуль synchronize).
На целевом хосте должны быть запущены графическая сессия пользователя,
`gsettings` и `xfconf-query`.

## Пример

```bash
ansible-playbook playbooks/kora_icons.yml
```

```yaml
- hosts: desktops
  roles:
    - role: kora_icons
      vars:
        kora_icons_user: ivan
        kora_icons_gtk_theme: Adwaita
```
