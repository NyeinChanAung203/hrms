import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../providers/auth_provider.dart';

import '../providers/theme_provider.dart';
import '../themes/styles.dart';
import 'package:provider/provider.dart';

import 'forgotpw_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  late Future<void> getFormDataAndCheckBox;

  @override
  void initState() {
    super.initState();
    getFormDataAndCheckBox =
        context.read<AuthProvider>().getFormDataAndCheckBox();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder(
          future: getFormDataAndCheckBox,
          builder: (context, snapshot) {
            emailController.text = context.read<AuthProvider>().email ?? '';
            passwordController.text =
                context.read<AuthProvider>().password ?? '';

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),
              );
            }
            return Form(
              key: _formKey,
              child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  controller: scrollController,
                  children: [
                    /* Cover Image */
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 20),
                      child: Image.asset(
                        "assets/loginboard.png",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
                    ),
                    /* Logo Image */
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: SvgPicture.asset(
                        "assets/logob.svg",
                        height: 30,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                            context.watch<ThemeProvider>().themeMode ==
                                    ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            BlendMode.srcIn),
                        fit: BoxFit.contain,
                      ),
                    ),
                    /* Welcome Text */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'EMS',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: kPrimaryColor,
                                  ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // Text('Emplyee\'s App',
                    //     textAlign: TextAlign.center,
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .titleMedium
                    // ?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 20,
                    ),
                    buildEmailField(),
                    const SizedBox(
                      height: 18,
                    ),
                    PasswordField(
                        scrollController: scrollController,
                        passwordController: passwordController),
                    const SizedBox(
                      height: 8,
                    ),
                    buildRMCheckbox(context),
                    const SizedBox(
                      height: 8,
                    ),
                    buildSubmitBtn(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30, top: 10),
                      child: GestureDetector(
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: kPrimaryColor),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ForgotPwScreen()));
                        },
                      ),
                    )
                  ]),
            );
          }),
    );
  }

  Padding buildSubmitBtn() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 20,
      ),
      child: SizedBox(
        height: 55,
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            return ElevatedButton(
              onPressed: provider.btnLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        await provider.login(
                            context,
                            emailController.text.trim(),
                            passwordController.text.trim());
                      }
                    },
              child: provider.btnLoading
                  ? const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    )
                  : const Text('Login'),
            );
          },
        ),
      ),
    );
  }

  GestureDetector buildRMCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AuthProvider>().toggleCheckbox();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Checkbox(
                value: provider.isRememberme,
                onChanged: (v) => provider.toggleCheckbox(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          ),
          Text(
            'Remember me',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Padding buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        onTap: () {
          Future.delayed(
              const Duration(milliseconds: 200),
              () => scrollController.animateTo(
                  scrollController.position.viewportDimension,
                  duration: const Duration(
                    milliseconds: 800,
                  ),
                  curve: Curves.linear));
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill the Email';
          }
          return null;
        },
        autocorrect: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.scrollController,
    required this.passwordController,
  });

  final ScrollController scrollController;
  final TextEditingController passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isSecure = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        onTap: () {
          Future.delayed(
              const Duration(milliseconds: 200),
              () => widget.scrollController
                  .animateTo(widget.scrollController.position.viewportDimension,
                      duration: const Duration(
                        milliseconds: 800,
                      ),
                      curve: Curves.linear));
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please fill the Password';
          }
          return null;
        },
        autocorrect: false,
        obscureText: isSecure,
        controller: widget.passwordController,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            hintText: 'Password',
            suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isSecure = !isSecure;
                  });
                },
                child: isSecure
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
      ),
    );
  }
}
