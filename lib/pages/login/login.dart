import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFailure,
        ActionInProgress,
        ActionStarted,
        ActionState,
        ActionSuccess,
        CurrentLoginResponseGetBloc,
        FormState2,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        FormValueUpdated,
        LoginBloc,
        LoginFormBloc;
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/progress_button_icon.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show LayoutTier, Login, LoginFormData, SavedLoginResponse;
import 'package:game_oclock/utils/form_validators.dart';
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
import 'package:game_oclock/utils/show_snackbar.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginFormBloc(
            data: LoginFormData(
              host: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              username: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
              password: FormControl<String>(
                validators: [NotEmptyValidator(context)],
              ),
            ),
          ),
        ),
      ],
      child: const LoginBuilder(),
    );
  }
}

class LoginBuilder extends StatelessWidget {
  const LoginBuilder({super.key});

  @override
  Widget build(final BuildContext context) {
    final layoutTier = layoutTierFromContext(context);

    return Scaffold(
      body: layoutTier == LayoutTier.compact
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const FlutterLogo(), buildForm(context)],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(flex: 1, child: FlutterLogo()),
                Expanded(flex: 1, child: buildForm(context)),
              ],
            ),
    );
  }

  Widget buildForm(final BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginFormBloc, FormState2<LoginFormData, Login>>(
          listener: (final context, final state) {
            if (state is FormStateSubmitSuccess<LoginFormData, Login>) {
              context.read<LoginBloc>().add(ActionStarted(data: state.value));
            }
          },
        ),
        BlocListener<LoginBloc, ActionState<void>>(
          listener: (final context, final state) {
            if (state is ActionSuccess<void, Login>) {
              showSnackBar(
                context,
                message: context.localize().loginSuccessfulLabel,
              );
              GoRouter.of(context).go(CommonPaths.homePath);
            }
            if (state is ActionFailure<void, Login>) {
              showErrorSnackBar(
                context,
                name: context.localize().unableToLoginLabel,
                error: state.error,
              );
            }
          },
        ),
        BlocListener<
          CurrentLoginResponseGetBloc,
          ActionState<SavedLoginResponse>
        >(
          listener: (final context, final state) {
            SavedLoginResponse currentLoginResponse;
            if (state is ActionSuccess<SavedLoginResponse, void>) {
              currentLoginResponse = state.data;
              context.read<LoginFormBloc>().add(
                FormValueUpdated(
                  value: Login(
                    host: currentLoginResponse.host,
                    username: currentLoginResponse.username,
                    password: '',
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<LoginFormBloc, FormState2<LoginFormData, Login>>(
        builder: (final context, final formState) {
          return BlocBuilder<
            CurrentLoginResponseGetBloc,
            ActionState<SavedLoginResponse>
          >(
            builder: (final context, final getState) {
              return BlocBuilder<LoginBloc, ActionState<void>>(
                builder: (final context, final loginState) {
                  final inProgress =
                      getState is ActionInProgress ||
                      formState is FormStateSubmitInProgress ||
                      loginState is ActionInProgress;

                  return SimpleForm(
                    formGroup: formState.data.formGroup,
                    onSubmit: inProgress
                        ? null
                        : () {
                            context.read<LoginFormBloc>().add(
                              const FormSubmitted(),
                            );
                          },
                    child: _fieldsBuilder(context, formState.data, inProgress),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

Widget _fieldsBuilder(
  final BuildContext context,
  final LoginFormData formGroup,
  final bool readOnly,
) {
  return FormFieldsContainer(
    children: <Widget>[
      SimpleTextFormField(
        formControl: formGroup.host,
        label: context.localize().hostLabel,
        readOnly: readOnly,
      ),
      SimpleTextFormField(
        formControl: formGroup.username,
        label: context.localize().usernameLabel,
        readOnly: readOnly,
      ),
      SimpleObscuredTextFormField(
        formControl: formGroup.password,
        label: context.localize().passwordLabel,
        readOnly: readOnly,
      ),
    ],
  );
}

class SimpleForm extends StatelessWidget {
  const SimpleForm({
    super.key,
    required this.formGroup,
    required this.child,
    this.onSubmit,
  });

  final FormGroup formGroup;
  final Widget child;
  final VoidCallback? onSubmit;

  @override
  Widget build(final BuildContext context) {
    final inProgress = onSubmit == null;
    final saveButton = TextButton.icon(
      icon: inProgress ? const ProgressButtonIcon() : null,
      label: Text(context.localize().loginLabel),
      onPressed: onSubmit,
    );

    final form = ReactiveForm(formGroup: formGroup, child: child);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(child: form),
          const SizedBox(height: 24.0),
          saveButton,
        ],
      ),
    );
  }
}
