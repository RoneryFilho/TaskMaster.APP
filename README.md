# TaskMaster.App – Aplicativo Flutter

##Pré-requisitos

- [Flutter 3.29.3](https://docs.flutter.dev/get-started/install)
- Android Studio / VS Code com extensão Flutter
- Emulador Android ou dispositivo físico

---

##Como rodar o app

### 1. Clone o repositório e entre no projeto

```bash
git clone https://github.com/seu-usuario/TaskMaster.App.git
cd TaskMaster.App
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Rode o aplicativo

```bash
flutter run
```

> Se quiser testar em web:
```bash
flutter run -d chrome
```

---

## Configurar URL da API

A API precisa estar rodando localmente.

No arquivo `lib/services/api_service.dart`, atualize a URL base da API se necessário:

```dart
final String baseUrl = 'https://[ipv4 da maquia rodando a API]:7280(ou porta da database postgres configurada)/api/tasks';
```

> **Se estiver testando no Android Emulator**, use:
```dart
final String baseUrl = 'https://10.0.2.2:5000/api/tasks';
```

---

## Funcionalidades principais

- Adicionar, editar e remover tarefas
- Marcar tarefas como concluídas
- Filtrar por prioridade e data
- Buscar por texto
- Conexão com API em .NET via HTTP

---

## Estrutura do Projeto

```
TaskMaster.App/
│
├── lib/
│   ├── main.dart
│   ├── models/task.dart
│   ├── services/api_service.dart
│   └── screens/
│       ├── home_screen.dart
│       └── task_form.dart
│
├── pubspec.yaml
└── README.md
```
