# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Connectivity Plus
-keep class com.baseflow.connectivity.** { *; }

# Fix Play Core build failures (referenced by Flutter engine for deferred components)
-dontwarn com.google.android.play.core.**


