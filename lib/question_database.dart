class Question {
  final String id;
  final String category; // 'Beginner' | 'Intermediate' | 'Advanced'
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String? codeSnippet; // Optional code snippet to display

  const Question({
    required this.id,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.codeSnippet,
  });
}

const List<Question> questionDatabase = [
  // ==================== BEGINNER ====================
  Question(
    id: 'b1',
    category: 'Beginner',
    questionText: 'What is the primary difference between a StatelessWidget and a StatefulWidget?',
    options: [
      'StatelessWidget is faster to compile than StatefulWidget.',
      'StatelessWidget does not maintain mutable state, while StatefulWidget does.',
      'StatefulWidget cannot be updated once rendered.',
      'StatelessWidget requires a State object to render.'
    ],
    correctOptionIndex: 1,
    explanation: 'A StatelessWidget is immutable and its properties cannot change over time; its build method is called once or when its configuration updates. A StatefulWidget has an associated State object that can hold mutable state, which triggers a UI rebuild when setState() is called.',
  ),
  Question(
    id: 'b2',
    category: 'Beginner',
    questionText: 'Which file in a Flutter project is used to manage external packages, assets, and fonts?',
    options: [
      'pubspec.lock',
      'main.dart',
      'pubspec.yaml',
      'config.json'
    ],
    correctOptionIndex: 2,
    explanation: 'pubspec.yaml is the configuration file for a Flutter project. It is written in YAML and is used to define project metadata, specify third-party dependencies (from pub.dev), register asset images, and declare custom fonts.',
  ),
  Question(
    id: 'b3',
    category: 'Beginner',
    questionText: 'What command is used to run a Flutter app in development mode with support for Hot Reload?',
    options: [
      'flutter build',
      'flutter start',
      'flutter run',
      'flutter dev'
    ],
    correctOptionIndex: 2,
    explanation: 'The "flutter run" command compiles and launches the application on a connected device, emulator, or browser. It starts a development session supporting interactive commands like Hot Reload (press r) and Hot Restart (press R).',
  ),
  Question(
    id: 'b4',
    category: 'Beginner',
    questionText: 'What is the purpose of calling the `setState` method in a StatefulWidget?',
    options: [
      'It completely rebuilds the entire widget tree from the root.',
      'It notifies the framework that the internal state of this object has changed, triggering a rebuild for this widget.',
      'It initializes the state of the widget before rendering.',
      'It saves the state variables to local storage.'
    ],
    correctOptionIndex: 1,
    explanation: 'Calling setState() schedules a rebuild of the State object\'s build method. It tells the framework that some variables in the state have changed and that the user interface needs to be updated to reflect the new values.',
    codeSnippet: '''void _incrementCounter() {
  setState(() {
    _counter++; // Rebuilds the UI with the new counter value
  });
}''',
  ),
  Question(
    id: 'b5',
    category: 'Beginner',
    questionText: 'What is the role of the `main()` function in a Flutter/Dart application?',
    options: [
      'It defines the primary theme of the application.',
      'It is the entry point of the program where execution begins.',
      'It acts as a controller for global state management.',
      'It is only used for unit testing purposes.'
    ],
    correctOptionIndex: 1,
    explanation: 'In Dart and Flutter, the main() function is the mandatory entry point of the program. The runtime environment starts executing the application code inside main(), which typically calls runApp() to inflate the root widget.',
    codeSnippet: '''void main() {
  runApp(const MyApp());
}''',
  ),
  Question(
    id: 'b6',
    category: 'Beginner',
    questionText: 'Which widget is commonly used to create an infinite or long scrollable list of widgets efficiently?',
    options: [
      'SingleChildScrollView',
      'Column',
      'ListView.builder',
      'Row'
    ],
    correctOptionIndex: 2,
    explanation: 'ListView.builder is highly efficient for long lists because it uses a lazy-loading mechanism. It only builds and renders widgets that are currently visible on the screen, recycling them as they scroll off, which conserves device memory.',
    codeSnippet: '''ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item \$index'));
  },
)''',
  ),
  Question(
    id: 'b7',
    category: 'Beginner',
    questionText: 'What is the difference between Hot Reload and Hot Restart in Flutter?',
    options: [
      'Hot Reload compiles native code, while Hot Restart runs JIT compilation.',
      'Hot Reload updates the UI without resetting the app state, while Hot Restart resets the app state and restarts the app.',
      'Hot Reload is only available on web, while Hot Restart is for mobile.',
      'There is no difference; they are different names for the same process.'
    ],
    correctOptionIndex: 1,
    explanation: 'Hot Reload injects updated code into the running Dart VM, rebuilds the widget tree, and preserves the application state. Hot Restart also loads code changes, but resets the state to its initial conditions and restarts the application from main().',
  ),
  Question(
    id: 'b8',
    category: 'Beginner',
    questionText: 'In Flutter, which layout widget displays its children in a horizontal row?',
    options: [
      'Column',
      'Stack',
      'Row',
      'Wrap'
    ],
    correctOptionIndex: 2,
    explanation: 'A Row is a layout widget that displays its children in a horizontal array (along the x-axis). The main axis is horizontal, and the cross axis is vertical.',
  ),
  Question(
    id: 'b9',
    category: 'Beginner',
    questionText: 'Which widget is used to apply spacing or margin around a child widget?',
    options: [
      'Spacer',
      'Padding',
      'Expanded',
      'Center'
    ],
    correctOptionIndex: 1,
    explanation: 'The Padding widget adds empty space (inset) around its child. While Container has a padding property, using the dedicated Padding widget is more lightweight and follows Flutter\'s composition-first philosophy.',
    codeSnippet: '''Padding(
  padding: const EdgeInsets.all(16.0),
  child: Text('Hello World'),
)''',
  ),
  Question(
    id: 'b10',
    category: 'Beginner',
    questionText: 'What is the name of the package repository and manager for Dart and Flutter?',
    options: [
      'npm',
      'CocoaPods',
      'Pub',
      'Maven'
    ],
    correctOptionIndex: 2,
    explanation: 'Pub is the package management system for Dart and Flutter. It manages dependencies, downloads them from pub.dev, and generates the pubspec.lock file to pin versions.',
  ),

  // ==================== INTERMEDIATE ====================
  Question(
    id: 'i1',
    category: 'Intermediate',
    questionText: 'What is the primary purpose of a `GlobalKey` in Flutter?',
    options: [
      'To define global configuration values and strings.',
      'To uniquely identify a widget and access its State or Element from anywhere in the app.',
      'To manage global styles and themes.',
      'To create cross-platform database connections.'
    ],
    correctOptionIndex: 1,
    explanation: 'A GlobalKey uniquely identifies a widget across the entire application widget tree. It allows access to the State, Element, or RenderObject associated with that widget. It is also used to move widgets within the tree without losing their state, although they are resource-heavy.',
    codeSnippet: '''final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// Later used to validate form from a button:
_formKey.currentState?.validate();''',
  ),
  Question(
    id: 'i2',
    category: 'Intermediate',
    questionText: 'How is asynchronous programming handled in Dart using the Event Loop?',
    options: [
      'Dart compiles async code into separate OS threads automatically.',
      'Dart runs on a single thread and schedules async tasks in the Microtask and Event queues.',
      'Dart uses background JS workers for asynchronous requests.',
      'Dart does not support asynchronous programming.'
    ],
    correctOptionIndex: 1,
    explanation: 'Dart is single-threaded and executes code within an isolate. Asynchronous operations are managed by an Event Loop, which processes tasks from two queues: the high-priority Microtask queue (for internal VM operations) and the Event queue (for futures, timers, user inputs, and network responses).',
  ),
  Question(
    id: 'i3',
    category: 'Intermediate',
    questionText: 'What is the difference between a `Future` and a `Stream` in Dart?',
    options: [
      'A Future represents a single asynchronous value, whereas a Stream represents a sequence of asynchronous values over time.',
      'A Future runs synchronously, and a Stream runs asynchronously.',
      'Futures are only used for network requests, and Streams are for UI rendering.',
      'Streams cannot trigger UI rebuilds, whereas Futures can.'
    ],
    correctOptionIndex: 0,
    explanation: 'A Future represents a one-time asynchronous computation that completes either with a value or an error. A Stream represents a sequence of asynchronous events (zero or more values, errors, or a done signal) that can be listened to over time.',
    codeSnippet: '''Future<String> fetchUser() async {
  return "Alice"; // Completes once
}

Stream<int> counterStream() async* {
  for (int i = 0; i < 5; i++) {
    yield i; // Emits multiple values over time
  }
}''',
  ),
  Question(
    id: 'i4',
    category: 'Intermediate',
    questionText: 'Which lifecycle method of a `State` object is called exactly once when the widget is first inserted into the tree?',
    options: [
      'build',
      'didUpdateWidget',
      'initState',
      'dispose'
    ],
    correctOptionIndex: 2,
    explanation: 'initState() is called exactly once when the State object is created and inserted into the widget tree. It is used for one-time initialization like setting up animation controllers, subscribing to streams, or initializing local variables.',
    codeSnippet: '''@override
void initState() {
  super.initState();
  _controller = TextEditingController();
}''',
  ),
  Question(
    id: 'i5',
    category: 'Intermediate',
    questionText: 'What is the role of an `InheritedWidget` in Flutter?',
    options: [
      'To pass data down the widget tree efficiently to descendants without passing parameters manually.',
      'To implement widget-based class inheritance and method overrides.',
      'To provide platform-specific UI rendering (Android vs iOS).',
      'To manage native background threads.'
    ],
    correctOptionIndex: 0,
    explanation: 'InheritedWidget is a base class that propagates information down the widget tree. Descendant widgets can query the nearest ancestor InheritedWidget of a specific type (e.g., Theme or MediaQuery) and register themselves to rebuild automatically when that widget changes.',
    codeSnippet: '''class MyInheritedTheme extends InheritedWidget {
  final Color themeColor;
  
  const MyInheritedTheme({required this.themeColor, required super.child});
  
  static MyInheritedTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedTheme>();
  }
  
  @override
  bool updateShouldNotify(MyInheritedTheme oldWidget) => themeColor != oldWidget.themeColor;
}''',
  ),
  Question(
    id: 'i6',
    category: 'Intermediate',
    questionText: 'How does Navigator 2.0 (Router API) differ from Navigator 1.0?',
    options: [
      'Navigator 2.0 is written in native Java/Swift, whereas Navigator 1.0 is in Dart.',
      'Navigator 2.0 is declarative and makes the page stack a direct function of the application state, whereas Navigator 1.0 is imperative.',
      'Navigator 2.0 runs faster and consumes less memory, but lacks back button support.',
      'Navigator 2.0 only supports web apps, whereas Navigator 1.0 is for mobile only.'
    ],
    correctOptionIndex: 1,
    explanation: 'Navigator 1.0 is imperative, where screens are pushed and popped manually (e.g., Navigator.push). Navigator 2.0 (Router API) is declarative. It binds the navigation stack to the app\'s state, automatically updating the visible pages when state changes. This is highly useful for handling browser URL syncing, web deep linking, and hardware back buttons.',
  ),
  Question(
    id: 'i7',
    category: 'Intermediate',
    questionText: 'When is the `didUpdateWidget` lifecycle method called in a StatefulWidget\'s State class?',
    options: [
      'Immediately after the build method finishes rendering.',
      'When the parent widget rebuilds and passes a new widget configuration with the same runtime type and key.',
      'When the state object is destroyed and garbage-collected.',
      'When the device changes screen orientation.'
    ],
    correctOptionIndex: 1,
    explanation: 'didUpdateWidget(oldWidget) is triggered when the parent widget rebuilds and passes a new widget instance of the same type and key. This allows the persistent State object to compare properties between the old and new widget configuration and reinitialize or respond to changes.',
    codeSnippet: '''@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.userId != oldWidget.userId) {
    _fetchUserData(); // Reload data if userId parameter changed
  }
}''',
  ),
  Question(
    id: 'i8',
    category: 'Intermediate',
    questionText: 'What is the role of `BuildContext` in the Flutter framework?',
    options: [
      'It is used to compile native binaries for Android and iOS.',
      'It represents a handle to the location of a widget in the widget tree structure.',
      'It is a global variable used to access SQLite database configurations.',
      'It is only used to manage state inside local caches.'
    ],
    correctOptionIndex: 1,
    explanation: 'BuildContext is an object representing a widget\'s location in the widget tree. It provides a way to look up ancestor widgets (like InheritedWidgets), retrieve themes and styles, and obtain sizes or positions. Each widget has its own BuildContext passed to its build() method.',
  ),
  Question(
    id: 'i9',
    category: 'Intermediate',
    questionText: 'Why are `Keys` useful in Flutter when working with lists of stateful widgets?',
    options: [
      'They encrypt widget parameters for local caching.',
      'They help Flutter\'s element reconciliation algorithm preserve state when widgets are moved, reordered, or deleted in the tree.',
      'They define database primary keys for SQLite packages.',
      'They map hardware keyboard inputs to specific widgets.'
    ],
    correctOptionIndex: 1,
    explanation: 'Keys assist Flutter in identifying which widgets map to which active Elements in the tree. When stateful widgets are reordered, deleted, or inserted in a list, standard widget matching by runtime type is insufficient. Using UniqueKey or ValueKey ensures that the State object remains attached to the correct widget configuration.',
  ),
  Question(
    id: 'i10',
    category: 'Intermediate',
    questionText: 'What is the purpose of the `CustomPaint` widget in Flutter?',
    options: [
      'To render external HTML pages inside the Flutter tree.',
      'To provide a canvas on which custom shapes, lines, and vectors can be drawn using a CustomPainter.',
      'To download and optimize remote image assets.',
      'To animate text styles without using an AnimationController.'
    ],
    correctOptionIndex: 1,
    explanation: 'CustomPaint is a widget that exposes a drawing Canvas. By subclassing CustomPainter and implementing paint() and shouldRepaint(), developers can draw shapes, lines, gradients, and custom layouts at the pixel level directly via drawing commands.',
    codeSnippet: '''CustomPaint(
  size: const Size(200, 200),
  painter: MyCirclePainter(),
)''',
  ),

  // ==================== ADVANCED ====================
  Question(
    id: 'a1',
    category: 'Advanced',
    questionText: 'What is the difference between Dart\'s Microtask queue and Event queue?',
    options: [
      'Microtask queue runs on a secondary thread, while the Event queue runs on the main thread.',
      'The Microtask queue has higher priority; the event loop drains it completely before running the next event from the Event queue.',
      'Microtasks are used for UI paint instructions, and Events are for I/O operations.',
      'There is no difference; they are processed concurrently on a FIFO basis.'
    ],
    correctOptionIndex: 1,
    explanation: 'Dart\'s Event Loop manages two queues. The Microtask queue is for short, internal tasks that need to run asynchronously but as soon as possible (before the next event is executed). The Event queue is for standard events (user inputs, network I/O, timers). The loop drains the microtask queue completely before processing each event.',
    codeSnippet: '''Future(() => print('Event')); // Scheduled on Event queue
scheduleMicrotask(() => print('Microtask')); // Scheduled on Microtask queue
print('Sync');
// Output: Sync -> Microtask -> Event''',
  ),
  Question(
    id: 'a2',
    category: 'Advanced',
    questionText: 'How do `Isolates` in Dart differ from threads in traditional programming languages like Java or C++?',
    options: [
      'Isolates are run on a single logical CPU core and cannot perform parallel computations.',
      'Isolates do not share memory; each has its own private heap and event loop, communicating solely by message passing.',
      'Isolates are managed by the operating system directly rather than the Dart Virtual Machine.',
      'Isolates share the same memory heap but have separate stack frames.'
    ],
    correctOptionIndex: 1,
    explanation: 'Unlike traditional threads that share memory and require locks or mutexes to prevent race conditions, Dart Isolates do not share memory. Each isolate has its own isolated heap, memory allocation, garbage collector, and event loop. Isolates communicate asynchronously by passing serialized messages through SendPort and ReceivePort.',
    codeSnippet: '''// Spawning an isolate:
final receivePort = ReceivePort();
await Isolate.spawn(heavyCalculation, receivePort.sendPort);
receivePort.listen((message) {
  print('Result from isolate: \$message');
});''',
  ),
  Question(
    id: 'a3',
    category: 'Advanced',
    questionText: 'What is the primary optimization benefit of the `RepaintBoundary` widget?',
    options: [
      'It prevents child widgets from calling build() again.',
      'It isolates a subtree so that it repaints independently of its parent and sibling widgets, creating its own display list layer.',
      'It scales down high-resolution images to conserve GPU memory.',
      'It compiles widgets into native platforms ahead of time.'
    ],
    correctOptionIndex: 1,
    explanation: 'RepaintBoundary forces its child subtree to render onto a separate display list/layer. When the child or parent is invalidated, only that specific layer repaints rather than rendering the entire screen. This is crucial for optimizing performance in highly animated or scrollable subviews.',
    codeSnippet: '''RepaintBoundary(
  child: MyComplexAnimationWidget(),
)''',
  ),
  Question(
    id: 'a4',
    category: 'Advanced',
    questionText: 'In Flutter\'s rendering pipeline, what are the roles of the Widget, Element, and RenderObject trees?',
    options: [
      'Widget tree handles networking, Element tree handles state, RenderObject tree handles UI.',
      'Widget tree contains immutable configurations, Element tree manages lifecycles and links trees (the glue), RenderObject tree controls size, layout, and painting.',
      'Widget tree compiles to CSS, Element tree compiles to HTML, RenderObject tree compiles to Javascript.',
      'Widget tree is for mobile, Element tree is for web, RenderObject tree is for desktop.'
    ],
    correctOptionIndex: 1,
    explanation: '1. Widget Tree: Immutable, lightweight configuration blueprints. Rebuilt frequently.\n2. Element Tree: The logical structure, managing lifecycle states and holding references to widgets and RenderObjects. Re-used where possible.\n3. RenderObject Tree: The actual rendering objects containing dimensions, margins, hit-testing, and drawing instructions. This tree is maintained for high-performance layout and painting.',
  ),
  Question(
    id: 'a5',
    category: 'Advanced',
    questionText: 'What is the layout protocol rule of a `RenderObject` in Flutter?',
    options: [
      'Size is decided first by the child, and position is decided by the parent.',
      'Constraints go down, sizes go up, and parent sets the positions.',
      'RenderObjects automatically occupy the entire screen unless padding is applied.',
      'Layout is determined by CSS Flexbox rules computed inside Dart VM.'
    ],
    correctOptionIndex: 1,
    explanation: 'The layout protocol in Flutter follows the rule: "Constraints go down, sizes go up, parent sets position." A parent RenderObject passes constraints (minimum/maximum width/height) to its child. The child computes its size within those boundaries and returns its size to the parent. The parent then decides the horizontal and vertical offset position of the child.',
  ),
  Question(
    id: 'a6',
    category: 'Advanced',
    questionText: 'How does a `MethodChannel` allow Dart to communicate with native iOS (Swift/ObjC) or Android (Kotlin/Java) platforms?',
    options: [
      'By compiling Dart classes directly into Java bytecodes and Swift structs.',
      'By passing serialized asynchronous messages across a platform channel bridge.',
      'By using native web views and injecting JavaScript functions.',
      'By running a local HTTP server on the device and fetching JSON responses.'
    ],
    correctOptionIndex: 1,
    explanation: 'MethodChannel enables communication between Dart and host platform code (Swift/Kotlin). When Dart calls a method on a MethodChannel, it serializes the method name and arguments into binary. The platform runner receives the message, runs native code, and returns a serialized response asynchronously back to Dart.',
    codeSnippet: '''// Dart Side:
static const platform = MethodChannel('samples.flutter.dev/battery');
final int result = await platform.invokeMethod('getBatteryLevel');

// Native Android (Kotlin):
MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
  if (call.method == "getBatteryLevel") {
    result.success(getBattery())
  }
}''',
  ),
  Question(
    id: 'a7',
    category: 'Advanced',
    questionText: 'What is Dart\'s `FFI` (Foreign Function Interface) used for in Flutter development?',
    options: [
      'To compile WebAssembly binaries for the web target.',
      'To directly invoke C/C++ libraries and allocate native memory from Dart, bypassing MethodChannels.',
      'To format Dart source code automatically.',
      'To create animations using physics simulation models.'
    ],
    correctOptionIndex: 1,
    explanation: 'Dart FFI (Foreign Function Interface) enables Dart code to directly load shared libraries (like .dll, .so, .dylib) written in C, C++, or Rust. It allows calling native functions, allocating native memory, and passing data directly, avoiding the message-serialization overhead of MethodChannels.',
    codeSnippet: '''import 'dart:ffi' as ffi;
// Open shared library:
final dylib = ffi.DynamicLibrary.open('libsqlite3.so');
// Look up a C function:
final sqlite3_open = dylib.lookupFunction<...>();''',
  ),
  Question(
    id: 'a8',
    category: 'Advanced',
    questionText: 'What does the "Paint" phase do in the Flutter rendering pipeline?',
    options: [
      'It instantly draws RGB colors onto the physical screen pixels.',
      'It records drawing operations on a Canvas using a PictureRecorder, which creates display lists.',
      'It compiles widget styles into HTML and CSS files.',
      'It downloads images from network URLs.'
    ],
    correctOptionIndex: 1,
    explanation: 'The Paint phase doesn\'t draw directly to the screen pixels. Instead, it processes the RenderObject tree and records drawing instructions (drawRect, drawPath, drawText) onto a Canvas with a PictureRecorder, outputting a set of display commands. These commands are sent to the compositing layer, where the GPU rasterizes them using Impeller or Skia.',
  ),
  Question(
    id: 'a9',
    category: 'Advanced',
    questionText: 'What is the responsibility of the `SchedulerBinding` in the Flutter architecture?',
    options: [
      'To manage package upgrades and dependency downloads.',
      'To coordinate frame callbacks, tickers, and transient callbacks in sync with the screen refresh rate (VSYNC).',
      'To schedule background database backup processes.',
      'To manage remote network request timeouts.'
    ],
    correctOptionIndex: 1,
    explanation: 'SchedulerBinding coordinates the execution of frame-rendering loops. It registers callbacks that run at various phases of a frame (e.g., Ticker animations during transient callbacks, layout/draw calls during persistent callbacks) synchronized with VSYNC signals from the operating system.',
  ),
  Question(
    id: 'a10',
    category: 'Advanced',
    questionText: 'What is a common cause of memory leaks in Flutter applications, and how is it resolved?',
    options: [
      'Using too many StatelessWidget instances, resolved by converting to StatefulWidgets.',
      'Failing to dispose of controllers (e.g., AnimationController, ScrollController) and failing to cancel Stream subscriptions when widgets are destroyed.',
      'Loading too many network images, resolved by using SVG files.',
      'Running too many asynchronous isolates simultaneously.'
    ],
    correctOptionIndex: 1,
    explanation: 'Memory leaks occur when objects that should be garbage-collected remain referenced. In Flutter, this frequently happens when controllers (AnimationController, ScrollController, TextEditingController) or StreamSubscriptions are created within a state object but not cleaned up. This is resolved by cancelling subscriptions and invoking .dispose() on controllers inside the dispose() lifecycle method.',
    codeSnippet: '''@override
void dispose() {
  _animationController.dispose();
  _textController.dispose();
  _streamSubscription.cancel();
  super.dispose();
}''',
  ),
];
