#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "XcodeGen не найден. Установите через Homebrew: brew install xcodegen"
  exit 1
fi

echo "Генерация Xcode проекта из project.yml..."
xcodegen generate --spec project.yml
echo "Готово: откройте FitDesk.xcodeproj в Xcode."
