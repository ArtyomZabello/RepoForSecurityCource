#!/usr/bin/env bash

# Security First: Скрипт должен прерываться при любой ошибке
set -e

# Проверяем, запущен ли скрипт от root
if [ "$EUID" -ne 0 ]; then
  echo "Ошибка: Пожалуйста, запустите этот скрипт с sudo."
  exit 1
fi

echo "[*] Копирование исполняемого скрипта..."
cp sysmonitor.sh /usr/local/bin/sysmonitor.sh

# 755 = rwxr-xr-x (Root может менять и запускать. Остальные могут только читать и запускать).
chmod 755 /usr/local/bin/sysmonitor.sh

echo "[*] Установка systemd юнитов..."
cp sysmonitor.service /etc/systemd/system/
cp sysmonitor.timer /etc/systemd/system/

# 644 = rw-r--r--
chmod 644 /etc/systemd/system/sysmonitor.service
chmod 644 /etc/systemd/system/sysmonitor.timer

echo "[*] Перезагрузка конфигурации systemd..."
systemctl daemon-reload

echo "[*] Включение и запуск таймера..."
systemctl enable --now sysmonitor.timer

echo "[+] Установка успешно завершена! Логи будут доступны в /var/log/sysmonitor/metrics.log"