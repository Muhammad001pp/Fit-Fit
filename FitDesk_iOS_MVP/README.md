
# FitDesk iOS — SwiftUI MVP

Готовый каркас приложения для iOS (Xcode 16.2+, iOS 17+). Без внешних зависимостей. SwiftUI + Charts. Локальная база справочника в JSON с автозагрузкой в кеш приложения.

## Что входит
- Навигация с вкладками: **Тренировки**, **Справочник**, **Аналитика**, **Ещё**.
- Экран «Рабочий стол», список сплитов, экран упражнений, карточка упражнения с таймером и историей.
- Аналитика: графики ЧСС, калории, поднятый вес; вкладка «Замеры» со списком и деталями.
- Замеры: добавление, редактирование, удаление.
- Справочник: группы мышц → упражнения, данные из JSON.
- Профиль: просмотр и простое редактирование.
- Сидинг данных из /Source/Data/seed/*.json при первом запуске (в файловый кеш в каталоге Documents).

## Установка

### Вариант A: Автогенерация проекта (XcodeGen)
1. Установите XcodeGen (один раз):
  - `brew install xcodegen`
2. В корне `FitDesk_iOS_MVP/` сгенерируйте проект:
  - `./Scripts/gen_xcodeproj.sh`
3. Откройте `FitDesk.xcodeproj` и запустите на симуляторе.

### Вариант B: Вручную в Xcode
1) Внутри программы (Xcode)
- Откройте Xcode → **File → New → Project… → iOS App**.
- Название: `FitDesk`, Interface: **SwiftUI**, Language: **Swift**, iOS 17+.
- В Project Navigator создайте группы: Models, Services, Views (и подпапки), Data/seed, Resources, Profile/… (либо перетащите готовые папки из этого архива).
- **Add Files to “FitDesk”…** и укажите содержимое папки `Source/` — поставьте галочку *Copy items if needed* и добавьте в таргет `FitDesk`.
- В **Signing & Capabilities** убедитесь, что iOS Deployment Target ≥ 17.0.

### 2) В терминале
- Распакуйте архив в любую папку:  
  `unzip FitDesk_iOS_MVP.zip -d ~/Downloads/FitDesk`
- Никаких дополнительных команд не требуется.

## Права (Info.plist)
Добавьте ключи, если будете подключать камеру/фотобиблиотеку:
- `NSCameraUsageDescription` = «Нужно для фото прогресса»
- `NSPhotoLibraryAddUsageDescription` = «Сохранение фото прогресса»
- `NSPhotoLibraryUsageDescription` = «Выбор фото прогресса»

## Старт
Соберите и запустите в симуляторе iPhone. Данные из JSON будут загружены автоматически при первом запуске.

## Запуск из VS Code на симуляторе
В репозитории есть задача VS Code, которая билдит, устанавливает и запускает приложение на выбранном симуляторе.

1) Откройте папку `Fit-Fit` в VS Code.
2) Команда: «Terminal → Run Task…» → `iOS: Build & Install & Launch (Simulator)`.
3) Укажите UUID симулятора (узнать: `xcrun simctl list devices`). По умолчанию подставлен пример.

Задача делает:
- сборка через `xcodebuild` (Debug, iphonesimulator);
- поиск пути к .app в DerivedData;
- boot симулятора (если он уже запущен — пропускается);
- установка и запуск приложения (bundle id: `com.fitdesk.app`).

## Публикация на GitHub
Если ещё нет git-репозитория:
```
git init
git add .
git commit -m "chore: initial import + VS Code task"
git branch -M main
git remote add origin https://github.com/<your-account>/<repo>.git
git push -u origin main
```

Файл `.gitignore` добавлен (исключены DerivedData, build, .xcworkspace, xcuserdata, .DS_Store и др.).
