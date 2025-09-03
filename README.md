## Описание
Для создания xml редактора UI элементов. 

## Motivation
Без изменения кода, загрузки в store изменять UI и обмен данными с сервером приложения клиента.   
![admin-layout-photo](https://github.com/user-attachments/assets/adfe04bb-2789-467a-90aa-ab821ca82a89)

## Использование

Вывод компонентов макета:
```dart
Column(
  children: [
    Items(layoutModel.root,layoutModel),
  ],
),
```

Вывод источников-переменных макета:
```dart
Column(
  children: [
    Items(
        layoutModel.root.items
            .whereType<SourcePage>()
            .first,layoutModel,
    ),
  ],
),
```

Вывод стилей макета:
```dart
Column(
  children: [
    Items(
        layoutModel.root.items
            .whereType<StylePage>()
            .first,layoutModel, 
    ),
  ],
),
```


Вывод процессов макета:
```dart
Column(
  children: [
    ProcessItems(
        layoutModel.root.items
            .whereType<ProcessPage>()
            .first,layoutModel,
    ),
  ],
),
```

Вывод вьюшки, как страница выглядит
Обязательно указать размер экрана из [enum ScreenSizeEnum]
```dart
LayoutBuilder(
    builder: (context, constraints) {
        return Consumer<LayoutModel>(
            builder: (context, value, child) {
                return ComponentsAndSources(value,constraints, screenSize);
            },
        );
    }
),
```

## Дополнительная информация

