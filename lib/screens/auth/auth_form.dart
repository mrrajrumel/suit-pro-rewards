import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String? fullName, bool isLogin)
      _submitAuthForm;
  final bool isLoading;

  const AuthForm(this._submitAuthForm, this.isLoading, {super.key});

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget._submitAuthForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _isLogin ? null : _userName.trim(),
        _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!_isLogin)
            TextFormField(
              key: const ValueKey('fullname'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your full name.';
                }
                return null;
              },
              onSaved: (value) {
                _userName = value!;
              },
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
          TextFormField(
            key: const ValueKey('email'),
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
            onSaved: (value) {
              _userEmail = value!;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
            ),
          ),
          TextFormField(
            key: const ValueKey('password'),
            validator: (value) {
              if (value!.isEmpty || value.length < 7) {
                return 'Password must be at least 7 characters long.';
              }
              return null;
            },
            onSaved: (value) {
              _userPassword = value!;
            },
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          if (widget.isLoading) const CircularProgressIndicator(),
          if (!widget.isLoading)
            ElevatedButton(
              onPressed: _trySubmit,
              child: Text(_isLogin ? 'Login' : 'Signup'),
            ),
          if (!widget.isLoading)
            TextButton(
              child: Text(_isLogin
                  ? 'Create new account'
                  : 'I already have an account'),
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
            )
        ],
      ),
    );
  }
}
