import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionInProgress,
        ActionStarted,
        ActionState,
        ActionSuccess,
        FormState2,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        FormValueUpdated,
        LoginFormBloc,
        LoginSaveBloc,
        SavedLoginResponseGetBloc;
import 'package:game_oclock/components/forms/form_fields.dart';
import 'package:game_oclock/components/progress_button_icon.dart';
import 'package:game_oclock/constants/paths.dart';
import 'package:game_oclock/models/models.dart'
    show LayoutTier, Login, LoginFormData, SavedLoginResponse;
import 'package:game_oclock/utils/layout_tier_utils.dart';
import 'package:game_oclock/utils/localisation_extension.dart';
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
              host: FormControl<String>(validators: [Validators.required]),
              username: FormControl<String>(validators: [Validators.required]),
              password: FormControl<String>(validators: [Validators.required]),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => LoginSaveBloc(
            service: RepositoryProvider.of(context),
            authService: RepositoryProvider.of(context),
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
              context.read<LoginSaveBloc>().add(
                ActionStarted(data: state.value),
              );
            }
          },
        ),
        BlocListener<LoginSaveBloc, ActionState<void>>(
          listener: (final context, final state) {
            // TODO possibly clear dirty now
            GoRouter.of(context).go(CommonPaths.gamesPath);
          },
        ),
        BlocListener<
          SavedLoginResponseGetBloc,
          ActionState<SavedLoginResponse>
        >(
          listener: (final context, final state) {
            SavedLoginResponse savedLogin;
            if (state is ActionSuccess<SavedLoginResponse, void>) {
              savedLogin = state.data;
              context.read<LoginFormBloc>().add(
                FormValueUpdated(
                  value: Login(
                    host: savedLogin.host,
                    username: savedLogin.username,
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
            SavedLoginResponseGetBloc,
            ActionState<SavedLoginResponse>
          >(
            builder: (final context, final getState) {
              return BlocBuilder<LoginSaveBloc, ActionState<void>>(
                builder: (final context, final saveState) {
                  final inProgress =
                      getState is ActionInProgress ||
                      formState is FormStateSubmitInProgress ||
                      saveState is ActionInProgress;

                  return SimpleForm(
                    formGroup: formState.data.formGroup,
                    onSubmit: // TODO possibly disallow submit if not dirty
                    inProgress
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
