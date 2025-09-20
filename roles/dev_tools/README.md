# dev_tools

Установка инструментов разработчика из бинарных релизов (без пакетных менеджеров,
где это возможно). Каждый инструмент включается своим флагом.

## Инструменты

| Инструмент | Флаг | Переменная версии |
|---|---|---|
| Terraform | `dev_tools_terraform_enabled` | `dev_tools_terraform_version` |
| Terragrunt | `dev_tools_terragrunt_enabled` | `dev_tools_terragrunt_version` |
| SOPS (+ age) | `dev_tools_sops_enabled` | `dev_tools_sops_version` |
| kubectl | `dev_tools_kubectl_enabled` | `dev_tools_kubectl_version` |
| k9s | `dev_tools_k9s_enabled` | `dev_tools_k9s_version` |
| adb/scrcpy | `dev_tools_adb_enabled` | `dev_tools_scrcpy_version` |
| medusa | `dev_tools_medusa_enabled` | `dev_tools_medusa_version` |
| privatebin-cli | `dev_tools_privatebin_enabled` | — (apt) |
| Helm | `dev_tools_helm_enabled` | `dev_tools_helm_version` (пусто = latest) |
| MinIO client (mc) | `dev_tools_minio_client_enabled` | `dev_tools_minio_client_version` |
| Cilium CLI | `dev_tools_cilium_enabled` | `dev_tools_cilium_version` (пусто = latest stable) |

## Переменные

| Переменная | По умолчанию | Описание |
|---|---|---|
| `dev_tools_bin_dir` | `/usr/local/bin` | Каталог установки бинарных файлов |
| `dev_tools_tmp_dir` | `/tmp/dev-tools` | Временный каталог загрузок |
| `dev_tools_architecture` | `amd64` | Архитектура бинарных релизов |
| `dev_tools_os` | `linux` | ОС бинарных релизов |
| `dev_tools_terraform_registry_mirror` | `https://tf-proxy.selectel.ru/mirror/v1/` | Зеркало провайдеров Terraform (пишется в `/etc/terraformrc`) |
| `dev_tools_privatebin_home` | `$HOME` пользователя, запустившего ansible | Домашний каталог для конфига privatebin |
| `dev_tools_privatebin_host` | `https://paste.vmtlw.ru` | PrivateBin-инстанс |

Для Cilium CLI скачанный архив проверяется по sha256-сумме из релиза.

## Пример

```bash
ansible-playbook playbooks/dev_tools.yml
```

Установить только часть инструментов:

```yaml
- hosts: all
  roles:
    - role: dev_tools
      vars:
        dev_tools_adb_enabled: false
        dev_tools_medusa_enabled: false
        dev_tools_minio_client_enabled: false
```
