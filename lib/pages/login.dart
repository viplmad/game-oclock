import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show
        ActionFinal,
        ActionInProgress,
        ActionStarted,
        ActionState,
        FormDirtied,
        FormState2,
        FormStateSubmitInProgress,
        FormStateSubmitSuccess,
        FormSubmitted,
        FormValuesUpdated,
        LayoutTierBloc,
        LayoutTierState,
        Login,
        LoginFormBloc,
        LoginFormData,
        LoginGetBloc,
        LoginSaveBloc;
import 'package:game_oclock/models/models.dart' show LayoutTier;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => LoginFormBloc(
                formGroup: LoginFormData(
                  host: TextEditingController(),
                  username: TextEditingController(),
                  password: TextEditingController(),
                ),
              ),
        ),
        BlocProvider(create: (_) => LoginSaveBloc()),
        BlocProvider(
          create: (_) => LoginGetBloc()..add(ActionStarted(data: 'get')),
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
    return BlocBuilder<LayoutTierBloc, LayoutTierState>(
      builder: (final context, final layoutState) {
        final layoutTier = layoutState.tier;

        return Scaffold(
          body:
              layoutTier == LayoutTier.compact
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [const FlutterLogo(), buildForm(context)],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Flexible(flex: 1, child: FlutterLogo()),
                      Flexible(flex: 1, child: buildForm(context)),
                    ],
                  ),
        );
      },
    );
  }

  Widget buildForm(final BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginFormBloc, FormState2<LoginFormData, Login>>(
          listener: (final context, final state) {
            if (state is FormStateSubmitSuccess<LoginFormData, Login>) {
              context.read<LoginSaveBloc>().add(
                ActionStarted(data: state.data),
              );
            }
          },
        ),
        BlocListener<LoginSaveBloc, ActionState<void>>(
          listener: (final context, final state) {
            final snackBar = SnackBar(content: Text('Data updated $state'));
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            // TODO possibly clear dirty now
          },
        ),
        BlocListener<LoginGetBloc, ActionState<Login?>>(
          listener: (final context, final state) {
            Login? login;
            if (state is ActionFinal<Login?>) {
              login = state.data;
              if (login != null) {
                context.read<LoginFormBloc>().add(
                  FormValuesUpdated(values: login),
                );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<LoginFormBloc, FormState2<LoginFormData, Login>>(
        builder: (final context, final formState) {
          return BlocBuilder<LoginGetBloc, ActionState<Login?>>(
            builder: (final context, final getState) {
              bool skeleton = false; // TODO
              if (getState is ActionInProgress<Login?>) {
                skeleton = true; // TODO only if initial load?
              }

              return BlocBuilder<LoginSaveBloc, ActionState<void>>(
                builder: (final context, final saveState) {
                  final inProgress =
                      getState is ActionInProgress ||
                      formState is FormStateSubmitInProgress ||
                      saveState is ActionInProgress;

                  return SimpleForm(
                    formKey: formState.key,
                    formFieldsContainer: buildFormFieldsContainer(
                      formGroup: formState.group,
                      readOnly: inProgress,
                    ),
                    dirty: formState.dirty,
                    onChanged:
                        () => context.read<LoginFormBloc>().add(
                          const FormDirtied(),
                        ),
                    onSubmit: // TODO possibly disallow submit if not dirty
                        inProgress
                            ? null
                            : () {
                              context.read<LoginFormBloc>().add(
                                const FormSubmitted(),
                              );
                            },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildFormFieldsContainer({
    required final LoginFormData formGroup,
    required final bool readOnly,
  }) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: formGroup.host,
          readOnly: readOnly,
          validator: notEmptyValidator,
        ),
        TextFormField(controller: formGroup.username, readOnly: readOnly),
        TextFormField(controller: formGroup.password, readOnly: readOnly),
      ],
    );
  }

  String? notEmptyValidator(final value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}

class SimpleForm extends StatelessWidget {
  const SimpleForm({
    super.key,
    required this.formKey,
    required this.dirty,
    required this.formFieldsContainer,
    required this.onChanged,
    this.onSubmit,
  });

  final Key formKey;
  final bool dirty;
  final Widget formFieldsContainer;
  final VoidCallback onChanged;
  final VoidCallback? onSubmit;

  @override
  Widget build(final BuildContext context) {
    final inProgress = onSubmit == null;
    final saveButton = TextButton.icon(
      icon: inProgress ? const CircularProgressIndicator() : null,
      label: const Text('Login'), // TODO i18n
      onPressed: onSubmit,
    );

    final form = Form(
      key: formKey,
      onChanged: inProgress ? null : onChanged,
      child: formFieldsContainer,
    );
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(child: form),
          const SizedBox(height: 24.0),
          saveButton,
        ],
      ),
    );
  }
}
