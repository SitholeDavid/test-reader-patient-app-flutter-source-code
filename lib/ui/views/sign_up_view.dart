import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stacked/stacked.dart';
import 'package:test_reader_patient_app/core/viewmodels/sign_up_viewmodel.dart';
import 'package:test_reader_patient_app/ui/constants/margins.dart';
import 'package:test_reader_patient_app/ui/constants/text_sizes.dart';
import 'package:test_reader_patient_app/ui/constants/ui_helpers.dart';
import 'package:test_reader_patient_app/ui/widgets/custom_button.dart';
import 'package:test_reader_patient_app/ui/widgets/custom_input_field.dart';
import 'package:test_reader_patient_app/ui/widgets/custom_loading_indicator.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'email is required'),
    EmailValidator(errorText: 'please enter a valid email address')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(3, errorText: 'Name must be at least 3 characters long')
  ]);

  final surnameValidator = MultiValidator([
    RequiredValidator(errorText: 'Surname is required'),
    MinLengthValidator(3,
        errorText: 'Surname must be at least 3 characters long')
  ]);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: pageVerticalMargin,
                          horizontal: pageHorizontalMargin),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                extraLargeSpace,
                                Text(
                                  'Sign Up',
                                  style: largeTextFont,
                                  textAlign: TextAlign.start,
                                ),
                                extraLargeSpace,
                                customInputField(
                                    controller: _nameController,
                                    hint: 'Enter your name',
                                    validator: nameValidator),
                                mediumSpace,
                                customInputField(
                                  controller: _surnameController,
                                  validator: surnameValidator,
                                  hint: 'Enter your surname',
                                ),
                                mediumSpace,
                                customInputField(
                                    controller: _emailController,
                                    hint: 'Enter email',
                                    inputType: TextInputType.emailAddress,
                                    validator: emailValidator),
                                mediumSpace,
                                customInputField(
                                    controller: _passwordController,
                                    hint: 'Password',
                                    inputType: TextInputType.visiblePassword,
                                    validator: passwordValidator),
                                mediumSpace,
                                customInputField(
                                    controller: _confirmPasswordController,
                                    hint: 'Confirm password',
                                    inputType: TextInputType.visiblePassword,
                                    validator: (val) => MatchValidator(
                                            errorText: 'passwords do not match')
                                        .validateMatch(
                                            val, _passwordController.text)),
                              ],
                            ),
                          ),
                          largeSpace,
                          customButton('Sign up', () {
                            if (_formKey.currentState.validate()) {
                              model.signUp(
                                  email: _emailController.text,
                                  name: _nameController.text,
                                  surname: _surnameController.text,
                                  password: _passwordController.text);
                            }
                          })
                        ],
                      ),
                    ),
                    loadingIndicator(model.isBusy, 'Signing you up..')
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => SignUpViewModel());
  }
}
