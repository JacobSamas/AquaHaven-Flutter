# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Keep support library classes
-keep class androidx.lifecycle.DefaultLifecycleObserver

# Keep Kotlin metadata
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Keep application class
-keep public class * extends android.app.Application
-keep public class * extends androidx.appcompat.app.AppCompatActivity
-keep public class * extends androidx.fragment.app.Fragment
-keep public class * extends android.app.Fragment

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep View bindings
-keepclassmembers class * {
    @androidx.viewbinding.BindView *;
    @butterknife.BindView *;
    @butterknife.internal.DebounceOnClick *;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable implementations
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable

# Remove logs in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Keep important Flutter classes
-keep class io.flutter.plugins.GeneratedPluginRegistrant
-keep class io.flutter.embedding.engine.FlutterEngine
-keep class io.flutter.embedding.android.FlutterActivity
-keep class io.flutter.embedding.android.FlutterFragment
-keep class io.flutter.embedding.android.FlutterView

# Keep R classes
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Add project specific rules here
# For example, if you're using Firebase, add Firebase rules:
# -keep class com.google.firebase.** { *; }
# -keep class com.google.android.gms.** { *; }
