# Migrating from BLoC to RxGet

This guide provides a comprehensive mapping and migration path for transitioning your Flutter projects from **BLoC / Cubit** to the **RxGet** architecture.

---

## 1. Core Concept Mapping

| BLoC / Cubit Concept | RxGet Concept | Description |
| :--- | :--- | :--- |
| `Bloc` or `Cubit` Class | `GetxController<_State>` | The core controller handling all business logic and mutations. |
| `State` Class (Immutable) | `_State` Class (`GetxState`) | Stores state as private reactive (`Rx`) variables and exposes them via public read-only getters. |
| `Event` Class | Public Controller Methods | Explicit event classes are replaced by direct public method calls on the controller. |
| `BlocProvider` | `GetInWidget` + `GetIn` | Dependency injection is handled at the widget level using `GetInWidget`. |
| `BlocBuilder` / `BlocConsumer` | `Obx` or `Obl` | Reactive UI rebuilding. `Obx` automatically tracks and rebuilds when any observed `Rx` variable changes. |

---

## 2. Migrating the State

In BLoC, state is traditionally immutable, requiring you to emit entirely new state instances using `.copyWith()`.
In RxGet, state is a single mutable object that contains private reactive variables (observables). The UI only accesses public read-only getters.

### Before (BLoC / Equatable)
```dart
class FeatureState extends Equatable {
  final bool isLoading;
  final int count;

  const FeatureState({this.isLoading = false, this.count = 0});

  FeatureState copyWith({bool? isLoading, int? count}) {
    return FeatureState(
      isLoading: isLoading ?? this.isLoading,
      count: count ?? this.count,
    );
  }
  
  @override
  List<Object> get props => [isLoading, count];
}
```

### After (RxGet)
*File: `feature_state.dart`*
```dart
part of 'feature_controller.dart';

class _FeatureState extends GetxState {
  // 1. Private mutable reactive state
  final _isLoading = false.obs;
  final _count = 0.obs;

  // 2. Public read-only getters for the UI
  bool get isLoading => _isLoading.value;
  int get count => _count.value;

  // 3. Always clean up streams to prevent memory leaks
  @override
  void onClose() {
    _isLoading.close();
    _count.close();
  }
}
```

---

## 3. Migrating the Controller Logic

In BLoC, you map incoming `Events` to new `States` using `emit()` or `yield`.
In RxGet, you define public methods on the controller that internally mutate the private `Rx` variables of the state.

### Before (BLoC)
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc() : super(const FeatureState()) {
    on<IncrementEvent>((event, emit) {
      emit(state.copyWith(count: state.count + 1));
    });

    on<LoadDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(const Duration(seconds: 1)); // Mock work
      emit(state.copyWith(isLoading: false));
    });
  }
}
```

### After (RxGet)
*File: `feature_controller.dart`*
```dart
import 'package:rxget/rxget.dart';

part 'feature_state.dart';

class FeatureController extends GetxController<_FeatureState> {
  FeatureController() : state = _FeatureState();

  @override
  final _FeatureState state;

  // ==========================================
  // Public Events (Interface for UI)
  // ==========================================
  void incrementCount() => _incrementCount();
  Future<void> loadData() => _loadData();

  // ==========================================
  // Private Implementations (Business Logic)
  // ==========================================
  void _incrementCount() {
    // Mutate state directly. UI wrapped in Obx will automatically rebuild.
    state._count.value++; 
  }

  Future<void> _loadData() async {
    state._isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1)); // Mock work
    } finally {
      state._isLoading.value = false;
    }
  }
}
```

---

## 4. Migrating Dependency Injection & UI

In BLoC, `BlocProvider` makes the bloc available to the subtree, and `BlocBuilder` rebuilds the UI on state changes.
In RxGet, we use `GetInWidget` for injection, and `Obx` (or `Obl`) for rebuilding.

### Before (BLoC)
```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeatureBloc()..add(LoadDataEvent()),
      child: Scaffold(
        body: BlocBuilder<FeatureBloc, FeatureState>(
          builder: (context, state) {
            if (state.isLoading) return const CircularProgressIndicator();
            
            return Center(
              child: ElevatedButton(
                onPressed: () => context.read<FeatureBloc>().add(IncrementEvent()),
                child: Text('Count: ${state.count}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### After (RxGet)
```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetInWidget(
      dependencies: [
        // Inject the controller
        GetIn(() => FeatureController()..loadData()),
      ],
      child: Scaffold(
        // Wrap ONLY the reactive parts of the UI in Obx
        body: Obx(() {
          // Retrieve the controller
          final controller = Get.find<FeatureController>();
          
          if (controller.state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          return Center(
            child: ElevatedButton(
              onPressed: controller.incrementCount,
              child: Text('Count: ${controller.state.count}'),
            ),
          );
        }),
      ),
    );
  }
}
```

---

## 5. Summary & Best Practices

1. **State Safety**: Never expose `Rx` variables publicly in the State class. UI should only read primitives / regular objects.
2. **Encapsulation**: Separate public event declarations from private logic implementations in the Controller.
3. **Clean Up**: Always override `onClose()` in your state class to close `Rx` variables and streams.
4. **UI Performance**: Wrap only the smallest possible widgets in `Obx` or `Obl` to avoid rebuilding large widget trees unnecessarily.
5. **Connecting State**: Always use `part` and `part of` to link your controller and state files neatly.
