import 'package:fiqah/presentation/screen/main/main_menu_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form and input controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State for password visibility
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Dummy user data for validation
  static const String _dummyEmail = 'test@example.com';
  static const String _dummyPassword = 'password123';

  @override
  void initState() {
    super.initState();
    // Initialize animations
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// --- Validation and Login Logic --- ///

  void _login() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Validate the form. If it's not valid, do nothing.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate a network request
    await Future.delayed(Duration(seconds: 2));

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Check against dummy credentials
    if (email == _dummyEmail && password == _dummyPassword) {
      // On success, navigate to the main menu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenuScreen()),
      );
    } else {
      // On failure, show a themed error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or password. Please try again.'),
          backgroundColor: Colors.black54,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// --- Build Method and UI Widgets --- ///

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade700, Colors.green.shade900],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    _buildHeaderIcon(),
                    SizedBox(height: 20),
                    _buildTitle(),
                    _buildSubtitle(),
                    SizedBox(height: 40),
                    _buildLoginForm(),
                    SizedBox(height: 30),
                    _buildLoginButton(),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildHeaderIcon() {
    // A decorative icon at the top
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2)),
      child: Icon(
        Icons.book_outlined,
        size: 50,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle() {
    // The main title of the screen
    return Text(
      'Fiqih Pernikahan', // Marriage Fiqh
      style: TextStyle(
        fontFamily: 'Serif',
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.3),
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Sign in to continue',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white.withOpacity(0.8),
      ),
    );
  }

  Widget _buildLoginForm() {
    // The Form widget that contains our input fields
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          SizedBox(height: 20),
          _buildPasswordField(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    // TextFormField for email input
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(
        hintText: 'Enter your email',
        prefixIcon: Icons.email_outlined,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        // Using a simple regex for email validation
        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    // TextFormField for password input
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible, // Hides the password
      style: TextStyle(color: Colors.white),
      decoration: _buildInputDecoration(
        hintText: 'Enter your password',
        prefixIcon: Icons.lock_outline,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    // A helper method for consistent input field styling
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(prefixIcon, color: Colors.white.withOpacity(0.7)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        // Consistent border styling for all states
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent.shade100, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.redAccent.shade100, width: 2),
        ),
        errorStyle: TextStyle(
            color: Colors.redAccent.shade100, fontWeight: FontWeight.bold));
  }

  Widget _buildLoginButton() {
    // The main login button, now themed in green
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _isLoading ? null : _login, // Disable button when loading
          child: Center(
            child: _isLoading
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.green.shade800),
                  )
                : Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                      letterSpacing: 1.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
