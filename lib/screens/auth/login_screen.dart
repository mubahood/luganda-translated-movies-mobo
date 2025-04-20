import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart'; // Assuming FxButton, FxText are used
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart'; // For icons

// Assuming these paths are correct - adjust if needed
import 'package:ugflix/screens/auth/password_reset_screen.dart';
import 'package:ugflix/screens/auth/register_screen.dart';
import '../../core/styles.dart'; // Assuming AppStyles is here
import '../../models/LoggedInUserModel.dart';
import '../../models/RespondModel.dart';

// Assuming SplashScreen path is correct
import '../../src/features/app_introduction/view/splash_screen.dart';

// Controller import might not be needed if logic stays within the screen state
// import '../../src/features/authentication/controllers/login_screen_controller.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart'; // Your theme colors
import '../../utils/Utilities.dart'; // Your utilities

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Keep controller if complex logic is needed, otherwise manage state locally
  // final LoginScreenController _loginController = LoginScreenController();
  final RxBool _isLoading = false.obs; // Use RxBool for reactive loading state
  final RxBool _obscurePassword = true.obs; // For password visibility toggle

  // Define colors from theme for consistency
  late Color _accentColor;
  late Color _primaryColor;
  late Color _textColor;
  late Color _textMutedColor;
  late Color _textFieldFillColor;

  @override
  void initState() {
    super.initState();
    // Initialize theme colors (ensure CustomTheme is accessible)
    _accentColor = CustomTheme.accent; // Your defined accent color
    _primaryColor = CustomTheme.primary;
    _textColor = Colors.white;
    _textMutedColor = Colors.white70;
    _textFieldFillColor = Colors.white.withOpacity(0.15);

    // Ensure theme is initialized if needed globally elsewhere
    // Utils.init_theme(); // Call this in main.dart ideally
    checkForUpdate();
  }

  @override
  void dispose() {
    // Dispose controller if used
    // _loginController.dispose();
    super.dispose();
  }

  // --- UI Build Methods ---

  @override
  Widget build(BuildContext context) {
    // Get text theme for consistent styling
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent, // Needed for Stack background
        appBar: AppBar(
          // Keep AppBar transparent for status bar style
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            // Make status bar transparent
            statusBarIconBrightness: Brightness.light,
            // Light icons for dark background
            systemNavigationBarColor: _primaryColor.withOpacity(0.8),
            // Match gradient bottom
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        ),
        body: Stack(
          children: [
            _buildBackground(),
            _buildGradientOverlay(),
            _buildLoginForm(textTheme), // Pass theme
            // Optional: Loading overlay
            Obx(() => _isLoading.value
                ? _buildLoadingOverlay()
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/bg.jpg', // Ensure this path is correct
        fit: BoxFit.cover,
        // Optional: Add slight color filter if image is too bright/distracting
        // color: Colors.black.withOpacity(0.1),
        // colorBlendMode: BlendMode.darken,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.0, 0.7, 1.0],
            // Adjust stops for smoother transition
            colors: [
              _primaryColor.withOpacity(0.95), // Darker near bottom
              _primaryColor.withOpacity(0.7),
              Colors.transparent, // Fades out at top
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(TextTheme textTheme) {
    return Center(
      child: SingleChildScrollView(
        // Ensures form scrolls on smaller screens
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25), // More rounded corners
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            // Slightly more blur
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              // Adjust padding
              decoration: BoxDecoration(
                // Slightly more opaque for better readability
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                    color: Colors.white.withOpacity(0.15)), // Softer border
              ),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent column stretching
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 20),
                    _buildTitle(textTheme),
                    const SizedBox(height: 35),
                    _buildEmailField(textTheme),
                    const SizedBox(height: 20),
                    _buildPasswordField(textTheme),
                    const SizedBox(height: 10),
                    _buildForgotPassword(textTheme),
                    const SizedBox(height: 25),
                    _buildSignInButton(textTheme),
                    const SizedBox(height: 30),
                    _buildDivider(textTheme),
                    const SizedBox(height: 20),
                    _buildCreateAccountLink(textTheme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        AppConfig.logo_1, // Ensure this path is correct
        width: 130, // Adjust size as needed
        fit: BoxFit.contain,
        // Optional: Add semantic label for accessibility
        // semanticLabel: 'App Logo',
      ),
    );
  }

  Widget _buildTitle(TextTheme textTheme) {
    return Center(
      child: Text(
        'Sign In',
        // Use theme headline style and override color/weight
        style: textTheme.headlineMedium?.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmailField(TextTheme textTheme) {
    return FormBuilderTextField(
      name: "email",
      style: textTheme.bodyLarge?.copyWith(color: _textColor),
      // Use theme style
      cursorColor: _accentColor,
      decoration: _inputDecoration(
        hintText: 'Enter your email',
        labelText: 'Email',
        prefixIcon: FeatherIcons.mail,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "Email is required."),
        FormBuilderValidators.email(errorText: "Please enter a valid email."),
      ]),
    );
  }

  Widget _buildPasswordField(TextTheme textTheme) {
    return Obx(() => FormBuilderTextField(
          // Wrap with Obx for reactivity
          name: "password",
          style: textTheme.bodyLarge?.copyWith(color: _textColor),
          cursorColor: _accentColor,
          obscureText: _obscurePassword.value,
          // Use reactive value
          decoration: _inputDecoration(
            hintText: 'Enter your password',
            labelText: 'Password',
            prefixIcon: FeatherIcons.lock,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword.value ? FeatherIcons.eyeOff : FeatherIcons.eye,
                color: _textMutedColor,
                size: 20,
              ),
              onPressed: () => _obscurePassword.toggle(), // Toggle visibility
            ),
          ),
          textInputAction: TextInputAction.done,
          validator: FormBuilderValidators.required(
              errorText: "Password is required."),
          // Submit form on action key press (optional)
          // onFieldSubmitted: (_) => _isLoading.value ? null : _attemptLogin(),
        ));
  }

  Widget _buildForgotPassword(TextTheme textTheme) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(() => const PasswordResetScreen()),
        style: TextButton.styleFrom(
          foregroundColor: _accentColor.withOpacity(0.4), // Splash color
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: Text(
          "Forgot Password?",
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: _accentColor, // Use accent color
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(TextTheme textTheme) {
    return Obx(() => ElevatedButton(
          // Wrap with Obx to react to loading state
          onPressed: _isLoading.value ? null : _attemptLogin,
          // Disable when loading
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            // Slightly taller
            backgroundColor: _accentColor,
            // Use accent color
            foregroundColor: Colors.black,
            // Text/icon color on accent button
            disabledBackgroundColor: _accentColor.withOpacity(0.5),
            // Dim when disabled
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            // More rounded
            elevation: 4,
            // Add elevation
            shadowColor: _accentColor.withOpacity(0.3),
          ),
          child: _isLoading.value
              ? SizedBox(
                  // Constrained progress indicator
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                    // Use primary for contrast
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  'Sign In',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black, // Ensure contrast
                  ),
                ),
        ));
  }

  Widget _buildDivider(TextTheme textTheme) {
    return Row(
      children: [
        Expanded(child: Divider(color: _textMutedColor, thickness: 0.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR",
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: _textMutedColor,
            ),
          ),
        ),
        Expanded(child: Divider(color: _textMutedColor, thickness: 0.5)),
      ],
    );
  }

  Widget _buildCreateAccountLink(TextTheme textTheme) {
    return Row(
      // Use Row for better alignment
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: textTheme.bodyMedium?.copyWith(color: _textMutedColor),
        ),
        TextButton(
          onPressed: () => Get.to(() => const RegisterScreen()),
          style: TextButton.styleFrom(
            foregroundColor: _accentColor.withOpacity(0.4), // Splash
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          ),
          child: Text(
            'Create Account',
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: _accentColor, // Use accent color
              // decoration: TextDecoration.underline, // Optional underline
              // decorationColor: _accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
        ),
      ),
    );
  }

  // --- Helper for Input Decoration ---

  InputDecoration _inputDecoration({
    required String hintText,
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: _textMutedColor, size: 20),
      suffixIcon: suffixIcon,
      // Style for label when focused/unfocused
      labelStyle: TextStyle(color: _textMutedColor),
      floatingLabelStyle: TextStyle(color: _accentColor),
      // Accent when focused
      hintStyle: TextStyle(color: _textMutedColor.withOpacity(0.5)),
      // Fill color and borders
      filled: true,
      fillColor: _textFieldFillColor,
      // Use defined fill color
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      // Adjust padding
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
        borderSide: BorderSide.none, // No border by default
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2), width: 1), // Subtle border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: _accentColor, width: 1.5), // Accent border on focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent.shade100, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.redAccent.shade100, width: 1.5),
      ),
      errorStyle: const TextStyle(
          color: Colors.redAccent, fontSize: 12), // Customize error text
    );
  }

  // --- Logic Methods ---

  Future<void> _attemptLogin() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.saveAndValidate()) {
      // Shake animation or subtle feedback on validation fail? (Optional)
      return;
    }

    _isLoading(true); // Start loading

    final formData = {
      'email': _formKey.currentState!.fields['email']!.value.toString().trim(),
      'password': _formKey.currentState!.fields['password']!.value.toString(),
    };

    // Show loading feedback (overlay is handled by Obx)
    // Get.dialog(Center(child: CircularProgressIndicator(color: _accentColor)), barrierDismissible: false);

    try {
      final resp = await Utils.http_post(
          'auth/login', formData); // Ensure Utils handles errors
      final responseModel = RespondModel(resp);

      if (responseModel.code != 1) {
        _showErrorSnackbar("Login Failed",
            responseModel.message ?? "An unknown error occurred.");
        _isLoading(false);
        return;
      }

      if (responseModel.data == null || responseModel.data['user'] == null) {
        _showErrorSnackbar("Login Failed", "User data not found in response.");
        _isLoading(false);
        return;
      }

      final user = LoggedInUserModel.fromJson(responseModel.data['user']);
      if (user.id < 1) {
        _showErrorSnackbar("Login Failed", "Invalid user data received.");
        _isLoading(false);
        return;
      }

      // Save user data and token
      if (!(await user.save())) {
        // Ensure save method returns bool
        _showErrorSnackbar("Login Failed", "Could not save your session.");
        _isLoading(false);
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'token', user.token ?? ''); // Handle potential null token

      // Success feedback (optional)
      Get.snackbar(
        "Login Successful",
        "Welcome back, ${user.name}!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        icon: const Icon(FeatherIcons.checkCircle, color: Colors.white),
      );

      // Navigate to home/splash screen after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAll(
          () => const SplashScreen()); // Use offAll to clear navigation stack
    } catch (e) {
      print("Login Exception: $e");
      _showErrorSnackbar(
          "Login Error", "An unexpected error occurred. Please try again.");
      _isLoading(false);
    } finally {
      // Ensure loading state is always turned off
      // if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog if used
      _isLoading(false);
    }
  }

  Future<bool> _onWillPop() async {
    // Use GetX dialog with custom styling
    final result = await Get.defaultDialog<bool>(
      title: "Confirm Exit",
      titleStyle: TextStyle(color: _textColor, fontWeight: FontWeight.w600),
      middleText: "Are you sure you want to quit the App?",
      middleTextStyle: TextStyle(color: _textMutedColor),
      backgroundColor: _primaryColor.withOpacity(0.9),
      // Use primary color
      barrierDismissible: true,
      radius: 15,
      contentPadding: const EdgeInsets.all(20),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          // Dismiss dialog, return false
          child: FxText('CANCEL', color: _textMutedColor),
        ),
        ElevatedButton(
          // Use ElevatedButton for the primary action
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, // Destructive action color
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Get.back(result: true); // Dismiss dialog, return true
            // Use SystemNavigator.pop() for a cleaner exit if appropriate
            SystemNavigator.pop();
          },
          child: FxText('QUIT'),
        ),
      ],
    );
    // Return true if user confirmed exit, false otherwise (or null if dismissed)
    return result ?? false;
  }

  /// Helper to show a standardized error SnackBar.
  void _showErrorSnackbar(String title, String message) {
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
      icon: const Icon(FeatherIcons.alertCircle, color: Colors.white, size: 20),
    );
  }
}

Future<void> checkForUpdate() async {
/*  InAppUpdate.checkForUpdate().then((info) {
    try {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          return AppUpdateResult.inAppUpdateFailed;
        });
      }
    } catch (e) {
      print(e);
    }
  }).catchError((e) {});*/
}
